import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/routes/contact_selection/contact_selection/contact_selection_bloc.dart';
import 'package:social_contact_tracker/routes/contact_selection/contact_selection_search_widget.dart';
import 'package:social_contact_tracker/routes/contact_selection/searchable_contact_list/searchable_contact_list_bloc.dart';
import 'package:social_contact_tracker/widgets/selectable_bottom_sheet_title.dart';
import 'package:social_contact_tracker/widgets/selectable_contact_list_entry.dart';
import 'package:social_contact_tracker/widgets/selected_contact_entry.dart';

class ContactSelectionListScreen extends StatelessWidget {
  final String title;
  final List<Contact> initialSelection;
  final Future Function(Contact) storeSelectionFunction;
  final Future Function() clearStoredSelectionFunction;
  final _listKey =
      GlobalKey<SliverAnimatedListState>(debugLabel: 'ContactSelectionListkey');

  ContactSelectionListScreen(
      {Key key,
      this.title,
      this.initialSelection,
      this.storeSelectionFunction,
      this.clearStoredSelectionFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchableContactListBloc>(
          create: (_) =>
              SearchableContactListBloc()..add(LoadContactListEvent()),
        ),
        BlocProvider<ContactSelectionBloc>(
            create: (_) => ContactSelectionBloc(initialSelection,
                storeSelectionFunction, clearStoredSelectionFunction)),
      ],
      child: Builder(
        builder: (context) =>
            BlocListener<ContactSelectionBloc, ContactSelectionState>(
          listener: (context, state) {
            if (state is SelectionStorageDoneState) {
              Navigator.of(context).pop(true);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Color(0xFFF3F5FA),
            appBar: AppBar(
              title: Text(
                title,
                style: TextStyle(color: Color(0xFF2D3748)),
              ),
              backgroundColor: Colors.white,
              elevation: 4.0,
              brightness: Brightness.light,
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
                  child: ContactSelectionSearchWidget(),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                BlocBuilder<SearchableContactListBloc,
                    SearchableContactListState>(
                  builder: (context, state) {
                    Widget widget = Container();

                    if (state is ContactListLoadingState) {
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

                    if (state is ContactListLoadedState) {
                      widget = Padding(
                        padding: const EdgeInsets.only(bottom: 190),
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverPadding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (index.isEven) {
                                      return SelectableContactListEntry(
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
                  initialChildSize: 0.25,
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
                            delegate:
                                SelectableBottomSheetTitle('Title und so'),
                          ),
                          BlocBuilder<ContactSelectionBloc,
                              ContactSelectionState>(
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
                            initialItemCount: initialSelection.length,
                            itemBuilder: (context, index, animation) {
                              return SelectedContactEntry(
                                BlocProvider.of<ContactSelectionBloc>(context)
                                    .contacts[index],
                                animation: animation,
                              );
                            },
                          ),
                          BlocListener<ContactSelectionBloc,
                              ContactSelectionState>(
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
                                  return SelectedContactEntry(
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
      ),
    );
  }
}
