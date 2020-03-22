part of 'contact_selection_bloc.dart';

@immutable
abstract class ContactSelectionState {}

class NoContactsSelectedState extends ContactSelectionState {}

class ContactsSelectedState extends ContactSelectionState {}

class ContactInsertState extends ContactSelectionState {
  final int index;
  final Contact contact;

  ContactInsertState(this.index, this.contact);
}

class ContactRemovedState extends ContactSelectionState {
  final int index;
  final Contact contact;

  ContactRemovedState(this.index, this.contact);
}

class SelectionStorageInProgressState extends ContactSelectionState {

}

class SelectionStorageDoneState extends ContactSelectionState{

}