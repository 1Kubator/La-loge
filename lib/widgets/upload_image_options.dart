import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:la_loge/utils/app_localizations.dart';

class UploadImageOptions extends StatelessWidget {
  final Function(ImageSource) onTap;

  UploadImageOptions({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.linked_camera),
            title: Text(
              MyAppLocalizations.of(context).camera,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () async {
              Navigator.of(context).pop();
              onTap(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text(
              MyAppLocalizations.of(context).gallery,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () async {
              Navigator.of(context).pop();
              onTap(ImageSource.gallery);
            },
          )
        ],
      ),
    );
  }
}
