import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/model/contact_type.dart';
import 'package:social_contact_tracker/model/selected_contact.dart';

part 'selected_contacts_event.dart';

part 'selected_contacts_state.dart';

class SelectedContactsBloc
    extends Bloc<SelectedContactsEvent, SelectedContactsState> {
  @override
  SelectedContactsState get initialState => NoContactsSelectedState();

  ContactsAvailableState get _contactsAvailableState =>
      state as ContactsAvailableState;

  @override
  Stream<SelectedContactsState> mapEventToState(
      SelectedContactsEvent event) async* {
    if (event is SelectContactEvent) {
      if (state is NoContactsSelectedState) {
        final contacts = [
          SelectedContact(event.contact, event.contactType, event.avatarColor)
        ];
        yield ContactsSelectedState(contacts);
        await Future.delayed(Duration(milliseconds: 300));
        yield ContactInsertState(0, contacts);
      } else {
        final contacts = List.of(_contactsAvailableState.contacts);
        contacts.add(SelectedContact(
            event.contact, event.contactType, event.avatarColor));
        yield ContactsSelectedState(contacts);
        await Future.delayed(Duration(milliseconds: 300));
        yield ContactInsertState(contacts.length - 1, contacts);
      }
    }

    if (event is RemoveContactEvent) {
      final contacts = List.of(_contactsAvailableState.contacts);
      final removeIndex = contacts
          .indexWhere((c) => c.contact.identifier == event.contact.identifier);
      final removedContact = contacts.removeAt(removeIndex);
      yield ContactsSelectedState(contacts);
      await Future.delayed(Duration(milliseconds: 300));
      yield ContactRemovedState(removeIndex, removedContact, contacts);
    }
  }
}
