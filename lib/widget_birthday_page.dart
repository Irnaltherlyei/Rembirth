import 'package:flutter/material.dart';
import 'package:hello_flutter/widget_birthday_input.dart';

import 'widget_birthday_entry.dart';
import 'birthday_entry.dart';

class WidgetBirthdayPage extends StatefulWidget {
  const WidgetBirthdayPage({Key? key}) : super(key: key);

  @override
  State<WidgetBirthdayPage> createState() => _WidgetBirthdayPageState();
}

class _WidgetBirthdayPageState extends State<WidgetBirthdayPage>{

  BirthdayEntry? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails details){
          setState((){
            selected = null;
          });
        },
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: birthdayEntries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: WidgetBirthdayEntry(
                        entry: birthdayEntries[index],
                        onLongPress: () {
                          setState(() {
                            selected = birthdayEntries[index];
                          });
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selected != null ? FloatingActionButton(
              onPressed: () {
                _editEntry(context, selected!);
              },
              tooltip: 'Edit',
              child: const Icon(Icons.edit),
            ) : Container(),
            selected != null ? FloatingActionButton(
              onPressed: () {
                deleteBirthdayEntry(selected!);
                selected = null;
              },
              tooltip: 'Delete',
              child: const Icon(Icons.delete),
            ) : Container(),
            selected == null ? FloatingActionButton(
              onPressed: () {
                _addEntry(context);
              },
              tooltip: 'Add',
              child: const Icon(Icons.add),
            ) :  FloatingActionButton(
              onPressed: () {
                setState(() {
                  selected = null;
                });
              },
              tooltip: 'Cancel',
              child: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addEntry(BuildContext context) async{
    final BirthdayEntry entry = await Navigator.push(
        context,
        DialogRoute(builder: (context) => const WidgetBirthdayInput(), context: context),
    );

    if(!mounted) return;

    addBirthdayEntry(entry);
  }

  Future<void> _editEntry(BuildContext context, BirthdayEntry selected) async{
    final BirthdayEntry entry = await Navigator.push(
      context,
      DialogRoute(builder: (context) => WidgetBirthdayInput(entry: selected), context: context),
    );

    if(!mounted) return;

    editBirthdayEntry(selected, entry);
  }

  final List<BirthdayEntry> birthdayEntries = [
    BirthdayEntry(name: 'Adrian', date: DateTime(2000,8,6).toString()),
    BirthdayEntry(name: 'Ann-Kathrin', date: DateTime(1999,3,5).toString()),
  ];

  bool validateBirthdayEntry(BirthdayEntry entry){
    // Birthday entry can't exist already.
    if(birthdayEntries.any((element) => element.name == entry.name && DateUtils.isSameDay(element.getDate(), entry.getDate()))){
      return false;
    }
    // Name can't be blank.
    if(entry.name.isEmpty){
      return false;
    }
    // Name has less than 32 characters.
    if(entry.name.length > 32){
      return false;
    }
    return true;
  }

  void deleteBirthdayEntry(BirthdayEntry entry){
    setState(() {
      birthdayEntries.removeWhere((element) => element.name == entry.name && DateUtils.isSameDay(element.getDate(), entry.getDate()));
    });
  }

  void addBirthdayEntry(BirthdayEntry entry) {
    setState(() {
      if(validateBirthdayEntry(entry)) {
        birthdayEntries.add(entry);
      }
    });
  }

  void editBirthdayEntry(BirthdayEntry selected, BirthdayEntry entry){
    setState(() {
      int index = birthdayEntries.indexWhere((element) => element.name == selected.name && DateUtils.isSameDay(element.getDate(), selected.getDate()));
      birthdayEntries[index] = entry;
    });
  }
}