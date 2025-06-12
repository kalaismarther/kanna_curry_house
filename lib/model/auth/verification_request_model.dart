class VerificationRequestModel {
  final String userId;
  final String otp;
  final String countryId;
  final String mobile;
  final String deviceId;
  final String deviceType;
  final String fcmToken;

  VerificationRequestModel(
      {required this.userId,
      required this.otp,
      required this.countryId,
      required this.mobile,
      required this.deviceId,
      required this.deviceType,
      required this.fcmToken});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'otp': otp,
        'country_code_id': countryId,
        'mobile': mobile,
        'device_id': deviceId,
        'device_type': deviceType,
        'fcm_id': fcmToken,
      };
}
