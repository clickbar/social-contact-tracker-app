import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_contact_tracker/model/encountered_contact.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';
import 'package:social_contact_tracker/model/covid_status.dart';

class EncounteredContactEntryWidget extends StatelessWidget {
  final EncounteredContact encounteredContact;

  const EncounteredContactEntryWidget(this.encounteredContact, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Row(
            children: <Widget>[
              encounteredContact.hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        File(encounteredContact.picturePath),
                        width: 42,
                        height: 42,
                      ))
                  : Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: encounteredContact.avatarColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          encounteredContact.initials,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 42 / 2.33,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          encounteredContact.displayName,
                          style: TextStyle(
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: encounteredContact.covidStatus
                                .toBackgroundColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: encounteredContact.encounterType
                            .toBadgeBackgroundColor(),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        encounteredContact.encounterType.toDisplayString(),
                        style: TextStyle(
                          color: encounteredContact.encounterType
                              .toBadgeTextColorColor(),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
