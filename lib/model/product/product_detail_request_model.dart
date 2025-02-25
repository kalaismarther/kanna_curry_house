class ProductDetailRequestModel {
  final String userId;
  final String productId;

  ProductDetailRequestModel({required this.userId, required this.productId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'product_id': productId};
}
