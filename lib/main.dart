import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Transactions.dart';
import '../widgets/new_transactions.dart';
import '../widgets/transaction_list.dart';
import 'package:expence_manager/widgets/chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            toolbarTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
      home: const _MyHomePage(title: 'Expense Tracker'),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final List<Transactions> _transactionList = [];

  bool _showChart = false;

  List<Transactions> get _recentTransactions {
    return _transactionList.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txName, double txAmount, DateTime selectedDate) {
    final transaction = Transactions(
        DateTime.now().toString(), txName, txAmount, selectedDate);
    setState(() {
      _transactionList.add(transaction);
      Navigator.pop(context);
    });
  }

  void _deleteTransaction(String id) {
    setState(() => _transactionList.removeWhere((element) => element.id == id));
  }

  void _showAddTransactionBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return NewTransactions(_addNewTransaction);
        });
  }

  PreferredSizeWidget _prepareAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
        middle: const Text("Personal Expenses"),
        trailing: GestureDetector(
          onTap: () => {_showAddTransactionBottomSheet(context)},
          child: const Icon(Icons.add),
        )) as PreferredSizeWidget
        : AppBar(
      title: const Text("Personal Expenses"),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {_showAddTransactionBottomSheet(context)})
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appbar = _prepareAppBar();
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget transactionWidget = SizedBox(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.8,
        child: TransactionList(_transactionList, _deleteTransaction));

    List<Widget> _buildLandscepeContent(Widget transactionWidget) {
      return [
        Switch.adaptive(
            activeColor: Theme.of(context).primaryColor,
            value: _showChart,
            onChanged: (value) => {
                  setState(() {
                    _showChart = value;
                  })
                }),
        _showChart
            ? SizedBox(
                height: (MediaQuery.of(context).size.height -
                        appbar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.4,
                child: Chart(_recentTransactions))
            : transactionWidget
      ];
    }

    List<Widget> _buildPortraintContent(Widget transactionWidget) {
      return [
        SizedBox(
            height: (MediaQuery.of(context).size.height -
                    appbar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                0.3,
            child: Chart(_recentTransactions)),
        transactionWidget
      ];
    }

    return Scaffold(
        appBar: appbar,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isAndroid
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  _showAddTransactionBottomSheet(context);
                },
              )
            : null,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape) ..._buildLandscepeContent(transactionWidget),
              if (!isLandscape) ..._buildPortraintContent(transactionWidget),
            ],
          )),
        ));
  }
}
