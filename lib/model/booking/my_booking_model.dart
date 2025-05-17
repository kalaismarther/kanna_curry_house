class MyBookingModel {
  final String id;
  final String uniqueNo;
  final String date;
  final String time;
  String status;
  final String contactNo;
  final String contactNumber;
  final String adultsCount;
  final String kidsCount;
  final String rejectedReason;

  MyBookingModel(
      {required this.id,
      required this.uniqueNo,
      required this.date,
      required this.time,
      required this.status,
      required this.contactNo,
      required this.contactNumber,
      required this.adultsCount,
      required this.kidsCount,
      required this.rejectedReason});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) => MyBookingModel(
        id: json['id']?.toString() ?? '0',
        uniqueNo: json['booking_unique_id']?.toString() ?? '0',
        date: json['formatted_date']?.toString() ?? '0',
        time: json['formatted_time']?.toString() ?? '0',
        status: json['status']?.toString() ?? '0',
        contactNo: json['contact_name']?.toString() ?? '0',
        contactNumber: json['contact_mobile']?.toString() ?? '0',
        adultsCount: json['adult']?.toString() ?? '0',
        kidsCount: json['kid']?.toString() ?? '0',
        rejectedReason: json['reject_reason']?.toString() ?? '',
      );
}
