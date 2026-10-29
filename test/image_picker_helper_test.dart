import 'package:flutter_test/flutter_test.dart';
import 'package:campus_reports/core/constants/app_constants.dart';

void main() {
  test('maxImageSize is 5MB', () { expect(AppConstants.maxImageSize, 5 * 1024 * 1024); });
  test('imageQuality is set', () { expect(AppConstants.imageQuality, 80); });
}
