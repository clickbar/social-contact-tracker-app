import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class ContactListEntry extends StatefulWidget {
  static final RandomColor _randomColor = RandomColor();

  final Contact contact;

  const ContactListEntry(this.contact, {Key key}) : super(key: key);

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
        widget.contact.avatar.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.memory(
                  widget.contact.avatar,
                  width: 42,
                  height: 42,
                ))
            : Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: ContactListEntry._randomColor
                      .randomColor(colorHue: ColorHue.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    widget.contact.initials(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFFFBECDE)),
            child: Text(
              'Direkter Kontakt',
              style: TextStyle(
                color: Color(0xFF803219),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFFFCF5BA)),
            child: Text(
              'Selber Raum',
              style: TextStyle(
                color: Color(0xFF6B3D1D),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFFE3F6ED)),
            child: Text(
              '2m Abstand',
              style: TextStyle(
                color: Color(0xFF225240),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
}
