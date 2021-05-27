import 'package:flutter/material.dart';
import 'package:la_loge/service/firebase_auth.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/progress_dialog.dart';
import 'package:regexpattern/regexpattern.dart';

class ForgotPassword extends StatelessWidget {
  final progressDialog = ProgressDialog();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 32,
      child: TextButton(
        onPressed: () async {
          _showDialogForEmail(context);
        },
        child: Text(MyAppLocalizations.of(context).forgotPassword,
            style: textTheme.caption.copyWith(fontSize: 11)),
      ),
    );
  }

  _showDialogForEmail(BuildContext context) {
    final theme = Theme.of(context);
    var title = Text(MyAppLocalizations.of(context).email);
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.accentColor, width: 0.3),
    );
    String email = '';
    var content = Material(
      color: Colors.transparent,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: title.data,
          enabledBorder: border,
          focusedBorder: border,
        ),
        onChanged: (val) {
          email = val;
        },
      ),
    );
    var actions = [
      TextButton(
        onPressed: () {
          if (email.isEmpty || (!email.isEmail()))
            return DialogBox.showCustomErrorDialog(
              context,
              MyAppLocalizations.of(context).enterEmail,
            );
          _resetPassword(context, email);
        },
        child: Text(MyAppLocalizations.of(context).ok),
      )
    ];
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox.getPlatformBasedDialog(
            title: title,
            actions: actions,
            content: content,
          );
        });
  }

  _resetPassword(BuildContext context, String email) async {
    progressDialog.show(context);
    try {
      await FirebaseAuthentication.resetPassword(email);
      progressDialog.hide();
      await DialogBox.showSuccessDialog(
        context,
        MyAppLocalizations.of(context).passwordResetEmailSent,
      );
      Navigator.pop(context);
    } catch (e) {
      progressDialog.hide();
      await DialogBox.parseAndShowExceptionDialog(context, e);
    }
  }
}
