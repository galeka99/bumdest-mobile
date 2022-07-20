import 'package:bumdest/components/custom_button.dart';
import 'package:bumdest/models/city.dart';
import 'package:bumdest/models/district.dart';
import 'package:bumdest/models/province.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/location/cities.dart';
import 'package:bumdest/views/location/districts.dart';
import 'package:bumdest/views/location/provinces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  TextEditingController _provinceText = TextEditingController();
  TextEditingController _cityText = TextEditingController();
  TextEditingController _districtText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int>> _genders = [
    DropdownMenuItem(child: Text('Male'), value: 1),
    DropdownMenuItem(child: Text('Female'), value: 2),
  ];
  ProvinceModel? _province;
  CityModel? _city;
  DistrictModel? _district;
  int _gender = 1;
  bool _loading = false;

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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _loading = true;
    });

    try {
      await Api.post(
        '/v1/user/register',
        auth: false,
        data: {
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'password': _password.text.trim(),
          'phone': _phone.text.trim(),
          'address': _address.text.trim(),
          'postal_code': _postalCode.text.trim(),
          'gender_id': _gender,
          'district_id': _district!.id,
        },
      );

      Helper.toast(context, 'Account created, now you can login using your new account');
      Nav.pop(context);
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        Helper.toast(context, 'System error', isError: true);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
    _address.dispose();
    _postalCode.dispose();
    _provinceText.dispose();
    _cityText.dispose();
    _districtText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 25,
        ),
        shrinkWrap: true,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Text(
            'Create An Account'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 35),
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
                  controller: _password,
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
                    if (str.length < 8) return 'Password at least 8 character';
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
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  validator: (str) {
                    if (str!.isEmpty) return 'Confirm password cannot be empty';
                    if (str != _password.text)
                      return 'Confirm password not match';
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
              ],
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            label: 'Register',
            onPressed: _register,
            loading: _loading,
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              InkWell(
                onTap: () => Nav.pop(context),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
