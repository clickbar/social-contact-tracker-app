part of 'sign_in_bloc.dart';

@immutable
@sealed
abstract class SignInState {}

class InitialSignInState extends SignInState {}

abstract class VerificationIdAvailableState extends SignInState {
  final String verificationId;

  VerificationIdAvailableState(this.verificationId);
}

class PhoneCodeSentState extends VerificationIdAvailableState {
  PhoneCodeSentState(String verificationId) : super(verificationId);
}

class PhoneCodeAutoRetrievalTimeoutState extends VerificationIdAvailableState {
  PhoneCodeAutoRetrievalTimeoutState(String verificationId)
      : super(verificationId);
}

class SignInWithPhoneSuccessfulState extends SignInState {
  final bool withoutSms;

  SignInWithPhoneSuccessfulState({this.withoutSms});
}

class SignInWithPhoneFailedState extends SignInState {}

class PhoneVerificationFailedState extends SignInState {
  final AuthException authException;

  PhoneVerificationFailedState(this.authException);
}
