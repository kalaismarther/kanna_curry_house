class UpdatePaymentRequestModel {
  final String billId;
  final bool isSuccess;

  UpdatePaymentRequestModel({required this.billId, required this.isSuccess});
  Map<String, dynamic> toJson() =>
      {'user_id': billId, 'paid': isSuccess ? 'true' : 'false'};
}
