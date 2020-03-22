import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'encounter_date_selection_event.dart';

part 'encounter_date_selection_state.dart';

class EncounterDateSelectionBloc
    extends Bloc<EncounterDateSelectionEvent, EncounterDateSelectionState> {
  @override
  EncounterDateSelectionState get initialState =>
      EncounterDateSelectionState.initial();

  @override
  Stream<EncounterDateSelectionState> mapEventToState(
      EncounterDateSelectionEvent event) async* {
    if (event is EncounterDateChangedEvent) {
      yield EncounterDateSelectionState(event.dateTime);
    }
  }
}
