class MyOrderModel {
  final String id;
  final String uniqueNo;
  final String orderDate;
  final String itemsQuantity;
  String status;
  final String subTotal;
  final String taxAmount;
  final String couponAmount;
  final String total;
  bool isRatingSubmitted;
  final String preparationTime;

  MyOrderModel(
      {required this.id,
      required this.uniqueNo,
      required this.orderDate,
      required this.itemsQuantity,
      required this.status,
      required this.subTotal,
      required this.taxAmount,
      required this.couponAmount,
      required this.total,
      required this.isRatingSubmitted,
      required this.preparationTime});

  factory MyOrderModel.fromJson(Map<String, dynamic> json) => MyOrderModel(
      id: json['id']?.toString() ?? '0',
      uniqueNo: json['order_id']?.toString() ?? '',
      orderDate: json['is_order_date']?.toString() ?? '',
      itemsQuantity: json['no_of_product']?.toString() ?? '',
      status: json['is_status']?.toString() ?? '',
      subTotal: json['sub_total']?.toString() ?? '',
      taxAmount: json['tax']?.toString() ?? '',
      couponAmount: json['discount']?.toString() ?? '',
      total: json['is_final_grand_total']?.toString() ?? '',
      isRatingSubmitted: json['is_rating_submitted']?.toString() == '1',
      preparationTime: json['is_esti_preparation_time']?.toString() ?? '');
}
