import 'package:easy_localization/easy_localization.dart';

/// Form validation utilities for sign up and other forms
class FormValidators {
  /// Validates email format
  /// Returns null if valid, error message string if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'validation.email_required'.tr();
    }

    // Regular expression for email validation
    const emailRegex = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailRegex);

    if (!regex.hasMatch(email)) {
      return 'validation.email_invalid'.tr();
    }

    return null;
  }

  /// Validates password strength
  /// Returns null if valid, error message string if invalid
  /// Requirements: min 8 chars, at least one uppercase, one lowercase, one number, one special char
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'validation.password_required'.tr();
    }

    if (password.length < 8) {
      return 'validation.password_min_length'.tr();
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'validation.password_uppercase'.tr();
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'validation.password_lowercase'.tr();
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'validation.password_number'.tr();
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'validation.password_special_char'.tr();
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
      return 'validation.confirm_password_required'.tr();
    }

    if (password != confirmPassword) {
      return 'validation.password_mismatch'.tr();
    }

    return null;
  }

  /// Validates username/name field
  /// Returns null if valid, error message string if invalid
  /// Only allows alphabetic characters and spaces
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'validation.name_required'.tr();
    }

    if (name.length < 2) {
      return 'validation.name_min_length'.tr();
    }

    // Only allow alphabetic characters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'validation.name_letters_only'.tr();
    }

    return null;
  }
}