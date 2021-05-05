class StoreAppointment {
  StoreAppointment({
    this.bookingQuestions,
    this.status,
    this.appointmentTimeStamp,
    this.userId,
  });

  final Map<String, dynamic> bookingQuestions;
  final String status;
  final DateTime appointmentTimeStamp;
  final String userId;

  StoreAppointment copyWith({
    Map<String, dynamic> bookingQuestions,
    String status,
    DateTime appointmentTimeStamp,
    String userId,
  }) =>
      StoreAppointment(
        bookingQuestions: bookingQuestions ?? this.bookingQuestions,
        status: status ?? this.status,
        appointmentTimeStamp: appointmentTimeStamp ?? this.appointmentTimeStamp,
        userId: userId ?? this.userId,
      );

  factory StoreAppointment.fromMap(Map<String, dynamic> json) =>
      StoreAppointment(
        bookingQuestions: json["booking_questions"] == null
            ? null
            : json["booking_questions"],
        status: json["status"] == null ? null : json["status"],
        appointmentTimeStamp: json["appointment_time_stamp"] == null
            ? null
            : json["appointment_time_stamp"],
        userId: json["user_id"] == null ? null : json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "booking_questions": bookingQuestions == null ? null : bookingQuestions,
        "status": status == null ? null : status,
        "appointment_time_stamp":
            appointmentTimeStamp == null ? null : appointmentTimeStamp,
        "user_id": userId == null ? null : userId,
      };
}
