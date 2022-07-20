import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/components/loading.dart';
import 'package:bumdest/models/bumdes.dart';
import 'package:bumdest/models/bumdes_investor.dart';
import 'package:bumdest/models/product.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/bumdes/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class BumdesDetailPage extends StatefulWidget {
  final int bumdesId;

  const BumdesDetailPage(this.bumdesId, {Key? key}) : super(key: key);

  @override
  State<BumdesDetailPage> createState() => _BumdesDetailPageState();
}

class _BumdesDetailPageState extends State<BumdesDetailPage> {
  late BumdesModel _bumdes;
  bool _loading = true;
  List<ProductModel> _products = [];
  List<BumdesInvestorModel> _investors = [];

  Future<void> _getData() async {
    try {
      dynamic data = await Api.get('/v1/bumdes/${widget.bumdesId}');
      _bumdes = BumdesModel.parse(data);
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _getProducts() async {
    try {
      dynamic data =
          await Api.get('/v1/bumdes/${widget.bumdesId}/products?limit=5');
      setState(() {
        _products =
            (data['data'] as List).map((e) => ProductModel.parse(e)).toList();
      });
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  Future<void> _getTopTenInvestors() async {
    try {
      dynamic data =
          await Api.get('/v1/bumdes/${widget.bumdesId}/investors/top_ten');
      setState(() {
        _investors =
            (data as List).map((e) => BumdesInvestorModel.parse(e)).toList();
      });
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  void _showDescription() {
    showFlexibleBottomSheet(
      context: context,
      minHeight: .6,
      maxHeight: .85,
      initHeight: .6,
      bottomSheetColor: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_, controller, ___) => ListView(
        controller: controller,
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'About ${_bumdes.name}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(),
          SizedBox(height: 5),
          Text(
            _bumdes.description,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _bestProductsWidget() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Text(
          'Best Products',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _products.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (_, i) {
            ProductModel item = _products[i];

            return InkWell(
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
            );
          },
        ),
        SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {},
          child: Text(
            'View More Products'.toUpperCase(),
          ),
        ),
      ],
    );
  }

  Widget _latestProductsWidget() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Text(
          'Latest Products',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _products.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (_, i) {
            ProductModel item = _products[i];

            return InkWell(
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
            );
          },
        ),
        SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {},
          child: Text(
            'View More Products'.toUpperCase(),
          ),
        ),
      ],
    );
  }

  Widget _relatedProductsWidget() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Text(
          'Related Products',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _products.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (_, i) {
            ProductModel item = _products[i];

            return InkWell(
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
            );
          },
        ),
        SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {},
          child: Text(
            'View More Products'.toUpperCase(),
          ),
        ),
      ],
    );
  }

  Widget _topTenInvestorsWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10).copyWith(bottom: 0),
            child: Text(
              'Top 10 Investors',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Divider(),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: _investors.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (_, i) {
              BumdesInvestorModel item = _investors[i];

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.25),
                  child: Text(
                    (i + 1).toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                title: Text(
                  item.userName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Ionicons.location_outline,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '${item.userCity}, ${item.userProvince}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  Helper.compactNumber(item.investAmount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getData();
    _getProducts();
    _getTopTenInvestors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'BUMDes Profile'),
      body: _loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _bumdes.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            _bumdes.voteAverage.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Ionicons.star,
                            size: 12,
                            color: Colors.amber.shade600,
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Text(
                        _bumdes.address ?? 'No address found',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Ionicons.location_outline,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 3),
                          Text(
                            '${_bumdes.location.districtName.toUpperCase()}, ${_bumdes.location.cityName}, ${_bumdes.location.provinceName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10).copyWith(bottom: 0),
                        child: Text(
                          'About this BUMDes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: _showDescription,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            _bumdes.description,
                            textAlign: TextAlign.justify,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: _showDescription,
                        child: Container(
                          padding: EdgeInsets.all(10).copyWith(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Read More'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Ionicons.chevron_down_outline,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _topTenInvestorsWidget(),
                SizedBox(height: 20),
                _bestProductsWidget(),
                SizedBox(height: 20),
                _relatedProductsWidget(),
                SizedBox(height: 20),
                _latestProductsWidget(),
              ],
            ),
    );
  }
}
