part of 'selected_contacts_bloc.dart';

@immutable
@sealed
abstract class SelectedContactsState {}

class NoContactsSelectedState extends SelectedContactsState {}

class ContactsSelectedState extends SelectedContactsState {}

class ContactInsertState extends SelectedContactsState {
  final int index;

  ContactInsertState(this.index);
}

class ContactRemovedState extends SelectedContactsState {
  final int index;
  final SelectedContact contact;

  ContactRemovedState(this.index, this.contact);
}

class StoringEncountersState extends SelectedContactsState {}

class EncountersStoredState extends SelectedContactsState {}
