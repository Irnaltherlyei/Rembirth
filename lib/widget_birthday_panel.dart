import 'package:flutter/material.dart';
import 'package:hello_flutter/birthday_entry.dart';
import 'package:hello_flutter/date.dart';

class WidgetBirthdayPanel extends StatefulWidget {
  const WidgetBirthdayPanel({Key? key, required this.entry}) : super(key: key);

  final BirthdayEntry entry;

  @override
  State<WidgetBirthdayPanel> createState() => _WidgetBirthdayPanelState();
}

class _WidgetBirthdayPanelState extends State<WidgetBirthdayPanel> {
  @override
  Widget build(BuildContext context) {
    String name = widget.entry.name;
    int age = Date.calculateAge(widget.entry.getDate());
    
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
