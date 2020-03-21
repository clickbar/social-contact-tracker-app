import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/model/contact_type.dart';
import 'package:social_contact_tracker/model/selected_contact.dart';
import 'package:social_contact_tracker/routes/contact_search/selected_contacts/selected_contacts_bloc.dart';

import 'contact_avatar.dart';

class MetContactEntry extends StatelessWidget {
  final SelectedContact selectedContact;
  final Animation<double> animation;
  final slideTween = Tween<Offset>(begin: Offset(-20, 0), end: Offset(0, 0));

  MetContactEntry(this.selectedContact, {Key key, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        child: Row(
          children: <Widget>[
            ContactAvatar(selectedContact.contact,
                size: 24, radius: 8, avatarColor: selectedContact.avatarColor),
            const SizedBox(width: 12),
            Text(selectedContact.contact.displayName),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: selectedContact.contactType.toBadgeBackgroundColor(),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: Text(
                selectedContact.contactType.toDisplayString(),
                style: TextStyle(
                    color: selectedContact.contactType.toBadgeTextColorColor(),
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<SelectedContactsBloc>(context)
                    .add(RemoveContactEvent(selectedContact.contact));
              },
              icon: Icon(
                Icons.clear,
                color: Color(0xFF718096),
              ),
            )
          ],
        ),
      ),
    );
  }
}
