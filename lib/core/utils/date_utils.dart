import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String formatTime(DateTime date) => DateFormat('HH:mm').format(date);

  static String formatDayOfWeek(DateTime date) => DateFormat('EEEE', 'ko').format(date);

  static String formatShortDate(DateTime date) => DateFormat('M/d (E)', 'ko').format(date);
}
