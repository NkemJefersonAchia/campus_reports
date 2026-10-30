import '../constants/app_constants.dart';

abstract final class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final trimmed = value.trim().toLowerCase();
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
    if (!emailRegex.hasMatch(trimmed)) return 'Enter a valid email address';
    final domain = trimmed.split('@').last;
    if (!AppConstants.allowedEmailDomains.contains(domain)) {
      return 'Only ALU email addresses are allowed';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include at least one uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include at least one number';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 2) return 'Name is too short';
    if (value.trim().length > 50) return 'Name is too long';
    return null;
  }

  static String? incidentTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    if (value.trim().length < AppConstants.titleMinLength) {
      return 'Title must be at least ${AppConstants.titleMinLength} characters';
    }
    if (value.trim().length > AppConstants.titleMaxLength) {
      return 'Title cannot exceed ${AppConstants.titleMaxLength} characters';
    }
    return null;
  }

  static String? incidentDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    if (value.trim().length < AppConstants.descriptionMinLength) {
      return 'Description must be at least ${AppConstants.descriptionMinLength} characters';
    }
    if (value.trim().length > AppConstants.descriptionMaxLength) {
      return 'Description cannot exceed ${AppConstants.descriptionMaxLength} characters';
    }
    return null;
  }
}
