import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/persistence/settings_store.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:social_contact_tracker/widgets/with_material_hero.dart';

class NameSetupScreen extends StatefulWidget {
  @override
  _NameSetupScreenState createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  TextEditingController _nameTextController;
  FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();

    _nameTextController = TextEditingController();
    _nameFocusNode = FocusNode();

    Future.delayed(Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(_nameFocusNode);
    });
  }

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
                    child: Image.asset(
                      'assets/images/logbook_logo.png',
                      width: MediaQuery.of(context).size.width * 2 / 5,
                    ),
                  ),
                ),
                const SizedBox(height: 64),
                WithMaterialHero(
                  tag: 'setup_title',
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Willkommen,',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Wie sollen wir dich nennen?',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 40),
                Text(
                  'Name',
                  style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                WithMaterialHero(
                  tag: 'setup_textfield',
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    focusNode: _nameFocusNode,
                    controller: _nameTextController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Color(0xFF3182CE),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0.0),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0)),
                          gapPadding: 0.0),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF63B3ED), width: 1.0),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0)),
                          gapPadding: 0.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0.0),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0)),
                          gapPadding: 0.0),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Hero(
                    tag: 'setup_action_button',
                    child: FlatRoundIconButton(
                      onTap: _maybeSaveNameAndContinue,
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

  _maybeSaveNameAndContinue() async {
    if (_nameTextController.text.isNotEmpty) {
      await UserStore().setName(_nameTextController.text);
      Navigator.of(context).pushReplacementNamed('/setupCovidStatus',
          arguments: {'name': _nameTextController.text});
    }
  }
}
