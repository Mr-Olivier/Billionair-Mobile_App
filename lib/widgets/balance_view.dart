import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceView extends StatelessWidget {
  final double balance;
  final Animation<double>? animation;
  final bool isDarkMode;

  const BalanceView({
    Key? key,
    required this.balance,
    this.animation,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format currency with commas
    final formattedBalance = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    ).format(balance);

    // Determine status based on balance
    String? statusText;
    Color? statusColor;
    IconData? statusIcon;

    if (balance >= 1000000000) {
      statusText = 'BILLIONAIRE STATUS';
      statusColor = isDarkMode ? Colors.amber : Colors.amber[800];
      statusIcon = Icons.emoji_events;
    } else if (balance >= 1000000) {
      statusText = 'MILLIONAIRE';
      statusColor = isDarkMode ? Colors.orange : Colors.orange[800];
      statusIcon = Icons.local_fire_department;
    } else if (balance >= 100000) {
      statusText = 'GETTING RICHER';
      statusColor = isDarkMode ? Colors.green : Colors.green[700];
      statusIcon = Icons.trending_up;
    }

    return Expanded(
      flex: 9,
      child: Center(
        child: Card(
          elevation: isDarkMode ? 8 : 4,
          shadowColor: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedBuilder(
            animation: animation ?? const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              return Transform.scale(
                scale: animation?.value ?? 1.0,
                child: child,
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDarkMode
                          ? [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.7),
                          ]
                          : [Colors.white, Colors.blue.shade50],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your Balance',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    formattedBalance,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (statusText != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor?.withOpacity(isDarkMode ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor ?? Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (statusIcon != null) ...[
                            Icon(statusIcon, color: statusColor, size: 20),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
