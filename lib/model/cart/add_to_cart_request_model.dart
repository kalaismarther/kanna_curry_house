class AddToCartRequestModel {
  final String userId;
  final String productId;
  final int quantity;

  AddToCartRequestModel({
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'product_id': productId, 'qty': quantity};
}
