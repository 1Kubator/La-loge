import 'package:flutter/material.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/dialog_box.dart';

import '../stores_list_screen.dart';

class BookingUnavailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: Future.delayed(
        Duration(milliseconds: 300),
        () {
          return DialogBox.showCustomErrorDialog(
            context,
            MyAppLocalizations.of(context).noPrivateShoppingHoursAvailable,
            onPopped: () {
              Navigator.popUntil(
                context,
                (route) => route.settings.name == StoresListScreen.id,
              );
            },
          );
        },
      ),
      builder: (context, snap) {
        if (snap.data == null) return Container();
        return snap.data;
      },
    );
  }
}
