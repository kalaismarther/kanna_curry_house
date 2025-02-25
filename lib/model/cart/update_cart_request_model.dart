class UpdateCartRequestModel {
  final String userId;
  final String cartItemId;
  final int quantity;

  UpdateCartRequestModel({
    required this.userId,
    required this.cartItemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'item_id': cartItemId, 'qty': quantity};
}
