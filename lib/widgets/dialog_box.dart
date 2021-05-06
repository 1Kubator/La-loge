import 'package:flutter/material.dart';
import 'package:la_loge/error_handling/network_error.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';

class DialogBox {
  static showSuccessDialog(context, msg) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
        ],
      ),
    );
  }

  static showNetworkErrorDialog(context, e) {
    final errorMsg = NetworkErrorMessage.getValue(context, e);
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMsg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
        ],
      ),
    );
  }

  static showCustomErrorDialog(context, String errorMsg,
      {Function() onPopped}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMsg),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onPopped != null) onPopped();
              },
              child: Text('Ok'))
        ],
      ),
    );
  }

  static Future<bool> showDiscontinueAppointmentAlert(
      BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_context) => AlertDialog(
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
      ),
    );
    return Future.value(false);
  }
}
