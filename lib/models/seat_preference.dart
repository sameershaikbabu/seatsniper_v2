class SeatPreference {
  final int priority;
  final List<String> seats;
  final bool isPreferred;

  const SeatPreference({
    required this.priority,
    required this.seats,
    required this.isPreferred,
  });

  String get displayName {
    return seats.join(' + ');
  }

  Map<String, dynamic> toJson() {
    return {
      'priority': priority,
      'seats': seats,
      'is_preferred': isPreferred,
    };
  }
}