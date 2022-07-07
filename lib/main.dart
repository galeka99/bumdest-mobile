import 'package:bumdest/components/custom_scroll_behavior.dart';
import 'package:bumdest/services/config.dart';
import 'package:bumdest/views/common/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nav/nav.dart';

void main() => runApp(BumdestApp());

class BumdestApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  const BumdestApp({Key? key}) : super(key: key);

  @override
  State<BumdestApp> createState() => _BumdestAppState();
}

class _BumdestAppState extends State<BumdestApp> with Nav {
  @override
  GlobalKey<NavigatorState> get navigatorKey => BumdestApp.navigatorKey;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade700,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: config.appName,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Finlandica',
        ),
        builder: (ctx, child) => ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: child!,
        ),
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('id', 'ID'),
        ],
        locale: Locale('id', 'ID'),
        initialRoute: '/',
        home: SplashPage(),
      ),
    );
  }
}