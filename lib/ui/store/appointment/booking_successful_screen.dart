import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/providers/tabs_notifier.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/ui/appointment/edit_appointment_screen.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:provider/provider.dart';

class BookingSuccessfulScreen extends StatelessWidget {
  static const id = 'booking_successful_screen';
  final StoreAppointment appointment;

  const BookingSuccessfulScreen({Key key, this.appointment}) : super(key: key);

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
          body: ListView(
            children: [
              Center(child: AppTitle()),
              SizedBox(height: 32),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        MyAppLocalizations.of(context).bookingRegistered,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        MyAppLocalizations.of(context).wishYouHappyShopping,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        MyAppLocalizations.of(context).receiveEmailConfirmation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            EditAppointmentScreen.id,
                            arguments: appointment,
                          );
                        },
                        child: Text(
                          MyAppLocalizations.of(context).editPrivateShopping,
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                      SizedBox(height: 44),
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
                            MyAppLocalizations.of(context).myPrivateShopping,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.popUntil(
                                context,
                                (route) =>
                                    route.settings.name == StoresListScreen.id);
                            tabNotifier.setTabIndex = 2;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
