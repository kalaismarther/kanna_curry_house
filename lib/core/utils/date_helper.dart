import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(String dateString) {
    try {
      if (dateString.isEmpty) {
        return '';
      } else {
        // Parse the input date string
        DateTime date = DateTime.parse(dateString);

        // Format the date
        return DateFormat("d MMMM yyyy").format(date);
      }
    } catch (e) {
      return '';
    }
  }
}
