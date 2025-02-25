class CategoryModel {
  final String id;
  final String name;
  final String imageLink;

  CategoryModel(
      {required this.id, required this.name, required this.imageLink});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id']?.toString() ?? '0',
        name: json['name']?.toString() ?? '',
        imageLink: json['is_image']?.toString() ?? '',
      );
}
