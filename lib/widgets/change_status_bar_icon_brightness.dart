import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeStatusBarIconBrightness extends StatelessWidget {
  final Widget child;
  final Brightness brightness;

  const ChangeStatusBarIconBrightness(
      {Key key, @required this.brightness, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: brightness,
          statusBarBrightness: brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light // Dark == white status bar -- for IOS.
          ),
      child: child,
    );
  }
}
