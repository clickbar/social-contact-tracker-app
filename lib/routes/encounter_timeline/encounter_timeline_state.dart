part of 'encounter_timeline_bloc.dart';

@immutable
abstract class EncounterTimelineState {}

class InitialEncounterTimelineState extends EncounterTimelineState {}

class EncounterTimelineLoadingState extends EncounterTimelineState {}

class EncounterTimelineLoadedState extends EncounterTimelineState {
  final List entries;

  EncounterTimelineLoadedState(this.entries);
}
