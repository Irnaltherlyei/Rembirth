import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'birthday_entry.dart';
import 'Date.dart';

/// Single element representing a birthday entry. Are placed in a list to be displayed on the main page.
/// Is a widget.
class WidgetBirthdayEntry extends StatefulWidget {
  const WidgetBirthdayEntry({Key? key, required this.entry, required this.onLongPress, required this.onTap}) : super(key: key);

  /// Birthday entry data
  final BirthdayEntry entry;

  /// Gesture calls.
  final GestureTapCallback onLongPress;
  final GestureTapCallback onTap;

  @override
  State<WidgetBirthdayEntry> createState() => _WidgetBirthdayEntryState();
}

class _WidgetBirthdayEntryState extends State<WidgetBirthdayEntry> {
  /// Mapping numbers to weekdays used to display weekdays as strings.
  /// Needed because DateTime .weekday returns a number.
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
    /// Calculating days to birthday to be displayed.
    int daysToBirthday = Date.daysToBirthday(widget.entry.getDate());
    /// Calculating weekday the birthday falls on to be displayed on screen.
    String weekday = weekdays[Date.now().add(Duration(days: daysToBirthday)).weekday];

    /// Design
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
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
