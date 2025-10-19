import 'package:animations/animations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../models/daily_goal_model.dart';
import '../../services/notification_service.dart';

class DailyGoalPage extends StatefulWidget {
  const DailyGoalPage({super.key});

  @override
  State<DailyGoalPage> createState() => _DailyGoalPageState();
}

class _DailyGoalPageState extends State<DailyGoalPage>
    with SingleTickerProviderStateMixin {
  late Box<DailyGoalModel> goalBox;
  DailyGoalModel? currentGoal;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadGoalData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadGoalData() async {
    goalBox = await Hive.openBox<DailyGoalModel>('daily_goal');
    if (goalBox.isEmpty) {
      final newGoal = DailyGoalModel();
      await goalBox.add(newGoal);
    }
    setState(() {
      currentGoal = goalBox.values.first;
    });
  }

  Future<void> _updateProgress(int pagesRead) async {
    if (currentGoal == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final currentProgress = currentGoal!.dailyProgress[today] ?? 0;

    currentGoal!.dailyProgress[today] = currentProgress + pagesRead;
    currentGoal!.totalPagesRead += pagesRead;

    if (currentGoal!.dailyProgress[today]! >= currentGoal!.goalPages) {
      _updateStreak(today);
    }

    await currentGoal!.save();
    setState(() {});
  }

  void _updateStreak(String today) {
    final lastDate = currentGoal!.lastReadDate;
    if (lastDate.isEmpty) {
      currentGoal!.currentStreak = 1;
    } else {
      final last = DateTime.parse(lastDate);
      final current = DateTime.parse(today);
      final difference = current.difference(last).inDays;

      if (difference == 1) {
        currentGoal!.currentStreak += 1;
        if (currentGoal!.currentStreak > currentGoal!.longestStreak) {
          currentGoal!.longestStreak = currentGoal!.currentStreak;
          NotificationService().showStreakNotification(
            currentGoal!.currentStreak,
          );
        }
      } else if (difference > 1) {
        currentGoal!.currentStreak = 1;
      }
    }
    currentGoal!.lastReadDate = today;
  }

  @override
  Widget build(BuildContext context) {
    if (currentGoal == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayProgress = currentGoal!.dailyProgress[today] ?? 0;
    final progressPercentage = (todayProgress / currentGoal!.goalPages).clamp(
      0.0,
      1.0,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'الورد اليومي 📖',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 80,
                      child: Icon(
                        Icons.auto_stories_outlined,
                        size: 100,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTodayProgressCard(todayProgress, progressPercentage),
                const SizedBox(height: 16),
                _buildStreakCard(),
                const SizedBox(height: 16),
                _buildGoalSettingsCard(),
                const SizedBox(height: 16),
                _buildWeeklyChartCard(),
                const SizedBox(height: 16),
                _buildStatsCards(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _showAddProgressDialog(),
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'تسجيل قراءة',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgressCard(int todayProgress, double progressPercentage) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'تقدم اليوم',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        value: progressPercentage,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$todayProgress',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          'من ${currentGoal!.goalPages}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontFamily: 'Amiri',
                          ),
                        ),
                        const Text(
                          'صفحة',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (progressPercentage >= 1.0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'أحسنت! أكملت ورد اليوم',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
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

  Widget _buildStreakCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.deepOrange.shade400],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStreakItem(
              '🔥',
              '${currentGoal!.currentStreak}',
              'يوم متتالي',
            ),
            Container(
              height: 60,
              width: 1,
              color: Colors.white.withOpacity(0.5),
            ),
            _buildStreakItem(
              '🏆',
              '${currentGoal!.longestStreak}',
              'أطول سلسلة',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'Amiri',
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSettingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات الهدف اليومي',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'عدد الصفحات يوميًا:',
                    style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _updateGoal(-1),
                      ),
                      Text(
                        '${currentGoal!.goalPages}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _updateGoal(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChartCard() {
    final last7Days = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      return DateFormat('yyyy-MM-dd').format(date);
    });

    final chartData = last7Days.map((date) {
      return currentGoal!.dailyProgress[date] ?? 0;
    }).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'القراءة خلال الأسبوع',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (chartData.reduce((a, b) => a > b ? a : b) + 5)
                      .toDouble(),
                  barGroups: chartData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: Theme.of(context).primaryColor,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '📚',
            '${currentGoal!.totalPagesRead}',
            'إجمالي الصفحات',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '📅',
            '${currentGoal!.dailyProgress.length}',
            'أيام القراءة',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Amiri',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateGoal(int change) async {
    final newGoal = currentGoal!.goalPages + change;
    if (newGoal < 1) return;

    currentGoal!.goalPages = newGoal;
    await currentGoal!.save();
    setState(() {});
  }

  Future<void> _showAddProgressDialog() async {
    final controller = TextEditingController();

    await showModal(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'تسجيل قراءة جديدة',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'كم صفحة قرأت؟',
              style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Amiri')),
          ),
          ElevatedButton(
            onPressed: () {
              final pages = int.tryParse(controller.text) ?? 0;
              if (pages > 0) {
                _updateProgress(pages);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'حفظ',
              style: TextStyle(fontFamily: 'Amiri', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
