import 'package:permission_handler/permission_handler.dart';

/// Requests a [Permission] - [p] and returns whether or not the permission was granted.
Future<bool> requestPermission(Permission p) async {
  return await p.request().isGranted;
}
