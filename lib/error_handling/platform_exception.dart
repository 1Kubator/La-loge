import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:la_loge/utils/app_localizations.dart';

class PlatformExceptionHelper {
  static String parseError(BuildContext context, PlatformException exception) {
    switch (exception.code) {
      case 'photo_access_denied':
        return MyAppLocalizations.of(context).userDeniedGalleryPermission;
      case 'camera_access_denied':
        return MyAppLocalizations.of(context).userDeniedCameraPermission;
      default:
        return exception.message;
    }
  }
}
