import 'package:bumdest/components/loading.dart';
import 'package:bumdest/models/user.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/services/store.dart';
import 'package:bumdest/views/common/login.dart';
import 'package:bumdest/views/main/index.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // GET TOKEN FROM LOCAL STORAGE
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // REDIRECT TO LOGIN IF TOKEN ISN'T EXISTS
    if (token == null) return Nav.pushReplacement(LoginPage());

    // SAVE TOKEN TO TEMP STORAGE
    store.token = token;

    // CHECK IF TOKEN IS VALID
    try {
      Map<String, dynamic> data = await Api.get('/v1/user/info');
      UserModel user = UserModel.parse(data);
      store.user = user;
      return Nav.pushReplacement(MainPage());
    } catch (e) {
      print(e);
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);

        // CLEAR TOKEN AND REDIRECT TO LOGIN IF TOKEN INVALID
        if (e.code == 401) {
          await prefs.clear();
          return Nav.pushReplacement(LoginPage());
        }
      } else {
        Helper.toast(context, 'Error while get user data', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Loading(isDark: true);
  }
}
