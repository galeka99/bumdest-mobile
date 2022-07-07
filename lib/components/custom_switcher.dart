import 'package:flutter/widgets.dart';

class CustomSwitcher extends AnimatedSwitcher {
  final Widget child;
  final Duration duration;

  CustomSwitcher({
    required this.child,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          duration: duration,
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.linear,
          child: child,
        );
}
