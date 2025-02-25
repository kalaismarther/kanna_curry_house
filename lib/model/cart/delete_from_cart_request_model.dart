class DeleteFromCartRequestModel {
  final String userId;
  final String cartItemId;

  DeleteFromCartRequestModel({required this.userId, required this.cartItemId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'item_id': cartItemId};
}
