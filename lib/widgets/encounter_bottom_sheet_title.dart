import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/selected_contacts/selected_contacts_bloc.dart';

import 'flat_round_icon_button.dart';

class EncounterBottomSheetTitle extends SliverPersistentHeaderDelegate {
  static const HEIGHT = 61.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: Row(
              children: <Widget>[
                Text(
                  'Begegnungen',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<SelectedContactsBloc, SelectedContactsState>(
                    condition: (s1, s2) =>
                        s2 is ContactInsertState || s2 is ContactRemovedState,
                    builder: (context, state) {
                      final count =
                          BlocProvider.of<SelectedContactsBloc>(context)
                              .contacts
                              .length;
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF2D3748)),
                        height: 28,
                        width: 28,
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BlocBuilder<SelectedContactsBloc, SelectedContactsState>(
              condition: (s1, s2) =>
                  s2 is NoContactsSelectedState || s2 is ContactsSelectedState,
              builder: (context, state) {
                return FlatRoundIconButton(
                  child: Text('Hinzufügen'),
                  endIcon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: state is NoContactsSelectedState ? null : () {},
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => HEIGHT;

  @override
  double get minExtent => HEIGHT;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
