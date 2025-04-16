import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:billionaireapp/services/stats_service.dart';

class StatsScreen extends StatelessWidget {
  final bool isDarkMode;

  const StatsScreen({Key? key, required this.isDarkMode}) : super(key: key);

  // Show confirmation dialog for stats reset
  void _confirmStatsReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Statistics'),
          content: const Text(
            'Are you sure you want to reset all statistics? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('RESET'),
              onPressed: () async {
                await StatsService.resetAllStats();
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).pop(); // Pop twice to go back to main screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Card(
      elevation: isDarkMode ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 25,
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: StatsService.getStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No statistics available'));
          }

          final stats = snapshot.data!;
          final currencyFormat = NumberFormat.currency(
            symbol: '\$',
            decimalDigits: 0,
          );

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDarkMode
                        ? [Colors.blueGrey[900]!, Colors.blueGrey[800]!]
                        : [Colors.blue[50]!, Colors.blue[100]!],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatCard(
                  context,
                  'Total Money Earned',
                  currencyFormat.format(stats['totalEarned']),
                  Icons.trending_up,
                  Colors.green,
                  isDarkMode,
                ),
                _buildStatCard(
                  context,
                  'Total Money Spent',
                  currencyFormat.format(stats['totalSpent']),
                  Icons.trending_down,
                  Colors.red,
                  isDarkMode,
                ),
                _buildStatCard(
                  context,
                  'Highest Balance',
                  currencyFormat.format(stats['highestBalance']),
                  Icons.emoji_events,
                  Colors.amber,
                  isDarkMode,
                ),
                _buildStatCard(
                  context,
                  'Total Actions',
                  stats['actionCount'].toString(),
                  Icons.touch_app,
                  Colors.blue,
                  isDarkMode,
                ),
                _buildStatCard(
                  context,
                  'Last Reset',
                  stats['lastReset'],
                  Icons.restart_alt,
                  Colors.purple,
                  isDarkMode,
                ),
                const SizedBox(height: 24),

                // Reset stats button
                ElevatedButton.icon(
                  onPressed: () => _confirmStatsReset(context),
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('RESET STATISTICS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
