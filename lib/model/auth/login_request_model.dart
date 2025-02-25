class LoginRequestModel {
  final String mobile;

  LoginRequestModel({required this.mobile});

  Map<String, dynamic> toJson() => {'mobile': mobile};
}
