import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../seat_preferences/seat_preferences_screen.dart';

class AutoBookingScreen extends StatefulWidget {
  const AutoBookingScreen({super.key});

  @override
  State<AutoBookingScreen> createState() => _AutoBookingScreenState();
}

class _AutoBookingScreenState extends State<AutoBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController movieController =
      TextEditingController();

  final TextEditingController theatreController =
      TextEditingController();

  final TextEditingController budgetController =
      TextEditingController();

  DateTime? selectedDate;

  String? selectedShowTime;

  int ticketCount = 2;

  final List<String> showTimes = [
    '10:00 AM',
    '1:00 PM',
    '4:00 PM',
    '7:30 PM',
    '10:00 PM',
  ];

  @override
  void dispose() {
    movieController.dispose();
    theatreController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  
    void _createAutoBooking() {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (selectedDate == null) {
    _showMessage('Please select a booking date.');
    return;
  }

  if (selectedShowTime == null) {
    _showMessage('Please select a show time.');
    return;
  }

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SeatPreferencesScreen(
        ticketCount: ticketCount,
        movieName: movieController.text.trim(),
        theatreName: theatreController.text.trim(),
        bookingDate: selectedDate,
        showTime: selectedShowTime,
        budget: double.parse(
          budgetController.text.trim(),
        ),
      ),
    ),
  );
}

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  String _formatDate(DateTime date) {
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Auto Booking',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Form(
        key: _formKey,

        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 28),

              _buildSectionTitle('Movie Details'),

              const SizedBox(height: 14),

              _buildTextField(
                controller: movieController,
                label: 'Movie Name',
                hint: 'Enter movie name',
                icon: Icons.movie_outlined,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: theatreController,
                label: 'Theatre',
                hint: 'Enter theatre name',
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 26),

              _buildSectionTitle('Show Details'),

              const SizedBox(height: 14),

              _buildDateSelector(),

              const SizedBox(height: 16),

              _buildShowTimeSelector(),

              const SizedBox(height: 16),

              _buildTicketSelector(),

              const SizedBox(height: 26),

              _buildSectionTitle('Budget'),

              const SizedBox(height: 14),

              _buildBudgetField(),

              const SizedBox(height: 26),

              _buildInfoCard(),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _createAutoBooking,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Auto Booking',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Tell SeatSniper what you want. '
          'The booking engine will handle the rest.',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,

      textInputAction: TextInputAction.next,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,

      borderRadius: BorderRadius.circular(14),

      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Booking Date',
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
          ),
        ),

        child: Text(
          selectedDate == null
              ? 'Select date'
              : _formatDate(selectedDate!),
          style: TextStyle(
            color: selectedDate == null
                ? Colors.grey.shade500
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildShowTimeSelector() {
    return DropdownButtonFormField<String>(
      initialValue: selectedShowTime,

      decoration: const InputDecoration(
        labelText: 'Show Time',
        prefixIcon: Icon(
          Icons.access_time_rounded,
        ),
      ),

      hint: const Text('Select show time'),

      items: showTimes.map((time) {
        return DropdownMenuItem<String>(
          value: time,
          child: Text(time),
        );
      }).toList(),

      onChanged: (value) {
        setState(() {
          selectedShowTime = value;
        });
      },

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select show time';
        }

        return null;
      },
    );
  }

  Widget _buildTicketSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.people_outline_rounded,
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Number of Tickets',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          IconButton(
            onPressed: ticketCount > 1
                ? () {
                    setState(() {
                      ticketCount--;
                    });
                  }
                : null,
            icon: const Icon(
              Icons.remove_circle_outline,
            ),
          ),

          Text(
            '$ticketCount',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          IconButton(
            onPressed: ticketCount < 10
                ? () {
                    setState(() {
                      ticketCount++;
                    });
                  }
                : null,
            icon: const Icon(
              Icons.add_circle_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetField() {
    return TextFormField(
      controller: budgetController,

      keyboardType: TextInputType.number,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Maximum budget is required';
        }

        final budget = double.tryParse(value);

        if (budget == null || budget <= 0) {
          return 'Enter a valid budget';
        }

        return null;
      },

      decoration: const InputDecoration(
        labelText: 'Maximum Budget',
        hintText: 'Example: 800',
        prefixText: '₹ ',
        prefixIcon: Icon(
          Icons.account_balance_wallet_outlined,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.18),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppTheme.primaryColor,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'After creating the request, you can configure '
              'preferred and alternate seat combinations. '
              'SeatSniper will try them in priority order.',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}