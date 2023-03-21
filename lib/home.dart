import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:personal_expenses_app1/widgets/chart.dart';
import 'package:personal_expenses_app1/widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'models/transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _usertransations = [
    Transaction(
      'T1',
      'Shoes',
      69.51,
      DateTime.now(),
    ),
    Transaction(
      'T2',
      'Watch',
      98.54,
      DateTime.now(),
    ),
  ];
  bool _showchart = false;

  List<Transaction> get _recentTransactions {
    return _usertransations.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      DateTime.now().toString(),
      txTitle.toString(),
      txAmount,
      chosenDate,
    );
    setState(() {
      _usertransations.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransactions(String id) {
    setState(() {
      _usertransations.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget TxListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Show Chart"),
          Switch(
              value: _showchart,
              onChanged: (val) {
                setState(() {
                  _showchart = val;
                });
              }),
        ],
      ),
      _showchart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : TxListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget TxListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      TxListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: const Icon(Icons.add_circle_outline))
      ],
      title: const Text(
        "Personal Expenses",
        style: TextStyle(
          fontFamily: 'Open Sans',
        ),
      ),
    );
    final TxListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.6,
      child: TransactionList(_usertransations, _deleteTransactions),
    );
    final dataBody = SingleChildScrollView(
      child: Column(
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(
              mediaQuery,
              appBar,
              TxListWidget,
            ),
          if (!isLandscape)
            ..._buildPotraitContent(
              mediaQuery,
              appBar,
              TxListWidget,
            ),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: dataBody,
          )
        : Scaffold(
            appBar: appBar,
            body: dataBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: const Icon(
                      Icons.add_circle_outline,
                      size: 50,
                    ),
                  ),
          );
  }
}

// video 87;
