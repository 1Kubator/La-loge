import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum NetworkError {
  CONNECTIVITY_ERROR,
  AUTHENTICATION_ERROR,
  USER_NOT_FOUND,
  INVALID_EMAIL,
  EMAIL_ALREADY_IN_USE,
  WRONG_PASSWORD,
  USER_DISABLED,
  TOO_MANY_REQUESTS,
  UNHANDLED,
}

class NetworkErrorMessage {
  static String getValue(BuildContext context, error) {
    switch (error.message) {
      case NetworkError.CONNECTIVITY_ERROR:
        return AppLocalizations.of(context).connectivityException;
        break;
      case NetworkError.AUTHENTICATION_ERROR:
        return AppLocalizations.of(context).authenticationException;
        break;
      case NetworkError.USER_NOT_FOUND:
        return AppLocalizations.of(context).loginInvalidCredentials;
        break;
      case NetworkError.INVALID_EMAIL:
        return AppLocalizations.of(context).loginInvalidCredentials;
        break;
      case NetworkError.EMAIL_ALREADY_IN_USE:
        return AppLocalizations.of(context)
            .registrationEmailAlreadyInUseException;
        break;
      case NetworkError.WRONG_PASSWORD:
        return AppLocalizations.of(context).loginInvalidCredentials;
        break;
      case NetworkError.USER_DISABLED:
        return AppLocalizations.of(context).loginUserDisabled;
        break;
      case NetworkError.TOO_MANY_REQUESTS:
        return AppLocalizations.of(context).loginTooManyRequest;
        break;
      default:
        return "genericErrorMessage";
    }
  }
}
