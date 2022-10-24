import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Date.dart';
import 'birthday_entry.dart';

class WidgetBirthdayEntry extends StatefulWidget {
  const WidgetBirthdayEntry({Key? key, required this.entry, required this.onLongPress}) : super(key: key);

  final BirthdayEntry entry;
  final GestureTapCallback onLongPress;

  @override
  State<WidgetBirthdayEntry> createState() => _WidgetBirthdayEntryState();
}

class _WidgetBirthdayEntryState extends State<WidgetBirthdayEntry> {
  final Map weekdays = {
    1: 'monday',
    2: 'tuesday',
    3: 'wednesday',
    4: 'thursday',
    5: 'friday',
    6: 'saturday',
    7: 'sunday',
  };

  @override
  Widget build(BuildContext context) {
    int daysToBirthday = Date.daysToBirthday(widget.entry.getDate());
    String weekday = weekdays[Date.now().add(Duration(days: daysToBirthday)).weekday];

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.entry.name),
                  daysToBirthday == 365 ? Text('Today is ${widget.entry.name}\'s birthday.') : Text('Next birthday in $daysToBirthday days.')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('dd. MMMM yyyy').format(widget.entry.getDate())),
                  daysToBirthday == 365 ? const Text('') : Text('on $weekday')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
