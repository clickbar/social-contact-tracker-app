part of 'contact_selection_bloc.dart';

@immutable
abstract class ContactSelectionEvent {}

class SelectContactEvent extends ContactSelectionEvent {
  final Contact contact;

  SelectContactEvent(this.contact);
}

class RemoveContactEvent extends ContactSelectionEvent {
  final Contact contact;

  RemoveContactEvent(this.contact);
}

class InitInitialSelectionEvent extends ContactSelectionEvent {
  final List<Contact> selection;

  InitInitialSelectionEvent(this.selection);
}

class SaveSelectionEvent extends ContactSelectionEvent {

}
