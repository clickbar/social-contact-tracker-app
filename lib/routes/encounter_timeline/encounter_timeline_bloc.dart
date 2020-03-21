import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/extensions/date_time.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/model/encountered_contact.dart';

part 'encounter_timeline_event.dart';

part 'encounter_timeline_state.dart';

class EncounterTimelineBloc
    extends Bloc<EncounterTimelineEvent, EncounterTimelineState> {
  @override
  EncounterTimelineState get initialState => InitialEncounterTimelineState();

  @override
  Stream<EncounterTimelineState> mapEventToState(
      EncounterTimelineEvent event) async* {
    if (event is LoadEncountersEvent) {
      yield EncounterTimelineLoadingState();

      final encounters = await CovidDatabase().getEncounters();
      final List elements = [];
      String lastDatetime = '';
      for (var encounter in encounters) {
        final currentDate = encounter.encounteredAt.toShortDateFormat();
        // Check for a date change (in days)
        if (currentDate != lastDatetime) {
          lastDatetime = currentDate;
          elements.add(encounter.encounteredAt);
        }
        // Add the encounter to the elements
        elements.add(EncounteredContact(
            encounter.contactIdentifier,
            encounter.contactInitials,
            encounter.picturePath,
            encounter.avatarColor,
            encounter.contactDisplayName,
            encounter.encounterType,
            CovidStatus.HEALTHY,
            DateTime.now()));
      }

      yield EncounterTimelineLoadedState(elements);
    }
  }
}
