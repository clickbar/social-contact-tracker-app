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

part 'contact_search_event.dart';

part 'contact_search_state.dart';

class ContactSearchBloc extends Bloc<ContactSearchEvent, ContactSearchState> {
  static final RandomColor _randomColor = RandomColor();

  @override
  ContactSearchState get initialState => InitialContactSearchState();

  @override
  Stream<ContactSearchState> mapEventToState(ContactSearchEvent event) async* {
    try {
      if (event is LoadContactsEvent) {
        // Check for contacts permission
        if ((await PermissionHandler()
                .checkPermissionStatus(PermissionGroup.contacts)) !=
            PermissionStatus.granted) {
          yield ContactPermissionDeniedState();
        } else {
          yield ContactsLoadingState();
          bool firstLoad = false;

          // Load the contacts from the database first
          final List<Contact> cachedContacts =
              await CovidDatabase().getContacts();

          // Check if there are cached contacts
          if (cachedContacts.isNotEmpty) {
            // --> yield id
            yield ContactsLoadedState(cachedContacts);
          } else {
            firstLoad = true;
          }

          // Load all contacts from the local address book
          Iterable<address_book.Contact> contacts =
              await address_book.ContactsService.getContacts();
          final realContacts = contacts
              .where((contact) =>
                  contact.givenName != null && contact.phones.isNotEmpty)
              .toList();

          print(await CovidApi().syncContacts(realContacts));

          // Create the directory for the avatars
          final appSupportDir = await getApplicationSupportDirectory();
          final avatarDir = await Directory('${appSupportDir.path}/avatars/')
            ..create();

          // Compare the contacts with the cached contacts
          for (var addressBookContact in realContacts) {
            final cachedContact = await CovidDatabase()
                .getContactForIdentifier(addressBookContact.identifier);
            if (cachedContact == null) {
              String picturePath = null;
              // Check if the contact has an image
              if (addressBookContact.avatar != null &&
                  addressBookContact.avatar.isNotEmpty) {
                // Store the image into the internal storage
                picturePath =
                    '${avatarDir.path}/${addressBookContact.identifier}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                await File(picturePath).writeAsBytes(addressBookContact.avatar);
              }

              await CovidDatabase().storeContact(
                  addressBookContact,
                  picturePath,
                  _randomColor.randomColor(colorHue: ColorHue.blue));
            } else {
              // --> Update the contact
              String picturePath = null;

              // Check if the contact has an image
              if (addressBookContact.avatar != null &&
                  addressBookContact.avatar.isNotEmpty) {
                // Check if there was an image before
                if (cachedContact.picturePath != null) {
                  // --> Overwrite the old image
                  picturePath = cachedContact.picturePath;
                } else {
                  // --> Create new image path
                  picturePath =
                      '${avatarDir.path}/${addressBookContact.identifier}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                }
                await File(picturePath).writeAsBytes(addressBookContact.avatar);
              }

              // Update the contact
              await CovidDatabase()
                  .updateContact(addressBookContact, picturePath);
            }
          }

          if (firstLoad) {
            // Cached is now available load again
            final List<Contact> cachedContacts =
            await CovidDatabase().getContacts();
            yield ContactsLoadedState(cachedContacts);
          }
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
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
