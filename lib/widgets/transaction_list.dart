import 'package:flutter/material.dart';
import '../../models/Transactions.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactionList;

  final Function deleteTransaction;

  const TransactionList(this.transactionList, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return transactionList.isEmpty
        ? Column(
            children: [
              const Text('No Transaction added yet'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/price-list.png',
                    fit: BoxFit.cover,
                  ))
            ],
          )
        : ListView.builder(
            itemCount: transactionList.length,
            itemBuilder: (ctx, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                elevation: 6,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: FittedBox(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          '\$ ${transactionList[index].amount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                  ),
                  title: Text(
                    transactionList[index].tittle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    DateFormat('MMM d, yyyy  hh:mm aa')
                        .format(transactionList[index].dateTime),
                    // DateFormat.yMMMd().format(transactionList[index].dateTime),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () =>
                        deleteTransaction(transactionList[index].id),
                  ),
                ),
              );
            },
          );
  }
}
