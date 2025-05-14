class AppConstants {
  static const String _baseUrl = 'http://18.188.82.54/kanna/';
  static const String apiEndPoint = '${_baseUrl}api/';

//<!------------------------ AUTH --------------------->
  static const String loginUrl = '${apiEndPoint}user_login';
  static const String verifyOtpUrl = '${apiEndPoint}verifyotp';
  static const String resendOtpUrl = '${apiEndPoint}resend_otp';
  static const String logoutUrl = '${apiEndPoint}logout';
  static const String termsUrl = 'https://www.google.com';

//<!------------------------ PROFILE --------------------->
  static const String updateProfileUrl = '${apiEndPoint}update_profile';
  static const String editProfileUrl = '${apiEndPoint}edit_profile';

//<!------------------------ HOME --------------------->
  static const String homeContentUrl = '${apiEndPoint}home_content';

//<!------------------------ NOTIFICATION --------------------->
  static const String notificationListUrl =
      '${apiEndPoint}get_notification_lists';

//<!------------------------ CART --------------------->
  static const String viewCartUrl = '${apiEndPoint}view_cart';
  static const String addToCartUrl = '${apiEndPoint}add_cart';
  static const String updateCartUrl = '${apiEndPoint}update_cart';
  static const String deleteFromCartUrl = '${apiEndPoint}delete_cart';
  static const String reviewCartUrl = '${apiEndPoint}review_cart';

//<!------------------------ CATEGORY --------------------->
  static const String categoriesUrl = '${apiEndPoint}get_main_categories';
  static const String productsUrl = '${apiEndPoint}products_by_category';

//<!------------------------ PRODUCT --------------------->
  static const String productDetailUrl = '${apiEndPoint}product_detalis';

//<!------------------------ PRODUCT --------------------->
  static const String couponsUrl = '${apiEndPoint}show_coupons';
  static const String checkCouponUrl = '${apiEndPoint}check_coupon';

//<!------------------------ CHECKOUT --------------------->
  static const String checkoutUrl = '${apiEndPoint}place_new_order';
  static const String createPaymentUrl = '${apiEndPoint}create_billplz_payment';
  static const String updatePaymentUrl = '${apiEndPoint}billplz/callback';

//<!------------------------ ORDER --------------------->
  static const String myOrdersUrl = '${apiEndPoint}my_orders';
  static const String orderDetailUrl = '${apiEndPoint}get_ordered_items';
  static const String orderRatingUrl = '${apiEndPoint}post_order_rating';
  static const String cancelOrderUrl = '${apiEndPoint}cancel_order';
  static const String cancellationPolicyUrl =
      '${apiEndPoint}cancellation_policy';

//<!------------------------ BOOKING --------------------->
  static const String tableBookingUrl = '${apiEndPoint}request_table_booking';
  static const String myBookingsUrl = '${apiEndPoint}my_table_booking_list';
  static const String bookingDetailUrl = '${apiEndPoint}table_booking_detail';
  static const String cancelBookingUrl = '${apiEndPoint}cancel_booking';

//<!------------------------ HELP --------------------->
  static const String helpAndSupportUrl = '${apiEndPoint}get_help_support';
  static const String faqUrl = '${apiEndPoint}faq';

//<!------------------------ CANCEL --------------------->
  static const String reasonListUrl = '${apiEndPoint}get_reason_master';
}
