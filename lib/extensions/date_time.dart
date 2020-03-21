extension DateTimeExtensions on DateTime {
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
