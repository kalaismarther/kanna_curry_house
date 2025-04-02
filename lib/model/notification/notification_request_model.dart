class NotificationRequestModel {
  final String userId;
  final int pageNo;

  NotificationRequestModel({
    required this.userId,
    required this.pageNo,
  });

  Map<String, dynamic> toJson() => {'user_id': userId, 'page_no': pageNo};
}
