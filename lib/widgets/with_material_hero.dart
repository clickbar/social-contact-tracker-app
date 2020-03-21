import 'package:flutter/material.dart';

class WithMaterialHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const WithMaterialHero({Key key, this.tag, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: child,
      flightShuttleBuilder: (BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext) =>
          Material(
              type: MaterialType.transparency, child: toHeroContext.widget),
    );
  }
}
