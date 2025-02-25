class CheckoutRequestModel {
  final String userId;
  final String cartId;
  final String addressId;
  final String shippingMethod;
  final String paymentMethod;
  final String? couponId;

  CheckoutRequestModel(
      {required this.userId,
      required this.cartId,
      required this.addressId,
      required this.shippingMethod,
      required this.paymentMethod,
      this.couponId});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'cart_id': cartId,
        'payment_method': paymentMethod,
        'shipping_method': shippingMethod,
        'user_address_id': addressId,
        if (couponId != null) ...{'coupon_id': couponId}
      };
}
