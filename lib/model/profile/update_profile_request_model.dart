import 'package:intl/intl.dart';
import 'package:kanna_curry_house/model/address/address_model.dart';

class UpdateProfileRequestModel {
  final String userId;
  final String name;
  final String email;
  final String countryId;
  final DateTime dob;
  final AddressModel address;

  UpdateProfileRequestModel(
      {required this.userId,
      required this.name,
      required this.email,
      required this.countryId,
      required this.dob,
      required this.address});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'email': email,
        'country_code_id': countryId,
        'dob': DateFormat('yyyy-MM-dd').format(dob),
        'address_type': address.type,
        'location': address.location,
        'flat': address.doorNo,
        'pincode': address.pincode,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'landmark': address.landmark,
      };
}
