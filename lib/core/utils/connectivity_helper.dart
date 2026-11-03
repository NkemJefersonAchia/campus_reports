import 'dart:async';
import 'dart:io';

const _lookupTimeout = Duration(seconds: 5);
const _retryDelay = Duration(seconds: 3);

Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(_lookupTimeout);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  } on Exception catch (_) {
    return false;
  }
}

Future<bool> waitForConnection({int maxAttempts = 3}) async {
  for (var i = 0; i < maxAttempts; i++) {
    if (await hasInternetConnection()) return true;
    if (i < maxAttempts - 1) {
      await Future.delayed(_retryDelay);
    }
  }
  return false;
}
