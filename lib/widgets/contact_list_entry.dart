import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';
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
    return BlocListener<SelectedContactsBloc, SelectedContactsState>(
      condition: (s1, s2) => s2 is ContactRemovedState,
      listener: (context, state){
        if(state is ContactRemovedState && state.contact.contact.identifier == widget.contact.identifier){
          setState(() {
            pressed = false;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            onTap: BlocProvider.of<SelectedContactsBloc>(context)
                .isSelected(widget.contact) || pressed
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
      ),
    );
  }

  _getContactWidgets() => [
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            ContactAvatar(
              widget.contact,
              size: 42,
              radius: 10,
              avatarColor: widget.avatarColor,
            ),
            BlocBuilder<SelectedContactsBloc, SelectedContactsState>(
              builder: (context, state) {
                print('Rebuild: ${widget.contact.displayName} => $state');

                try {
                  final encounterType =
                      BlocProvider.of<SelectedContactsBloc>(context)
                          .contacts
                          .firstWhere((c) =>
                              c.contact.identifier == widget.contact.identifier)
                          .encounterType;

                  return Positioned(
                    bottom: -6,
                    right: -6,
                    child: TweenAnimationBuilder(
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOutCirc,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: encounterType.toBadgeBackgroundColor(),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Icon(
                          Icons.done,
                          color: encounterType.toBadgeTextColorColor(),
                          size: 12,
                        ),
                      ),
                    ),
                  );
                } catch (e, s) {
                  return Container(width: 0, height: 0);
                }
              },
            ),
          ],
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
        BlocBuilder<SelectedContactsBloc, SelectedContactsState>(
          builder: (context, state) {
            if (BlocProvider.of<SelectedContactsBloc>(context).contacts.any(
                (c) => c.contact.identifier == widget.contact.identifier)) {
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Color(0xFF718096),
                ),
                onPressed: () {
                  BlocProvider.of<SelectedContactsBloc>(context)
                      .add(RemoveContactEvent(widget.contact));
                },
              );
            }

            return IconButton(
              icon: Icon(
                Icons.add,
                color: Color(0xFF718096),
              ),
              onPressed: null,
            );
          },
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
          child: _getBadge(EncounterType.DIRECT),
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
          child: _getBadge(EncounterType.SAME_ROOM),
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
          child: _getBadge(EncounterType.TWO_METERS),
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

  _getBadge(EncounterType encounterType) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: encounterType.toBadgeBackgroundColor(),
      child: InkWell(
        onTap: () {
          BlocProvider.of<SelectedContactsBloc>(context).add(SelectContactEvent(
              widget.contact, encounterType, widget.avatarColor));
          setState(() {
            pressed = false;
          });
        },
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            encounterType.toDisplayString(),
            style: TextStyle(
              color: encounterType.toBadgeTextColorColor(),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
