import 'package:expence_manager/widgets/chart_bar.dart';
import 'package:intl/intl.dart';
import '../../models/Transactions.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  List<Transactions> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> groupedTransactionValues() {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].dateTime.day == weekDay.day &&
            recentTransactions[i].dateTime.month == weekDay.month &&
            recentTransactions[i].dateTime.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues().map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'].toString(),
                data['amount'] as double,
                totalSpending == 0.00
                    ? 0.00
                    : (data['amount'] as double) / totalSpending,
                  totalSpending
              ),
            );
          }).toList()),
    );
  }

  double get totalSpending {
    return groupedTransactionValues().fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }
}
