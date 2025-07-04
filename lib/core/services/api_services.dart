import 'package:flutter/material.dart';
import 'package:kanna_curry_house/config/app_constants.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/dio_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/auth/country_model.dart';
import 'package:kanna_curry_house/model/auth/login_request_model.dart';
import 'package:kanna_curry_house/model/auth/resend_otp_request_model.dart';
import 'package:kanna_curry_house/model/auth/verification_request_model.dart';
import 'package:kanna_curry_house/model/booking/booking_detail_request_model.dart';
import 'package:kanna_curry_house/model/booking/my_booking_list_request_model.dart';
import 'package:kanna_curry_house/model/booking/my_booking_model.dart';
import 'package:kanna_curry_house/model/booking/table_booking_request_model.dart';
import 'package:kanna_curry_house/model/cancel/cancel_booking_request_model.dart';
import 'package:kanna_curry_house/model/cancel/reason_list_request_model.dart';
import 'package:kanna_curry_house/model/cancel/reason_model.dart';
import 'package:kanna_curry_house/model/cart/add_to_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/cart_info_model.dart';
import 'package:kanna_curry_house/model/cart/delete_from_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/review_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/update_cart_request_model.dart';
import 'package:kanna_curry_house/model/category/category_model.dart';
import 'package:kanna_curry_house/model/category/category_products_request_model.dart';
import 'package:kanna_curry_house/model/category/view_categories_request_model.dart';
import 'package:kanna_curry_house/model/checkout/checkout_request_model.dart';
import 'package:kanna_curry_house/model/checkout/create_payment_request_model.dart';
import 'package:kanna_curry_house/model/checkout/update_payment_request_model.dart';
import 'package:kanna_curry_house/model/coupon/check_coupon_request_model.dart';
import 'package:kanna_curry_house/model/coupon/coupon_model.dart';
import 'package:kanna_curry_house/model/help/faq_model.dart';
import 'package:kanna_curry_house/model/notification/notification_model.dart';
import 'package:kanna_curry_house/model/notification/notification_request_model.dart';
import 'package:kanna_curry_house/model/order/my_order_list_request_model.dart';
import 'package:kanna_curry_house/model/order/my_order_model.dart';
import 'package:kanna_curry_house/model/order/order_detail_request_model.dart';
import 'package:kanna_curry_house/model/order/order_rating_request_model.dart';
import 'package:kanna_curry_house/model/product/product_detail_request_model.dart';
import 'package:kanna_curry_house/model/product/product_model.dart';
import 'package:kanna_curry_house/model/profile/edit_profile_request_model.dart';
import 'package:kanna_curry_house/model/profile/update_profile_request_model.dart';
import 'package:kanna_curry_house/model/cancel/cancel_order_request_model.dart';
import 'package:dio/dio.dart' as dio;

class ApiServices {
  static Map<String, String> _headersWithoutToken() =>
      {'Content-Type': 'Application/json'};

  static Map<String, String> _headersWithToken() {
    final user = StorageHelper.getUserDetail();
    debugPrint(user.apiToken);
    return {'Content-Type': 'Application/json', 'Authorization': user.apiToken};
  }

//<---------------------------- AUTH ---------------------------------------->

