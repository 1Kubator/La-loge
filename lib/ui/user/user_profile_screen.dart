import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/user.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/image_from_net.dart';
import 'package:la_loge/widgets/loading_widget.dart';

class UserProfileScreen extends StatefulWidget {
  static const id = 'user_profile_screen';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future future;
  final db = locator<DatabaseService>();
  final dateFormat = DateFormat.yMd('fr');

  @override
  void initState() {
    super.initState();
    future = db.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError) return ErrorBox(error: snap.error);
        if (!snap.hasData) return LoadingWidget();
        final user = snap.data;
        return Scaffold(
          appBar: AppBar(),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            children: [
              Center(child: AppTitle()),
              SizedBox(height: 20),
              if (user.imageUrl != null)
                Center(
                  child: ImageFromNet(
                    imageUrl: user.imageUrl,
                    height: 140,
                    width: 140,
                    shape: BoxShape.circle,
                  ),
                ),
              SizedBox(height: 12),
              Center(
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              UserDetailsTile(
                title: MyAppLocalizations.of(context).emailAddress,
                subtitle: user.email,
              ),
              UserDetailsTile(
                title: MyAppLocalizations.of(context).location,
                subtitle: user.city,
              ),
              UserDetailsTile(
                title: MyAppLocalizations.of(context).dateOfBirth,
                subtitle: user.dob == null ? null : dateFormat.format(user.dob),
              ),
              SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(MyAppLocalizations.of(context).myPreferences),
                ),
              ),
              SizedBox(height: 24),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(MyAppLocalizations.of(context).editProfile),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserDetailsTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const UserDetailsTile({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle ?? '---------',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
