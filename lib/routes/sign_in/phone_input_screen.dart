import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/sign_in/sign_in_bloc.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:social_contact_tracker/widgets/with_material_hero.dart';

class PhoneInputScreen extends StatefulWidget {
  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  TextEditingController _phoneTextController;
  FocusNode _phoneFocusNode;

  @override
  void initState() {
    super.initState();

    _phoneTextController = TextEditingController(text: '+49 ');
    _phoneFocusNode = FocusNode();

    Future.delayed(Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is PhoneCodeSentState) {
          Navigator.of(context).pushNamed('/smscode');
        }
        if (state is SignInWithPhoneSuccessfulState && state.withoutSms) {
          Navigator.of(context).pushNamed('/home');
        }
      },
      child: Scaffold(
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
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        height: MediaQuery.of(context).size.width * 2 / 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF3182CE),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 64),
                  WithMaterialHero(
                    tag: 'sign_in_title',
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        'Gude',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Handynummer',
                    style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  WithMaterialHero(
                    tag: 'sign_in_textfield',
                    child: TextField(
                      focusNode: _phoneFocusNode,
                      controller: _phoneTextController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Color(0xFF3182CE),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0.0),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0)),
                            gapPadding: 0.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF63B3ED), width: 1.0),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0)),
                            gapPadding: 0.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0.0),
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
                      tag: 'sign_in_action_button',
                      child: FlatRoundIconButton(
                        onTap: () {
                          print('Phone entered : Bloc=${BlocProvider.of<SignInBloc>(context).hashCode}');
                          BlocProvider.of<SignInBloc>(context).add(
                              VerifyPhoneNumberEvent(
                                  _phoneTextController.text));
                        },
                        child: Text('Los gehts'),
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
      ),
    );
  }
}
