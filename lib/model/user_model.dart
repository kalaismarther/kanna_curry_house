import 'package:kanna_curry_house/model/auth/country_model.dart';

class UserModel {
  final String id;
  final String name;
  final String mobile;
  final CountryModel country;
  final String email;
  final String dob;
  final String profileImageUrl;
  final String apiToken;

  UserModel(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.country,
      required this.email,
      required this.dob,
      required this.profileImageUrl,
      required this.apiToken});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '0',
        name: json['first_name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        country: CountryModel(
          id: json['country_code_id']?.toString() ?? '',
          name: json['country_name']?.toString() ?? '',
          code: json['country_code']?.toString() ?? '',
        ),
        email: json['email']?.toString() ?? '',
        dob: json['dob']?.toString() ?? '',
        profileImageUrl: json['is_user_image']?.toString() ?? '',
        apiToken: json['user_auth_token']?.toString() ?? '',
      );
}
