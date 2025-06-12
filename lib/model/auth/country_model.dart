class CountryModel {
  final String id;
  final String name;
  final String code;

  CountryModel({required this.id, required this.name, required this.code});

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        code: json['country_code']?.toString() ?? '',
      );
}
