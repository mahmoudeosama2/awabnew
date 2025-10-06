import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/tasbeeh_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TasbeehTrackerPage extends StatefulWidget {
  const TasbeehTrackerPage({super.key});

  @override
  State<TasbeehTrackerPage> createState() => _TasbeehTrackerPageState();
}

class _TasbeehTrackerPageState extends State<TasbeehTrackerPage>
    with TickerProviderStateMixin {
  late Box<TasbeehSession> sessionBox;
  late Box<TasbeehStats> statsBox;
  TasbeehStats? stats;
  int currentCount = 0;
  String selectedZekr = 'سبحان الله';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> azkar = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'استغفر الله',
    'لا حول ولا قوة إلا بالله',
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    sessionBox = await Hive.openBox<TasbeehSession>('tasbeeh_sessions');
    statsBox = await Hive.openBox<TasbeehStats>('tasbeeh_stats');

    if (statsBox.isEmpty) {
      final newStats = TasbeehStats();
      await statsBox.add(newStats);
    }

    setState(() {
      stats = statsBox.values.first;
    });
  }

  void _incrementCount() {
    setState(() {
      currentCount++;
    });

    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  Future<void> _saveSession() async {
    if (currentCount == 0) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final timestamp = DateTime.now().toIso8601String();

    final session = TasbeehSession(
      id: const Uuid().v4(),
      date: today,
      count: currentCount,
      zekrType: selectedZekr,
      timestamp: timestamp,
    );

    await sessionBox.add(session);

    stats!.totalCount += currentCount;
    stats!.dailyStats[today] = (stats!.dailyStats[today] ?? 0) + currentCount;

    await stats!.save();

    setState(() {
      currentCount = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ التسبيح بنجاح ✨',
          style: const TextStyle(fontFamily: 'Amiri'),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'خريطة التسبيح 📿',
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
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'التسبيح'),
                    Tab(text: 'الإحصائيات'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildTasbeehTab(),
              _buildStatsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasbeehTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildZekrSelector(),
          const SizedBox(height: 24),
          _buildTasbeehCounter(),
          const SizedBox(height: 24),
          _buildActionButtons(),
          const SizedBox(height: 24),
          _buildTodayProgress(),
        ],
      ),
    );
  }

  Widget _buildZekrSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر الذكر:',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: azkar.map((zekr) {
                final isSelected = selectedZekr == zekr;
                return ChoiceChip(
                  label: Text(
                    zekr,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedZekr = zekr;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey.shade200,
                  elevation: isSelected ? 4 : 0,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbeehCounter() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              selectedZekr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _incrementCount,
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$currentCount',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'اضغط على الدائرة للتسبيح',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: currentCount > 0
                ? () {
                    setState(() {
                      currentCount = 0;
                    });
                  }
                : null,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'إعادة ضبط',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: currentCount > 0 ? _saveSession : null,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'حفظ',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayProgress() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayCount = stats!.dailyStats[today] ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'تسبيح اليوم',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 500,
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: todayCount.toDouble(),
                        color: Theme.of(context).primaryColor,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                    ],
                    pointers: [
                      NeedlePointer(
                        value: todayCount.toDouble(),
                        enableAnimation: true,
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: Text(
                          '$todayCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTotalStatsCard(),
          const SizedBox(height: 16),
          _buildWeeklyChartCard(),
          const SizedBox(height: 16),
          _buildRecentSessionsCard(),
        ],
      ),
    );
  }

  Widget _buildTotalStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'إجمالي التسبيحات',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${stats!.totalCount}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'تسبيحة',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: Colors.white70,
              ),
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
      return stats!.dailyStats[date] ?? 0;
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
              'التسبيح خلال الأسبوع',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        return FlSpot(
                            entry.key.toDouble(), entry.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessionsCard() {
    final recentSessions = sessionBox.values.toList().reversed.take(5).toList();

    if (recentSessions.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Text(
              'لا توجد جلسات محفوظة بعد',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'آخر الجلسات',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...recentSessions.map((session) {
              final date = DateTime.parse(session.timestamp);
              final formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                title: Text(
                  session.zekrType,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${session.count}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
