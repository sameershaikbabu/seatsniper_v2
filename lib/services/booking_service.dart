import 'package:flutter/foundation.dart';

import '../models/booking_request.dart';

class BookingService {
  static final ValueNotifier<List<BookingRequest>> bookingsNotifier =
      ValueNotifier<List<BookingRequest>>([]);

  static List<BookingRequest> get bookings => bookingsNotifier.value;

  static void addBooking(BookingRequest booking) {
    bookingsNotifier.value = [
      booking,
      ...bookingsNotifier.value,
    ];
  }
}