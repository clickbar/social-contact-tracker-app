import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contact_search_event.dart';

part 'contact_search_state.dart';

class ContactSearchBloc extends Bloc<ContactSearchEvent, ContactSearchState> {
  @override
  ContactSearchState get initialState => InitialContactSearchState();

  @override
  Stream<ContactSearchState> mapEventToState(ContactSearchEvent event) async* {
    if (event is LoadContactsEvent) {
      // Check for contacts permission
      if ((await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.contacts)) !=
          PermissionStatus.granted) {
        yield ContactPermissionDeniedState();
      } else {
        yield ContactsLoadingState();

        Iterable<Contact> contacts = await ContactsService.getContacts();
        final realContacts = contacts
            .where((contact) =>
                contact.givenName != null && contact.phones.isNotEmpty)
            .toList();
        yield ContactsLoadedState(realContacts);
      }
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
  }
}
