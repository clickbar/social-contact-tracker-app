part of 'contact_search_bloc.dart';

@immutable
@sealed
abstract class ContactSearchEvent {}

class LoadContactsEvent extends ContactSearchEvent {}
