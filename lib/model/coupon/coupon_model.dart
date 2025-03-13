class CouponModel {
  final String id;
  final String name;
  final String description;
  final String code;
  final String percentage;
  final String minOrderValue;
  final String imageLink;

  CouponModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.code,
      required this.percentage,
      required this.minOrderValue,
      required this.imageLink});

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['id']?.toString() ?? '0',
        name: json['coupon_name']?.toString() ?? '',
        description: json['coupon_description']?.toString() ?? '',
        code: json['coupon_code']?.toString() ?? '',
        percentage: json['coupon_percentage']?.toString() ?? '',
        minOrderValue: json['min_order_value']?.toString() ?? '',
        imageLink: json['is_coupon_image']?.toString() ?? '',
      );
}
