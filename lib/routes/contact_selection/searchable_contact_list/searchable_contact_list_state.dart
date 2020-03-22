part of 'searchable_contact_list_bloc.dart';

@immutable
@sealed
abstract class SearchableContactListState {}

class InitialSearchableContactListState extends SearchableContactListState {}

class ContactListLoadingState extends SearchableContactListState {}

class ContactListLoadedState extends SearchableContactListState {
  final List<Contact> contacts;

  ContactListLoadedState(this.contacts);
}
