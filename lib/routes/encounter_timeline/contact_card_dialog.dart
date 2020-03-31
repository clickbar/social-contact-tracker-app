import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/model/covid_status_update.dart';
import 'package:social_contact_tracker/model/encountered_contact.dart';
import 'package:social_contact_tracker/extensions/date_time.dart';
import 'package:social_contact_tracker/model/covid_status.dart';

class ContactCardDialog extends StatefulWidget {
  final EncounteredContact contact;

  const ContactCardDialog({Key key, this.contact}) : super(key: key);

  @override
  _ContactCardDialogState createState() => _ContactCardDialogState();
}

class _ContactCardDialogState extends State<ContactCardDialog> {
  var loadingShareStatus = true;
  var loadingStatusUpdates = true;
  Contact cachedContact = null;
  List<CovidStatusUpdate> statusUpdates = null;

  @override
  void initState() {
    super.initState();
    loadCovidStatusUpdates();
    loadCachedContact();
  }

  void loadCachedContact() async {
    final cachedContact = await CovidDatabase()
        .getContactForIdentifier(widget.contact.contactIdentifier);
    this.cachedContact = cachedContact;
    this.loadingShareStatus = false;
    setState(() {});
  }

  void loadCovidStatusUpdates() async {
    final statusUpdates = await CovidDatabase()
        .getCovidStatusupdates(widget.contact.contactIdentifier);
    this.statusUpdates = statusUpdates;
    this.loadingStatusUpdates = false;
    print(statusUpdates);
    setState(() {});
  }

  _createStatusUpdates() async {
    await CovidDatabase()
        .storeCovidStatusUpdateFor(cachedContact, CovidStatus.NO_CONTACT);
  }

  _buildStatusUpdateRow(CovidStatusUpdate covidStatusUpdate) {
    return SizedBox(
      height: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: covidStatusUpdate.status.toBackgroundColor(),
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                covidStatusUpdate.status.toDispalyText(),
                style: TextStyle(
                    color: covidStatusUpdate.status.toTextColor(),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            covidStatusUpdate.updatedAt.toDisplayDateWithTime(),
            style: TextStyle(
              color: Color(0xFFEB8C2CC),
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headlineTextStyle = TextStyle(
      color: Color(0xFF2D3748),
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );

    final contentTextStyle = TextStyle(
      color: Color(0xFF718096),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: new Hero(
              tag: 'contact-card' + widget.contact.contactIdentifier,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          widget.contact.hasImage
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.file(
                                    File(widget.contact.picturePath),
                                    width: 64,
                                    height: 64,
                                  ),
                                )
                              : Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: widget.contact.avatarColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.contact.initials,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 42 / 2.33,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.contact.displayName,
                            style: headlineTextStyle,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: widget.contact.covidStatus
                                      .toBackgroundColor(),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.contact.covidStatus.toDispalyText(),
                                style: TextStyle(
                                  color:
                                      widget.contact.covidStatus.toTextColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Statusverlauf',
                        style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 256,
                        child: loadingStatusUpdates
                            ? Container()
                            : statusUpdates.length == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      "Noch keinen Status erhalten.",
                                      style: contentTextStyle,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: statusUpdates.length,
                                    itemBuilder: (BuildContext cxt, int index) {
                                      return _buildStatusUpdateRow(
                                          statusUpdates[index]);
                                    }),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            size: 20,
                            color: Color(0xFFCBD5E0),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          loadingShareStatus
                              ? Text("Loading")
                              : Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Du teilst deinen Status ${cachedContact.shareStatus ? "" : "nicht "}mit ${widget.contact.displayName}.",
                                        style: contentTextStyle,
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }
}
