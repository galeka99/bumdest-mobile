import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/components/custom_button.dart';
import 'package:bumdest/models/payment_method.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/topup/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nav/nav.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({Key? key}) : super(key: key);

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _amount = TextEditingController(text: '10000');
  List<DropdownMenuItem<int>> _methods = [];
  int _method = 1;
  bool _loading = false;
  final List<Map<String, dynamic>> _amountTemplate = [
    {
      'amount': 10000,
      'label': '10K',
    },
    {
      'amount': 20000,
      'label': '20K',
    },
    {
      'amount': 25000,
      'label': '25K',
    },
    {
      'amount': 50000,
      'label': '50K',
    },
    {
      'amount': 100000,
      'label': '100K',
    },
    {
      'amount': 200000,
      'label': '200K',
    },
    {
      'amount': 250000,
      'label': '250K',
    },
    {
      'amount': 500000,
      'label': '500K',
    },
    {
      'amount': 1000000,
      'label': '1M',
    },
  ];

  Future<void> _getMethods() async {
    try {
      dynamic data = await Api.get('/v1/deposit/methods');
      setState(() {
        _methods = (data as List).map((e) {
          PaymentMethodModel method = PaymentMethodModel.parse(e);
          return DropdownMenuItem(child: Text(method.label), value: method.id);
        }).toList();
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

  Future<void> _topup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });
    try {
      await Api.post(
        '/v1/deposit/request',
        data: {
          'method': _method,
          'amount': int.parse(_amount.text.trim()),
        },
      );

      await Helper.getUserInfo(context);
      Helper.toast(context, 'Top up success');
      Nav.push(TopupHistoryPage());
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
    _getMethods();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        'Top Up',
        actions: [
          IconButton(
            onPressed: () => Nav.push(TopupHistoryPage()),
            icon: Icon(Icons.history_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  DropdownButtonFormField(
                    items: _methods,
                    value: _method,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      labelText: 'Payment Method',
                      labelStyle: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _method = val as int;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      labelText: 'Top Up Amount',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                      prefixText: 'Rp ',
                      prefixStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    validator: (str) {
                      if (str!.isEmpty) return 'Top up amount cannot be empty';
                      if (int.parse(str) < 10000) return 'Minimum top up amount is 10.000';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.75,
                    ),
                    itemCount: _amountTemplate.length,
                    itemBuilder: (_, i) {
                      Map<String, dynamic> item = _amountTemplate[i];

                      return InkWell(
                        onTap: () => setState(() {
                          _amount.text = item['amount'].toString();
                        }),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: CustomButton(
              label: 'Top Up Now',
              loading: _loading,
              onPressed: _topup,
            ),
          ),
        ],
      ),
    );
  }
}
