import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/contact_search/contact_search_bloc.dart';
import 'package:social_contact_tracker/widgets/contact_list_entry.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';

class ContactSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactSearchBloc>(
      create: (_) => ContactSearchBloc()..add(LoadContactsEvent()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color(0xFFF3F5FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                margin: const EdgeInsets.only(
                    top: 40, bottom: 16, left: 16, right: 16),
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
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 16.0),
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
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            if (index.isEven) {
                              return ContactListEntry(recents[index ~/ 2]);
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
              BlocBuilder<ContactSearchBloc, ContactSearchState>(
                builder: (context, state) {
                  if (state is ContactsLoadedState) {
                    return SliverPadding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index.isEven) {
                              return ContactListEntry(state.contacts[index ~/ 2]);
                            }
                            return const SizedBox(height: 12);
                          },
                          childCount: state.contacts.length * 2 - 1,
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter();
                },
              ),
            ],
          ),
          bottomNavigationBar: Material(
            elevation: 8,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            type: MaterialType.card,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Begegnungen',
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: FlatRoundIconButton(
                        child: Text('Hinzufügen'),
                        endIcon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
