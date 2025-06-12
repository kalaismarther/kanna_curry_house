class LoginRequestModel {
  final String countryId;
  final String mobile;

  LoginRequestModel({required this.countryId, required this.mobile});

  Map<String, dynamic> toJson() =>
      {'country_code_id': countryId, 'mobile': mobile};
}
