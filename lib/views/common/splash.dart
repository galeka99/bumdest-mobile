import 'package:bumdest/components/loading.dart';
import 'package:bumdest/views/common/login.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

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
    await Future.delayed(Duration(milliseconds: 2500));
    Nav.pushReplacement(LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Loading(isDark: true);
  }
}
