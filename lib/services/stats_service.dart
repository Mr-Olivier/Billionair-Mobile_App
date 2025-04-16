import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class StatsService {
  // Keys for SharedPreferences
  static const String _keyTotalEarned = 'stats_total_earned';
  static const String _keyTotalSpent = 'stats_total_spent';
  static const String _keyHighestBalance = 'stats_highest_balance';
  static const String _keyLastReset = 'stats_last_reset';
  static const String _keyActionCount = 'stats_action_count';

  // Track money earned
  static Future<void> trackMoneyEarned(double amount) async {
    if (amount <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final currentTotal = prefs.getDouble(_keyTotalEarned) ?? 0;
    await prefs.setDouble(_keyTotalEarned, currentTotal + amount);

    // Increment action count
    final actionCount = prefs.getInt(_keyActionCount) ?? 0;
    await prefs.setInt(_keyActionCount, actionCount + 1);
  }

  // Track money spent
  static Future<void> trackMoneySpent(double amount) async {
    if (amount >= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final currentTotal = prefs.getDouble(_keyTotalSpent) ?? 0;
    await prefs.setDouble(_keyTotalSpent, currentTotal + (-amount));

    // Increment action count
    final actionCount = prefs.getInt(_keyActionCount) ?? 0;
    await prefs.setInt(_keyActionCount, actionCount + 1);
  }

  // Update highest balance if new balance is higher
  static Future<void> updateHighestBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighest = prefs.getDouble(_keyHighestBalance) ?? 0;

    if (balance > currentHighest) {
      await prefs.setDouble(_keyHighestBalance, balance);
    }
  }

  // Record reset time
  static Future<void> recordReset() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyLastReset, now);
  }

  // Get all stats
  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();

    final totalEarned = prefs.getDouble(_keyTotalEarned) ?? 0;
    final totalSpent = prefs.getDouble(_keyTotalSpent) ?? 0;
    final highestBalance = prefs.getDouble(_keyHighestBalance) ?? 0;
    final actionCount = prefs.getInt(_keyActionCount) ?? 0;

    // Get last reset time
    final lastResetTimestamp = prefs.getInt(_keyLastReset);
    String lastReset = 'Never';

    if (lastResetTimestamp != null) {
      final lastResetDate = DateTime.fromMillisecondsSinceEpoch(
        lastResetTimestamp,
      );
      lastReset = DateFormat.yMMMd().add_jm().format(lastResetDate);
    }

    return {
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'highestBalance': highestBalance,
      'lastReset': lastReset,
      'actionCount': actionCount,
    };
  }

  // Reset all stats
  static Future<void> resetAllStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalEarned);
    await prefs.remove(_keyTotalSpent);
    await prefs.remove(_keyHighestBalance);
    await prefs.remove(_keyActionCount);
    await recordReset();
  }
}
