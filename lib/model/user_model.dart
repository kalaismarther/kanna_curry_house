class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String dob;
  final String profileImageUrl;
  final String apiToken;

  UserModel(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.email,
      required this.dob,
      required this.profileImageUrl,
      required this.apiToken});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '0',
        name: json['first_name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        dob: json['dob']?.toString() ?? '',
        profileImageUrl: json['is_user_image']?.toString() ?? '',
        apiToken: json['user_auth_token']?.toString() ?? '',
      );
}
