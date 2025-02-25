class CategoryProductsRequestModel {
  final String userId;
  final String categoryId;
  final int pageNo;

  CategoryProductsRequestModel(
      {required this.userId, required this.categoryId, required this.pageNo});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'category_id': categoryId, 'page_no': pageNo};
}
