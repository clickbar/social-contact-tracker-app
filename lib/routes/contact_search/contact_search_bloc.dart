import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart' as address_book;
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_color/random_color.dart';
import 'package:social_contact_tracker/api/covid_api.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:rxdart/rxdart.dart';

part 'contact_search_event.dart';

part 'contact_search_state.dart';

class ContactSearchBloc extends Bloc<ContactSearchEvent, ContactSearchState> {
  @override
  ContactSearchState get initialState => InitialContactSearchState();

  @override
  Stream<ContactSearchState> transformEvents(Stream<ContactSearchEvent> events,
      Stream<ContactSearchState> Function(ContactSearchEvent p1) next) {
    return super.transformEvents(
        events.debounce((event) => TimerStream(
            true,
            event is SearchQueryChangedEvent
                ? Duration(milliseconds: 300)
                : Duration.zero)),
        next);
  }

  @override
  Stream<ContactSearchState> mapEventToState(ContactSearchEvent event) async* {
    try {
      if (event is LoadContactsEvent) {
        yield ContactsLoadingState();
        // Load the contacts from the database first
        final List<Contact> cachedContacts =
            await CovidDatabase().getContacts();
        final contactsMostEncountered =
            await CovidDatabase().getContactsMostEncountered();

        yield ContactsLoadedState(cachedContacts, contactsMostEncountered);
      }

      if (event is RequestContactPermissionEvent) {
        final permissions = await PermissionHandler()
            .requestPermissions([PermissionGroup.contacts]);

        if (permissions[PermissionGroup.contacts] != PermissionStatus.granted) {
          yield ContactPermissionDeniedState();
        } else {
          add(LoadContactsEvent());
        }
      }

      if (event is SearchQueryChangedEvent) {
        List<Contact> contactsMostEncountered = [];
        if (event.query.isEmpty) {
          contactsMostEncountered =
              await CovidDatabase().getContactsMostEncountered();
        }
        final contacts = await CovidDatabase().getContactsForQuery(event.query);
        yield ContactsLoadedState(contacts, contactsMostEncountered);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
