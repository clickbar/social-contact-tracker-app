import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/model/encountered_contact.dart';
import 'package:social_contact_tracker/routes/encounter_timeline/encounter_timeline_bloc.dart';
import 'package:social_contact_tracker/routes/encounter_timeline/encountered_contact_entry_widget.dart';
import 'package:social_contact_tracker/extensions/date_time.dart';
import 'package:social_contact_tracker/routes/profile/profile_screen.dart';
import 'package:social_contact_tracker/dialogs/info_dialog.dart';

class EncounterTimelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EncounterTimelineBloc>(
      create: (_) => EncounterTimelineBloc()..add(LoadEncountersEvent()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color(0xFFF3F5FA),
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Deine Begegnungen',
              style: TextStyle(color: Colors.black),
            ),
            brightness: Brightness.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          body: BlocBuilder<EncounterTimelineBloc, EncounterTimelineState>(
            builder: (BuildContext context, EncounterTimelineState state) {
              if (state is EncounterTimelineLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is EncounterTimelineLoadedState) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final element = state.entries[index];
                    if (element is DateTime) {
                      return Container(
                        padding:
                            const EdgeInsets.only(left: 16, top: 24, bottom: 6),
                        child: Text(
                          element.toDisplayDate(),
                          style: TextStyle(
                            color: Color(0xFF2D3748),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    if (element is EncounteredContact) {
                      return EncounteredContactEntryWidget(element);
                    }

                    return Container();
                  },
                  itemCount: state.entries.length,
                );
              }

              return Container();
            },
          ),
          bottomNavigationBar: Container(
            height: 200,
            padding: const EdgeInsets.only(top: 64),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00F3F5FA), Color(0xFFF3F5FA)],
              stops: [0.0, 0.7],
            )),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    child: Container(
                      width: 68 * 2 + 72.0,
                      height: 48,
                      child: Material(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => InfoDialog());
                              },
                              child: Container(
                                height: double.infinity,
                                width: 80,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 22),
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.info,
                                    color: Color(0xFFCBD5E0),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/profile');
                              },
                              child: Container(
                                height: double.infinity,
                                width: 80,
                                child: Container(
                                  padding: const EdgeInsets.only(right: 22),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xFFCBD5E0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 72,
                    height: 72,
                    child: Material(
                      color: Color(0xFF2B6CB0),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Icon(Icons.add, color: Colors.white),
                        onTap: () => _onAddEncounterPressed(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onAddEncounterPressed(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed('/addEncounters');
    if (result != null && result) {
      BlocProvider.of<EncounterTimelineBloc>(context)
          .add(LoadEncountersEvent());
    }
  }
}
