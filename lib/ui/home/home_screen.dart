import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/user.dart';
import 'package:la_loge/providers/tabs_notifier.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:la_loge/widgets/submit_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final images = [
    Images.homeScreenFirstTab,
    Images.homeScreenSecondTab,
  ];
  final screens = [
    FirstPositionedTab(),
    SecondPositionedTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: images.length,
      pagination: new SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: Colors.white60,
          activeColor: Colors.white,
          size: 6,
          activeSize: 8,
        ),
      ),
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(images[index], fit: BoxFit.cover),
            screens[index]
          ],
        );
      },
    );
  }
}

class FirstPositionedTab extends StatelessWidget {
  final db = locator<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    final tabNotifier = Provider.of<TabsNotifier>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Positioned.fill(
      child: ListView(
        children: [
          SizedBox(height: 20),
          Center(child: AppTitle()),
          SizedBox(height: size.height / 6),
          Center(
            child: Text(
              MyAppLocalizations.of(context).welcome,
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w700,
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 4),
          StreamBuilder<User>(
              stream: db.getUserDetailsAsStream(),
              builder: (context, snap) {
                if (snap.hasError) return Container();
                if (!snap.hasData) return Container();
                return Center(
                  child: Text(
                    '${snap.data.name} !',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                    ),
                  ),
                );
              }),
          SizedBox(height: size.height / 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context).shoppingAppointment,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Center(
              child: Text(
                MyAppLocalizations.of(context).accessAdvantagesInFavStores,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 32),
          SubmitButton(
            AppLocalizations.of(context).bookPrivateShopping,
            isOutlined: true,
            onTap: () {
              tabNotifier.setTabIndex = 1;
            },
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class SecondPositionedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabNotifier = Provider.of<TabsNotifier>(context, listen: false);
    return Positioned.fill(
      bottom: 1,
      child: Column(
        children: [
          Spacer(flex: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context).findAppointments,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 28),
          SubmitButton(
            AppLocalizations.of(context).myPrivateShopping,
            isOutlined: true,
            onTap: () {
              tabNotifier.setTabIndex = 2;
            },
          ),
          Spacer(flex: 1)
        ],
      ),
    );
  }
}
