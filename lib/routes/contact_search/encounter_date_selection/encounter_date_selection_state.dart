part of 'encounter_date_selection_bloc.dart';

@immutable
class EncounterDateSelectionState {
  final DateTime dateTime;

  EncounterDateSelectionState(this.dateTime);

  factory EncounterDateSelectionState.initial() =>
      EncounterDateSelectionState(DateTime.now());
}
