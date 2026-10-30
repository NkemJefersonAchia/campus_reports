abstract final class AppConstants {
  static const String appName = 'Campus Reports';

  static const String appVersion = '1.0.1';
  static const String appBuildNumber = '2';
  static const List<String> allowedEmailDomains = [
    'alustudent.com',
    'alueducation.com',
  ];

  static const List<String> incidentCategories = [
    'Facilities',
    'Water',
    'Electricity',
    'Safety',
    'Sanitation',
    'Other',
  ];

  static const List<String> campusLocations = [
    'Block A',
    'Block B',
    'Block C',
    'Block D',
    'Block E',
    'Student Residence - East',
    'Student Residence - West',
    'Student Residence - North',
    'Cafeteria',
    'Library',
    'Main Hall',
    'Admin Building',
    'Sports Complex',
    'Parking Lot',
    'Health Center',
    'IT Lab',
    'Auditorium',
    'Garden / Outdoor',
    'Other',
  ];

  static const List<String> priorityLevels = ['Low', 'Normal', 'High', 'Urgent'];

  static const int titleMinLength = 5;
  static const int titleMaxLength = 80;
  static const int descriptionMinLength = 20;
  static const int descriptionMaxLength = 500;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxPhotosPerIncident = 3;
  static const int imageQuality = 80;

  static const Duration sessionTimeout = Duration(hours: 1);
}
