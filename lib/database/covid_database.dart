import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';
import 'package:sqflite/sqflite.dart';

import 'Encounter.dart';

class CovidDatabase {
  static final CovidDatabase _instance = CovidDatabase._internal();

  Future<Database> database;

  factory CovidDatabase() {
    return _instance;
  }

  CovidDatabase._internal() {}

  ///////////////////////////////////////////////////////////////////////////
  // Helper Stuff
  ///////////////////////////////////////////////////////////////////////////

  Future<Database> _createDatabase() async {
    final String dbPath = join(await getDatabasesPath(), 'qs.db');

    // Open the database
    return openDatabase(
      dbPath,
      onCreate: (db, version) async {
        print('creating db...');

        // Load the schema from the assets and create the database
        String schemaSql =
        await rootBundle.loadString('assets/database/schema.sql');
        for (var command in schemaSql.split(";")) {
          if (command.length > 5) {
            // catching any hidden characters at end of schema
            await db.execute(command + ';');
          }
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Load the migration from the assets and migrate
        String migrationSql = await rootBundle.loadString(
            'assets/database/migrations/migration_${oldVersion}_$newVersion.txt');
        for (var command in migrationSql.split(";;")) {
          if (command.length > 5) {
            // catching any hidden characters at end of schema
            await db.execute(command + ';');
          }
        }
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  _getDatabase() async {
    if (database != null) {
      return database;
    }
    database = _createDatabase();
    return database;
  }

///////////////////////////////////////////////////////////////////////////
// Store Methods
///////////////////////////////////////////////////////////////////////////

  storeEncounter(Contact contact, String picturePath, Color avatarColor,
      EncounterType encounterType, DateTime encounterDate) async {
    final Database db = await _getDatabase();
    final insertData = {
      'contact_identifier': contact.identifier,
      'contact_initials': contact.initials(),
      'contact_picture_path': picturePath,
      'contact_avatar_color': avatarColor.value,
      'contact_display_name': contact.displayName,
      'contact_encounter_type': encounterType.toDatabaseString(),
      'encountered_at': encounterDate.millisecondsSinceEpoch,
    };

    return db.insert('encounters', insertData);
  }

///////////////////////////////////////////////////////////////////////////
// Getter Methods
///////////////////////////////////////////////////////////////////////////

  Future<List<Encounter>> getEncounters() async {
    final Database db = await _getDatabase();
    final maps = await db.query('encounters', orderBy: 'encountered_at');
    return List.generate(maps.length, (i) => Encounter.fromDatabase(maps[i]));
  }


}
