import 'package:intl/intl.dart';
import 'package:world_clock/utils/utils.dart';

class DateUtils {
  static String getReadableDate(String dateString, {String locale = 'en'}) {
    return formatDateTimeString(dateString, "d MMM, yyyy.", locale: locale);
  }

  static String getReadableDateAndTime(String dateString,
      {String locale = 'en'}) {
    return formatDateTimeString(dateString, "d MMM, yyyy HH:mm",
        locale: locale);
  }

  static DateTime parseDateTimeString(String dateString,
      {String sourceFormat}) {
    final List<String> possibleFormats = const [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-dd"T"HH:mm:ss"Z"',
      'MMM dd, yyyy hh:mm:ss a',
    ];

    // initializeDateFormatting('en');

    if (sourceFormat != null) {
      // use that format instead
      return DateFormat(sourceFormat).parseUTC(dateString);
    }

    // try local parsing
    if (dateString.contains('T')) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        Utils.log('DATE => ' + e.toString());
      }
    }

    for (var possibleFormat in possibleFormats) {
      try {
        return DateFormat(possibleFormat).parseUTC(dateString);
      } catch (e) {
        Utils.log('DATE => ' + e.toString());
      }
    }
    Utils.log('Date format not in possible dates formats array: $dateString');
    return null;
  }

  static DateTime parse(dynamic object, {String format}) {
    if (object is String) {
      return parseDateTimeString(object, sourceFormat: format);
    }

    if (object is int) {
      return parseEpoch(object);
    }

    return null;
  }

  static String formatDateTimeString(String dateString, String format,
      {String locale = 'en'}) {
    final parsedDate = parseDateTimeString(dateString);
    return parsedDate != null
        ? DateFormat(format, locale).format(parsedDate)
        : '';
  }

  static DateTime parseEpoch(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds * 1000);
  }

  static String formatDateTime(DateTime date, String format,
      {String locale = 'en'}) {
    return DateFormat(format, locale).format(date);
  }

  static int toUnixTimestamp(DateTime dateTime) {
    return (dateTime.millisecondsSinceEpoch / 1000).ceil();
  }

  static bool isInSameMinute(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute;
  }

  ///
  /// strips off the time from a DateTime
  ///
  static DateTime stripOffTimeFromDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  ///
  /// converts a duration to time format mm:ss
  ///
  static String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

///
/// DATETIME EXTENSIONS
///

extension DateTimeExtension on DateTime {
  int get unixTimestamp => DateUtils.toUnixTimestamp(this);
}
