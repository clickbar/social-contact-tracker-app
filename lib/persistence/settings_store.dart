import 'package:shared_preferences/shared_preferences.dart';

class UserStore {
  static final UserStore _instance = UserStore._internal();

  factory UserStore() {
    return _instance;
  }

  UserStore._internal() {}

  static const _KEY_SENT_NOTIFICATION_TOKEN = 'sendNotificationToken';

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

}
