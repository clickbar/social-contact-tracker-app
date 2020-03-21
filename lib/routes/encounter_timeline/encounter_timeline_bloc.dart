import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'encounter_timeline_event.dart';

part 'encounter_timeline_state.dart';

class EncounterTimelineBloc
    extends Bloc<EncounterTimelineEvent, EncounterTimelineState> {
  @override
  EncounterTimelineState get initialState => InitialEncounterTimelineState();

  @override
  Stream<EncounterTimelineState> mapEventToState(
      EncounterTimelineEvent event) async* {
    // TODO: Add your event logic
  }
}
