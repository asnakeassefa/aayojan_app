import 'package:intl/intl.dart';

String formatDate(String dateString) {
  try {
    // Parse the input date string into a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('d MMMM yyyy').format(date);

    return formattedDate;
  } catch (e) {
    // Handle invalid date input
    return '';
  }
}

String formatTime(String time) {
  try {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12; // Convert to 12-hour format
    // check the length and add 0 if it is less than 2
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}$period';
  } catch (e) {
    return "";
  }
}

String formatTimeFromDate(String dateString) {
  try {
    // Parse the input date string into a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Format the DateTime object into the desired format that will only get time only
    String formattedDate = DateFormat.Hm().format(date);
    
    return formattedDate;
  } catch (e) {
    // Handle invalid date input
    return '';
  }
}
