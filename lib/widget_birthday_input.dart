import 'package:flutter/material.dart';
import 'package:hello_flutter/Date.dart';
import 'package:hello_flutter/birthday_entry.dart';

class WidgetBirthdayInput extends StatefulWidget {
  const WidgetBirthdayInput({Key? key, this.entry}) : super(key: key);

  final BirthdayEntry? entry;

  @override
  State<WidgetBirthdayInput> createState() => _WidgetBirthdayInputState();
}

class _WidgetBirthdayInputState extends State<WidgetBirthdayInput> {

  DateTime selectedDate = Date.now();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.entry != null ? widget.entry!.name : '';
    selectedDate = widget.entry != null ? widget.entry!.getDate() : selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter a name',
                ),
              ),
              const SizedBox(height: 32),
              const Text('Birthdate', style: TextStyle(color: Color.fromARGB(160, 30, 30, 30)),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Text('${"${selectedDate.toLocal()}".split('-')[0]}-'),
                    onTap: () => _getYear(context),
                  ),
                  InkWell(
                    child: Text('${"${selectedDate.toLocal()}".split('-')[1]}-'),
                    onTap: () => _getMonth(context),
                  ),
                  InkWell(
                    child: Text("${selectedDate.toLocal()}".split('-')[2].split(' ')[0]),
                    onTap: () => _getDay(context, selectedDate),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 2,),
              ElevatedButton(
                onPressed: () => _getYear(context),
                child: const Text('Select birthday'),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context, BirthdayEntry(name: nameController.text, date: selectedDate.toString()));
                    },
                    child: const Icon(Icons.check),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getDay(BuildContext context, DateTime currentDate) async{
    final int result = await Navigator.push(
      context,
      DialogRoute(builder: (context) => DayPicker(month: selectedDate.month, year: selectedDate.year,), context: context),
    );

    if(!mounted) return;

    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, result);
    });
  }

  Future<void> _getMonth(BuildContext context) async{
    final int result = await Navigator.push(
      context,
      DialogRoute(builder: (context) => const MonthPicker(), context: context),
    );

    if(!mounted) return;

    setState(() {
      selectedDate = DateTime(selectedDate.year, result, selectedDate.day);
    });

    _getDay(context, selectedDate);
  }

  Future<void> _getYear(BuildContext context) async{
    final int result = await Navigator.push(
      context,
      DialogRoute(builder: (context) => YearPicker(initialYear: 1900, endYear: Date.now().year), context: context),
    );

    if(!mounted) return;

    setState(() {
      selectedDate = DateTime(result, selectedDate.month, selectedDate.day);
    });

    _getMonth(context);
  }
}

class DayPicker extends StatefulWidget {

  final int month;
  final int year;

  DayPicker({Key? key, required this.month, this.year = 2000}) : super(key: key);

  @override
  State<DayPicker> createState() => _DayPicker();
}

List weekdays = <String>['Mon','Tue','Wed','Thu','Fri','Sat','Sun',];

class _DayPicker extends State<DayPicker> {

  @override
  Widget build(BuildContext context) {
    int firstDayOffset = DateUtils.firstDayOffset(widget.year, widget.month, const DefaultMaterialLocalizations()) - 1;
    int daysPerWeek = DateTime.daysPerWeek;

    if(firstDayOffset < 0){
      firstDayOffset = daysPerWeek + firstDayOffset;
    }

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
        child: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: daysPerWeek,
              ),
              itemCount: DateUtils.getDaysInMonth(widget.year, widget.month) + daysPerWeek + firstDayOffset,
              itemBuilder: (context, index) {
                if(index < daysPerWeek){
                  return Center(child: Text(weekdays[index]));
                } else if(index < daysPerWeek + firstDayOffset) {
                  return const SizedBox.shrink();
                } else {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, index + 1 - daysPerWeek - firstDayOffset);
                    },
                    child: Card(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        child: Center(
                            child: Text((index + 1 - daysPerWeek - firstDayOffset).toString())
                        )
                    ),
                  );
                }
              }
          ),
        ),
      ),
    );
  }
}

class MonthPicker extends StatefulWidget {
  const MonthPicker({Key? key}) : super(key: key);

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

Map months = {
  DateTime.january: 'january',
  DateTime.february: 'february',
  DateTime.march: 'march',
  DateTime.april: 'april',
  DateTime.may: 'may',
  DateTime.june: 'june',
  DateTime.july: 'july',
  DateTime.august: 'august',
  DateTime.september: 'september',
  DateTime.october: 'october',
  DateTime.november: 'november',
  DateTime.december: 'december',
};

class _MonthPickerState extends State<MonthPicker> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
        child: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, index + 1);
                  },
                  child: Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(child: Text(months[index + 1])),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}

class YearPicker extends StatefulWidget {

  final int initialYear;
  final int endYear;

  YearPicker({Key? key, this.initialYear = 1950, this.endYear = 2050}) : super(key: key);

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: widget.endYear - widget.initialYear + 1,
                itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pop(context, widget.endYear - index);
                        },
                        child: Card(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          child: SizedBox(
                              height: 100,
                              width: 200,
                              child: Center(child: Text((widget.endYear - index).toString()))
                          ),
                        ),
                      );
                  }
            ),
          ),
        ),
    );
  }
}