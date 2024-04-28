import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  '10.16.65.106', 
  5432,
  'sensea', 
  username: 'postgres',
  password: 'Puvisk09!', 
);
initdbConnection() async {
  connection.open().then((value) {
    debugPrint("Database Connected!");
  });
}


