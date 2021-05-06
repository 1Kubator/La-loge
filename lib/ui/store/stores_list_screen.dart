import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/store_gallery_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

import 'appointment/store_appointment_timings_screen.dart';

class StoresListScreen extends StatefulWidget {
  static const id = 'stores_list_screen';

  @override
  _StoresListScreenState createState() => _StoresListScreenState();
}

class _StoresListScreenState extends State<StoresListScreen> {
  final DatabaseService db = locator<DatabaseService>();
  Future future;
  final progressDialog = ProgressDialog();

  @override
  void initState() {
    super.initState();
    future = db.getStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Store>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return ErrorBox(error: snap.error);
          if (!snap.hasData) return LoadingAnimation();
          final stores = snap.data;
          return ListView(
            children: [
              Center(child: AppTitle()),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    MyAppLocalizations.of(context).readyForPrivateShopping,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    MyAppLocalizations.of(context).makeAnAppointmentWithStore,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 28),
              ListView.builder(
                itemCount: stores.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return ListTile(
                    onTap: () async {
                      checkAndNavigateToGalleryScreen(store);
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      store.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                    subtitle: Text(
                      store.location,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                    ),
                    trailing: Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  checkAndNavigateToGalleryScreen(Store store) async {
    progressDialog.show(context);
    try {
      var hasSeenGalleryItems = await db.hasSeenStoreCompleteGallery(store.id);
      progressDialog.hide();
      if (hasSeenGalleryItems) {
        Navigator.pushNamed(
          context,
          StoreAppointmentTimingsScreen.id,
          arguments: store,
        );
      } else {
        Navigator.pushNamed(
          context,
          StoreGalleryScreen.id,
          arguments: store,
        );
      }
    } catch (e) {
      progressDialog.hide();
      await DialogBox.showNetworkErrorDialog(context, e);
    }
  }
}
