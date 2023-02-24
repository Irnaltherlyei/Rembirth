import 'package:flutter/material.dart';

import 'widget_birthday_page.dart';

/// Main class. App starts from here.
void main() {
  runApp(const Rembirth());
}

/// Main app framework
class Rembirth extends StatelessWidget {
  const Rembirth({Key? key}) : super(key: key);

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

/**
 * Following represents the hierarchy in which the different components depend on each other.
 *
 * 1. Main                                               -> Main starting point for the app
 *    1. widget_birthday_page                            -> Main screen. List for birthday entries
 *        1. widget_birthday_panel                       -> On notification click. Show panel indicating someone's birthday
 *            1. birthday_entry
 *            2. date
 *        2. widget_birthday_entry                       -> Single list element representing a birthday entry
 *            1. birthday_entry
 *            2. date
 *        3. widget_birthday_input                       -> Frontend for creating new birthday entries
 *            1. birthday_entry
 *            2. date
 *        4. birthday_entry                              -> Object holding data for a single birthday entry
 *        5. date                                        -> Helper class with static functions for dates
 *        6. notifications                               -> Helper class for managing android notifications only
 *            1. date
 *        7. persistence                                 -> Helper class managing persistence
 *            1. birthday_entry
 */
