class ResendOtpRequestModel {
  final String userId;
  final String countryId;
  final String mobileNo;

  ResendOtpRequestModel(
      {required this.userId, required this.countryId, required this.mobileNo});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'country_code_id': countryId, 'mobile': mobileNo};
}
