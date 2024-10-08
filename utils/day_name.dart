import 'package:intl/intl.dart';

String getDayByName() {
  Map<String, String> days = {
    'Monday': 'Luni',
    'Tuesday': 'Marti',
    'Wednesday': 'Miercuri',
    'Thursday': 'Joi',
    'Friday': 'Vineri',
    'Saturday': 'Sambata',
    'Sunday': 'Duminica',
  };

  var today = DateFormat('EEEE').format(DateTime.now());
  return days[today];
}