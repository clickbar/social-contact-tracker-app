import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:contacts_service/contacts_service.dart' as address_book;

class CovidApi {
  static const _FUNCTION_ADD_NOTIFICATION_TOKEN = 'addNotificationToken';
  static const _FUNCTION_SEND_NOTIFICATION_TO_CONTACTS =
      'sendNotificationToContacts';
  static const _FUNCTION_MATCH_PHONE_NUMBER = 'matchPhoneNumbers';

  static final CovidApi _instance = CovidApi._internal();

  factory CovidApi() {
    return _instance;
  }

  CovidApi._internal() {}

  Future<bool> addNotificationToken(String token) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: _FUNCTION_ADD_NOTIFICATION_TOKEN,
    );

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'token': token,
        },
      );
      print(result.data);
      return true;
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    return false;
  }

  Future<bool> notifyCovidStatusChanged(
      List<Contact> contacts, CovidStatus covidStatus) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: _FUNCTION_SEND_NOTIFICATION_TO_CONTACTS,
    );

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'recipients': contacts.map((c) => c.firebaseUid),
          'status': covidStatus.toDatabaseString(),
        },
      );
      print(result.data);
      return true;
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    return false;
  }

  Future<bool> syncContacts(List<address_book.Contact> contacts) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: _FUNCTION_MATCH_PHONE_NUMBER,
    );

    // Loop over all contacts and build the parameters
    final contactParamList = [];
    final HashSet<String> alreadyAddedSet = HashSet<String>();

    for (var contact in contacts) {
      for (var phone in contact.phones) {
        // Since the same number might be there multiple times
        // Filter duplicates using a hash set
        if (!alreadyAddedSet.contains('${contact.identifier}_${phone.value}')) {
          contactParamList.add({
            'identifier': contact.identifier,
            'phoneNumber': phone.value,
          });
          alreadyAddedSet.add('${contact.identifier}_${phone.value}');
        }
      }
    }

    print('Anzahl ${contactParamList.length}');

    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'contacts': contactParamList,
        },
      );
      print(result.data);
      return true;
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    return false;
  }
}
