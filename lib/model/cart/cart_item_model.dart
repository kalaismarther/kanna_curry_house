class CartItemModel {
  final String id;
  final String productName;
  final String productVarient;
  final String productImageLink;
  final String mrpPrice;
  final String sellingPrice;
  final int cartQuantity;

  CartItemModel(
      {required this.id,
      required this.productName,
      required this.productVarient,
      required this.productImageLink,
      required this.mrpPrice,
      required this.sellingPrice,
      required this.cartQuantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id']?.toString() ?? '0',
        productName: json['product']?['name']?.toString() ?? '',
        productVarient: json['product']?['varient']?.toString() ?? '',
        productImageLink: json['product']?['is_image']?.toString() ?? '',
        mrpPrice: json['product']?['mrp_price']?.toString() ?? '',
        sellingPrice: json['product']?['selling_price']?.toString() ?? '',
        cartQuantity: int.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      );
}
