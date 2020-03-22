import 'package:flutter/material.dart';
import 'package:social_contact_tracker/database/covid_database.dart';
import 'package:social_contact_tracker/dialogs/info_dialog.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:social_contact_tracker/widgets/with_material_hero.dart';

class CovidStatusSetupScreen extends StatefulWidget {
  final String name;

  CovidStatusSetupScreen(this.name, {Key key}) : super(key: key);

  @override
  _CovidStatusSetupScreenState createState() => _CovidStatusSetupScreenState();
}

class _CovidStatusSetupScreenState extends State<CovidStatusSetupScreen> {
  CovidStatus _covidStatus = CovidStatus.NO_CONTACT;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B6CB0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 64),
                Center(
                  child: Hero(
                    tag: 'sign_in_logo',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2/ 6,
                      child: Image.asset('assets/images/logbook_logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 64),
                WithMaterialHero(
                  tag: 'setup_title',
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Hi ${widget.name},',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Was ist dein Corona Status?',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 48),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: new Hero(
                    tag: "preview",
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, bottom: 16),
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
                                    'Status wählen',
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
                            const SizedBox(height: 16),
                            _getCovidStatusRow(CovidStatus.NO_CONTACT),
                            const SizedBox(height: 8),
                            _getCovidStatusRow(CovidStatus.CONTACT_2),
                            const SizedBox(height: 8),
                            _getCovidStatusRow(CovidStatus.CONTACT_1),
                            const SizedBox(height: 8),
                            _getCovidStatusRow(CovidStatus.POSITIVE),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Hero(
                    tag: 'setup_action_button',
                    child: FlatRoundIconButton(
                      onTap: _onContinueWithCovidStatus,
                      child: Text('Weiter'),
                      endIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
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

  _onContinueWithCovidStatus()  async {
    await CovidDatabase().updateCurrentCovidStatus(_covidStatus);
    Navigator.of(context).pushReplacementNamed('/encounter');
  }


  Widget _getCovidStatusRow(CovidStatus covidStatus) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(99)),
        onTap: () {
          setState(() {
            _covidStatus = covidStatus;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: covidStatus == _covidStatus
              ? BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                )
              : BoxDecoration(),
          child: Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: covidStatus.toBackgroundColor(),
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                covidStatus.toDispalyText(),
                style: TextStyle(
                    color: covidStatus.toTextColor(),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
