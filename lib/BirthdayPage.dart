import 'package:flutter/material.dart';
import 'package:hello_flutter/BirthdayInput.dart';

import 'BirthdayEntry.dart';
import 'Entry.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({Key? key}) : super(key: key);

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage>{

  Entry? selected;

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
                      child: BirthdayEntry(
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
    final Entry entry = await Navigator.push(
        context,
        DialogRoute(builder: (context) => const BirthdayInput(), context: context),
    );

    if(!mounted) return;

    addBirthdayEntry(entry);
  }

  Future<void> _editEntry(BuildContext context, Entry selected) async{
    final Entry entry = await Navigator.push(
      context,
      DialogRoute(builder: (context) => BirthdayInput(entry: selected), context: context),
    );

    if(!mounted) return;

    editBirthdayEntry(selected, entry);
  }

  final List<Entry> birthdayEntries = [
    Entry(name: 'Adrian', date: DateTime(2000,8,6).toString()),
    Entry(name: 'Ann-Kathrin', date: DateTime(1998,3,5).toString()),
  ];

  bool validateBirthdayEntry(Entry entry){
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

  void deleteBirthdayEntry(Entry entry){
    setState(() {
      birthdayEntries.removeWhere((element) => element.name == entry.name && DateUtils.isSameDay(element.getDate(), entry.getDate()));
    });
  }

  void addBirthdayEntry(Entry entry) {
    setState(() {
      if(validateBirthdayEntry(entry)) {
        birthdayEntries.add(entry);
      }
    });
  }

  void editBirthdayEntry(Entry selected, Entry entry){
    setState(() {
      int index = birthdayEntries.indexWhere((element) => element.name == selected.name && DateUtils.isSameDay(element.getDate(), selected.getDate()));
      birthdayEntries[index] = entry;
    });
  }
}