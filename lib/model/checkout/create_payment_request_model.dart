class CreatePaymentRequestModel {
  final String userId;
  final String orderId;
  final String amount;

  CreatePaymentRequestModel(
      {required this.userId, required this.orderId, required this.amount});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'amount': amount,
        'order_id': orderId,
      };
}
