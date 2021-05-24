import 'package:flutter/material.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isOutlined;
  final ProgressDialog progressDialog = ProgressDialog();

  SubmitButton(this.title,
      {Key key, @required this.onTap, this.isOutlined = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onPressed = () async {
      progressDialog.show(context);
      try {
        await onTap();
      } catch (e) {
        progressDialog.hide();
        await DialogBox.showNetworkErrorDialog(context, e);
      }
      progressDialog.hide();
    };
    final child = Text(title);
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: isOutlined
            ? OutlinedButton(onPressed: onPressed, child: child)
            : ElevatedButton(onPressed: onPressed, child: child),
      ),
    );
  }
}
