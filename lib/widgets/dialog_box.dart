import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_loge/error_handling/network_error.dart';
import 'package:la_loge/error_handling/platform_exception.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';

class DialogBox {
  static showSuccessDialog(context, msg) {
    return showDialog(
      context: context,
      builder: (_) => getPlatformBasedDialog(
        title: Text(MyAppLocalizations.of(context).success),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MyAppLocalizations.of(context).ok),
          )
        ],
      ),
    );
  }

  static parseAndShowExceptionDialog(context, exception) {
    String errorMsg;
    if (exception is PlatformException) {
      errorMsg = PlatformExceptionHelper.parseError(context, exception);
    } else {
      errorMsg = NetworkErrorMessage.getValue(context, exception);
    }
    return showDialog(
      context: context,
      builder: (_context) => getPlatformBasedDialog(
        title: Text(MyAppLocalizations.of(context).error),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_context),
            child: Text(MyAppLocalizations.of(context).ok),
          )
        ],
      ),
    );
  }

  static Future<Widget> showCustomErrorDialog(context, String errorMsg,
      {Function() onPopped}) {
    return showDialog(
      context: context,
      builder: (_context) => getPlatformBasedDialog(
        title: Text(MyAppLocalizations.of(context).oops),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(_context);
              if (onPopped != null) onPopped();
            },
            child: Text(MyAppLocalizations.of(context).ok),
          )
        ],
      ),
    );
  }

  static Future<bool> showDiscontinueAppointmentAlert(
      BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_context) {
        return getPlatformBasedDialog(
          title: Text(MyAppLocalizations.of(context).discontinueAppointment),
          content:
              Text(MyAppLocalizations.of(context).alertDiscontinueAppointment),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(_context);
                Navigator.of(context).popUntil(
                  (route) => route.settings.name == StoresListScreen.id,
                );
              },
              child: Text(MyAppLocalizations.of(context).yes),
            ),
            TextButton(
              onPressed: () => Navigator.pop(_context),
              child: Text(MyAppLocalizations.of(context).no),
            ),
          ],
        );
      },
    );
    return Future.value(false);
  }

  static Widget getPlatformBasedDialog({
    Widget title,
    Widget content,
    List<Widget> actions,
  }) {
    if (Platform.isIOS)
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
