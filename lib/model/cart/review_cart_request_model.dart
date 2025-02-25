class ReviewCartRequestModel {
  final String userId;
  final String cartId;
  final String? appliedCouponId;

  ReviewCartRequestModel({
    required this.userId,
    required this.cartId,
    this.appliedCouponId,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'cart_id': cartId,
        if (appliedCouponId != null) ...{'coupon_id': appliedCouponId}
      };
}
