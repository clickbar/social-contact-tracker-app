import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/persistence/settings_store.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  ProfileState get initialState => InitialProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileEvent) {
      yield ProfileLoadingState();

      final phone = await UserStore().getPhoneNumber();
      final name = await UserStore().getName();
      final covidStatus = (await CovidDatabase().getCurrentCovidStatus()) ??
          CovidStatus.UNKNOWN;
      final statusShareContacts =
          await CovidDatabase().getContactsWithStatusShareEnabled();
      final livingWithContacts =
          await CovidDatabase().getContactsLivingTogether();

      yield ProfileLoadedState(
          name, phone, covidStatus, statusShareContacts, livingWithContacts);
    }

    if (event is UpdateCovidStatusEvent) {
      final oldState = state as ProfileLoadedState;
      yield ProfileLoadedState(
          oldState.phoneNumber,
          oldState.name,
          event.covidStatus,
          oldState.statusShareContacts,
          oldState.livingWithContacts);

      CovidDatabase().updateCurrentCovidStatus(event.covidStatus);
    }
  }
}
