import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/components/custom_button.dart';
import 'package:bumdest/models/city.dart';
import 'package:bumdest/models/district.dart';
import 'package:bumdest/models/province.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/services/store.dart';
import 'package:bumdest/views/location/cities.dart';
import 'package:bumdest/views/location/districts.dart';
import 'package:bumdest/views/location/provinces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  TextEditingController _provinceText = TextEditingController();
  TextEditingController _cityText = TextEditingController();
  TextEditingController _districtText = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  List<DropdownMenuItem<int>> _genders = [
    DropdownMenuItem(child: Text('Male'), value: 1),
    DropdownMenuItem(child: Text('Female'), value: 2),
  ];
  ProvinceModel? _province;
  CityModel? _city;
  DistrictModel? _district;
  int _gender = 1;

  Future<void> _getProvince() async {
    dynamic result = await Nav.push(ProvincesPage());
    if (result == null) return;

    setState(() {
      _province = result as ProvinceModel;
      _provinceText.text = _province!.name;
      _city = null;
      _cityText.clear();
      _district = null;
      _districtText.clear();
    });
  }

  Future<void> _getCity() async {
    if (_province == null) return;

    dynamic result = await Nav.push(CitiesPage(_province!.id));
    if (result == null) return;

    setState(() {
      _city = result as CityModel;
      _cityText.text = _city!.name;
      _district = null;
      _districtText.clear();
    });
  }

  Future<void> _getDistrict() async {
    if (_city == null) return;

    dynamic result = await Nav.push(DistrictsPage(_city!.id));
    if (result == null) return;

    setState(() {
      _district = result as DistrictModel;
      _districtText.text = _district!.name;
    });
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _loading = true;
      });

      await Api.post(
        '/v1/user/update',
        data: {
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
          'address': _address.text.trim(),
          'postal_code': _postalCode.text.trim(),
          'district_id': _district!.id,
          'gender_id': _gender,
          'old_password': _oldPassword.text.trim(),
        },
      );

      await Helper.getUserInfo(context);
      Helper.toast(context, 'Update profile success');
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
    _name.text = store.user!.name;
    _email.text = store.user!.email;
    _phone.text = store.user!.phone;
    _address.text = store.user!.address;
    _postalCode.text = store.user!.postalCode;
    if (store.user!.gender == 'Male') {
      _gender = 1;
    } else {
      _gender = 2;
    }

    _provinceText.text = store.user!.location.provinceName;
    _province = new ProvinceModel(
      id: store.user!.location.provinceId,
      name: store.user!.location.provinceName,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    _cityText.text = store.user!.location.cityName;
    _city = new CityModel(
      id: store.user!.location.cityId,
      name: store.user!.location.cityName,
      provinceId: store.user!.location.provinceId,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    _districtText.text = store.user!.location.districtName;
    _district = new DistrictModel(
      id: store.user!.location.districtId,
      name: store.user!.location.districtName,
      cityId: store.user!.location.cityId,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _postalCode.dispose();
    _provinceText.dispose();
    _cityText.dispose();
    _districtText.dispose();
    _newPassword.dispose();
    _oldPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Update Profile'),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
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
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.person_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty) return 'Name cannot be empty';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Email Address',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.at,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty) return 'Email address cannot be empty';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.call_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty)
                      return 'Phone number password cannot be empty';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField(
                  items: _genders,
                  value: _gender,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Gender',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.male_female_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _gender = val as int;
                    });
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _address,
                  keyboardType: TextInputType.streetAddress,
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Address',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.location_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty) return 'Address cannot be empty';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _provinceText,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Province',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.location_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  onTap: _getProvince,
                  validator: (str) {
                    if (str!.isEmpty) return 'Please select province first';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _cityText,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'City',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.location_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  onTap: _getCity,
                  validator: (str) {
                    if (str!.isEmpty) return 'Please select city first';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _districtText,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'District',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.location_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  onTap: _getDistrict,
                  validator: (str) {
                    if (str!.isEmpty) return 'Please select district first';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _postalCode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Postal Code',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.mail_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty) return 'Postal code cannot be empty';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _newPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'New Password',
                    helperText:
                        'Leave it empty if you don\'t want to change your password',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isNotEmpty) {
                      if (str.length < 8)
                        return 'Password at least 8 character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _confirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Confirm New Password',
                    helperText:
                        'Leave it empty if you don\'t want to change your password',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isNotEmpty) {
                      if (_newPassword.text.trim() != str.trim())
                        return 'Confirm password didn\'t match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                TextFormField(
                  controller: _oldPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty) return 'Password cannot be empty';
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            label: 'Update',
            loading: _loading,
            onPressed: _update,
          ),
        ],
      ),
    );
  }
}
