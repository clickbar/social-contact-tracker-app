import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
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
    if (event is SelectContactEvent) {
      if (contacts.isEmpty) {
        yield ContactsSelectedState();
      }

      contacts.add(SelectedContact(
          event.contact, event.encounterType, event.avatarColor));
      yield ContactInsertState(contacts.length - 1);
    }

    if (event is RemoveContactEvent) {
      final removeIndex = contacts
          .indexWhere((c) => c.contact.identifier == event.contact.identifier);
      final removedContact = contacts.removeAt(removeIndex);
      yield ContactRemovedState(removeIndex, removedContact);

      if (contacts.isEmpty) {
        await Future.delayed(Duration(milliseconds: 300));
        yield NoContactsSelectedState();
      }
    }
  }
}
