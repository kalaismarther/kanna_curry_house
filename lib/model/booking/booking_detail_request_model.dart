class BookingDetailRequestModel {
  final String userId;
  final String bookingId;

  BookingDetailRequestModel({required this.userId, required this.bookingId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'booking_id': bookingId};
}
