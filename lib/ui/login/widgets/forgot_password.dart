import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 16,
      child: FlatButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        child: Text(
          AppLocalizations.of(context).forgotPassword,
          style: textTheme.caption.copyWith(fontSize: 11),
        ),
      ),
    );
  }
}
