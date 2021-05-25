import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:la_loge/models/user.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/image_from_net.dart';
import 'package:la_loge/widgets/upload_image_options.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileImage extends StatefulWidget {
  final User user;
  final Function(File file) onImageSelected;

  const UserProfileImage({Key key, this.user, this.onImageSelected})
      : super(key: key);

  @override
  _UserProfileImageState createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  File file;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          if (file == null)
            ImageFromNet(
              imageUrl: widget.user.imageUrl,
              height: 140,
              width: 140,
              shape: BoxShape.circle,
              errorWidget: Container(color: Colors.grey),
            )
          else
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(file),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_context) => UploadImageOptions(
                    onTap: (source) async {
                      PickedFile pickedFile;
                      try {
                        pickedFile =
                            await ImagePicker().getImage(source: source);
                      } catch (e) {
                        await DialogBox.parseAndShowExceptionDialog(context, e);
                        await openAppSettings();
                        return;
                      }
                      if (pickedFile == null) return;
                      var _file = File(pickedFile.path);
                      this.file = _file;
                      widget.onImageSelected(File(_file.path));
                      setState(() {});
                    },
                  ),
                );
              },
              child: Icon(Icons.edit, size: 20),
            ),
          )
        ],
      ),
    );
  }
}
