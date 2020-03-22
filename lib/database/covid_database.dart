import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:social_contact_tracker/model/contact.dart' as model;
import 'package:social_contact_tracker/model/covid_status.dart';
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
    final String dbPath = join(await getDatabasesPath(), 'covid.db');

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

  storeEncounter(model.Contact contact, EncounterType encounterType,
      DateTime encounterDate) async {
    final Database db = await _getDatabase();
    final insertData = {
      'contact_id': contact.id,
      'contact_identifier': contact.internalIdentifier,
      'contact_initials': contact.initials,
      'contact_picture_path': contact.picturePath,
      'contact_avatar_color': contact.avatarColor.value,
      'contact_display_name': contact.displayName,
      'contact_encounter_type': encounterType.toDatabaseString(),
      'encountered_at': encounterDate.millisecondsSinceEpoch,
    };

    return db.insert('encounters', insertData);
  }

  storeContact(Contact contact, String picturePath, Color avatarColor) async {
    final Database db = await _getDatabase();

    final insertData = {
      'internal_identifier': contact.identifier,
      'initials': contact.initials(),
      'picture_path': picturePath,
      'avatar_color': avatarColor.value,
      'display_name': contact.displayName,
      'phone': contact.phones.first.value,
    };

    return db.insert('contacts', insertData);
  }

  updateContact(Contact contact, String picturePath) async {
    final Database db = await _getDatabase();

    final updateData = {
      'internal_identifier': contact.identifier,
      'initials': contact.initials(),
      'picture_path': picturePath,
      'display_name': contact.displayName,
      'phone': contact.phones.first.value,
    };

    return db.update('contacts', updateData,
        where: 'internal_identifier = ?', whereArgs: [contact.identifier]);
  }

  updateCurrentCovidStatus(CovidStatus covidStatus) async {
    final Database db = await _getDatabase();

    final insertData = {
      'covid_status': covidStatus.toDatabaseString(),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };

    return db.insert('covid_states', insertData);
  }

  Future clearStoredLivingTogetherSelection() async {
    final Database db = await _getDatabase();

    final updateData = {
      'living_together': 0,
    };

    return db.update('contacts', updateData);
  }

  Future storeLivingTogetherFor(model.Contact contact) async {
    print('DB Update For: $contact');
    final Database db = await _getDatabase();
    final updateData = {
      'living_together': 1,
    };

    return db.update('contacts', updateData,
        where: 'id = ?', whereArgs: [contact.id]);
  }

  Future clearStoredShareStatusSelection() async {
    final Database db = await _getDatabase();

    final updateData = {
      'share_status': 0,
    };

    return db.update('contacts', updateData);
  }

  Future storeShareStatusFor(model.Contact contact) async {
    print('DB Update For: $contact');
    final Database db = await _getDatabase();
    final updateData = {
      'share_status': 1,
    };

    return db.update('contacts', updateData,
        where: 'id = ?', whereArgs: [contact.id]);
  }

///////////////////////////////////////////////////////////////////////////
// Getter Methods
///////////////////////////////////////////////////////////////////////////

  Future<List<Encounter>> getEncounters() async {
    final Database db = await _getDatabase();
    final maps = await db.query('encounters', orderBy: 'encountered_at DESC');
    return List.generate(maps.length, (i) => Encounter.fromDatabase(maps[i]));
  }

  Future<model.Contact> getContactForIdentifier(String identifier) async {
    final Database db = await _getDatabase();
    final maps = await db.query('contacts',
        where: 'internal_identifier = ?', whereArgs: [identifier]);
    if (maps.isEmpty) {
      return null;
    }
    return model.Contact.fromDatabase(maps.first);
  }

  Future<List<model.Contact>> getContacts() async {
    final Database db = await _getDatabase();
    final maps = await db.query('contacts', orderBy: 'display_name');
    return List.generate(
        maps.length, (i) => model.Contact.fromDatabase(maps[i]));
  }

  Future<List<model.Contact>> getContactsForQuery(String query) async {
    final Database db = await _getDatabase();
    final maps = await db.query('contacts',
        orderBy: 'display_name', where: 'display_name LIKE "%$query%"');
    return List.generate(
        maps.length, (i) => model.Contact.fromDatabase(maps[i]));
  }

  Future<List<model.Contact>> getContactsWithStatusShareEnabled() async {
    final Database db = await _getDatabase();
    final maps = await db.query(
      'contacts',
      where: 'share_status = ?',
      whereArgs: [1],
      orderBy: 'display_name',
    );
    return List.generate(
        maps.length, (i) => model.Contact.fromDatabase(maps[i]));
  }

  Future<List<model.Contact>> getContactsLivingTogether() async {
    final Database db = await _getDatabase();
    final maps = await db.query(
      'contacts',
      where: 'living_together = ?',
      whereArgs: [1],
      orderBy: 'display_name',
    );
    return List.generate(
        maps.length, (i) => model.Contact.fromDatabase(maps[i]));
  }

  Future<List<model.Contact>> getContactsMostEncountered() async {
    final Database db = await _getDatabase();
    final query = '''
    SELECT contacts.*, 
      (SELECT COUNT(*) FROM encounters WHERE contact_id = contacts.id) AS amount 
    FROM contacts 
    WHERE living_together = 0 
    ORDER BY amount DESC 
    LIMIT 3;
    ''';
    final maps = await db.rawQuery(query);
    return List.generate(
        maps.length, (i) => model.Contact.fromDatabase(maps[i]));
  }

  Future<CovidStatus> getCurrentCovidStatus() async {
    final Database db = await _getDatabase();
    final maps = await db.query('covid_states',
        where: 'contact_id IS NULL', orderBy: 'updated_at DESC', limit: 1);
    if (maps.isEmpty) {
      return null;
    }
    return covidStatusFromDatabaseString(maps.first['covid_status']);
  }
}
