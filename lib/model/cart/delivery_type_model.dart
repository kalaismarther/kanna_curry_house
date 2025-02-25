class DeliveryTypeModel {
  final String id;
  final String deliveryType;

  DeliveryTypeModel({required this.id, required this.deliveryType});

  factory DeliveryTypeModel.fromJson(Map<String, dynamic> json) =>
      DeliveryTypeModel(
        id: json['id']?.toString() ?? '0',
        deliveryType: json['delivery_type']?.toString() ?? '',
      );
}
