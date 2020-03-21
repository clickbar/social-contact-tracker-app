import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_contact_tracker/model/contact_type.dart';

class SelectedContact {
  final Contact contact;
  final ContactType contactType;
  final Color avatarColor;

  SelectedContact(this.contact, this.contactType, this.avatarColor);
}