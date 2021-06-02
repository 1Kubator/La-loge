import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';

class StoreAppointmentTiming {
  static final DatabaseService db = locator<DatabaseService>();

  StoreAppointmentTiming({
    this.date,
    this.timestamps,
  });

  final DateTime date;
  final List<TimeStampsForDate> timestamps;

  StoreAppointmentTiming copyWith({
    DateTime date,
    List<DateTime> timestamps,
  }) =>
      StoreAppointmentTiming(
        date: date ?? this.date,
        timestamps: timestamps ?? this.timestamps,
      );

  factory StoreAppointmentTiming.fromMap(Map<String, dynamic> json) =>
      StoreAppointmentTiming(
        date: json["date"] == null ? null : json["date"],
        timestamps: json["timestamps"] == null
            ? null
            : List<TimeStampsForDate>.from(json["timestamps"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "date": date == null ? null : date,
        "timestamps": timestamps == null
            ? null
            : List<dynamic>.from(timestamps.map((x) => x)),
      };

  static Future<List<StoreAppointmentTiming>> fromDocuments(
      List<QueryDocumentSnapshot> docs, storeId) async {
    List<StoreAppointmentTiming> storeAppointmentTimings = [];
    final dates = docs.map((e) {
      final data = e.data();
      if (data is Map<String, dynamic>) {
        var date = data['datetime'] as Timestamp;
        return date.toDate();
      }
    }).toList();
    dates.map((e) => DateTime(e.year, e.month, e.day)).toSet().forEach((date) {
      storeAppointmentTimings.add(
        StoreAppointmentTiming(
            date: date,
            timestamps: dates.where((datetime) {
              return datetime.year == date.year &&
                  datetime.month == date.month &&
                  datetime.day == date.day;
            }).map((timestamp) {
              return TimeStampsForDate(timestamp: timestamp);
            }).toList()),
      );
    });
    for (int i = 0; i < storeAppointmentTimings.length; i++) {
      for (int j = 0; j < storeAppointmentTimings[i].timestamps.length; j++) {
        final isAvailable = await db.hasAppointmentForDateTime(
            storeId, storeAppointmentTimings[i].timestamps[j].timestamp);
        storeAppointmentTimings[i].timestamps[j] = storeAppointmentTimings[i]
            .timestamps[j]
            .copyWith(isAvailable: isAvailable);
      }
    }
    return storeAppointmentTimings;
  }
}

class TimeStampsForDate {
  final DateTime timestamp;
  final bool isAvailable;

  TimeStampsForDate({this.timestamp, this.isAvailable});

  TimeStampsForDate copyWith({
    DateTime timestamp,
    bool isAvailable,
  }) =>
      TimeStampsForDate(
        timestamp: timestamp ?? this.timestamp,
        isAvailable: isAvailable ?? this.isAvailable,
      );
}
