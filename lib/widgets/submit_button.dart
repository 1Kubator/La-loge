import 'package:flutter/material.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/progress_dialog.dart';
import 'loading_widget.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final ProgressDialog progressDialog = ProgressDialog();

  SubmitButton(this.title, {Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ElevatedButton(
          onPressed: () async {
            progressDialog.show(context);
            try {
              await onTap();
            } catch (e) {
              await DialogBox.showErrorDialog(context, e);
            } finally {
              progressDialog.hide();
            }
          },
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