  static Future<List<CountryModel>> getCountriesList() async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.getCountriesUrl,
        headers: _headersWithToken(),
        input: {});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final country in response.body['data'] ?? [])
            CountryModel.fromJson(country)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<void> guestLogin() async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.guestLoginUrl,
        headers: _headersWithoutToken(),
        input: {'email': 'guestlogin@gmail.com', 'password': '123456'});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        if (response.body['data']?.runtimeType != null) {
          await StorageHelper.write('guest_login', true);
          await StorageHelper.write('user', response.body['data'] ?? {});
        } else {
          await StorageHelper.deleteAll();
        }
        return;
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<void> userLogin(LoginRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.loginUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        if (response.body['data']?.runtimeType != null) {
          await StorageHelper.write('guest_login', false);
          await StorageHelper.write('user', response.body['data'] ?? {});
        } else {
          await StorageHelper.deleteAll();
        }
        return;
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String?> resendVerificationCode(
      ResendOtpRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.resendOtpUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString();
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> verifyMobileNumber(
      VerificationRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.verifyOtpUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> logout() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.logoutUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- PROFILE ---------------------------------------->

  static Future<void> updateUserProfile(UpdateProfileRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.updateProfileUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        await StorageHelper.write('user', response.body['data'] ?? {});
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> editProfile(
      EditProfileRequestModel input) async {
    var data = dio.FormData.fromMap({
      'user_id': input.userId,
      'first_name': input.name,
      'email': input.email,
      'mobile': input.mobile,
      if (input.dob.isNotEmpty) 'dob': input.dob,
      if (input.profileImagePath.isNotEmpty)
        'profile_image':
            await dio.MultipartFile.fromFile(input.profileImagePath),
    });

    final response = await DioHelper.postHttpMethod(
        url: AppConstants.editProfileUrl,
        headers: _headersWithToken(),
        input: data);

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        UiHelper.showToast(response.body['message'].toString());
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<bool> getDeleteBtnStatus() async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deleteBtnUrl,
        headers: _headersWithoutToken(),
        input: {});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data']?.toString() == '1';
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> deleteUserAccount() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deleteAccountUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- HOME ---------------------------------------->
  static Future<Map<String, dynamic>> getHomeContent() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.homeContentUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- NOTIFICATION ---------------------------------------->
  static Future<List<NotificationModel>> getNotificationList(
      NotificationRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.notificationListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final notification in response.body['data'] ?? [])
            NotificationModel.fromJson(notification)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- CART ---------------------------------------->

  static Future<Map<String, dynamic>> getCartData() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.viewCartUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<ProductModel?> addProductToCart(
      AddToCartRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addToCartUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        String? currentCartId = response.body['carttotal']?['id']?.toString();
        await StorageHelper.write('current_cart_id', currentCartId);

        for (final item in response.body['cartitems'] ?? []) {
          await StorageHelper.write('current_cart_id', currentCartId);
          if (item['product_id']?.toString() == input.productId) {
            return ProductModel.fromJson(item['product']);
          }
        }
        return null;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<ProductModel?> updateProductInCart(
      UpdateCartRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.updateCartUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        String? currentCartId = response.body['carttotal']?['id']?.toString();
        await StorageHelper.write('current_cart_id', currentCartId);

        for (final item in response.body['cartitems'] ?? []) {
          if (item['id']?.toString() == input.cartItemId) {
            return ProductModel.fromJson(item['product']);
          }
        }
        return null;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<ProductModel?> updateCartItem(
      UpdateCartRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.updateCartUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        String? currentCartId = response.body['carttotal']?['id']?.toString();
        await StorageHelper.write('current_cart_id', currentCartId);

        for (final item in response.body['cartitems'] ?? []) {
          if (item['id']?.toString() == input.cartItemId &&
              item['product'] != null) {
            return ProductModel.fromJson(item['product']);
          }
        }
        return null;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<void> deleteProductFromCart(
      DeleteFromCartRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deleteFromCartUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        String? currentCartId = response.body['carttotal']?['id']?.toString();
        await StorageHelper.write('current_cart_id', currentCartId);

        return;
      } else if (response.body['status']?.toString() == '0' &&
          response.body['message']?.toString().toLowerCase() ==
              'cart is empty') {
        await StorageHelper.remove('current_cart_id');
        return;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<CartInfoModel?> reviewCart(ReviewCartRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.reviewCartUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return CartInfoModel.fromJson(response.body);
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- CATEGORIES ---------------------------------------->

  static Future<List<CategoryModel>> getCategories(
      ViewCategoriesRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.categoriesUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final category in response.body['data'] ?? [])
            CategoryModel.fromJson(category)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<ProductModel>> getCategoryProducts(
      CategoryProductsRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.productsUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final product in response.body['data'] ?? [])
            ProductModel.fromJson(product)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- PRODUCT ---------------------------------------->

  static Future<ProductModel?> getProductDetail(
      ProductDetailRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.productDetailUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return ProductModel.fromJson(response.body['data']);
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- COUPON ---------------------------------------->

  static Future<List<CouponModel>> getCoupons() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.couponsUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final coupon in response.body['data'] ?? [])
            CouponModel.fromJson(coupon)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<void> checkCoupon(CheckCouponRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.checkCouponUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- CHECKOUT ---------------------------------------->

  static Future<Map<String, dynamic>> checkoutCart(
      CheckoutRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.checkoutUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1' ||
          response.body['status']?.toString() == '6') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> createBillPlzPayment(
      CreatePaymentRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.createPaymentUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> updatePaymentStatus(
      UpdatePaymentRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.updatePaymentUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- ORDER ---------------------------------------->
  static Future<List<MyOrderModel>> getMyOrders(
      MyOrderListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.myOrdersUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final order in response.body['data'] ?? [])
            MyOrderModel.fromJson(order)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> getOrderDetail(
      OrderDetailRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.orderDetailUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> giveRatingToOrder(OrderRatingRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.orderRatingUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ??
            'Rating submitted successfully';
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> getCancellationPolicy() async {
    final response = await DioHelper.getHttpMethod(
        url: AppConstants.cancellationPolicyUrl, headers: _headersWithToken());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- BOOKING ---------------------------------------->

  static Future<String> requestForTableBooking(
      TableBookingRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.tableBookingUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ??
            'Table Booking Request Sent Successfully';
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<MyBookingModel>> getMyBookings(
      MyBookingListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.myBookingsUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final booking in response.body['data'] ?? [])
            MyBookingModel.fromJson(booking)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<MyBookingModel> getBookingDetail(
      BookingDetailRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.bookingDetailUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return MyBookingModel.fromJson(response.body['data']);
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<dynamic, dynamic>> getHelpAndSupport() async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.helpAndSupportUrl,
        headers: _headersWithToken(),
        input: {});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<FaqModel>> getFaqList() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.faqUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final faq in response.body['data'] ?? []) FaqModel.fromJson(faq)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

//<---------------------------- CANCEL ---------------------------------------->

  static Future<List<ReasonModel>> getCancelReasonList(
      ReasonListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.reasonListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final faq in response.body['data'] ?? [])
            ReasonModel.fromJson(faq)
        ];
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> cancelMyOrder(
      CancelOrderRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.cancelOrderUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> cancelMyBooking(CancelBookingRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.cancelBookingUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ??
            'Booking cancelled successfully';
      } else if (response.body['status']?.toString() == '2') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }
}
