import 'package:intl/intl.dart';

// place all helper function in this class
class AppUtil {
  String formatDate(DateTime date) {
    final formatter = DateFormat('MM dd yyyy');
    return formatter.format(date);
  }

  bool isEmailValid(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
