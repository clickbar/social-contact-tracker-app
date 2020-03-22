import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/encounter_date_selection/encounter_date_selection_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/selected_contacts/selected_contacts_bloc.dart';
import 'package:social_contact_tracker/extensions/date_time.dart';

import 'flat_round_icon_button.dart';

class EncounterBottomSheetTitle extends SliverPersistentHeaderDelegate {
  static const HEIGHT = 90.0;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
                            s2 is ContactInsertState ||
                            s2 is ContactRemovedState,
                        builder: (context, state) {
                          final count =
                              BlocProvider.of<SelectedContactsBloc>(context)
                                  .contacts
                                  .length;
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF2D3748)),
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
                      s2 is NoContactsSelectedState ||
                      s2 is ContactsSelectedState ||
                      s2 is StoringEncountersState ||
                      s2 is EncountersStoredState,
                  builder: (context, state) {
                    return FlatRoundIconButton(
                      child: Text('Hinzufügen'),
                      endIcon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      onTap: state is NoContactsSelectedState ||
                              state is StoringEncountersState
                          ? null
                          : () {
                              BlocProvider.of<SelectedContactsBloc>(context)
                                  .add(AddToEncountersEvent());
                            },
                    );
                  },
                ),
              )
            ],
          ),
          BlocBuilder<EncounterDateSelectionBloc, EncounterDateSelectionState>(
            builder: (context, state) {
              return InkWell(
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    state.dateTime.toDisplayDate(),
                    style: TextStyle(
                      color: Color(0xFF2B6CB0),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () => _onShowDatePicker(context, state.dateTime),
              );
            },
          ),
        ],
      ),
    );
  }

  _onShowDatePicker(BuildContext context, DateTime currentDate) async {
    final date = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2018),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(primaryColor: Color(0xFF2C5282)),
            child: child,
          );
        });
    if (date != null &&
        date.toShortDateFormat() != currentDate.toShortDateFormat()) {
      BlocProvider.of<EncounterDateSelectionBloc>(context)
          .add(EncounterDateChangedEvent(date));
    }
  }

  @override
  double get maxExtent => HEIGHT;

  @override
  double get minExtent => HEIGHT;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
