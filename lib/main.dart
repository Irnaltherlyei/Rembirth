import 'package:flutter/material.dart';

import 'widget_birthday_page.dart';

void main()async {
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
      home: const WidgetBirthdayPage(),
    );
  }
}


