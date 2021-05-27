import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/appointment/widgets/appointment_card.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';

class AppointmentListScreen extends StatefulWidget {
  static const id = 'appointment_list_screen';

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final db = locator<DatabaseService>();
  final dateFormat = DateFormat.yMMMMEEEEd('fr');
  final timeFormat = DateFormat.Hm('fr');
  Stream<List<StoreAppointmentArgument>> stream;

  @override
  void initState() {
    super.initState();
    stream = db.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<List<StoreAppointmentArgument>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.hasError) return Center(child: ErrorBox(error: snap.error));
          if (!snap.hasData) return LoadingAnimation();
          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: [
                Center(child: AppTitle()),
                SizedBox(height: 40),
                if (snap.data.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        MyAppLocalizations.of(context).noAppointments,
                        style: textTheme.caption,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 55 / 100,
                    child: Swiper(
                      itemCount: snap.data.length,
                      viewportFraction: 0.85,
                      scale: 0.95,
                      loop: false,
                      itemBuilder: (context, index) {
                        return AppointmentCard(
                          dateFormat: dateFormat,
                          storeAppointmentArg: snap.data[index],
                          timeFormat: timeFormat,
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
