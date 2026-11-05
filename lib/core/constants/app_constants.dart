abstract final class AppConstants {
  static const String appName = 'Campus Reports';

  static const String appVersion = '1.0.1';
  static const String appBuildNumber = '2';
  static const List<String> allowedEmailDomains = [
    'alustudent.com',
    'alueducation.com',
  ];

  static const List<String> incidentCategories = [
    'WiFi / Network',
    'Water',
    'Electricity',
    'Printers',
    'Facilities',
    'Safety',
    'Sanitation',
    'Other',
  ];

  static const List<String> campusLocations = [
    'Social Commons - GF',
    'Social Commons - FF',
    'Social Commons - SF',
    'Learning Commons - GF',
    'Learning Commons - FF',
    'Learning Commons - SF',
    'Enterprise Commons - GF',
    'Enterprise Commons - FF',
    'Enterprise Commons - SF',
    'Angola Room',
    'Mozambique Room',
    'Kenya-Burundi Room',
    'Algeria Room',
    'Egypt Room',
    'Lesotho Room',
    'Malawi Room',
    'Fab Lab',
    'Elevator - Social Commons',
    'Elevator - Learning Commons',
    'Elevator - Enterprise Commons',
    'Restrooms - Social Commons',
    'Restrooms - Learning Commons',
    'Restrooms - Enterprise Commons',
    'Food Court',
    'Game Court',
    'Library',
    'Computer Lab',
    'Learning Pods',
    'Other',
  ];

  static const List<String> priorityLevels = ['Low', 'Normal', 'High', 'Urgent'];

  static const List<String> statusValues = [
    'Submitted',
    'In Progress',
    'Resolved',
    'Rejected',
  ];

  static const int titleMinLength = 5;
  static const int titleMaxLength = 80;
  static const int descriptionMinLength = 20;
  static const int descriptionMaxLength = 500;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxPhotosPerIncident = 3;
  static const int imageQuality = 80;

  static const int maxNoteLength = 300;
  static const int recentReportsLimit = 5;
  static const int notificationsPageSize = 20;
  static const Duration sessionTimeout = Duration(hours: 1);
  static const Duration debounceDelay = Duration(milliseconds: 400);
}
