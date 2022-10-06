import 'package:flutter/material.dart';

import 'BirthdayPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remember every birthday',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const BirthdayPage(),
    );
  }
}


