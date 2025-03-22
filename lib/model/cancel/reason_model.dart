class ReasonModel {
  final String id;
  final String name;

  ReasonModel({required this.id, required this.name});

  factory ReasonModel.fromJson(Map<String, dynamic> json) => ReasonModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
}
