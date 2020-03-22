import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:social_contact_tracker/persistence/settings_store.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFF2A4365),
      child: Container(
        height: 200,
        width: 200,
        child: FlareActor(
          "assets/animations/logo_animation.flr",
          animation: "Untitled",
          isPaused: false,
          callback: (_) {
            _checkForSignIn(context);
          },
        ),
      ),
    );
  }

  _checkForSignIn(BuildContext context) async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      // signed in
      // Check if setup is done
      if ((await UserStore().isSetupCompleted())) {
        Navigator.of(context).pushReplacementNamed('/encounter');
      } else {
        Navigator.of(context).pushReplacementNamed('/setupName');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/signin');
    }
  }
}
