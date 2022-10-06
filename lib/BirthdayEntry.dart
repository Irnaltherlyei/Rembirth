import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Entry.dart';

class BirthdayEntry extends StatefulWidget {
  const BirthdayEntry({Key? key, required this.entry, required this.onLongPress}) : super(key: key);

  final Entry entry;
  final GestureTapCallback onLongPress;

  @override
  State<BirthdayEntry> createState() => _BirthdayEntryState();
}

class _BirthdayEntryState extends State<BirthdayEntry> {

  int _daysToBirthday(DateTime birthday){
    DateTime from = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime to = DateTime(DateTime.now().year, birthday.month, birthday.day);
    return to.difference(from).inDays < 0 ? DateTime(DateTime.now().year + 1, birthday.month, birthday.day).difference(from).inDays : to.difference(from).inDays;
  }

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
              Text('Next birthday in ${_daysToBirthday(widget.entry.getDate())} days.')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd. MMMM yyyy').format(widget.entry.getDate())),
              Text('on ${weekdays[DateTime.now().add(Duration(days: _daysToBirthday(widget.entry.getDate()))).weekday]}'),
            ],
          )
        ],
      ),
    );
  }
}
