import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:rxdart/rxdart.dart';

part 'searchable_contact_list_event.dart';

part 'searchable_contact_list_state.dart';

class SearchableContactListBloc
    extends Bloc<SearchableContactListEvent, SearchableContactListState> {
  @override
  SearchableContactListState get initialState =>
      InitialSearchableContactListState();

  @override
  Stream<SearchableContactListState> transformEvents(
      Stream<SearchableContactListEvent> events,
      Stream<SearchableContactListState> Function(SearchableContactListEvent p1)
          next) {
    return super.transformEvents(
        events.debounce((event) => TimerStream(
            true,
            event is SearchQueryChangedEvent
                ? Duration(milliseconds: 300)
                : Duration.zero)),
        next);
  }

  @override
  Stream<SearchableContactListState> mapEventToState(
      SearchableContactListEvent event) async* {
    if (event is LoadContactListEvent) {
      yield ContactListLoadingState();
      final contacts = await CovidDatabase().getContacts();
      yield ContactListLoadedState(contacts);
    }

    if (event is SearchQueryChangedEvent) {
      final contacts = await CovidDatabase().getContactsForQuery(event.query);
      yield ContactListLoadedState(contacts);
    }
  }
}
