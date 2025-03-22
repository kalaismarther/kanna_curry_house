class ReasonListRequestModel {
  final String userId;
  final String type;
  final int pageNo;

  ReasonListRequestModel(
      {required this.userId, required this.type, required this.pageNo});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'type': type, 'page_no': pageNo};
}
