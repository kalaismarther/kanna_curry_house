import 'package:kanna_curry_house/model/address/address_model.dart';
import 'package:kanna_curry_house/model/cart/delivery_type_model.dart';

class CartInfoModel {
  final String id;
  final int itemCount;
  final String subTotal;
  final String taxPercentage;
  final String taxAmount;
  final String couponAmount;
  final String total;
  final List<DeliveryTypeModel> availableDeliveryTypes;
  final String currentDeliveryTypeId;
  final AddressModel defaultAddress;

  CartInfoModel(
      {required this.id,
      required this.itemCount,
      required this.subTotal,
      required this.taxPercentage,
      required this.taxAmount,
      required this.couponAmount,
      required this.total,
      required this.availableDeliveryTypes,
      required this.currentDeliveryTypeId,
      required this.defaultAddress});

  factory CartInfoModel.fromJson(Map<String, dynamic> json) => CartInfoModel(
        id: json['data']?['id']?.toString() ?? '0',
        itemCount:
            int.tryParse(json['data']?['is_qty']?.toString() ?? '0') ?? 0,
        subTotal: json['data']?['without_tax_subtotal']?.toString() ?? '0',
        taxPercentage: json['data']?['tax_percentage']?.toString() ?? '0',
        taxAmount: json['data']?['tax_amount']?.toString() ?? '0',
        couponAmount: json['coupon_amount']?.toString() ?? '0',
        total: json['total_price']?.toString() ?? '0',
        availableDeliveryTypes: [
          for (final type in json['data']?['delivery_type'] ?? [])
            DeliveryTypeModel.fromJson(type)
        ],
        currentDeliveryTypeId:
            json['data']?['is_delivery_type']?.toString() ?? '0',
        defaultAddress: AddressModel.fromJson(
          json['user_address'],
        ),
      );
}
