import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/dialogs/info_dialog.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/routes/profile/covid_status_change_dialog.dart';
import 'package:social_contact_tracker/routes/profile/profile_bloc.dart';
import 'package:social_contact_tracker/widgets/contact_avatar.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:social_contact_tracker/extensions/list.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc()..add(LoadProfileEvent()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color(0xFFF3F5FA),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: Material(
              elevation: 4,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Color(0xFF3182CE),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoadedState) {
                        return Text('Gude ${state.name}',
                            style: TextStyle(
                                color: Color(0xFF2D3748),
                                fontSize: 28,
                                fontWeight: FontWeight.w600));
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(height: 24)
                ],
              ),
            ),
          ),
          body: Container(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return Container();
                }

                if (state is ProfileLoadedState) {
                  int possibleContactCount = 0;

                  bool enoughSpace = true;
                  final availableWidth =
                      MediaQuery.of(context).size.width - 2 * 16.0 - 2 * 16.0;
                  final neededWidth = state.statusShareContacts.length * 24 +
                      (state.statusShareContacts.length - 1) * 10;
                  if (neededWidth > availableWidth) {
                    // --> Not enough space
                    final difference = neededWidth - availableWidth;
                    final removeAmount = (difference / (24.0 + 10.0)).ceil();
                    possibleContactCount =
                        state.statusShareContacts.length - removeAmount - 1;
                    enoughSpace = false;
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Du bist angemeldet mit der Nr.',
                                style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(state.phoneNumber,
                                  style: TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          child: Hero(
                            tag: 'preview',
                            child: Material(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 16, bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Text(
                                            'Dein Status',
                                            style: TextStyle(
                                                color: Color(0xFF718096),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, right: 2.0),
                                          child: IconButton(
                                            icon: Icon(Icons.info,
                                                color: Color(0xFFCBD5E0)),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  child: InfoDialog(
                                                    onlyCovidStatus: true,
                                                  ));
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: state.covidStatus
                                                .toBackgroundColor(),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.covidStatus.toDispalyText(),
                                          style: TextStyle(
                                            color:
                                                state.covidStatus.toTextColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.only(right: 16),
                                      alignment: Alignment.bottomRight,
                                      child: FlatRoundIconButton(
                                        child: Text('Status Bearbeiten'),
                                        onTap: () => _editCovidStatusTapped(
                                            context,
                                            state.statusShareContacts.length,
                                            state.covidStatus),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Dein Status wird geteilt mit',
                                style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: '${state.statusShareContacts.length} ',
                                  style: TextStyle(
                                      color: Color(0xFF2C5282),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(
                                        text:
                                            state.statusShareContacts.length ==
                                                    1
                                                ? 'Kontakt'
                                                : 'Kontakten',
                                        style: TextStyle(
                                            color: Color(0xFF718096))),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  if (enoughSpace)
                                    ...state.statusShareContacts.separated(
                                        element: (e, _) => ContactAvatar(e,
                                            size: 24, radius: 99),
                                        separator: (_) =>
                                            const SizedBox(width: 10)),
                                  if (!enoughSpace) ...[
                                    for (var i = 0;
                                        i < possibleContactCount * 2;
                                        i++)
                                      i.isEven
                                          ? ContactAvatar(
                                              state.statusShareContacts[i ~/ 2],
                                              size: 24,
                                              radius: 99)
                                          : const SizedBox(width: 10),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE6EBF8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Icon(
                                        Icons.add,
                                        color: Color(0xFF718096),
                                        size: 16,
                                      )),
                                    ),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 24),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: FlatRoundIconButton(
                                  child: Text('Liste bearbeiten'),
                                  onTap: () => _editSharedContactsPressed(
                                      context, state.statusShareContacts),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'In deinem Haushalt leben',
                                style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 16),
                              state.livingWithContacts.isEmpty
                                  ? Text(
                                      'Du wohnst alleine',
                                      style: TextStyle(
                                          color: Color(0xFF718096),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: state.livingWithContacts
                                          .separated(
                                              element: (c, _) => Row(
                                                    children: <Widget>[
                                                      ContactAvatar(c,
                                                          size: 24, radius: 99),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        c.displayName,
                                                        style: (TextStyle(
                                                          color:
                                                              Color(0xFF718096),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                              separator: (_) => const SizedBox(
                                                  height: 12.0))),
                              const SizedBox(height: 24),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: FlatRoundIconButton(
                                  child: Text('Haushalt bearbeiten'),
                                  onTap: () => _editLivingTogetherPressed(
                                      context, state.livingWithContacts),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  _editCovidStatusTapped(BuildContext context, int statusShareContactCount,
      CovidStatus currentCovidStatus) async {
    final newCovidStatus = await Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black26,
        pageBuilder: (_, __, ___) => CovidStatusChangeDialog(
          statusShareContactCount: statusShareContactCount,
          currentCovidStatus: currentCovidStatus,
        ),
      ),
    );

    if (newCovidStatus != null && newCovidStatus != currentCovidStatus) {
      BlocProvider.of<ProfileBloc>(context)
          .add(UpdateCovidStatusEvent(newCovidStatus));
    }
  }

  _editSharedContactsPressed(
      BuildContext context, List<Contact> initialSelection) {
    _showContactSelection(
        context,
        initialSelection,
        'Share With',
        (Contact c) => CovidDatabase().storeShareStatusFor(c),
        () => CovidDatabase().clearStoredShareStatusSelection());
  }

  _editLivingTogetherPressed(
      BuildContext context, List<Contact> initialSelection) {
    _showContactSelection(
        context,
        initialSelection,
        'Haushalt wählen',
        (Contact c) => CovidDatabase().storeLivingTogetherFor(c),
        () => CovidDatabase().clearStoredLivingTogetherSelection());
  }

  _showContactSelection(
      BuildContext context,
      List<Contact> initialSelection,
      String title,
      Future Function(Contact) storeSelectionFunction,
      Future Function() clearStoredSelectionFunction) async {
    final response =
        await Navigator.of(context).pushNamed('/contactSelection', arguments: {
      'initial_selection': initialSelection,
      'title': title,
      'store_seletion_function': storeSelectionFunction,
      'clear_stored_seletion_function': clearStoredSelectionFunction,
    });

    if (response != null && response) {
      BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent());
    }
  }
}
