import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/models/report_history.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/investment/report_detail.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nav/nav.dart';

class ReportHistoryPage extends StatefulWidget {
  const ReportHistoryPage({Key? key}) : super(key: key);

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  final int _pageSize = 25;
  final PagingController<int, ReportHistoryModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _getData(int page) async {
    try {
      dynamic data = await Api.get('/v1/report?limit=$_pageSize&page=$page');
      List<ReportHistoryModel> products = (data['data'] as List)
          .map((e) => ReportHistoryModel.parse(e))
          .toList();

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
      appBar: CustomAppBar(context, 'Report History'),
      body: PagedListView<int, ReportHistoryModel>.separated(
        padding: EdgeInsets.all(20),
        pagingController: _pagingController,
        separatorBuilder: (_, __) => Divider(),
        builderDelegate: PagedChildBuilderDelegate<ReportHistoryModel>(
          noItemsFoundIndicatorBuilder: (_) => Container(
            child: Center(
              child: Text(
                'There Is No Data'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          itemBuilder: (_, item, __) => InkWell(
            onTap: () => Nav.push(ReportDetailPage(item.id)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item.productTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  Helper.formatDate(
                    item.createdAt,
                    format: 'EEE, MMM dd, yyyy HH:mm:ss',
                    locale: 'en',
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Helper.toRupiah(item.amount.toInt()),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      Helper.formatDate(
                        '${item.year}-${item.month.toString().padLeft(2, '0')}-01',
                        format: 'MMMM yyyy',
                        locale: 'en',
                      ).toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
