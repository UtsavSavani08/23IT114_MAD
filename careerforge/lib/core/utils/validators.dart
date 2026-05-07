class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit Indian mobile number';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is usually optional
    }
    final urlRegex = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Year is required';
    }
    final yearRegex = RegExp(r'^\d{4}$');
    if (!yearRegex.hasMatch(value)) {
      return 'Enter a valid 4-digit year';
    }
    final year = int.tryParse(value);
    if (year == null || year < 1900 || year > DateTime.now().year + 5) {
      return 'Enter a realistic year';
    }
    return null;
  }
}
