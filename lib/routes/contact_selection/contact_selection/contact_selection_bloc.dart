import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/model/contact.dart';

part 'contact_selection_event.dart';

part 'contact_selection_state.dart';

class ContactSelectionBloc
    extends Bloc<ContactSelectionEvent, ContactSelectionState> {
  final List<Contact> contacts;

  final Future Function(Contact) storeSelectionFunction;
  final Future Function() clearStoredSelectionFunction;

  ContactSelectionBloc(List<Contact> initialSelection,
      this.storeSelectionFunction, this.clearStoredSelectionFunction)
      : this.contacts = []..addAll(initialSelection);

  bool isSelected(Contact contact) => contacts.any((c) => c.id == contact.id);

  @override
  ContactSelectionState get initialState {
    if (contacts.isEmpty) {
      print('is Empty');
      return NoContactsSelectedState();
    } else {
      print('is not Empty');
      return ContactsSelectedState();
    }
  }

  @override
  Stream<ContactSelectionState> mapEventToState(
      ContactSelectionEvent event) async* {
    try {
      if (event is SelectContactEvent) {
        if (contacts.isEmpty) {
          yield ContactsSelectedState();
        }

        contacts.add(event.contact);
        yield ContactInsertState(contacts.length - 1, event.contact);
      }

      if (event is RemoveContactEvent) {
        final removeIndex =
            contacts.indexWhere((c) => c.id == event.contact.id);
        final removedContact = contacts.removeAt(removeIndex);
        yield ContactRemovedState(removeIndex, removedContact);

        if (contacts.isEmpty) {
          await Future.delayed(Duration(milliseconds: 300));
          yield NoContactsSelectedState();
        }
      }

      if (event is SaveSelectionEvent) {
        yield SelectionStorageInProgressState();
        await clearStoredSelectionFunction();
        for (var contact in contacts) {
          print('Storing: $contact');
          await storeSelectionFunction(contact);
        }
        yield SelectionStorageDoneState();
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
