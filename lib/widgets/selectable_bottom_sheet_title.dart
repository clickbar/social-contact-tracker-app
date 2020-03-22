import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/selected_contacts/selected_contacts_bloc.dart';
import 'package:social_contact_tracker/routes/contact_selection/contact_selection/contact_selection_bloc.dart';

import 'flat_round_icon_button.dart';

class SelectableBottomSheetTitle extends SliverPersistentHeaderDelegate {
  static const HEIGHT = 61.0;

  final String title;

  SelectableBottomSheetTitle(this.title);

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
                  title,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF2D3748)),
                  height: 28,
                  width: 28,
                  child: Center(
                    child: BlocBuilder<ContactSelectionBloc,
                        ContactSelectionState>(
                      builder: (context, state) {
                        return Text(
                          BlocProvider.of<ContactSelectionBloc>(context)
                              .contacts
                              .length
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BlocBuilder<ContactSelectionBloc, ContactSelectionState>(
              builder: (BuildContext context, ContactSelectionState state) {
                return FlatRoundIconButton(
                    child: Text('Speichern'),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: state is SelectionStorageInProgressState
                        ? null
                        : () {
                            BlocProvider.of<ContactSelectionBloc>(context)
                                .add(SaveSelectionEvent());
                          });
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
