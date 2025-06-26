import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Sales {
  final int saleYear;
  final double saleVal;
  final String colorVal;

  Sales({
    required this.saleYear,
    required this.saleVal,
    required this.colorVal,
  });

  factory Sales.fromMap(Map<String, dynamic> map) {
    if (map['saleYear'] == null ||
        map['saleVal'] == null ||
        map['colorVal'] == null) {
      throw Exception('Missing field in sales document: $map');
    }
    return Sales(
      saleYear:
          map['saleYear'] is int
              ? map['saleYear']
              : int.tryParse(map['saleYear'].toString()) ?? 0,
      saleVal: (map['saleVal'] as num).toDouble(),
      colorVal: map['colorVal'].toString(),
    );
  }
}

class Task {
  final String taskdetails;
  final double taskVal;
  final String colorVal;

  Task({
    required this.taskdetails,
    required this.taskVal,
    required this.colorVal,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskdetails: map['taskdetails'],
      taskVal: (map['taskVal'] as num).toDouble(),
      colorVal: map['colorVal'],
    );
  }
}

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  // Helper widget for the legend
  Widget buildLegendHorizontal(List<Color> colors, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(colors.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                color: colors[i],
              ),
              SizedBox(width: 8),
              Text(
                labels[i],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sales Chart
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('sales').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                List<Sales> sales = snapshot.data!.docs
                    .map((doc) => Sales.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();
                if (sales.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No sales data available'),
                  );
                }

                // Prepare legend data for sales
                final salesColors = sales.map((s) => Color(int.parse(s.colorVal))).toList();
                final salesLabels = sales.map((s) => s.saleYear.toString()).toList();

                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Sales by Year',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      buildLegendHorizontal(salesColors, salesLabels), // <-- Legend for sales
                      SizedBox(height: 10.0),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY:
                                sales
                                    .map((e) => e.saleVal)
                                    .reduce((a, b) => a > b ? a : b) +
                                10,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (
                                    double value,
                                    TitleMeta meta,
                                  ) {
                                    int idx = value.toInt();
                                    if (idx < 0 || idx >= sales.length)
                                      return Container();
                                    return Text('${sales[idx].saleYear}');
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(sales.length, (i) {
                              final s = sales[i];
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: s.saleVal,
                                    color: Color(int.parse(s.colorVal)),
                                    width: 22,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }),
                          ),
                          swapAnimationDuration: Duration(seconds: 1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(height: 32, thickness: 2),
            // Tasks Chart
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('task').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                List<Task> tasks = snapshot.data!.docs
                    .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();
                if (tasks.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No task data available'),
                  );
                }

                // Prepare legend data for tasks
                final taskColors = tasks.map((t) => Color(int.parse(t.colorVal))).toList();
                final taskLabels = tasks.map((t) => t.taskdetails).toList();

                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Time spent on daily tasks',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      buildLegendHorizontal(taskColors, taskLabels), // <-- Legend for tasks
                      SizedBox(height: 10.0),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: List.generate(tasks.length, (i) {
                              final task = tasks[i];
                              return PieChartSectionData(
                                color: Color(int.parse(task.colorVal)),
                                value: task.taskVal,
                                title: '${task.taskdetails}\n${task.taskVal}',
                                radius: 80,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                          swapAnimationDuration: Duration(seconds: 1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
