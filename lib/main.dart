import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_contact_tracker/routes/contact_search/contact_search_screen.dart';
import 'package:social_contact_tracker/routes/encounter_timeline/encounter_timeline_screen.dart';
import 'package:social_contact_tracker/routes/sign_in/phone_input_screen.dart';
import 'package:social_contact_tracker/routes/sign_in/sign_in_bloc.dart';
import 'package:social_contact_tracker/routes/sign_in/verification_code_input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (_) => SignInBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Inter',
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (_) => EncounterTimelineScreen(),
          '/home': (_) => HomePage(),
          '/smscode': (_) => VerificationCodeInputScreen(),
          '/addEncounters': (_) => ContactSearchScreen(),
        },
        initialRoute: '/',
      ),
    );
  }


}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = "";

  getUid() {}

  @override
  void initState() {
    this.uid = "";
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Center(
        child: Text("Welcome to HomePage \n $uid"),
      ),
    );
  }
}
