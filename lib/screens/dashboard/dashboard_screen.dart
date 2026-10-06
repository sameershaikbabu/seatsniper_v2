import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/wallet_service.dart';
import '../auto_booking/auto_booking_screen.dart';
import '../seat_preferences/seat_preferences_screen.dart';
import '../wallet/wallet_screen.dart';
import '../../services/booking_service.dart';
import '../../models/booking_request.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return months[month - 1];
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SeatSniper',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),

            const SizedBox(height: 24),

            _buildWalletCard(context),

            const SizedBox(height: 28),

            _buildSectionTitle(
              title: 'Quick Action',
            ),

            const SizedBox(height: 12),

            _buildCreateBookingButton(context),

            const SizedBox(height: 12),

            _buildSeatPreferencesButton(context),

            const SizedBox(height: 28),

            _buildSectionTitle(
              title: 'Upcoming Auto Booking',
              actionText: 'View All',
            ),

            const SizedBox(height: 12),

            _buildUpcomingBooking(),

            const SizedBox(height: 28),

            _buildSectionTitle(
              title: 'Recent Bookings',
            ),

            const SizedBox(height: 12),

            ValueListenableBuilder<List<BookingRequest>>(
  valueListenable: BookingService.bookingsNotifier,
  builder: (context, bookings, child) {
    if (bookings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No bookings yet',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      children: bookings.take(5).map((booking) {
        final String statusText =
            booking.status == 'success' ? 'Completed' : 'Waiting';

        final IconData statusIcon =
            booking.status == 'success'
                ? Icons.check_circle_outline_rounded
                : Icons.schedule_rounded;

        return _buildRecentBooking(
          movie: booking.movieName,
          date:
              '${booking.bookingDate.day} ${_monthName(booking.bookingDate.month)} ${booking.bookingDate.year}',
          time: booking.showTime,
          status: statusText,
          statusIcon: statusIcon,
        );
      }).toList(),
    );
  },
),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello 👋',
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Ready for your next booking?',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const WalletScreen(),
          ),
        );

        setState(() {});
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF302B63),
              Color(0xFF24243E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'SMART WALLET',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ],
            ),

            const SizedBox(height: 22),

            ValueListenableBuilder<double>(
  valueListenable: WalletService.balanceNotifier,
  builder: (context, balance, child) {
    return Text(
      '₹${balance.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
      ),
    );
  },
),

            const SizedBox(height: 4),

            Text(
              'DEMO CREDITS • VIRTUAL ONLY',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    String? actionText,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: const TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCreateBookingButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AutoBookingScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.auto_awesome_rounded,
        ),
        label: const Text(
          'Create Auto Booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSeatPreferencesButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SeatPreferencesScreen(
                ticketCount: 2,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.event_seat_outlined,
        ),
        label: const Text(
          'Seat Preferences',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingBooking() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.movie_outlined,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avengers: Endgame',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Demo Theatre',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            height: 1,
            color: Colors.white12,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text('30 Sep 2026'),

              const SizedBox(width: 20),

              const Icon(
                Icons.access_time_rounded,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text('7:30 PM'),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.people_outline_rounded,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text('2 Tickets'),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'WAITING',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBooking({
    required String movie,
    required String date,
    required String time,
    required String status,
    required IconData statusIcon,
  }) {
    final bool completed = status == 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.movie_outlined,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$date • $time',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            statusIcon,
            size: 17,
            color: completed
                ? Colors.greenAccent
                : Colors.orangeAccent,
          ),

          const SizedBox(width: 5),

          Text(
            status,
            style: TextStyle(
              color: completed
                  ? Colors.greenAccent
                  : Colors.orangeAccent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}