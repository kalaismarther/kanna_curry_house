class CheckCouponRequestModel {
  final String userId;
  final String couponCode;
  final String orderAmount;

  CheckCouponRequestModel(
      {required this.userId,
      required this.couponCode,
      required this.orderAmount});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'coupon_code': couponCode, 'amount': orderAmount};
}
