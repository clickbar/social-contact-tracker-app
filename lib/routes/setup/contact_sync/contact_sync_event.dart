part of 'contact_sync_bloc.dart';

@immutable
abstract class ContactSyncEvent {}

class SyncContactsEvent extends ContactSyncEvent {}

class RequestContactPermissionEvent extends ContactSyncEvent {}