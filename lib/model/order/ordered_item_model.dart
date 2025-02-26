class OrderedItemModel {
  final String id;
  final String imageLink;
  final String name;
  final String price;
  final String quantity;

  OrderedItemModel(
      {required this.id,
      required this.imageLink,
      required this.name,
      required this.price,
      required this.quantity});

  factory OrderedItemModel.fromJson(Map<String, dynamic> json) =>
      OrderedItemModel(
        id: json['id']?.toString() ?? '',
        imageLink: json['is_product_image']?.toString() ?? '',
        name: json['is_product_name']?.toString() ?? '',
        price: json['price']?.toString() ?? '',
        quantity: json['qty']?.toString() ?? '',
      );
}
