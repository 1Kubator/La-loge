class StoreAppointment {
  StoreAppointment({
    this.bookingQuestions,
    this.status,
    this.appointmentDateTime,
    this.userId,
  });

  final Map<String, dynamic> bookingQuestions;
  final String status;
  final DateTime appointmentDateTime;
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
        appointmentDateTime: appointmentTimeStamp ?? this.appointmentDateTime,
        userId: userId ?? this.userId,
      );

  factory StoreAppointment.fromMap(Map<String, dynamic> json) =>
      StoreAppointment(
        bookingQuestions: json["booking_questions"] == null
            ? null
            : json["booking_questions"],
        status: json["status"] == null ? null : json["status"],
        appointmentDateTime: json["appointment_date_time"] == null
            ? null
            : json["appointment_date_time"],
        userId: json["user_id"] == null ? null : json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "booking_questions": bookingQuestions == null ? null : bookingQuestions,
        "status": status == null ? null : status,
        "appointment_date_time":
            appointmentDateTime == null ? null : appointmentDateTime,
        "user_id": userId == null ? null : userId,
      };
}
