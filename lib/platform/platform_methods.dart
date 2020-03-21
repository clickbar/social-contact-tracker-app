import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class PlatformMethods {
  static const DATABASE_CHANNEL = 'social_contact_tracker.clickbar.dev/database';

  static final PlatformMethods _instance = PlatformMethods._internal();
  static const platformDatabase = MethodChannel(DATABASE_CHANNEL);

  factory PlatformMethods() {
    return _instance;
  }

  PlatformMethods._internal() {}

  static exportDb() async {
    final dbPath = await getDatabasesPath();

    try {
      final result = await platformDatabase.invokeMethod('export',
          {'dbPath': '$dbPath/covid.db', 'fileName': 'exportCovidNew.sqlite'});
    } on PlatformException catch (e) {}
  }
}
