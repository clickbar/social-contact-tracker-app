import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/routes/contact_search/contact_search_bloc.dart';
import 'package:social_contact_tracker/routes/contact_selection/contact_selection/contact_selection_bloc.dart';

part 'searchable_contact_list_event.dart';

part 'searchable_contact_list_state.dart';

class SearchableContactListBloc
    extends Bloc<SearchableContactListEvent, SearchableContactListState> {


  @override
  SearchableContactListState get initialState =>
      InitialSearchableContactListState();

  @override
  Stream<SearchableContactListState> mapEventToState(
      SearchableContactListEvent event) async* {
    if (event is LoadContactListEvent) {
      yield ContactListLoadingState();
      final contacts = await CovidDatabase().getContacts();
      yield ContactListLoadedState(contacts);
    }
  }
}
