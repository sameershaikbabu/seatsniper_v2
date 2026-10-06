import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/seat_preference.dart';
import '../booking_status/booking_status_screen.dart';
import '../../models/booking_request.dart';
class SeatPreferencesScreen extends StatefulWidget {
  final int ticketCount;
  final String? movieName;
  final String? theatreName;
  final DateTime? bookingDate;
  final String? showTime;
  final double? budget;

  const SeatPreferencesScreen({
    super.key,
    required this.ticketCount,
    this.movieName,
    this.theatreName,
    this.bookingDate,
    this.showTime,
    this.budget,
  });

  @override
  State<SeatPreferencesScreen> createState() =>
      _SeatPreferencesScreenState();
}

class _SeatPreferencesScreenState extends State<SeatPreferencesScreen> {
  static const int seatsPerRow = 8;

  static const List<String> rows = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
  ];

  // Demo occupied seats.
  // Later these will come from the Python backend.
  static const Set<String> occupiedSeats = {
    'A2',
    'A3',
    'B6',
    'C1',
    'C2',
    'D7',
    'E4',
    'F5',
    'G2',
    'H8',
  };

  final List<SeatPreference> preferences = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Preferences'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSeatLegend(),
              const SizedBox(height: 24),
              _buildPreferenceSection(),
              const SizedBox(height: 24),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_seat,
                color: AppTheme.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Choose Your Seats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'You selected ${widget.ticketCount} ticket${widget.ticketCount == 1 ? '' : 's'}. '
            'Choose exactly ${widget.ticketCount} seats for each preference.',
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem(
          color: Colors.white,
          borderColor: Colors.grey.shade400,
          label: 'Available',
        ),
        _legendItem(
          color: AppTheme.primaryColor,
          borderColor: AppTheme.primaryColor,
          label: 'Selected',
        ),
        _legendItem(
          color: Colors.grey.shade400,
          borderColor: Colors.grey.shade400,
          label: 'Occupied',
        ),
      ],
    );
  }

  Widget _legendItem({
    required Color color,
    required Color borderColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${preferences.length}/5',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (preferences.isEmpty)
          _buildEmptyState()
        else
          ...preferences.asMap().entries.map(
                (entry) => _buildPreferenceCard(
                  entry.key,
                  entry.value,
                ),
              ),
        const SizedBox(height: 12),
        if (preferences.length < 5)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openSeatSelection,
              icon: const Icon(Icons.add),
              label: const Text('Add Seat Preference'),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_seat_outlined,
            size: 42,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 10),
          const Text(
            'No seat preferences added',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Add your first preferred seat combination.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceCard(
    int index,
    SeatPreference preference,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: preference.isPreferred
              ? AppTheme.primaryColor
              : Colors.grey.shade300,
          width: preference.isPreferred ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preference.displayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  preference.isPreferred
                      ? 'Primary preference'
                      : 'Alternative preference',
                  style: TextStyle(
                    color: preference.isPreferred
                        ? AppTheme.primaryColor
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                preferences.removeAt(index);

                if (preferences.isNotEmpty &&
                    !preferences.any((item) => item.isPreferred)) {
                  final first = preferences.first;

                  preferences[0] = SeatPreference(
                    priority: 1,
                    seats: first.seats,
                    isPreferred: true,
                  );
                }

                for (int i = 0; i < preferences.length; i++) {
                  final item = preferences[i];

                  preferences[i] = SeatPreference(
                    priority: i + 1,
                    seats: item.seats,
                    isPreferred: i == 0,
                  );
                }
              });
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: preferences.isEmpty ? null : _continueBooking,
        child: const Text(
          'Continue to Booking Status',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _openSeatSelection() {
    final selectedSeats = <String>{};
    bool isPrimary = preferences.isEmpty;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Seats',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${selectedSeats.length} / ${widget.ticketCount} seats selected',
                        style: TextStyle(
                          color: selectedSeats.length == widget.ticketCount
                              ? Colors.green
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Screen
                      Container(
                        width: double.infinity,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'SCREEN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildSeatGrid(
                        selectedSeats,
                        setDialogState,
                      ),

                      const SizedBox(height: 18),

                      if (selectedSeats.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Selected: ${selectedSeats.join(', ')}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Primary preference',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: isPrimary,
                        onChanged: preferences.isEmpty
                            ? null
                            : (value) {
                                setDialogState(() {
                                  isPrimary = value;
                                });
                              },
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  selectedSeats.length == widget.ticketCount
                                      ? () {
                                          _savePreference(
                                            selectedSeats,
                                            isPrimary,
                                          );

                                          Navigator.of(dialogContext).pop();
                                        }
                                      : null,
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSeatGrid(
    Set<String> selectedSeats,
    StateSetter setDialogState,
  ) {
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(seatsPerRow, (index) {
              final seatNumber = index + 1;
              final seatName = '$row$seatNumber';

              final isOccupied = occupiedSeats.contains(seatName);
              final isSelected = selectedSeats.contains(seatName);

              return Padding(
                padding: EdgeInsets.only(
                  right: index == 3 ? 18 : 4,
                ),
                child: _buildSeat(
                  seatName: seatName,
                  isOccupied: isOccupied,
                  isSelected: isSelected,
                  onTap: () {
                    if (isOccupied) {
                      _showMessage('Seat $seatName is already occupied.');
                      return;
                    }

                    setDialogState(() {
                      if (isSelected) {
                        selectedSeats.remove(seatName);
                      } else {
                        if (selectedSeats.length >= widget.ticketCount) {
                          _showMessage(
                            'You can select only ${widget.ticketCount} seats.',
                          );
                          return;
                        }

                        selectedSeats.add(seatName);
                      }
                    });
                  },
                ),
              );
            }),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeat({
    required String seatName,
    required bool isOccupied,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isOccupied) {
      backgroundColor = Colors.grey.shade400;
      borderColor = Colors.grey.shade400;
      textColor = Colors.white;
    } else if (isSelected) {
      backgroundColor = AppTheme.primaryColor;
      borderColor = AppTheme.primaryColor;
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.white;
      borderColor = Colors.grey.shade400;
      textColor = Colors.grey.shade800;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Text(
          seatName,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _savePreference(
    Set<String> selectedSeats,
    bool isPrimary,
  ) {
    final seats = selectedSeats.toList();

    if (seats.length != widget.ticketCount) {
      _showMessage(
        'Please select exactly ${widget.ticketCount} seats.',
      );
      return;
    }

    if (seats.toSet().length != seats.length) {
      _showMessage('Duplicate seats are not allowed.');
      return;
    }

    setState(() {
      if (isPrimary) {
        for (int i = 0; i < preferences.length; i++) {
          final item = preferences[i];

          preferences[i] = SeatPreference(
            priority: item.priority,
            seats: item.seats,
            isPreferred: false,
          );
        }
      }

      preferences.add(
        SeatPreference(
          priority: preferences.length + 1,
          seats: seats,
          isPreferred: isPrimary || preferences.isEmpty,
        ),
      );

      for (int i = 0; i < preferences.length; i++) {
        final item = preferences[i];

        preferences[i] = SeatPreference(
          priority: i + 1,
          seats: item.seats,
          isPreferred: i == 0,
        );
      }
    });
  }

  void _continueBooking() {
  final bookingRequest = BookingRequest(
    movieName: widget.movieName ?? 'Demo Movie',
    theatreName: widget.theatreName ?? 'Demo Theatre',
    bookingDate: widget.bookingDate ?? DateTime.now(),
    showTime: widget.showTime ?? 'Not selected',
    ticketCount: widget.ticketCount,
    budget: widget.budget ?? 0,
    seatPreferences: List.unmodifiable(preferences),
    status: 'ready',
  );

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BookingStatusScreen(
        bookingRequest: bookingRequest,
      ),
    ),
  );
}
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}