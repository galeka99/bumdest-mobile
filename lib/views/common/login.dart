import 'package:bumdest/components/custom_button.dart';
import 'package:bumdest/views/common/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nav/nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    //
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
            TextField(
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
              ),
            ),
            SizedBox(height: 15),
            TextField(
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
