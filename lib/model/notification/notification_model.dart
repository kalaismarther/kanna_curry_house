class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final String redirectId;
  final String refId;

  NotificationModel(
      {required this.id,
      required this.title,
      required this.message,
      required this.date,
      required this.redirectId,
      required this.refId});

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) =>
      NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        date: json['is_date']?.toString() ?? '',
        redirectId: json['redirect_id']?.toString() ?? '',
        refId: json['ref_id']?.toString() ?? '',
      );
}
