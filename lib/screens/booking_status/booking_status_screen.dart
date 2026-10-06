import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/booking_request.dart';
import '../../services/wallet_service.dart';
import '../../services/booking_service.dart';

class BookingStatusScreen extends StatefulWidget {
  final BookingRequest bookingRequest;

  const BookingStatusScreen({
    super.key,
    required this.bookingRequest,
  });

  @override
  State<BookingStatusScreen> createState() =>
      _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  String bookingStatus = 'ready';
  bool isProcessing = false;

  double get estimatedCost {
    return widget.bookingRequest.budget;
  }

  void _startBookingCheck() {
  if (isProcessing) {
    return;
  }

  setState(() {
    isProcessing = true;
    bookingStatus = 'checking';
  });

  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) {
      return;
    }

    if (WalletService.hasEnoughBalance(estimatedCost)) {
      WalletService.deductBalance(estimatedCost);

      final completedBooking = widget.bookingRequest.copyWith(
        status: 'success',
      );

      BookingService.addBooking(completedBooking);

      setState(() {
        bookingStatus = 'success';
        isProcessing = false;
      });
    } else {
      setState(() {
        bookingStatus = 'insufficient_balance';
        isProcessing = false;
      });
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Booking Status'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildMovieCard(),
            const SizedBox(height: 16),
            _buildBookingDetails(),
            const SizedBox(height: 16),
            _buildSeatPreferences(),
            const SizedBox(height: 16),
            _buildWalletCard(),
            const SizedBox(height: 24),
            _buildActionButton(),
            const SizedBox(height: 12),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    String title;
    String message;

    switch (bookingStatus) {
      case 'checking':
        icon = Icons.auto_awesome_rounded;
        iconColor = Colors.blue.shade800;
        backgroundColor = Colors.blue.shade100;
        title = 'AI Checking Booking';
        message = 'Checking wallet and booking requirements...';
        break;

      case 'success':
        icon = Icons.check_circle_rounded;
        iconColor = Colors.green.shade800;
        backgroundColor = Colors.green.shade100;
        title = 'Booking Successful';
        message = 'Demo booking has been completed successfully.';
        break;

      case 'insufficient_balance':
        icon = Icons.account_balance_wallet_outlined;
        iconColor = Colors.red.shade800;
        backgroundColor = Colors.red.shade100;
        title = 'Insufficient Wallet Balance';
        message = 'Your virtual wallet does not have enough credits.';
        break;

      default:
        icon = Icons.access_time_rounded;
        iconColor = Colors.orange.shade800;
        backgroundColor = Colors.orange.shade100;
        title = 'Waiting for Booking Window';
        message = 'Your booking request is ready.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade200,
            ),
            child: const Icon(
              Icons.movie_outlined,
              size: 28,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              widget.bookingRequest.movieName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    final date = widget.bookingRequest.bookingDate;

    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    return _sectionCard(
      title: 'Booking Details',
      icon: Icons.confirmation_number_outlined,
      children: [
        _detailRow(
          'Movie',
          widget.bookingRequest.movieName,
        ),
        _detailRow(
          'Theatre',
          widget.bookingRequest.theatreName,
        ),
        _detailRow(
          'Date',
          formattedDate,
        ),
        _detailRow(
          'Show Time',
          widget.bookingRequest.showTime,
        ),
        _detailRow(
          'Tickets',
          '${widget.bookingRequest.ticketCount}',
        ),
        _detailRow(
          'Budget',
          '₹${widget.bookingRequest.budget.toStringAsFixed(2)}',
        ),
      ],
    );
  }

  Widget _buildSeatPreferences() {
    return _sectionCard(
      title: 'Seat Preferences',
      icon: Icons.event_seat_outlined,
      children: [
        if (widget.bookingRequest.seatPreferences.isEmpty)
          const Text(
            'No seat preferences selected.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          )
        else
          ...widget.bookingRequest.seatPreferences.map(
            (preference) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(
                        '${preference.priority}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        preference.displayName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (preference.isPreferred)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Primary',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildWalletCard() {
  return ValueListenableBuilder<double>(
    valueListenable: WalletService.balanceNotifier,
    builder: (context, balance, child) {
      final bool enoughBalance = balance >= estimatedCost;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Smart Wallet',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(
              'Balance',
              '₹${balance.toStringAsFixed(2)}',
            ),
            _detailRow(
              'Booking Cost',
              '₹${estimatedCost.toStringAsFixed(2)}',
            ),
            _detailRow(
              'After Booking',
              enoughBalance
                  ? '₹${(balance - estimatedCost).toStringAsFixed(2)}'
                  : 'Insufficient',
            ),
          ],
        ),
      );
    },
  );
}
  Widget _detailRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (bookingStatus == 'success') {
      return Container(
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          '✓ Demo Booking Completed',
          style: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (bookingStatus == 'checking') {
      return const SizedBox(
        width: double.infinity,
        height: 52,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (bookingStatus == 'insufficient_balance') {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              bookingStatus = 'ready';
            });
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Check Again'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _startBookingCheck,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text(
          'Start AI Booking',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).popUntil(
            (route) => route.isFirst,
          );
        },
        child: const Text(
          'Back to Dashboard',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}