import 'package:flutter/material.dart';

abstract final class CategoryIcons {
  static IconData forCategory(String category) {
    switch (category) {
      case 'Facilities':
        return Icons.apartment;
      case 'Water':
        return Icons.water_drop_outlined;
      case 'Electricity':
        return Icons.bolt_outlined;
      case 'Safety':
        return Icons.shield_outlined;
      case 'Sanitation':
        return Icons.cleaning_services_outlined;
      case 'Network / IT':
        return Icons.wifi_outlined;
      case 'Other':
        return Icons.more_horiz;
      default:
        return Icons.report_outlined;
    }
  }
}
