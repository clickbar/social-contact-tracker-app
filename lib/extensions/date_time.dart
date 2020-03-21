import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {

  static final _SHORT_DATE_FORMAT = DateFormat('dd.MM.yyyy');

  String toShortDateFormat() => _SHORT_DATE_FORMAT.format(this);

  String toDisplayDate() {
    final dayDifference = DateTime.now().difference(this).inDays;

    if (dayDifference == 0) {
      return 'Heute';
    }

    if (dayDifference == 1) {
      return 'Gestern';
    }

    if (dayDifference == 2) {
      return 'Vorgestern';
    }

    if (dayDifference < 15) {
      return 'Vor $dayDifference Tagen';
    }

    return 'Vor 2 Wochen';
  }
}
