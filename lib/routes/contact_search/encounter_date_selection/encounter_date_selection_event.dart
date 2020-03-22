part of 'encounter_date_selection_bloc.dart';

@immutable
@sealed
abstract class EncounterDateSelectionEvent {}

class EncounterDateChangedEvent extends EncounterDateSelectionEvent {
  final DateTime dateTime;

  EncounterDateChangedEvent(this.dateTime);
}