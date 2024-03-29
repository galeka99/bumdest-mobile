import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/models/product.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/bumdes/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class BumdesLatestProductPage extends StatefulWidget {
  final int bumdesId;
  const BumdesLatestProductPage(this.bumdesId, {Key? key}) : super(key: key);

  @override
  State<BumdesLatestProductPage> createState() =>
      _BumdesLatestProductPageState();
}

class _BumdesLatestProductPageState extends State<BumdesLatestProductPage> {
  final int _pageSize = 25;
  final PagingController<int, ProductModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _getData(int page) async {
    try {
      dynamic data = await Api.get(
          '/v1/bumdes/${widget.bumdesId}/products?limit=$_pageSize&page=$page');
      List<ProductModel> products =
          (data['data'] as List).map((e) => ProductModel.parse(e)).toList();

      if (products.length < _pageSize) {
        _pagingController.appendLastPage(products);
      } else {
        _pagingController.appendPage(products, page + 1);
      }
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _getData(pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Latest Products'),
      body: PagedListView<int, ProductModel>.separated(
        padding: EdgeInsets.all(20),
        pagingController: _pagingController,
        separatorBuilder: (_, __) => SizedBox(height: 10),
        builderDelegate: PagedChildBuilderDelegate<ProductModel>(
          noItemsFoundIndicatorBuilder: (_) => Container(
            child: Center(
              child: Text(
                'No Products Found'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          itemBuilder: (_, item, i) => InkWell(
            onTap: () => Nav.push(ProductDetailPage(item.id, item.title)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.25),
                    offset: Offset(3, 3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(item.bumdes.name),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.star,
                              size: 14,
                              color: Colors.amber.shade700,
                            ),
                            SizedBox(width: 5),
                            Text(
                              item.voteAverage.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '(${item.voteCount})',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Ionicons.location_outline,
                              size: 12,
                              color: Colors.grey.shade800,
                            ),
                            SizedBox(width: 5),
                            Text(
                              item.bumdes.location.cityName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          Helper.toRupiah(item.currentInvest),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          Helper.toRupiah(item.investTarget),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
