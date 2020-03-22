import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/routes/contact_selection/contact_selection/contact_selection_bloc.dart';

import 'contact_avatar.dart';

class SelectableContactListEntry extends StatelessWidget {
  final Contact contact;

  const SelectableContactListEntry(this.contact, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap:
              BlocProvider.of<ContactSelectionBloc>(context).isSelected(contact)
                  ? null
                  : () {
                      if (!BlocProvider.of<ContactSelectionBloc>(context)
                          .isSelected(contact)) {
                        BlocProvider.of<ContactSelectionBloc>(context)
                            .add(SelectContactEvent(contact));
                      }
                    },
          child: Container(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: Row(
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    ContactAvatar(
                      contact,
                      size: 42,
                      radius: 10,
                    ),
                    BlocBuilder<ContactSelectionBloc, ContactSelectionState>(
                      builder: (context, state) {
                        if (BlocProvider.of<ContactSelectionBloc>(context)
                            .isSelected(contact)) {
                          return Positioned(
                            bottom: -6,
                            right: -6,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF2C5282),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Icon(
                                Icons.done,
                                color: Color(0xFFFAFAFA),
                                size: 12,
                              ),
                            ),
                          );
                        }

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contact.displayName,
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        contact.phone,
                        style: TextStyle(
                          color: Color(0xFF2D3748).withOpacity(0.54),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ContactSelectionBloc, ContactSelectionState>(
                  condition: (s1, s2) =>
                      s2 is ContactRemovedState || s2 is ContactInsertState,
                  builder: (context, state) {
                    if (BlocProvider.of<ContactSelectionBloc>(context)
                        .isSelected(contact)) {
                      return TweenAnimationBuilder(
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value,
                            child: child,
                          );
                        },
                        tween: Tween<double>(begin: 0, end: 3 / 4 * pi),
                        curve: Curves.easeInOutCirc,
                        duration: Duration(milliseconds: 300),
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Color(0xFF718096),
                            ),
                            onPressed: () {
                              BlocProvider.of<ContactSelectionBloc>(context)
                                  .add(RemoveContactEvent(contact));
                            }),
                      );
                    }

                    if (state is ContactRemovedState &&
                        state.contact.id == contact.id) {
                      return TweenAnimationBuilder(
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value,
                            child: child,
                          );
                        },
                        tween: Tween<double>(begin: 3 / 4 * pi, end: 0),
                        curve: Curves.easeInOutCirc,
                        duration: Duration(milliseconds: 300),
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Color(0xFF718096),
                            ),
                            onPressed: null),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
