import 'package:intl/intl.dart';

class TableBookingRequestModel {
  final String userId;
  final String mobile;
  final String name;
  final DateTime date;
  final String time;
  final int adultsCount;
  final int kidsCount;

  TableBookingRequestModel(
      {required this.userId,
      required this.mobile,
      required this.name,
      required this.date,
      required this.time,
      required this.adultsCount,
      required this.kidsCount});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "mobile": mobile,
        "date": DateFormat('yyyy-MM-dd').format(date),
        "time": time,
        "adult": adultsCount,
        "kid": kidsCount
      };
}
