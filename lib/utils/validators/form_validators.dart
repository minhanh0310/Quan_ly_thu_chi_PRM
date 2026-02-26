/// Form validation utilities for sign up and other forms
class FormValidators {
  /// Validates email format
  /// Returns null if valid, error message string if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    const emailRegex = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailRegex);

    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email address, like abc@xyz.com';
    }

    return null;
  }

  /// Validates password strength
  /// Returns null if valid, error message string if invalid
  /// Requirements: min 8 chars, at least one uppercase, one lowercase, one number, one special char
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates that password and confirm password match
  /// Returns null if valid, error message string if invalid
  static String? validatePasswordMatch(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates username/name field
  /// Returns null if valid, error message string if invalid
  /// Only allows alphabetic characters and spaces
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    // Only allow alphabetic characters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }
}
