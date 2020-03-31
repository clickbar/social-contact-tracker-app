import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  static final _SHORT_DATE_FORMAT = DateFormat('dd.MM.yyyy');

  String toShortDateFormat() => _SHORT_DATE_FORMAT.format(this);

  String toDisplayDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compare = DateTime(this.year, this.month, this.day);

    final dayDifference = today.difference(compare).inDays;

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

  String toDisplayDateWithTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compare = DateTime(this.year, this.month, this.day);

    final time = DateFormat('kk:mm').format(this);

    final dayDifference = today.difference(compare).inDays;

    if (dayDifference == 0) {
      return 'Heute um ${time}';
    }

    if (dayDifference == 1) {
      return 'Gestern um ${time}';
    }

    if (dayDifference == 2) {
      return 'Vorgestern um ${time}';
    }

    if (dayDifference < 15) {
      return 'Vor $dayDifference Tagen';
    }

    return 'Vor 2 Wochen';
  }
}
