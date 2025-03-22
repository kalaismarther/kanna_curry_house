class CancelOrderRequestModel {
  final String userId;
  final String orderId;
  final String reasonId;
  final String remarks;

  CancelOrderRequestModel(
      {required this.userId,
      required this.orderId,
      required this.reasonId,
      required this.remarks});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'order_id': orderId,
        'reason_id': reasonId,
        'cancel_reason': remarks,
      };
}
