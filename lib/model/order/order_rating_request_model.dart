class OrderRatingRequestModel {
  final String userId;
  final String orderId;
  final int foodRating;
  final int packageRating;
  final String feedback;

  OrderRatingRequestModel(
      {required this.userId,
      required this.orderId,
      required this.foodRating,
      required this.packageRating,
      required this.feedback});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'order_id': orderId,
        'food_rating': foodRating,
        'package_rating': packageRating,
        'comments': feedback
      };
}
