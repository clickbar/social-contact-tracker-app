import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:meta/meta.dart';

part 'contact_search_event.dart';

part 'contact_search_state.dart';

class ContactSearchBloc extends Bloc<ContactSearchEvent, ContactSearchState> {
  @override
  ContactSearchState get initialState => InitialContactSearchState();

  @override
  Stream<ContactSearchState> mapEventToState(ContactSearchEvent event) async* {
    if (event is LoadContactsEvent) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      final realContacts = contacts
          .where((contact) =>
              contact.givenName != null && contact.phones.isNotEmpty)
          .toList();
      yield ContactsLoadedState(realContacts);
    }
  }
}
