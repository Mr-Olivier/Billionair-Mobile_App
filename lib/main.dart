import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:billionaireapp/widgets/balance_view.dart';
import 'package:billionaireapp/widgets/add_money.dart';
import 'package:billionaireapp/widgets/reset_button.dart';
import 'package:billionaireapp/widgets/money_actions.dart';
import 'package:billionaireapp/services/achievement_service.dart';
import 'package:billionaireapp/services/stats_service.dart';
import 'package:billionaireapp/screens/stats_screen.dart';
import 'package:billionaireapp/theme/app_theme.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved balance and theme preference
  final prefs = await SharedPreferences.getInstance();
  final initialBalance = prefs.getDouble('balance') ?? 0.0;
  final isDarkMode = prefs.getBool('isDarkMode') ?? true;

  runApp(MyApp(initialBalance: initialBalance, initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final double initialBalance;
  final bool initialDarkMode;

  const MyApp({
    Key? key,
    required this.initialBalance,
    required this.initialDarkMode,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;
  late double _balance;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
    _balance = widget.initialBalance;

    // Update highest balance on app start
    StatsService.updateHighestBalance(_balance);
  }

  // Toggle between light and dark mode
  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    // Save theme preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Handle changing money
  Future<void> _changeMoney(double amount) async {
    final newBalance = _balance + amount;

    // Don't allow negative balance
    if (newBalance < 0) {
      _showInsufficientFundsDialog();
      return;
    }

    setState(() {
      _balance = newBalance;
    });

    // Save balance
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', _balance);

    // Track statistics
    if (amount > 0) {
      await StatsService.trackMoneyEarned(amount);
    } else {
      await StatsService.trackMoneySpent(amount);
    }

    // Update highest balance record
    await StatsService.updateHighestBalance(_balance);

    // Check for achievements
    final achievements = await AchievementService.checkAchievements(_balance);
    if (achievements.isNotEmpty) {
      // Wait until the next frame to show achievement dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAchievementDialog(achievements.first);
      });
    }
  }

  // Show insufficient funds dialog
  void _showInsufficientFundsDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.money_off, color: Colors.red),
              SizedBox(width: 10),
              Text('Insufficient Funds'),
            ],
          ),
          content: const Text(
            'You don\'t have enough money for this transaction.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Reset money to zero
  Future<void> _resetMoney() async {
    setState(() {
      _balance = 0;
    });

    // Save balance
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', _balance);

    // Record reset time
    await StatsService.recordReset();
  }

  // Show achievement unlocked dialog
  void _showAchievementDialog(Achievement achievement) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.emoji_events, color: Colors.amber),
              SizedBox(width: 10),
              Text('Achievement Unlocked!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: achievement.color.withOpacity(0.2),
                radius: 40,
                child: Icon(
                  achievement.icon,
                  size: 40,
                  color: achievement.color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                achievement.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(achievement.description, textAlign: TextAlign.center),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('AWESOME!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Open statistics screen
  void _openStats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatsScreen(isDarkMode: _isDarkMode),
      ),
    );
  }

  // Global key for navigator
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billionaire App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: BillionaireHome(
        balance: _balance,
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
        onMoneyChange: _changeMoney,
        onResetMoney: _resetMoney,
        onOpenStats: _openStats,
      ),
    );
  }
}

class BillionaireHome extends StatefulWidget {
  final double balance;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Function(double) onMoneyChange;
  final VoidCallback onResetMoney;
  final Function(BuildContext) onOpenStats;

  const BillionaireHome({
    Key? key,
    required this.balance,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onMoneyChange,
    required this.onResetMoney,
    required this.onOpenStats,
  }) : super(key: key);

  @override
  State<BillionaireHome> createState() => _BillionaireHomeState();
}

class _BillionaireHomeState extends State<BillionaireHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();

    // Set up animation for balance update
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Trigger money animation and call the money change callback
  void _handleMoneyChange(double amount) {
    _animationController.forward().then((_) => _animationController.reverse());
    widget.onMoneyChange(amount);
  }

  // Show confirmation dialog before resetting
  void _confirmReset() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Balance'),
          content: const Text(
            'Are you sure you want to reset your balance to \$0?',
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
              onPressed: () {
                Navigator.of(context).pop();
                widget.onResetMoney();
              },
            ),
          ],
        );
      },
    );
  }

  // Show achievements dialog
  void _showAchievements() async {
    final achievements = await AchievementService.getUnlockedAchievements();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.emoji_events, color: Colors.amber),
              SizedBox(width: 10),
              Text('Your Achievements'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child:
                achievements.isEmpty
                    ? const Center(
                      child: Text(
                        'No achievements unlocked yet.\nKeep earning money!',
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: achievement.color.withOpacity(0.2),
                            child: Icon(
                              achievement.icon,
                              color: achievement.color,
                            ),
                          ),
                          title: Text(achievement.title),
                          subtitle: Text(achievement.description),
                        );
                      },
                    ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors based on current theme
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '💰 Billionaire App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Stats button
          IconButton(
            icon: const Icon(Icons.insert_chart),
            onPressed: () => widget.onOpenStats(context),
            tooltip: 'Statistics',
          ),
          // Achievements button
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: _showAchievements,
            tooltip: 'Achievements',
          ),
          // Theme toggle button
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [Colors.blueGrey[900]!, Colors.blueGrey[800]!]
                    : [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Balance display with animation
            BalanceView(
              balance: widget.balance,
              animation: _animation,
              isDarkMode: isDark,
            ),

            // Action buttons section
            if (_showActions) ...[
              Expanded(
                child: MoneyActionsGrid(
                  onMoneyAction: _handleMoneyChange,
                  isDarkMode: isDark,
                ),
              ),

              // Toggle view button
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showActions = false;
                  });
                },
                icon: const Icon(Icons.arrow_upward),
                label: const Text('HIDE ACTIONS'),
              ),
            ] else ...[
              // Button row
              Row(
                children: [
                  // Reset button
                  Expanded(
                    flex: 1,
                    child: ResetButton(
                      onResetPressed: _confirmReset,
                      isDarkMode: isDark,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add money button
                  Expanded(
                    flex: 2,
                    child: AddMoneyButton(
                      addMoneyFunction: () => _handleMoneyChange(500),
                      isDarkMode: isDark,
                    ),
                  ),
                ],
              ),

              // Toggle view button
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showActions = true;
                  });
                },
                icon: const Icon(Icons.arrow_downward),
                label: const Text('SHOW MORE ACTIONS'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
