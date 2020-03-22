import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_contact_tracker/api/covid_api.dart';
import 'package:social_contact_tracker/persistence/settings_store.dart';
import 'package:social_contact_tracker/routes/contact_search/contact_search_screen.dart';
import 'package:social_contact_tracker/routes/encounter_timeline/encounter_timeline_screen.dart';
import 'package:social_contact_tracker/routes/profile/profile_screen.dart';
import 'package:social_contact_tracker/routes/sign_in/phone_input_screen.dart';
import 'package:social_contact_tracker/routes/sign_in/sign_in_bloc.dart';
import 'package:social_contact_tracker/routes/sign_in/verification_code_input_screen.dart';

void main() {
  runApp(MyApp());
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('data received');
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    testLocalStorage();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    // Retrieve the firebase messaging token
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _handleToken(token);
    });
  }

  testLocalStorage() async {
    UserStore().setPhoneNumber('+491605822419');
    UserStore().setName('Adrian');
  }

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
          '/profile': (_) => ProfileScreen(),
        },
        initialRoute: '/',
      ),
    );
  }

  _handleToken(String token) async {
    //Check if token differs from the stored token
    final oldToken = await UserStore().getSentNotificationToken();
    if (token != oldToken) {
      final success = await CovidApi().addNotificationToken(token);
      if (success) {
        UserStore().setNotificationTokenAsSent(token);
      }
    }
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
