import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/routes/contact_selection/contact_selection/contact_selection_bloc.dart';

import 'contact_avatar.dart';

class SelectedContactEntry extends StatelessWidget {
  final Contact contact;
  final Animation<double> animation;
  final slideTween = Tween<Offset>(begin: Offset(-20, 0), end: Offset(0, 0));

  SelectedContactEntry(this.contact, {Key key, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        child: Row(
          children: <Widget>[
            ContactAvatar(contact, size: 24, radius: 8),
            const SizedBox(width: 12),
            Text(contact.displayName),
            Spacer(),
            IconButton(
              onPressed: () {
                BlocProvider.of<ContactSelectionBloc>(context)
                    .add(RemoveContactEvent(contact));
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
