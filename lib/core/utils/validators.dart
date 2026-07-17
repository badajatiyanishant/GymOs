/// Reusable form-field validators. Return `null` when valid, else an error
/// message — the shape expected by [TextFormField.validator].
class Validators {
  Validators._();

  static String? requiredField(String? v, [String field = 'This field']) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'At least 6 characters';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Enter a valid phone number';
    return null;
  }

  static String? positiveNumber(String? v, [String field = 'Value']) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    final n = num.tryParse(v.trim());
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return '$field must be greater than 0';
    return null;
  }
}
