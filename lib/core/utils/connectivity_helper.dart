import 'dart:io';

const _lookupTimeout = Duration(seconds: 5);

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
