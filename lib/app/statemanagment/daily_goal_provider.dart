import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/daily_goal_model.dart';
import '../services/notification_service.dart';

class DailyGoalProvider extends ChangeNotifier {
  Box<DailyGoalModel>? _goalBox;
  DailyGoalModel? _currentGoal;

  DailyGoalModel? get currentGoal => _currentGoal;

  Future<void> initialize() async {
    _goalBox = await Hive.openBox<DailyGoalModel>('daily_goal');
    if (_goalBox!.isEmpty) {
      final newGoal = DailyGoalModel();
      await _goalBox!.add(newGoal);
    }
    _currentGoal = _goalBox!.values.first;
    notifyListeners();
  }

  Future<void> updateProgress(int pagesRead) async {
    if (_currentGoal == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final currentProgress = _currentGoal!.dailyProgress[today] ?? 0;

    _currentGoal!.dailyProgress[today] = currentProgress + pagesRead;
    _currentGoal!.totalPagesRead += pagesRead;

    if (_currentGoal!.dailyProgress[today]! >= _currentGoal!.goalPages) {
      _updateStreak(today);
    }

    await _currentGoal!.save();
    notifyListeners();
  }

  void _updateStreak(String today) {
    final lastDate = _currentGoal!.lastReadDate;
    if (lastDate.isEmpty) {
      _currentGoal!.currentStreak = 1;
    } else {
      final last = DateTime.parse(lastDate);
      final current = DateTime.parse(today);
      final difference = current.difference(last).inDays;

      if (difference == 1) {
        _currentGoal!.currentStreak += 1;
        if (_currentGoal!.currentStreak > _currentGoal!.longestStreak) {
          _currentGoal!.longestStreak = _currentGoal!.currentStreak;
          NotificationService().showStreakNotification(_currentGoal!.currentStreak);
        }
      } else if (difference > 1) {
        _currentGoal!.currentStreak = 1;
      }
    }
    _currentGoal!.lastReadDate = today;
  }

  Future<void> updateGoal(int newGoalPages) async {
    if (_currentGoal == null || newGoalPages < 1) return;
    _currentGoal!.goalPages = newGoalPages;
    await _currentGoal!.save();
    notifyListeners();
  }

  Map<String, int> getWeeklyProgress() {
    if (_currentGoal == null) return {};

    final today = DateTime.now();
    final weekProgress = <String, int>{};

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      weekProgress[dateStr] = _currentGoal!.dailyProgress[dateStr] ?? 0;
    }

    return weekProgress;
  }

  int getTodayProgress() {
    if (_currentGoal == null) return 0;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _currentGoal!.dailyProgress[today] ?? 0;
  }

  bool isTodayGoalCompleted() {
    if (_currentGoal == null) return false;
    return getTodayProgress() >= _currentGoal!.goalPages;
  }
}
