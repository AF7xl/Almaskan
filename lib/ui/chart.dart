import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialDashboard extends StatefulWidget {
  @override
  _FinancialDashboardState createState() => _FinancialDashboardState();
}

class _FinancialDashboardState extends State<FinancialDashboard> {
  int selectedYear = DateTime.now().year;
  int? selectedMonth; // null means all months
  final List<int> availableYears = [for (int y = 2025; y <= 2030; y++) y];
  final List<int> months = [for (int m = 1; m <= 12; m++) m];

  Map<int, MonthlyFinance> monthlyFinance = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await fetchFinancialData(selectedYear);
    setState(() {
      monthlyFinance = data;
    });
  }

  Future<Map<int, MonthlyFinance>> fetchFinancialData(int year) async {
    final firestore = FirebaseFirestore.instance;
    Map<int, MonthlyFinance> monthlyData = {
      for (int i = 1; i <= 12; i++) i: MonthlyFinance(i)
    };

    final sales = await firestore.collection('Sales').get();
    for (var doc in sales.docs) {
      final date = DateFormat('dd-MM-yyyy').parse(doc['Date']);
      if (date.year == year) {
        monthlyData[date.month]?.income += double.tryParse(doc['Total Amount']) ?? 0;
      }
    }

    final expenseSources = ['Vat Admin Expense', 'Vat Purchase'];
    for (var collection in expenseSources) {
      final expenses = await firestore.collection(collection).get();
      for (var doc in expenses.docs) {
        final date = DateFormat('dd-MM-yyyy').parse(doc['Date']);
        if (date.year == year) {
          monthlyData[date.month]?.expenses += double.tryParse(doc['Total Amount']) ?? 0;
        }
      }
    }

    return monthlyData;
  }

  double get filteredIncome {
    if (selectedMonth != null) return monthlyFinance[selectedMonth!]?.income ?? 0;
    return monthlyFinance.values.fold(0, (sum, m) => sum + m.income);
  }

  double get filteredExpenses {
    if (selectedMonth != null) return monthlyFinance[selectedMonth!]?.expenses ?? 0;
    return monthlyFinance.values.fold(0, (sum, m) => sum + m.expenses);
  }

  double get filteredProfit => filteredIncome - filteredExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Financial Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  items: availableYears
                      .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
                      .toList(),
                  onChanged: (year) {
                    if (year != null) {
                      setState(() {
                        selectedYear = year;
                        selectedMonth = null; // reset month
                      });
                      _loadData();
                    }
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<int?>(
                  value: selectedMonth,
                  hint: Text("All Months"),
                  items: [
                    DropdownMenuItem(value: null, child: Text("All Months")),
                    ...months.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(DateFormat.MMMM().format(DateTime(0, m))),
                    ))
                  ],
                  onChanged: (month) {
                    setState(() {
                      selectedMonth = month;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SummaryCard(
              totalIncome: filteredIncome,
              totalExpenses: filteredExpenses,
              totalProfit: filteredProfit,
              label: selectedMonth == null
                  ? 'Yearly Summary'
                  : DateFormat.MMMM().format(DateTime(0, selectedMonth!)) + ' Summary',
            ),
            const SizedBox(height: 16),
            if (selectedMonth == null)
              Expanded(child: buildChart(monthlyFinance))
            else
              Container(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Chart disabled in month view. Switch to 'All Months' to view full year.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildChart(Map<int, MonthlyFinance> data) {
    return BarChart(
      BarChartData(
        groupsSpace: 12,
        barGroups: data.entries.map((entry) {
          final month = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(toY: value.income, color: Colors.blue, width: 8),
              BarChartRodData(toY: value.expenses, color: Colors.orange, width: 8),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final name = DateFormat.MMM().format(DateTime(0, value.toInt()));
                return Text(name, style: TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),

      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final double totalProfit;
  final String label;

  const SummaryCard({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalProfit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    TextStyle valueStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Text("Income", style: labelStyle),
                Text("₹${totalIncome.toStringAsFixed(2)}", style: valueStyle),
              ]),
              Column(children: [
                Text("Expenses", style: labelStyle),
                Text("₹${totalExpenses.toStringAsFixed(2)}", style: valueStyle),
              ]),
              Column(children: [
                Text("Profit", style: labelStyle),
                Text("₹${totalProfit.toStringAsFixed(2)}", style: valueStyle),
              ]),
            ],
          ),
        ]),
      ),
    );
  }
}

class MonthlyFinance {
  final int month;
  double income = 0;
  double expenses = 0;

  MonthlyFinance(this.month);

  double get profit => income - expenses;
}
