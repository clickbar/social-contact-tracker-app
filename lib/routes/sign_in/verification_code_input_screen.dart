import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/sign_in/sign_in_bloc.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:social_contact_tracker/widgets/with_material_hero.dart';

class VerificationCodeInputScreen extends StatefulWidget {
  @override
  _VerificationCodeInputScreenState createState() =>
      _VerificationCodeInputScreenState();
}

class _VerificationCodeInputScreenState
    extends State<VerificationCodeInputScreen> {
  TextEditingController _codeTextController;
  FocusNode _codeFocusNode;

  @override
  void initState() {
    super.initState();

    _codeTextController = TextEditingController();
    _codeFocusNode = FocusNode();

    _codeTextController.addListener(_codeChanged);

    Future.delayed(Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(_codeFocusNode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _codeFocusNode.dispose();
    _codeTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInWithPhoneSuccessfulState && !state.withoutSms) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Text(
                        'Code eingeben',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 6 * 34.0,
                    child: WithMaterialHero(
                      tag: 'sign_in_textfield',
                      child: TextField(
                        focusNode: _codeFocusNode,
                        controller: _codeTextController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 34,
                            letterSpacing: 10.0),
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
                  ),
                  const SizedBox(height: 48),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: 'sign_in_action_button',
                      child: FlatRoundIconButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Zurück'),
                        startIcon: Icon(
                          Icons.chevron_left,
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

  _codeChanged() {
    if (_codeTextController.text.length == 6) {
      print('Code complete : Bloc=${BlocProvider.of<SignInBloc>(context).hashCode}');
      BlocProvider.of<SignInBloc>(context)
          .add(SignInWithPhoneNumberEvent(_codeTextController.text));
    }
  }
}
