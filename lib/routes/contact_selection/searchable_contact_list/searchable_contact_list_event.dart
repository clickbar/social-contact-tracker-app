part of 'searchable_contact_list_bloc.dart';

@immutable
@sealed
abstract class SearchableContactListEvent {}

class LoadContactListEvent extends SearchableContactListEvent {}
