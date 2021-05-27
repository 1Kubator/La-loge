import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/store_gallery_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/image_from_net.dart';
import 'package:la_loge/widgets/loading_animation.dart';

class UserGallerySelectionsScreen extends StatefulWidget {
  static const id = 'user_gallery_selections_screen';

  @override
  _UserGallerySelectionsScreenState createState() =>
      _UserGallerySelectionsScreenState();
}

class _UserGallerySelectionsScreenState
    extends State<UserGallerySelectionsScreen> {
  Future<List<Store>> future;
  final db = locator<DatabaseService>();
  Store store;

  @override
  void initState() {
    super.initState();
    future = db.getStores();
    future.then((value) {
      store = value.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = InputBorder.none;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return FutureBuilder<List<Store>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return ErrorBox(error: snap.error);
          if (!snap.hasData) return LoadingAnimation();
          final stores = snap.data;
          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(child: AppTitle()),
                SizedBox(height: 32),
                Center(
                  child: Text(
                    MyAppLocalizations.of(context).whatUserLiked,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                DropdownButtonFormField(
                  value: store,
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                  ),
                  onChanged: (store) {
                    this.store = store;
                    setState(() {});
                  },
                  items: stores.map((store) {
                    return DropdownMenuItem<Store>(
                      child: Text(store.name),
                      value: store,
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),
                StreamBuilder(
                    key: UniqueKey(),
                    stream: db.getUserGallerySelections(store.id),
                    builder: (context, snap) {
                      if (snap.hasError) return ErrorBox(error: snap.error);
                      if (!snap.hasData) return LoadingAnimation();
                      final galleries = snap.data;
                      if (galleries.isEmpty)
                        return Center(
                          child: Text(
                            MyAppLocalizations.of(context).noSelections,
                          ),
                        );
                      return Container(
                        height: size.height / 2,
                        alignment: Alignment.center,
                        child: Theme(
                          data: theme.copyWith(
                            primaryColor: theme.accentColor,
                            scaffoldBackgroundColor:
                                theme.accentColor.withOpacity(0.4),
                          ),
                          child: Swiper(
                              loop: false,
                              outer: true,
                              itemCount: galleries.length,
                              viewportFraction: 0.9,
                              scrollDirection: Axis.horizontal,
                              pagination: SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(top: 32),
                                builder: DotSwiperPaginationBuilder(
                                  size: 7,
                                  activeSize: 8,
                                ),
                              ),
                              itemBuilder: (context, index) {
                                final gallery = galleries[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: ImageFromNet(
                                    imageUrl: gallery.imageUrl,
                                    // height: (size.height / 3),
                                    // width: (size.height / 3),
                                  ),
                                );
                              }),
                        ),
                      );
                    }),
                SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      StoreGalleryScreen.id,
                      arguments: store,
                    );
                  },
                  child: Text(MyAppLocalizations.of(context).redoSelections),
                )
              ],
            ),
          );
        });
  }
}
