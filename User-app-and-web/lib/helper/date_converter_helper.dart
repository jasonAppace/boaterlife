import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/main.dart';
import 'package:intl/intl.dart';

class DateConverterHelper {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String dateTimeInDays(String dateTime) {
    DateTime time = DateTime.parse(dateTime);
    return DateTime.now()
        .difference(time.add(const Duration(days: 1)))
        .inDays
        .toString();
  }

  static String convertToAgo(String input) {
    try {
      // Parse the datetime string, handling both UTC (Z) and regular formats
      DateTime time = DateTime.parse(input).toLocal();
      DateTime now = DateTime.now();
      Duration diff = now.difference(time);

      // Years
      if (diff.inDays >= 365) {
        int years = (diff.inDays / 365).floor();
        return years == 1 ? '$years year ago' : '$years years ago';
      }
      // Months
      else if (diff.inDays >= 30) {
        int months = (diff.inDays / 30).floor();
        return months == 1 ? '$months month ago' : '$months months ago';
      }
      // Days
      else if (diff.inDays >= 1) {
        int days = diff.inDays;
        return days == 1 ? '$days day ago' : '$days days ago';
      }
      // Hours
      else if (diff.inHours >= 1) {
        int hours = diff.inHours;
        return hours == 1 ? '$hours h ago' : '${hours}h ago';
      }
      // Minutes
      else if (diff.inMinutes >= 1) {
        int minutes = diff.inMinutes;
        return minutes == 1 ? '$minutes minute ago' : '${minutes}m ago';
      }
      // Seconds
      else if (diff.inSeconds >= 1) {
        int seconds = diff.inSeconds;
        return seconds == 1 ? '$seconds second ago' : '${seconds}s ago';
      }
      // Just now
      else {
        return 'just now';
      }
    } catch (e) {
      return 'just now';
    }
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('d-MMM-yyyy | h:mm a').format(dateTime.toLocal());
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS')
        .parse(dateTime, true)
        .toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }

  static String? getRelativeDate(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    return dateTime.difference(currentDateTime).inDays == 0
        ? getTranslated('today', Get.context!)
        : dateTime.difference(currentDateTime).inDays == -1
            ? getTranslated('yesterday', Get.context!)
            : null;
  }
}
