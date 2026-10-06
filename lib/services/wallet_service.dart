import 'package:flutter/foundation.dart';

class WalletService {
  static final ValueNotifier<double> balanceNotifier =
      ValueNotifier<double>(5000.00);

  static final ValueNotifier<List<Map<String, dynamic>>>
      transactionsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([
    {
      'title': 'Demo Wallet Added',
      'amount': 5000.00,
      'type': 'credit',
    },
  ]);

  static double get balance => balanceNotifier.value;

  static void addBalance(double amount) {
    balanceNotifier.value += amount;

    _addTransaction(
      title: 'Demo Balance Added',
      amount: amount,
      type: 'credit',
    );
  }

  static bool hasEnoughBalance(double amount) {
    return balance >= amount;
  }

  static void deductBalance(double amount) {
    if (hasEnoughBalance(amount)) {
      balanceNotifier.value -= amount;

      _addTransaction(
        title: 'Movie Booking',
        amount: amount,
        type: 'debit',
      );
    }
  }

  static void _addTransaction({
    required String title,
    required double amount,
    required String type,
  }) {
    final updatedTransactions = [
      {
        'title': title,
        'amount': amount,
        'type': type,
      },
      ...transactionsNotifier.value,
    ];

    transactionsNotifier.value = updatedTransactions;
  }
}