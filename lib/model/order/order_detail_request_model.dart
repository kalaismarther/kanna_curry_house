class OrderDetailRequestModel {
  final String userId;
  final String orderId;

  OrderDetailRequestModel({required this.userId, required this.orderId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'order_id': orderId};
}
