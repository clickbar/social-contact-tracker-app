import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/contact_search_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/selected_contacts/selected_contacts_bloc.dart';
import 'package:social_contact_tracker/widgets/contact_list_entry.dart';
import 'package:social_contact_tracker/widgets/encounter_bottom_sheet_title.dart';
import 'package:social_contact_tracker/widgets/encountered_contact_entry.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';

class ContactSearchScreen extends StatelessWidget {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContactSearchBloc>(
          create: (_) => ContactSearchBloc()..add(LoadContactsEvent()),
        ),
        BlocProvider<SelectedContactsBloc>(
            create: (_) => SelectedContactsBloc()),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color(0xFFF3F5FA),
          appBar: AppBar(
            title: Text('Begegnungen hinzufügen',
                style: TextStyle(color: Color(0xFF2D3748))),
            backgroundColor: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Container(
                margin: const EdgeInsets.only(
                    top: 0, bottom: 16, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Kontakte suchen',
                    hintStyle: TextStyle(
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    fillColor: Color(0xFFF3F5FA),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(16.0)),
                        gapPadding: 0.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF63B3ED), width: 1.0),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(16.0)),
                        gapPadding: 0.0),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(16.0)),
                        gapPadding: 0.0),
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              BlocBuilder<ContactSearchBloc, ContactSearchState>(
                builder: (BuildContext context, ContactSearchState state) {
                  Widget widget = Container();

                  if (state is ContactsLoadingState) {
                    widget = Container(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, bottom: 200),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Kontakte werden geladen...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ContactPermissionDeniedState) {
                    widget = Container(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, bottom: 200),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Damit du einfach Begegnungen hinzufügen kannst, müssen wir auf die Kontakte in deinem Adressbuch zugreifen.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 16),
                            FlatRoundIconButton(
                              onTap: () {
                                BlocProvider.of<ContactSearchBloc>(context)
                                    .add(RequestContactPermissionEvent());
                              },
                              child: Text('Zugriff zulassen'),
                              startIcon: Icon(
                                Icons.security,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ContactsLoadedState) {
                    widget = Padding(
                      padding: const EdgeInsets.only(bottom: 190),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 24.0, left: 16.0),
                              child: Text(
                                'Zuletzt hinzugefügt',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF718096)),
                              ),
                            ),
                          ),
                          BlocBuilder<ContactSearchBloc, ContactSearchState>(
                            builder: (context, state) {
                              if (state is ContactsLoadedState) {
                                final recents = List.of(state.contacts);
                                recents.shuffle();
                                return SliverPadding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 16),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (index.isEven) {
                                          return ContactListEntry(
                                              recents[index ~/ 2]);
                                        }
                                        return const SizedBox(height: 12);
                                      },
                                      childCount: 3 * 2 - 1,
                                    ),
                                  ),
                                );
                              }
                              return SliverToBoxAdapter();
                            },
                          ),
                          SliverToBoxAdapter(
                            child: const SizedBox(height: 16),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (index.isEven) {
                                    return ContactListEntry(
                                        state.contacts[index ~/ 2]);
                                  }
                                  return const SizedBox(height: 12);
                                },
                                childCount: state.contacts.length * 2 - 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: widget,
                  );
                },
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.3,
                builder: (BuildContext context, myscrollController) {
                  return Material(
                    elevation: 8,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    type: MaterialType.card,
                    child: CustomScrollView(
                      controller: myscrollController,
                      slivers: <Widget>[
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: EncounterBottomSheetTitle(),
                        ),
                        BlocBuilder<SelectedContactsBloc,
                            SelectedContactsState>(
                          condition: (s1, s2) =>
                              s2 is NoContactsSelectedState ||
                              s2 is ContactsSelectedState,
                          builder: (context, state) {
                            return SliverToBoxAdapter(
                              child: state is! NoContactsSelectedState
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(top: 24),
                                      child: Center(
                                        child: Text(
                                          'Kontakte, die du auswählst werden hier\nangezeigt',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFFAFAFAF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                        SliverAnimatedList(
                          key: _listKey,
                          initialItemCount: 0,
                          itemBuilder: (context, index, animation) {
                            return EncounteredContactEntry(
                              BlocProvider.of<SelectedContactsBloc>(context)
                                  .contacts[index],
                              animation: animation,
                            );
                          },
                        ),
                        BlocListener<SelectedContactsBloc,
                            SelectedContactsState>(
                          condition: (s1, s2) =>
                              s2 is ContactInsertState ||
                              s2 is ContactRemovedState,
                          listener: (context, state) {
                            if (state is ContactInsertState) {
                              _listKey.currentState.insertItem(state.index);
                            }
                            if (state is ContactRemovedState) {
                              _listKey.currentState.removeItem(state.index,
                                  (context, animation) {
                                return EncounteredContactEntry(
                                  state.contact,
                                  animation: animation,
                                );
                              });
                            }
                          },
                          child: SliverToBoxAdapter(
                            child: Container(),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
