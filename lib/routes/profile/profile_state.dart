part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final String name;
  final String phoneNumber;
  final CovidStatus covidStatus;
  final List<Contact> statusShareContacts;
  final List<Contact> livingWithContacts;

  ProfileLoadedState(this.name, this.phoneNumber, this.covidStatus,
      this.statusShareContacts, this.livingWithContacts);
}
