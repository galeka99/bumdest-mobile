import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/components/loading.dart';
import 'package:bumdest/models/investment.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/bumdes/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class InvestmentDetailPage extends StatefulWidget {
  final InvestmentModel investment;
  const InvestmentDetailPage(this.investment, {Key? key}) : super(key: key);

  @override
  State<InvestmentDetailPage> createState() => _InvestmentDetailPageState();
}

class _InvestmentDetailPageState extends State<InvestmentDetailPage> {
  late InvestmentModel _inv;
  late Color _statusColor;
  late IconData _statusIcon;
  bool _loading = true;

  Future<void> _getData() async {
    try {
      dynamic data = await Api.get('/v1/investment/${widget.investment.id}');
      _inv = InvestmentModel.parse(data);
      if (_inv.status.id == 1) {
        _statusColor = Colors.blue.shade600;
        _statusIcon = Ionicons.hourglass_outline;
      } else if (_inv.status.id == 2) {
        _statusColor = Colors.green.shade600;
        _statusIcon = Ionicons.checkmark_outline;
      } else if (_inv.status.id == 3) {
        _statusColor = Colors.red.shade600;
        _statusIcon = Ionicons.close_outline;
      }
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Investment History'),
      body: _loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _statusColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      _statusIcon,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    Helper.toRupiah(_inv.amount),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Text(
                    Helper.formatDate(
                      _inv.createdAt,
                      format: 'MMMM dd, yyyy HH:mm:ss',
                      locale: 'en',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.25),
                        offset: Offset(3, 3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Table(
                        columnWidths: {
                          0: FractionColumnWidth(.35),
                          1: FractionColumnWidth(.65),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Invest amount',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                Helper.toRupiah(_inv.amount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                _inv.status.label.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _statusColor,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Product name',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                _inv.product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Product status',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                _inv.product.status.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'BUMDes name',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                _inv.product.bumdes.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'BUMDes location',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                _inv.product.bumdes.location.cityName +
                                    ', ' +
                                    _inv.product.bumdes.location.provinceName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Nav.push(ProductDetailPage(_inv.product.id, _inv.product.title)),
                  child: Text(
                    'Open Product'.toUpperCase(),
                  ),
                ),
              ],
            ),
    );
  }
}
