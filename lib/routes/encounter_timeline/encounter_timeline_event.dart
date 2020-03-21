part of 'encounter_timeline_bloc.dart';

@immutable
@sealed
abstract class EncounterTimelineEvent {}

class LoadEncountersEvent extends EncounterTimelineEvent {}
