import 'package:app/models/schedule.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDayMonth(DateTime date) {
    return '${date.day}/${date.month}';
  }

  static String formatTimeRange(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) return '';

    // Lấy giờ và phút (format HH:mm)
    String start = startTime.substring(0, 5);
    String end = endTime.substring(0, 5);

    return '$start - $end';
  }

  static String formatScheduleTimeRange(Schedule schedule) {
    return formatTimeRange(schedule.startTime, schedule.endTime);
  }

  // Format date với pattern tùy chỉnh
  static String formatDateWithPattern(DateTime date, String pattern) {
    try {
      final DateFormat formatter = DateFormat(pattern);
      return formatter.format(date);
    } catch (e) {
      return '';
    }
  }

  // Parse string sang DateTime
  static DateTime? parseDate(String date, {String pattern = 'dd/MM/yyyy'}) {
    try {
      final DateFormat formatter = DateFormat(pattern);
      return formatter.parse(date);
    } catch (e) {
      return null;
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
    date.month == now.month &&
    date.day == now.day;
    }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}