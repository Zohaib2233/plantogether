import 'package:intl/intl.dart';

formatDate(String date){
  DateTime dateTime = DateTime.parse(date);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('E, MMM d y').format(dateTime);
  return formattedDate;
}

class Utils{
  static List<String> getNextFiveDays() {
    List<String> dates = [];

    // Get today's date
    DateTime today = DateTime.now();

    // Add today's date
    dates.add(formatDate(today));

    // Add the next five days
    for (int i = 1; i <= 4; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      dates.add(formatDate(nextDay));
    }
    print("dates = $dates");
    return dates;
  }

  static String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  static String formatDateWithMonth(String dateString) {
    DateTime date = DateTime.parse(dateString);

    // Format the date using DateFormat
    String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);

    return formattedDate;
  }
  static String formatTimestampToDateTime(int timeStamp) {
    // Convert Unix timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

    // Format the time
    String formattedTime = formatTime(dateTime);

    return formattedTime;
  }
  static String formatTime(DateTime dateTime) {
    // Format the DateTime into the desired time format
    return DateFormat.jm().format(dateTime);
  }

  static String convertTime(String inputTime) {
    // Parse the input time string
    final parsedTime = DateFormat('h:mm:ss a').parse(inputTime);

    // Format the parsed time without seconds
    return DateFormat('h:mm a').format(parsedTime);
  }

  static String convertTimeTo12HourFormat(String time) {
    // Parse the input time string
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);

    // Format the time in 12-hour clock format
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  static String formatDateTimetoTime(DateTime time) {
    // Define the date format
    final dateFormat = DateFormat('h:mm a');

    // Format the DateTime object
    return dateFormat.format(time);
  }
}