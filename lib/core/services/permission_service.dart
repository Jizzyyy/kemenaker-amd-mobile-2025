import 'package:permission_handler/permission_handler.dart';

/// Service to handle app permissions
class PermissionService {
  /// Check if notification permission is granted
  Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Check if storage/photos permission is granted
  Future<bool> checkStoragePermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  /// Request storage/photos permission
  Future<bool> requestStoragePermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  /// Get permission status as string
  String getPermissionStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Diizinkan';
      case PermissionStatus.denied:
        return 'Ditolak';
      case PermissionStatus.restricted:
        return 'Dibatasi';
      case PermissionStatus.limited:
        return 'Terbatas';
      case PermissionStatus.permanentlyDenied:
        return 'Ditolak Permanen';
      case PermissionStatus.provisional:
        return 'Sementara';
    }
  }
}
