import 'package:expense_manager/database.dart'; // Replace with your actual database import
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const contentColorYellow = Colors.yellow;
  static const contentColorOrange = Colors.orange;
}

extension ColorUtils on Color {
  Color avg(Color other) {
    return Color.fromARGB(
      (alpha + other.alpha) ~/ 2,
      (red + other.red) ~/ 2,
      (green + other.green) ~/ 2,
      (blue + other.blue) ~/ 2,
    );
  }
}

class BarChartScreen extends StatefulWidget {
  BarChartScreen({super.key});

  final Color leftBarColor = AppColors.contentColorYellow;

  @override
  State<StatefulWidget> createState() => BarChartScreenState();
}

class BarChartScreenState extends State<BarChartScreen> {
  final double width = 10; // Width of the bars in the chart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(width: 38),
                Text(
                  'Transactions',
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
            const SizedBox(height: 38),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchLast7DaysData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.quicksand(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final barGroups = data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final amount = (entry.value['amount'] as double);
                      return makeGroupData(index, amount, 0);
                    }).toList();

                    return BarChart(
                      BarChartData(
                        maxY: 5000,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${data[group.x.toInt()]['amount']}',
                                GoogleFonts.quicksand(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
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
                                final dayName = data[value.toInt()]['day'];
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: Text(
                                    dayName,
                                    style: GoogleFonts.quicksand(
                                      color: const Color(0xff7589a2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1000,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                        gridData: const FlGridData(show: false),
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'No data available',
                      style: GoogleFonts.quicksand(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: GoogleFonts.quicksand(
        color: const Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: width, height: 10, color: Colors.white.withOpacity(0.4)),
        const SizedBox(width: space),
        Container(width: width, height: 28, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: space),
        Container(width: width, height: 42, color: Colors.white.withOpacity(1)),
        const SizedBox(width: space),
        Container(width: width, height: 28, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: space),
        Container(width: width, height: 10, color: Colors.white.withOpacity(0.4)),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> fetchLast7DaysData() async {
  try {
    final transactions = await fetchTransactions();
    final Map<String, double> dailyTotals = {
      'Sun': 0.0,
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
    };

    for (var transaction in transactions) {
      DateTime timestamp = DateTime.parse(transaction["timestamp"]);
      String fullDayName = DateFormat('EEEE').format(timestamp);
      String shortDayName;

      switch (fullDayName) {
        case 'Sunday':
          shortDayName = 'Sun';
          break;
        case 'Monday':
          shortDayName = 'Mon';
          break;
        case 'Tuesday':
          shortDayName = 'Tue';
          break;
        case 'Wednesday':
          shortDayName = 'Wed';
          break;
        case 'Thursday':
          shortDayName = 'Thu';
          break;
        case 'Friday':
          shortDayName = 'Fri';
          break;
        case 'Saturday':
          shortDayName = 'Sat';
          break;
        default:
          continue;
      }

      dailyTotals[shortDayName] = (dailyTotals[shortDayName] ?? 0) + (transaction["amount"] as double);
    }

    return dailyTotals.entries.map((entry) {
      return {
        'day': entry.key,
        'amount': entry.value,
      };
    }).toList();
  } catch (e) {
    print('Error fetching data: $e');
    return List.generate(7, (index) {
      return {
        'day': getDayName(index),
        'amount': 0.0,
      };
    });
  }
}

String getDayName(int index) {
  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return days[index];
}
