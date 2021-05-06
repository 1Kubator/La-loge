import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';

class StoreAppointmentArgument {
  final StoreAppointment storeAppointment;
  final Store store;
  final String appointmentReason;

  StoreAppointmentArgument(
      {this.storeAppointment, this.store, this.appointmentReason});
}
