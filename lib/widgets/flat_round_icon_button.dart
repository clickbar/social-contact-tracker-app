import 'package:flutter/material.dart';

class FlatRoundIconButton extends StatelessWidget {
  final Widget child;
  final Icon startIcon;
  final Icon endIcon;
  final Function onTap;
  final EdgeInsets padding;

  const FlatRoundIconButton(
      {Key key,
      this.startIcon,
      this.endIcon,
      this.child,
      this.onTap,
      this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(99)),
      color: onTap != null ? Color(0xFF2C5282) : Color(0xFF83A4CE),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(99)),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (startIcon != null) ...[
                startIcon,
                const SizedBox(width: 8),
              ],
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 16),
                child: child,
              ),
              if (endIcon != null) ...[
                const SizedBox(width: 8),
                endIcon,
              ]
            ],
          ),
        ),
      ),
    );
  }
}
