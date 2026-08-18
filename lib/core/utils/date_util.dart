import 'package:intl/intl.dart';

class DateUtil {
  /// Formats date time in a relative format (e.g., "2 hours ago", "Yesterday")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  static String parseAndFormat(String input) {
    try {
      final parsed = DateTime.parse(input);
      return formatRelative(parsed);
    } catch (e) {
      return input;
    }
  }

  static String getCurrentMonthName() {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[now.month - 1];
  }

  static DateTime? convertDateToDateTime(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      // Invalid date format, ignore
      return null;
    }
    return null;
  }

  /// Converts a DateTime to UTC and returns ISO8601 string for backend
  static String toUtcIso8601(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// Normalizes a date-time value to the start of its day in local time.
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Normalizes a date-time value to the end of its day in local time.
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      23,
      59,
      59,
      999,
    );
  }

  /// Parses UTC IO8601 string from backend and converts to local time
  static DateTime parseUtcToLocal(String utcString) {
    final normalizedString = utcString.endsWith('Z')
        ? utcString
        : '${utcString}Z';
    final utcDateTime = DateTime.parse(normalizedString);
    return utcDateTime.toLocal();
  }

  /// Safely parses UTC string to local DateTime with fallback
  static DateTime? tryParseUtcToLocal(String? utcString) {
    if (utcString == null || utcString.isEmpty) return null;
    try {
      return parseUtcToLocal(utcString);
    } catch (e) {
      return null;
    }
  }
}
