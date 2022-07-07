import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/models/province.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class ProvincesPage extends StatefulWidget {
  const ProvincesPage({Key? key}) : super(key: key);

  @override
  State<ProvincesPage> createState() => _ProvincesPageState();
}

class _ProvincesPageState extends State<ProvincesPage> {
  TextEditingController _search = TextEditingController();
  List<ProvinceModel> _items = [];
  List<ProvinceModel> _temp = [];

  Future<void> _getItems() async {
    try {
      dynamic data = await Api.get('/v1/location/provinces', auth: false);
      setState(() {
        _items = (data as List).map((e) => ProvinceModel.parse(e)).toList();
        _temp = _items;
      });
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  @override
  void initState() {
    _getItems();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Select Province'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _search,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey.shade800,
                ),
                suffixIcon: _search.text.isEmpty
                    ? Icon(
                        Ionicons.search_outline,
                        color: Colors.grey.shade800,
                      )
                    : IconButton(
                        icon: Icon(
                          Ionicons.close_outline,
                          color: Colors.grey.shade800,
                        ),
                        onPressed: () {
                          setState(() {
                            _search.clear();
                            _temp = _items;
                          });
                        },
                      ),
              ),
              onChanged: (str) {
                setState(() {
                  _temp = _items.where((el) => el.name.toLowerCase().contains(str.toLowerCase())).toList();
                });
              },
            ),
          ),
          Flexible(
            child: ListView.separated(
                padding: EdgeInsets.all(20),
                itemCount: _temp.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (_, i) {
                  ProvinceModel item = _temp[i];

                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name),
                    trailing: Icon(Ionicons.chevron_forward_outline),
                    onTap: () => Nav.pop(context, result: item),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
