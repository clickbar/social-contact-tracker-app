import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_contact_tracker/model/contact.dart';

class ContactAvatar extends StatelessWidget {
  final Contact contact;
  final double size;
  final double radius;
  final Color avatarColor;

  const ContactAvatar(this.contact,
      {Key key,
      @required this.size,
      @required this.radius,
      @required this.avatarColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return contact.hasPicture
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            child: Image.file(
              File(contact.picturePath),
              width: size,
              height: size,
            ))
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: size / 2.33,
                  color: Colors.white54,
                ),
              ),
            ),
          );
  }
}
