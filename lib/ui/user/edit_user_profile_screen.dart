import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/user.dart';
import 'package:la_loge/service/cloud_storage_service.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/menu/menu_screen.dart';
import 'package:la_loge/ui/user/user_profile_screen.dart';
import 'package:la_loge/ui/user/widgets/user_profile_image.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/utils/file_compressor.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/submit_button.dart';
import 'package:regexpattern/regexpattern.dart';

class EditUserProfileScreen extends StatefulWidget {
  static const id = 'edit_user_profile_screen';
  final User user;

  EditUserProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _EditUserProfileScreenState createState() =>
      _EditUserProfileScreenState(user);
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final User user;

  _EditUserProfileScreenState(this.user);

  File imageFile;
  final formKey = GlobalKey<FormState>();
  final db = locator<DatabaseService>();
  final storage = locator<CloudStorageService>();
  final dateFormat = DateFormat.yMd('fr');
  final currentDate = DateTime.now();
  int day;
  int month;
  int year;
  String email;
  String city;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    fillFields();
  }

  void fillFields() {
    email = user.email;
    city = user.city;
    imageUrl = user.imageUrl;
    day = user.dob?.day;
    month = user.dob?.month;
    year = user.dob?.year;
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
      hintStyle: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w300,
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          children: [
            Center(child: AppTitle()),
            SizedBox(height: 20),
            UserProfileImage(
              user: widget.user,
              onImageSelected: (file) {
                imageFile = file;
              },
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                widget.user.name,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              initialValue: email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (val) {
                email = val;
              },
              validator: (val) {
                return val.isEmail()
                    ? null
                    : MyAppLocalizations.of(context).invalidEmail;
              },
              decoration: inputDecoration.copyWith(
                labelText: MyAppLocalizations.of(context).emailAddress,
                hintText: '',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: city,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
              ],
              onChanged: (val) {
                city = val;
              },
              validator: (val) {
                return val.length > 1
                    ? null
                    : MyAppLocalizations.of(context).invalidInput;
              },
              decoration: inputDecoration.copyWith(
                labelText: MyAppLocalizations.of(context).location,
                hintText: MyAppLocalizations.of(context).city,
              ),
            ),
            SizedBox(height: 32),
            Text(
              MyAppLocalizations.of(context).dateOfBirth,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    onChanged: (val) {
                      day = int.tryParse(val);
                    },
                    validator: (val) {
                      return val.length > 0 && int.parse(val) <= 31 ? null : '';
                    },
                    initialValue: day?.toString(),
                    decoration: inputDecoration.copyWith(
                      hintText: MyAppLocalizations.of(context).day,
                    ),
                  ),
                ),
                Text(
                  '  /  ',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    decoration: inputDecoration.copyWith(
                      hintText: MyAppLocalizations.of(context).month,
                    ),
                    maxLength: 2,
                    onChanged: (val) {
                      month = int.tryParse(val);
                    },
                    validator: (val) {
                      return val.length > 0 && int.parse(val) <= 12 ? null : '';
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    initialValue: month?.toString(),
                  ),
                ),
                Text(
                  '  /  ',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  width: 74,
                  child: TextFormField(
                    decoration: inputDecoration.copyWith(
                      hintText: MyAppLocalizations.of(context).year,
                    ),
                    onChanged: (val) {
                      year = int.tryParse(val);
                    },
                    maxLength: 4,
                    validator: (val) {
                      return val.length == 4 &&
                              int.parse(val) <= currentDate.year
                          ? null
                          : '';
                    },
                    keyboardType: TextInputType.number,
                    initialValue: year?.toString(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            SizedBox(height: 44),
            SubmitButton(
              MyAppLocalizations.of(context).editProfile,
              isOutlined: true,
              onTap: () async {
                if (!formKey.currentState.validate()) return;
                await _updateDetails();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateDetails() async {
    if (imageFile != null) {
      var compressedImg = await FileCompressor.compressImg(imageFile);
      imageUrl = await storage.uploadImageWithFile(compressedImg, 'users/');
    }
    var user = this.user.copyWith(
          email: email,
          city: city,
          imageUrl: imageUrl,
          dob: DateTime(year, month, day),
        );
    await db.updateUserDetails(user);
    Navigator.pushNamedAndRemoveUntil(
      context,
      UserProfileScreen.id,
      (route) => route.settings.name == MenuScreen.id,
    );
  }
}
