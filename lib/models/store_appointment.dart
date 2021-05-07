import 'package:cloud_firestore/cloud_firestore.dart';

class StoreAppointment {
  StoreAppointment({
    this.id,
    this.bookingQuestions,
    this.status,
    this.appointmentDateTime,
    this.userId,
    this.storeId,
  });

  final String id;
  final Map<String, dynamic> bookingQuestions;
  final String status;
  final DateTime appointmentDateTime;
  final String userId;
  final String storeId;

  StoreAppointment copyWith({
    Map<String, dynamic> bookingQuestions,
    String status,
    DateTime appointmentTimeStamp,
    String userId,
  }) =>
      StoreAppointment(
        id: id ?? this.id,
        bookingQuestions: bookingQuestions ?? this.bookingQuestions,
        status: status ?? this.status,
        appointmentDateTime: appointmentTimeStamp ?? this.appointmentDateTime,
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
      );

  factory StoreAppointment.fromMap(String id, Map<String, dynamic> json) =>
      StoreAppointment(
        id: id,
        bookingQuestions: json["booking_questions"] == null
            ? null
            : json["booking_questions"],
        status: json["status"] == null ? null : json["status"],
        appointmentDateTime: json["appointment_date_time"] == null
            ? null
            : json["appointment_date_time"] is Timestamp
                ? json["appointment_date_time"].toDate()
                : json["appointment_date_time"],
        userId: json["user_id"] == null ? null : json["user_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "booking_questions": bookingQuestions == null ? null : bookingQuestions,
        "status": status == null ? null : status,
        "appointment_date_time":
            appointmentDateTime == null ? null : appointmentDateTime,
        "user_id": userId == null ? null : userId,
        "store_id": storeId == null ? null : storeId,
      };
}
