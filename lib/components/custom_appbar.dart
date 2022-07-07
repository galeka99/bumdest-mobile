import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final bool dark;
  final bool enableLeading;
  final bool transparent;
  final Widget? leading;
  final List<Widget> actions;
  final PreferredSize? bottom;

  CustomAppBar(
    this.context,
    this.titleText, {
    this.enableLeading = true,
    this.dark = false,
    this.transparent = false,
    this.leading,
    this.actions = const [],
    this.bottom,
  }) : super(
          title: Text(
            titleText,
            style: TextStyle(
              color: dark ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: transparent
              ? Colors.transparent
              : dark
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).canvasColor,
          automaticallyImplyLeading: enableLeading,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: enableLeading
              ? leading ??
                  IconButton(
                    icon: Icon(Ionicons.chevron_back),
                    onPressed: Navigator.of(context).pop,
                  )
              : null,
          iconTheme: IconThemeData(
            color: dark ? Colors.white : Theme.of(context).primaryColor,
          ),
          actions: actions,
          bottom: bottom,
        );
}
