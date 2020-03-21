import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';
import 'package:social_contact_tracker/model/contact_type.dart';
import 'package:social_contact_tracker/routes/contact_search/selected_contacts/selected_contacts_bloc.dart';
import 'package:social_contact_tracker/widgets/contact_avatar.dart';

class ContactListEntry extends StatefulWidget {
  static final RandomColor _randomColor = RandomColor();

  final Contact contact;
  final avatarColor = _randomColor.randomColor(colorHue: ColorHue.blue);

  ContactListEntry(this.contact, {Key key}) : super(key: key);

  @override
  _ContactListEntryState createState() => _ContactListEntryState();
}

class _ContactListEntryState extends State<ContactListEntry> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap: pressed
              ? null
              : () {
                  setState(() {
                    if (pressed == false) pressed = true;
                  });
                },
          child: Container(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: Row(
              children: <Widget>[
                if (pressed) ..._getStatusWidgets(),
                if (!pressed) ..._getContactWidgets(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getContactWidgets() => [
        ContactAvatar(
          widget.contact,
          size: 42,
          radius: 10,
          avatarColor: widget.avatarColor,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.displayName,
                style: TextStyle(
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                widget.contact.phones.isNotEmpty
                    ? widget.contact.phones.first.value
                    : '',
                style: TextStyle(
                  color: Color(0xFF2D3748).withOpacity(0.54),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Color(0xFF718096),
          ),
          onPressed: null,
        )
      ];

  _getStatusWidgets() => [
        TweenAnimationBuilder(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOutCirc,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: _getBadge(ContactType.DIRECT),
        ),
        const SizedBox(width: 8),
        TweenAnimationBuilder(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutCirc,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: _getBadge(ContactType.SAME_ROOM),
        ),
        const SizedBox(width: 8),
        TweenAnimationBuilder(
          duration: Duration(milliseconds: 750),
          curve: Curves.easeInOutCirc,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: _getBadge(ContactType.TWO_METERS),
        ),
        Spacer(),
        TweenAnimationBuilder(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOutCirc,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: IconButton(
            icon: Icon(
              Icons.clear,
              color: Color(0xFF718096),
            ),
            onPressed: () {
              setState(() {
                pressed = false;
              });
            },
          ),
        )
      ];

  _getBadge(ContactType contactType) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: contactType.toBadgeBackgroundColor(),
      child: InkWell(
        onTap: () {
          BlocProvider.of<SelectedContactsBloc>(context)
              .add(SelectContactEvent(widget.contact, contactType, widget.avatarColor));
        },
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            contactType.toDisplayString(),
            style: TextStyle(
              color: contactType.toBadgeTextColorColor(),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
