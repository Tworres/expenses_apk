import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart(this._recentTransactions, {super.key});

  List<Map<String, Object>> get weeks {
    return List.generate(7, (index) {
      DateTime weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;
      for (var tr in _recentTransactions) {
        bool isSameDay = tr.date.day == weekDay.day;
        bool isSameMonth = tr.date.month == weekDay.month;
        bool isSameYear = tr.date.year == weekDay.year;

        if (isSameDay && isSameMonth && isSameYear) {
          totalSum += tr.value;
        }
      }

      return {'day': DateFormat.E().format(weekDay)[0], 'value': totalSum};
    }).reversed.toList();
  }

  double get weekTotalSum {
    return _recentTransactions.fold(0.0, (sum, tr) {
      return sum + tr.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    weeks;

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weeks.map((tr) {
            return Expanded(
              child: ChartBar(
                label: tr['day'].toString(),
                value: double.parse(tr['value'].toString()),
                percentage: weekTotalSum > 0 ? double.parse(tr['value'].toString()) / weekTotalSum : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
