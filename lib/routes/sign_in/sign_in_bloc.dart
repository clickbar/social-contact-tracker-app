import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  SignInState get initialState => InitialSignInState();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is VerifyPhoneNumberEvent) {
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        add(PhoneVerificationCompletedEvent(phoneAuthCredential));
        _auth.signInWithCredential(phoneAuthCredential);
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        add(PhoneVerificationFailedEvent(authException));
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        add(PhoneCodeSentEvent(verificationId));
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        add(PhoneCodeAutoRetrievalTimeoutEvent(verificationId));
      };

      await _auth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }

    if (event is PhoneVerificationCompletedEvent) {
      yield* _signInWithCredential(event.authCredential, withoutSms: true);
    }

    if (event is PhoneVerificationFailedEvent) {
      print(event.authException.message);
      yield PhoneVerificationFailedState(event.authException);
    }

    if (event is PhoneCodeSentEvent) {
      yield PhoneCodeSentState(event.verificationId);
    }

    if (event is PhoneCodeAutoRetrievalTimeoutEvent) {
      yield PhoneCodeAutoRetrievalTimeoutState(event.verificationId);
    }

    if (event is SignInWithPhoneNumberEvent) {
      final state = this.state;
      print('State = $state');
      if (state is VerificationIdAvailableState) {
        // Create the auth credentials
        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: state.verificationId,
          smsCode: event.smsCode,
        );
        yield* _signInWithCredential(credential);
      }
    }
  }

  Stream<SignInState> _signInWithCredential(AuthCredential credential,
      {bool withoutSms = false}) async* {
    // Sign In with the credentials
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    // Get the user
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    if (user != null) {
      yield SignInWithPhoneSuccessfulState(withoutSms: withoutSms);
    } else {
      yield SignInWithPhoneFailedState();
    }
  }

  @override
  void onTransition(Transition<SignInEvent, SignInState> transition) {
    super.onTransition(transition);
    print('${transition.currentState} + ${transition.event} => ${transition.nextState}');
  }
}
