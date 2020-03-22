part of 'searchable_contact_list_bloc.dart';

@immutable
@sealed
abstract class SearchableContactListEvent {}

class LoadContactListEvent extends SearchableContactListEvent {}

class SearchQueryChangedEvent extends SearchableContactListEvent {
  final String query;

  SearchQueryChangedEvent(this.query);
}
