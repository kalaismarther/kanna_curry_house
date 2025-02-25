class ValidationHelper {
  static final RegExp nameRegex = RegExp(r'^[a-zA-Z\s.]+$');
  static final RegExp numberRegex = RegExp(r'^\d+$');
  static final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    } else if (!nameRegex.hasMatch(value.trim())) {
      return 'Invalid name';
    } else {
      return null;
    }
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    } else if (value.trim().length < 10 ||
        !numberRegex.hasMatch(value.trim())) {
      return 'Invalid mobile number';
    } else {
      return null;
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    } else if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email';
    } else {
      return null;
    }
  }
}
