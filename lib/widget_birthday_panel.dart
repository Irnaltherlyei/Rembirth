import 'package:flutter/material.dart';

import 'birthday_entry.dart';
import 'date.dart';

/// Widget displaying a screen congratulating to
/// someone's birthday when a notification gets clicked on.
class WidgetBirthdayPanel extends StatefulWidget {
  const WidgetBirthdayPanel({Key? key, required this.entry}) : super(key: key);

  /// Takes in a birthday entry fetches its data and displays it to the screen.
  final BirthdayEntry entry;

  @override
  State<WidgetBirthdayPanel> createState() => _WidgetBirthdayPanelState();
}

class _WidgetBirthdayPanelState extends State<WidgetBirthdayPanel> {
  @override
  Widget build(BuildContext context) {
    /// Fetch data from entry
    String name = widget.entry.name;
    /// And calculate age in years.
    int age = Date.calculateAge(widget.entry.getDate());

    /// Design
    return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Column(
          children: [
            Text('Happy birthday to $name.'),
            Text('$name just turned $age years old.'),
            Text('Congratulate $name on his/her birthday.'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
    );
  }
}
