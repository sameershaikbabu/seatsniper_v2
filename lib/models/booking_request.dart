import 'seat_preference.dart';

class BookingRequest {
  final String movieName;
  final String theatreName;
  final DateTime bookingDate;
  final String showTime;
  final int ticketCount;
  final double budget;
  final List<SeatPreference> seatPreferences;
  final String status;

  const BookingRequest({
    required this.movieName,
    required this.theatreName,
    required this.bookingDate,
    required this.showTime,
    required this.ticketCount,
    required this.budget,
    required this.seatPreferences,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'movie_name': movieName,
      'theatre_name': theatreName,
      'booking_date': bookingDate.toIso8601String(),
      'show_time': showTime,
      'ticket_count': ticketCount,
      'budget': budget,
      'seat_preferences':
          seatPreferences.map((seat) => seat.toJson()).toList(),
      'status': status,
    };
  }

  BookingRequest copyWith({
    String? movieName,
    String? theatreName,
    DateTime? bookingDate,
    String? showTime,
    int? ticketCount,
    double? budget,
    List<SeatPreference>? seatPreferences,
    String? status,
  }) {
    return BookingRequest(
      movieName: movieName ?? this.movieName,
      theatreName: theatreName ?? this.theatreName,
      bookingDate: bookingDate ?? this.bookingDate,
      showTime: showTime ?? this.showTime,
      ticketCount: ticketCount ?? this.ticketCount,
      budget: budget ?? this.budget,
      seatPreferences: seatPreferences ?? this.seatPreferences,
      status: status ?? this.status,
    );
  }
}