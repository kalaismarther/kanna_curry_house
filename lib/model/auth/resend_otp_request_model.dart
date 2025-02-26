class ResendOtpRequestModel {
  final String userId;
  final String mobileNo;

  ResendOtpRequestModel({required this.userId, required this.mobileNo});

  Map<String, dynamic> toJson() => {'user_id': userId, 'mobile': mobileNo};
}
