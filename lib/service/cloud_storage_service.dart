import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  Future<String> uploadImageWithFile(
    File imageFile,
    String path,
  ) async {
    final imageName = '${DateTime.now().microsecondsSinceEpoch}';
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(
          path + imageName,
        );
    final uploadTask = firebaseStorageRef.putFile(imageFile);
    final storageSnapshot = await uploadTask.then((val) => val);
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    var url = downloadUrl.toString();
    return url;
  }
}
