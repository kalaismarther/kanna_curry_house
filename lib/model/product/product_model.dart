class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imageLink;
  final int cartQuantity;
  final String cartItemId;
  final String categoryId;
  final String mrpPrice;
  final String sellingPrice;
  final bool isAvailable;
  final String slotMessage;
  final bool inStock;
  bool isInCart;
  final String foodType;

  ProductModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageLink,
      required this.cartQuantity,
      required this.cartItemId,
      required this.categoryId,
      required this.mrpPrice,
      required this.sellingPrice,
      required this.isAvailable,
      required this.slotMessage,
      required this.inStock,
      required this.isInCart,
      required this.foodType});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id']?.toString() ?? '0',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageLink: json['is_image']?.toString() ?? '',
      cartQuantity: int.tryParse(json['cart_qty']?.toString() ?? '0') ?? 0,
      cartItemId: json['cart_item_id']?.toString() ?? '0',
      categoryId:
          json['product_category']?[0]?['category_id']?.toString() ?? '0',
      mrpPrice: json['mrp_price']?.toString() ?? '',
      sellingPrice: json['selling_price']?.toString() ?? '',
      isAvailable: json['is_product_available']?.toString() == '1',
      slotMessage: json['slot_message']?.toString() ?? '',
      inStock: json['stock_status']?.toString() != 'OUT_OF_STOCK',
      isInCart: (int.tryParse(json['cart_qty']?.toString() ?? '0') ?? 0) > 0,
      foodType: json['food_type']?.toString() ?? '0');
}
