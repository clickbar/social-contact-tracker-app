import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';
import 'package:social_contact_tracker/model/selected_contact.dart';

part 'selected_contacts_event.dart';

part 'selected_contacts_state.dart';

class SelectedContactsBloc
    extends Bloc<SelectedContactsEvent, SelectedContactsState> {
  final List<SelectedContact> contacts = [];

  @override
  SelectedContactsState get initialState => NoContactsSelectedState();

  bool isSelected(Contact contact) =>
      contacts.any((c) => c.contact.identifier == contact.identifier);

  @override
  Stream<SelectedContactsState> mapEventToState(
      SelectedContactsEvent event) async* {
    try {
      if (event is SelectContactEvent) {
        if (contacts.isEmpty) {
          yield ContactsSelectedState();
        }

        contacts.add(SelectedContact(
            event.contact, event.encounterType, event.avatarColor));
        yield ContactInsertState(contacts.length - 1);
      }

      if (event is RemoveContactEvent) {
        final removeIndex = contacts.indexWhere(
            (c) => c.contact.identifier == event.contact.identifier);
        final removedContact = contacts.removeAt(removeIndex);
        yield ContactRemovedState(removeIndex, removedContact);

        if (contacts.isEmpty) {
          await Future.delayed(Duration(milliseconds: 300));
          yield NoContactsSelectedState();
        }
      }

      if (event is AddToEncountersEvent) {
        yield StoringEncountersState();

        // get the directory for the avatars
        final appSupportDir = await getApplicationSupportDirectory();
        final avatarDir = await Directory('${appSupportDir.path}/avatars/')
          ..create();

        // Loop over all contacts
        for (var selectedContact in contacts) {
          String picturePath = null;

          // Check if the contact has an image
          if (selectedContact.contact.avatar != null &&
              selectedContact.contact.avatar.isNotEmpty) {
            // Store the image into the internal storage
            picturePath =
                '${avatarDir.path}/${selectedContact.contact.identifier}_${DateTime.now().millisecondsSinceEpoch}.jpg';
            await File(picturePath)
                .writeAsBytes(selectedContact.contact.avatar);
          }

          // store it into the database
          await CovidDatabase().storeEncounter(
              selectedContact.contact,
              picturePath,
              selectedContact.avatarColor,
              selectedContact.encounterType,
              DateTime.now());
        }

        print('Saved Encounters');
        yield EncountersStoredState();
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
