import 'package:bumdest/models/investment.dart';
import 'package:bumdest/models/product.dart';
import 'package:bumdest/models/report_history.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/config.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/services/store.dart';
import 'package:bumdest/views/bumdes/product_detail.dart';
import 'package:bumdest/views/investment/investment_detail.dart';
import 'package:bumdest/views/investment/report_detail.dart';
import 'package:bumdest/views/investment/report_history.dart';
import 'package:bumdest/views/topup/topup.dart';
import 'package:bumdest/views/withdraw/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InvestmentModel> _investments = [];
  List<ReportHistoryModel> _reports = [];
  List<ProductModel> _products = [];

  Future<void> _getLastInvestment() async {
    try {
      dynamic data = await Api.get('/v1/investment?limit=5');
      setState(() {
        _investments = (data['data'] as List)
            .map((e) => InvestmentModel.parse(e))
            .toList();
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

  Future<void> _getLastIncome() async {
    try {
      dynamic data = await Api.get('/v1/report?limit=5');
      setState(() {
        _reports = (data['data'] as List)
            .map((e) => ReportHistoryModel.parse(e))
            .toList();
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

  Future<void> _getRecommendProducts() async {
    try {
      dynamic data = await Api.get('/v1/product/recommended');
      setState(() {
        _products =
            (data as List).map((e) => ProductModel.parse(e)).toList();
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

  @override
  void initState() {
    _getLastInvestment();
    _getLastIncome();
    _getRecommendProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _getLastInvestment();
          await _getLastIncome();
          await _getRecommendProducts();
          await Helper.getUserInfo(context);
        },
        child: ListView(
          children: [
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (_, __) => Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .15,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColorDark,
                          Theme.of(context).primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 15),
                      Text(
                        config.appName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Helper.formatDate(
                                    DateTime.now().toIso8601String(),
                                    format: 'EEE, MMM d, yyyy',
                                    locale: 'en',
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  Helper.formatDate(
                                    DateTime.now().toIso8601String(),
                                    format: 'hh:mm:ss aaa',
                                    locale: 'en',
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 5),
                            Text(
                              Helper.toRupiah(store.user?.balance ?? 0),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => Nav.push(TopupPage()),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Ionicons.wallet_outline,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Top Up'.toUpperCase(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => Nav.push(WithdrawPage()),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Ionicons.send_outline,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Withdraw'.toUpperCase(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Invest',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            Helper.toRupiah(store.user?.totalInvest ?? 0),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Nav.push(ReportHistoryPage()),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Income',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            Helper.toRupiah(store.user?.totalIncome ?? 0),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your last investment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  _investments.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'No Investment Yet'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _investments.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            InvestmentModel item = _investments[i];

                            Color statusColor = Colors.blue.shade600;

                            if (item.status.id == 2)
                              statusColor = Colors.green.shade600;
                            if (item.status.id == 3)
                              statusColor = Colors.red.shade600;

                            return InkWell(
                              onTap: () => Nav.push(InvestmentDetailPage(item)),
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
                                    item.product.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.product.bumdes.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Helper.toRupiah(item.amount),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Text(
                                        item.status.label.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your last income',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  _reports.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'No Income Yet'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _reports.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            ReportHistoryModel item = _reports[i];
                            return InkWell(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            );
                          },
                        ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended for you',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  _products.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'No Products Yet'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.separated(
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
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(item.bumdes.name),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
