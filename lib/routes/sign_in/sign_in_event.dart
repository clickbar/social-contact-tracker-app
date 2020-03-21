part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class VerifyPhoneNumberEvent extends SignInEvent {
  final String phoneNumber;

  VerifyPhoneNumberEvent(this.phoneNumber);
}

class PhoneVerificationCompletedEvent extends SignInEvent {
  final AuthCredential authCredential;

  PhoneVerificationCompletedEvent(this.authCredential);
}

class PhoneVerificationFailedEvent extends SignInEvent {
  final AuthException authException;

  PhoneVerificationFailedEvent(this.authException);
}

class PhoneCodeSentEvent extends SignInEvent {
  final String verificationId;

  PhoneCodeSentEvent(this.verificationId);
}

class PhoneCodeAutoRetrievalTimeoutEvent extends SignInEvent {
  final String verificationId;

  PhoneCodeAutoRetrievalTimeoutEvent(this.verificationId);
}

class SignInWithPhoneNumberEvent extends SignInEvent {
  final String smsCode;

  SignInWithPhoneNumberEvent(this.smsCode);
}
