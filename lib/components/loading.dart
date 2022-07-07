import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  Loading({this.width = double.infinity, this.height = double.infinity, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
      width: width,
      height: height,
      padding: EdgeInsets.all(15),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: new AlwaysStoppedAnimation<Color>(
              isDark ? Theme.of(context).canvasColor : Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
