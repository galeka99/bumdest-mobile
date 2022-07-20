import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/components/loading.dart';
import 'package:bumdest/models/report_detail.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/bumdes/bumdes_detail.dart';
import 'package:bumdest/views/bumdes/product_detail.dart';
import 'package:bumdest/views/common/pdf_viewer.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class ReportDetailPage extends StatefulWidget {
  final int reportId;
  const ReportDetailPage(this.reportId, {Key? key}) : super(key: key);

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  bool _loading = true;
  late ReportDetailModel _report;
  PDFDocument? _doc;

  Future<void> _getData() async {
    try {
      dynamic data = await Api.get('/v1/report/${widget.reportId}');
      _report = ReportDetailModel.parse(data);
      if (_report.reportFile != null)
        _doc = await PDFDocument.fromURL(_report.reportFile!);
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
      appBar: CustomAppBar(context, 'Income Detail'),
      body: _loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.all(20),
              children: [
                Icon(
                  Ionicons.cash_outline,
                  size: 70,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 15),
                Text(
                  Helper.toRupiah(_report.profit),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  Helper.formatDate(
                    _report.createdAt,
                    format: 'EEEE, MMMM dd, yyyy HH:mm:ss',
                    locale: 'en',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 20),
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
                  child: Table(
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
                              'BUMDes income',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            Helper.toRupiah(_report.profit),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Share to you',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            '${_report.percentage} %',
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
                              'Share amount',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            Helper.toRupiah(_report.amount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Periode',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            Helper.formatDate(
                              '${_report.year}-${_report.month.toString().padLeft(2, '0')}-01',
                              format: 'MMMM yyyy',
                              locale: 'en',
                            ),
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
                              'Report file',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          _report.reportFile == null
                              ? Text(
                                  '-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                )
                              : InkWell(
                                  onTap: () => Nav.push(
                                    ProposalPage(
                                      _doc!,
                                      title: 'Income Report',
                                    ),
                                  ),
                                  child: Text(
                                    'Show file...',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Product',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            _report.productTitle,
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
                              'BUMDes',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            _report.bumdesName,
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
                            padding: EdgeInsets.only(bottom: 0),
                            child: Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            '${_report.bumdesLocation.cityName}, ${_report.bumdesLocation.provinceName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () => Nav.push(ProductDetailPage(_report.productId, _report.productTitle)),
                  child: Text(
                    'Open Product'.toUpperCase(),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Nav.push(BumdesDetailPage(_report.bumdesId)),
                  child: Text(
                    'View ${_report.bumdesName}'.toUpperCase(),
                  ),
                ),
              ],
            ),
    );
  }
}
