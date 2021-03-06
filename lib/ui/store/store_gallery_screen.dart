import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/gallery.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/store_gallery_complete_screen.dart';
import 'package:la_loge/ui/store/widgets/gallery_swiper.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';

class StoreGalleryScreen extends StatefulWidget {
  static const id = 'store_gallery_screen';
  final Store store;
  final bool isBookingProcess;

  const StoreGalleryScreen({Key key, this.store, this.isBookingProcess = true})
      : super(key: key);

  @override
  _StoreGalleryScreenState createState() => _StoreGalleryScreenState();
}

class _StoreGalleryScreenState extends State<StoreGalleryScreen> {
  Future<List<Gallery>> future;
  final DatabaseService db = locator<DatabaseService>();
  int galleryIndex = 0;

  @override
  void initState() {
    super.initState();
    future = db.getStoreGalleries(widget.store.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!widget.isBookingProcess) {
          Navigator.pop(context);
          return Future.value(false);
        }
        return DialogBox.showDiscontinueAppointmentAlert(context);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<List<Gallery>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasError) return ErrorBox(error: snap.error);
              if (!snap.hasData) return LoadingAnimation();

              return ListView(
                children: [
                  Center(child: AppTitle()),
                  SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        MyAppLocalizations.of(context).aboveAll,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        MyAppLocalizations.of(context).swipeInfo,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: Text(
                      '${galleryIndex + 1}/${snap.data.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: GallerySwiper(
                      galleries: snap.data,
                      onSwiped: (index, swipeInfo) {
                        db.updateGallerySelection(
                          snap.data[index].docReference,
                          swipeInfo.direction,
                          widget.store.id,
                        );
                        if (index + 1 == snap.data.length) {
                          if (!widget.isBookingProcess) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushNamed(
                              context,
                              StoreGalleryCompleteScreen.id,
                              arguments: widget.store,
                            );
                          }
                        } else {
                          galleryIndex++;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 28),
                ],
              );
            }),
      ),
    );
  }
}
