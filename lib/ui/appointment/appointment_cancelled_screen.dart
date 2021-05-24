import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/providers/tabs_notifier.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/ui/appointment/appointment_list_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:provider/provider.dart';

class AppointmentCancelledScreen extends StatelessWidget {
  static const id = 'appointment_cancelled_screen';

  @override
  Widget build(BuildContext context) {
    final tabNotifier = Provider.of<TabsNotifier>(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Images.homeScreenFirstTab)),
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Center(child: AppTitle()),
              SizedBox(height: 12),
              Spacer(),
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Text(
                            MyAppLocalizations.of(context).appointmentCancelled,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily:
                                  GoogleFonts.playfairDisplay().fontFamily,
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(
                            MyAppLocalizations.of(context)
                                .receiveEmailConfirmation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          SizedBox(height: 40),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColorDark,
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Theme.of(context).primaryColorDark,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                              child: Text(
                                MyAppLocalizations.of(context)
                                    .myPrivateShopping,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.popUntil(context, (route) {
                                  return route.settings.name ==
                                      AppointmentListScreen.id;
                                });
                                tabNotifier.setTabIndex = 1;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
