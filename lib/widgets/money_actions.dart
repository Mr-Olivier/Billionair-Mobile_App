import 'package:flutter/material.dart';

class MoneyAction {
  final String name;
  final IconData icon;
  final double amount;
  final Color color;
  final String description;

  MoneyAction({
    required this.name,
    required this.icon,
    required this.amount,
    required this.color,
    required this.description,
  });
}

class MoneyActionCard extends StatelessWidget {
  final MoneyAction action;
  final Function(double) onAction;
  final bool isDarkMode;

  const MoneyActionCard({
    Key? key,
    required this.action,
    required this.onAction,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDarkMode ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => onAction(action.amount),
        borderRadius: BorderRadius.circular(16),
        splashColor: action.color.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: action.color.withOpacity(0.2),
                radius: 25,
                child: Icon(action.icon, color: action.color, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                action.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                action.amount >= 0
                    ? '+\$${action.amount.toStringAsFixed(0)}'
                    : '-\$${(-action.amount).toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color:
                      action.amount >= 0 ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoneyActionsGrid extends StatelessWidget {
  final Function(double) onMoneyAction;
  final bool isDarkMode;

  const MoneyActionsGrid({
    Key? key,
    required this.onMoneyAction,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MoneyAction> actions = [
      MoneyAction(
        name: 'Work',
        icon: Icons.work,
        amount: 500,
        color: Colors.blue,
        description: 'Earn by working',
      ),
      MoneyAction(
        name: 'Invest',
        icon: Icons.trending_up,
        amount: 1000,
        color: Colors.green,
        description: 'Earn by investing',
      ),
      MoneyAction(
        name: 'Lottery',
        icon: Icons.casino,
        amount: 2000,
        color: Colors.purple,
        description: 'Try your luck!',
      ),
      MoneyAction(
        name: 'Expense',
        icon: Icons.shopping_cart,
        amount: -300,
        color: Colors.red,
        description: 'Daily expenses',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return MoneyActionCard(
          action: actions[index],
          onAction: onMoneyAction,
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}
