class ApiResponseModel {
  final bool success;
  final dynamic body;
  final String error;

  ApiResponseModel(
      {required this.success, required this.body, this.error = ''});
}
