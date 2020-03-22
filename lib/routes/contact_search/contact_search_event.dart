part of 'contact_search_bloc.dart';

@immutable
@sealed
abstract class ContactSearchEvent {}

class LoadContactsEvent extends ContactSearchEvent {}

class RequestContactPermissionEvent extends ContactSearchEvent {}

class SearchQueryChangedEvent extends ContactSearchEvent {
  final String query;

  SearchQueryChangedEvent(this.query);
}
