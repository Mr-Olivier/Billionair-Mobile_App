import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final double threshold;
  final Color color;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.threshold,
    required this.color,
  });
}

class AchievementService {
  static final List<Achievement> _achievements = [
    Achievement(
      id: 'first_thousand',
      title: 'First Grand',
      description: 'Reach \$1,000 in your account',
      icon: Icons.monetization_on,
      threshold: 1000,
      color: Colors.green,
    ),
    Achievement(
      id: 'first_million',
      title: 'Millionaire',
      description: 'Reach \$1,000,000 in your account',
      icon: Icons.attach_money,
      threshold: 1000000,
      color: Colors.amber,
    ),
    Achievement(
      id: 'billionaire',
      title: 'Billionaire',
      description: 'Reach \$1,000,000,000 in your account',
      icon: Icons.emoji_events,
      threshold: 1000000000,
      color: Colors.purple,
    ),
    Achievement(
      id: 'multi_billionaire',
      title: 'Multi-Billionaire',
      description: 'Reach \$10,000,000,000 in your account',
      icon: Icons.local_fire_department,
      threshold: 10000000000,
      color: Colors.red,
    ),
  ];

  static List<Achievement> get achievements => _achievements;

  // Check for newly unlocked achievements
  static Future<List<Achievement>> checkAchievements(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Achievement> newlyUnlocked = [];

    for (var achievement in _achievements) {
      final String key = 'achievement_${achievement.id}';
      final bool? alreadyUnlocked = prefs.getBool(key);

      if (balance >= achievement.threshold && alreadyUnlocked != true) {
        await prefs.setBool(key, true);
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  // Get all unlocked achievements
  static Future<List<Achievement>> getUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Achievement> unlocked = [];

    for (var achievement in _achievements) {
      final String key = 'achievement_${achievement.id}';
      final bool? isUnlocked = prefs.getBool(key);

      if (isUnlocked == true) {
        unlocked.add(achievement);
      }
    }

    return unlocked;
  }
}
