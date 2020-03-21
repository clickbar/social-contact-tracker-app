part of 'selected_contacts_bloc.dart';

@immutable
@sealed
abstract class SelectedContactsState {}

class NoContactsSelectedState extends SelectedContactsState {}

class ContactsAvailableState extends SelectedContactsState {
  final List<SelectedContact> contacts;

  ContactsAvailableState(this.contacts);
}

class ContactsSelectedState extends ContactsAvailableState {
  ContactsSelectedState(List<SelectedContact> contacts) : super(contacts);
}

class ContactInsertState extends ContactsAvailableState {
  final int index;

  ContactInsertState(this.index, contacts) : super(contacts);
}

class ContactRemovedState extends ContactsAvailableState {
  final int index;
  final SelectedContact contact;

  ContactRemovedState(this.index, this.contact, contacts) : super(contacts);
}
