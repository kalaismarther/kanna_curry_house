class CancelBookingRequestModel {
  final String userId;
  final String bookingId;
  final String reasonId;
  final String remarks;

  CancelBookingRequestModel(
      {required this.userId,
      required this.bookingId,
      required this.reasonId,
      required this.remarks});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'booking_id': bookingId,
        'reason_id': reasonId,
        'cancel_reason': remarks,
      };
}
