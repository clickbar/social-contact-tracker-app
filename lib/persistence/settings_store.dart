import 'package:shared_preferences/shared_preferences.dart';

class UserStore {
  static final UserStore _instance = UserStore._internal();

  factory UserStore() {
    return _instance;
  }

  UserStore._internal() {}

  static const _KEY_SENT_NOTIFICATION_TOKEN = 'sendNotificationToken';
  static const _KEY_PHONE_NUMBER = 'phoneNumber';
  static const _KEY_NAME = 'name';

  setNotificationTokenAsSent(String notificationToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_SENT_NOTIFICATION_TOKEN, notificationToken);
  }

  Future<String> getSentNotificationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_KEY_SENT_NOTIFICATION_TOKEN)
        ? prefs.getString(_KEY_SENT_NOTIFICATION_TOKEN)
        : null;
  }

  setPhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_PHONE_NUMBER, phoneNumber);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_PHONE_NUMBER);
  }

  setName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_NAME, name);
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_NAME);
  }
}
