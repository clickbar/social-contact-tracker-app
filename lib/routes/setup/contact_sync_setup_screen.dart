import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/setup/contact_sync/contact_sync_bloc.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:social_contact_tracker/widgets/with_material_hero.dart';

class ContactSyncSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactSyncBloc>(
      create: (_) => ContactSyncBloc()..add(SyncContactsEvent()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color(0xFF2B6CB0),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 64),
                    Align(
                      alignment: Alignment.center,
                      child: Hero(
                        tag: 'sign_in_logo',
                        child: Container(
                          width: MediaQuery.of(context).size.width * 2 / 6,
                          child: Image.asset('assets/images/logbook_logo.png'),
                        ),
                      ),
                    ),
                    BlocBuilder<ContactSyncBloc, ContactSyncState>(
                      builder: (context, state) {
                        if (state is ContactPermissionRequiredState) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 24),
                            child: Center(
                              child: Column(

                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height:80),
                                  Text(
                                    'Damit du einfach Begegnungen hinzufügen kannst, müssen wir auf die Kontakte in deinem Adressbuch zugreifen.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 24),
                                  FlatRoundIconButton(
                                    onTap: () {
                                      BlocProvider.of<ContactSyncBloc>(context)
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

                        if (state is ContactSyncRunningState) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height:80),
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: FlareActor(
                                    "assets/animations/logbook_spinner.flr",
                                    animation: "Untitled",
                                    isPaused: false,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Kontakte werden synchronisiert',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is ContactSyncDoneState) {
                          return Column(
                            children: <Widget>[
                              const SizedBox(height:80),
                              WithMaterialHero(
                                tag: 'setup_title',
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'Und Fertig',
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Jetz kann es losgehen',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Hero(
                                  tag: 'setup_action_button',
                                  child: FlatRoundIconButton(
                                    onTap: () {
                                      Navigator.of(context).pushReplacementNamed('/encounter');
                                    },
                                    child: Text('Abschließen'),
                                    endIcon: Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
