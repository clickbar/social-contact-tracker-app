part of 'contact_search_bloc.dart';

@immutable
abstract class ContactSearchState {}

class InitialContactSearchState extends ContactSearchState {}

class ContactsLoadingState extends ContactSearchState {}

class ContactsLoadedState extends ContactSearchState {
  final List<Contact> contacts;
  final List<Contact> contactsMostEncountered;

  ContactsLoadedState(this.contacts, this.contactsMostEncountered);
}

class ContactPermissionDeniedState extends ContactSearchState {}

