class AppConstants {
  static const String _baseUrl = 'http://18.189.69.82/kanna/';
  static const String apiEndPoint = '${_baseUrl}api/';

//<!------------------------ AUTH --------------------->
  static const String loginUrl = '${apiEndPoint}user_login';
  static const String verifyOtpUrl = '${apiEndPoint}verifyotp';
  static const String resendOtpUrl = '${apiEndPoint}resed_otp';
  static const String logoutUrl = '${apiEndPoint}logout';

//<!------------------------ PROFILE --------------------->
  static const String updateProfileUrl = '${apiEndPoint}update_profile';

//<!------------------------ HOME --------------------->
  static const String homeContentUrl = '${apiEndPoint}home_content';

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
  static const String couponsUrl = '${apiEndPoint}show_coupons';

//<!------------------------ PRODUCT --------------------->
  static const String checkoutUrl = '${apiEndPoint}place_new_order';
}
