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
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.entry.name),
              Text('Next birthday in ${Date.daysToBirthday(widget.entry.getDate())} days.')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd. MMMM yyyy').format(widget.entry.getDate())),
              Text('on ${weekdays[Date.now().add(Duration(days: Date.daysToBirthday(widget.entry.getDate()))).weekday]}'),
            ],
          )
        ],
      ),
    );
  }
}
