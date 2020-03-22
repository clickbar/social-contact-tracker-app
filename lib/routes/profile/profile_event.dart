part of 'profile_bloc.dart';

@immutable
@sealed
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {

}

class UpdateCovidStatusEvent extends ProfileEvent {
  final CovidStatus covidStatus;

  UpdateCovidStatusEvent(this.covidStatus);
}