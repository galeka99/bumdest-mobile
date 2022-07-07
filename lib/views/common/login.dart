import 'package:bumdest/components/custom_button.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/services/store.dart';
import 'package:bumdest/views/common/register.dart';
import 'package:bumdest/views/main/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      String token = await Api.post(
        '/v1/user/login',
        auth: false,
        data: {
          'email': _email.text.trim(),
          'password': _password.text.trim(), 
        },
      );

      // SAVE TOKEN TO LOCAL STORAGE
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // SAVE TOKEN TO TEMP STORAGE
      store.token = token;

      // GET USER INFO
      await Helper.getUserInfo(context);

      // REDIRECT TO MAIN PAGE
      Nav.pushReplacement(MainPage());
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
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
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 50),
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/bumdest.svg',
              color: Colors.blue,
              width: MediaQuery.of(context).size.width * .35,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .075,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        Ionicons.at_outline,
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
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Log In',
              onPressed: _login,
              loading: _loading,
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                InkWell(
                  onTap: () => Nav.push(RegisterPage()),
                  child: Text(
                    'Sign Up',
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
      ),
    );
  }
}
