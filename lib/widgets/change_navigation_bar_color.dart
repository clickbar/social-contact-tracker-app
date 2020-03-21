import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeNavigationBarColor extends StatelessWidget {
  final Color color;
  final Widget child;

  const ChangeNavigationBarColor(
      {Key key, @required this.color, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: color,
          systemNavigationBarIconBrightness:
              color == Colors.white ? Brightness.dark : Brightness.light),
      child: child,
    );
  }
}
