part of 'contact_sync_bloc.dart';

@immutable
abstract class ContactSyncState {}

class InitialContactSyncState extends ContactSyncState {}

class ContactPermissionRequiredState extends ContactSyncState {}

class ContactSyncRunningState extends ContactSyncState {}

class ContactSyncDoneState extends ContactSyncState {}

