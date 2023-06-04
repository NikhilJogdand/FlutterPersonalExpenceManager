import 'package:flutter/foundation.dart';

class Transactions {
  @required final String id;
  @required final String tittle;
  @required final double amount;
  @required final DateTime dateTime;

  Transactions(this.id, this.tittle, this.amount, this.dateTime);
}