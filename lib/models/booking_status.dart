enum BookingStatus { booked, cancelled }

class BookingStatusHelper {
  static BookingStatus fromString(String status) {
    switch (status) {
      case 'booked':
        return BookingStatus.booked;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return null;
    }
  }

  static String fromValue(BookingStatus status) {
    switch (status) {
      case BookingStatus.booked:
        return 'booked';
      case BookingStatus.cancelled:
        return 'cancelled';
      default:
        return null;
    }
  }
}
