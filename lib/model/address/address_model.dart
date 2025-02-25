class AddressModel {
  final String id;
  final String location;
  final String doorNo;
  final String pincode;
  final String landmark;
  final double? latitude;
  final double? longitude;
  final String type;
  final bool isDefault;

  AddressModel(
      {this.id = '0',
      required this.location,
      required this.doorNo,
      required this.pincode,
      required this.landmark,
      required this.latitude,
      required this.longitude,
      required this.type,
      this.isDefault = false});

  factory AddressModel.fromJson(Map<dynamic, dynamic> json) => AddressModel(
        id: json['id']?.toString() ?? '0',
        location: json['location']?.toString() ?? '',
        latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
        longitude:
            double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
        doorNo: json['flat']?.toString() ?? '',
        landmark: json['landmark']?.toString() ?? '',
        pincode: json['pincode']?.toString() ?? '',
        type: json['address_type']?.toString() ?? '',
        isDefault: json['is_default']?.toString() == '1',
      );

  static AddressModel? tryParse(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    } else {
      return AddressModel.fromJson(json);
    }
  }
}
