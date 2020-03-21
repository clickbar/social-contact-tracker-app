import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/contact.dart';
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
      contacts.any((c) => c.contact.id == contact.id);

  @override
  Stream<SelectedContactsState> mapEventToState(
      SelectedContactsEvent event) async* {
    try {
      if (event is SelectContactEvent) {
        if (contacts.isEmpty) {
          yield ContactsSelectedState();
        }

        contacts.add(SelectedContact(event.contact, event.encounterType));
        yield ContactInsertState(contacts.length - 1);
      }

      if (event is RemoveContactEvent) {
        final removeIndex =
            contacts.indexWhere((c) => c.contact.id == event.contact.id);
        final removedContact = contacts.removeAt(removeIndex);
        yield ContactRemovedState(removeIndex, removedContact);

        if (contacts.isEmpty) {
          await Future.delayed(Duration(milliseconds: 300));
          yield NoContactsSelectedState();
        }
      }

      if (event is AddToEncountersEvent) {
        yield StoringEncountersState();

        // Loop over all contacts
        for (var selectedContact in contacts) {
          // store it into the database
          await CovidDatabase().storeEncounter(selectedContact.contact,
              selectedContact.encounterType, DateTime.now());
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
