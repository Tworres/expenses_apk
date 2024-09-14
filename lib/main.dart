import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';

main() => runApp(ExpansesApp());

class ExpansesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          headlineLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: MediaQuery.textScalerOf(context).scale(18),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: MediaQuery.textScalerOf(context).scale(20),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(id: 't1', title: 'conta #1', value: 310.76, date: DateTime.now()),
    // Transaction(id: 't1', title: 'conta #1', value: 310.76, date: DateTime.now().subtract(Duration(days: 5))),
    // Transaction(id: 't1', title: 'conta #1', value: 310.76, date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(id: 't2', title: 'conta #2', value: 110.76, date: DateTime.now()),
    // Transaction(id: 't3', title: 'conta #3', value: 110.76, date: DateTime.now()),
    // Transaction(id: 't4', title: 'conta #4', value: 110.76, date: DateTime.now()),
    // Transaction(id: 't5', title: 'conta #5', value: 110.76, date: DateTime.now()),
    // Transaction(id: 't6', title: 'conta #6', value: 110.76, date: DateTime.now()),
    // Transaction(id: 't7', title: 'conta #7', value: 110.76, date: DateTime.now()),
    // Transaction(id: 't8', title: 'conta #8', value: 110.76, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      DateTime startOfWeek = DateTime.now().subtract(Duration(days: 8));
      return tr.date.isAfter(startOfWeek);
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(id: Random().nextDouble().toString(), title: title, value: value, date: date);

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text("Despesas Pessoais"),
      actions: [
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: Icon(Icons.add),
        ),
      ],
    );

    final _mediaQuery = MediaQuery.of(context);
    final _availableHeight = _mediaQuery.size.height - _appBar.preferredSize.height - _mediaQuery.padding.top;
    final _isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLandScape)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text('Exibir Gráfico'),
                    Switch(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (_showChart || !_isLandScape)
              SizedBox(
                height: _isLandScape ? _availableHeight * .6 : _availableHeight * 0.2,
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !_isLandScape)
              SizedBox(
                height: _availableHeight * 0.8,
                child: TransactionList(_recentTransactions, _removeTransaction),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
