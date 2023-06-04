import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactions extends StatefulWidget {
  final Function addNewTransaction;

  NewTransactions(this.addNewTransaction);

  @override
  State<NewTransactions> createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    double amount = double.parse(_amountController.text);
    if (_titleController.text.isEmpty || amount <= 0) {
      return;
    }
    widget.addNewTransaction(_titleController.text, amount, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(2),
      child: Card(
        color: Colors.yellow,
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                controller: _titleController,
                keyboardType: TextInputType.name,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                textInputAction: TextInputAction.done,
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? "No Date Chosen!"
                        : "Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}"),
                  ),
                  MaterialButton(
                    onPressed: _showDatePicker,
                    elevation: 6,
                    textColor: Theme.of(context).textTheme.button?.color,
                    child: const Text(
                      "Chose Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: _submitData,
                  child: const Text(
                    "Add Transaction",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now())
        .then((value) => {
              setState(() {
                _selectedDate = value;
              })
            });
  }
}
