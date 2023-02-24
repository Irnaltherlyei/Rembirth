import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'widget_birthday_panel.dart';
import 'widget_birthday_entry.dart';
import 'widget_birthday_input.dart';

import 'birthday_entry.dart';
import 'date.dart';
import 'notifications.dart';
import 'persistence.dart';
import 'debug.dart';

/// Widget displaying the main page of the App
/// Showing a list of birthday entries

/// Functionality:
///       Persistence and the loaded database birthday entry list work independent.
///       On start the birthday entry list is fetched from the database which is held in memory throughout the app usage until closed.
///       When adding, editing, deleting entries they get modified in the birthday entry list, updated in the database separately, also notifications get scheduled.
///       On every action scheduled notifications get checked and scheduled when not existing for any birthday entry.
class WidgetBirthdayPage extends StatefulWidget {
  const WidgetBirthdayPage({Key? key}) : super(key: key);

  @override
  State<WidgetBirthdayPage> createState() => _WidgetBirthdayPageState();
}

class _WidgetBirthdayPageState extends State<WidgetBirthdayPage>{

  /// Recent selected birthday entry
  BirthdayEntry? recentSelected;
  /// List of currently selected birthday entries
  List<BirthdayEntry> selected = [];

  late Persistence persistence;
  late Notifications notifications;

  @override
  void initState() {
    /// Initializing persistence manager
    persistence = Persistence();
    persistence.init();

    /// Initializing notification manager
    notifications = Notifications();
    notifications.initNotifications();

    /// Listening to notification events. E.g. OnClick.
    listenToNotifications();

    super.initState();
  }

  /// List holding all birthday entries during runtime for faster access
  List<BirthdayEntry> birthdayEntries = [];

  @override
  Widget build(BuildContext context) {
    /// Design
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState((){
            recentSelected = null;
            selected.clear();
          });
        },
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<BirthdayEntry>>(
                  future: fetchBirthdayEntries(),
                  builder: (context, future){
                    if(!future.hasData) {
                      return Container();
                    } else {
                      birthdayEntries = future.data!;
                      updateNotifications(birthdayEntries);
                      birthdayEntries.sort((a, b) => Date.daysToBirthday(a.getDate()).compareTo(Date.daysToBirthday(b.getDate())));
                      return ListView.builder(
                          itemCount: birthdayEntries.length,
                          itemBuilder: (context, index){

                            // Selected entries get indented.
                            double padding = 0.0;
                            if(selected.contains(birthdayEntries[index])){
                              padding = 32.0;
                            }

                            return Padding(
                              padding: EdgeInsets.only(left: padding),
                              child: WidgetBirthdayEntry(
                                  entry: birthdayEntries[index],
                                  onLongPress: () {
                                    setState(() {
                                      if(recentSelected == null){
                                        recentSelected = birthdayEntries[index];
                                        if(selected.contains(birthdayEntries[index])){
                                          selected.remove(birthdayEntries[index]);
                                          recentSelected = selected.isNotEmpty ? selected.last : null;
                                        } else {
                                          selected.add(birthdayEntries[index]);
                                        }
                                      }
                                    });
                                  },
                                  onTap: () {
                                    if(recentSelected != null){
                                      setState(() {
                                        recentSelected = birthdayEntries[index];
                                        if(selected.contains(birthdayEntries[index])){
                                          selected.remove(birthdayEntries[index]);
                                          recentSelected = selected.isNotEmpty ? selected.last : null;
                                        } else {
                                          selected.add(birthdayEntries[index]);
                                        }
                                      });
                                    }
                                  },
                              ),
                            );
                          }
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: [
              recentSelected != null ? FloatingActionButton(
                onPressed: () {
                  _editEntry(context, recentSelected!);
                },
                tooltip: 'Edit',
                child: const Icon(Icons.edit),
              ) : Container(),
              Expanded(child: Container()),
              recentSelected != null ? FloatingActionButton(
                onPressed: () {
                  if(selected.isEmpty){
                    deleteBirthdayEntry(recentSelected!);
                  } else {
                    for (BirthdayEntry entry in selected) {
                      deleteBirthdayEntry(entry);
                    }
                    selected.clear();
                  }
                  recentSelected = null;
                },
                tooltip: 'Delete',
                child: const Icon(Icons.delete),
              ) : Container(),
              Expanded(child: Container()),
              recentSelected == null ? FloatingActionButton(
                onPressed: () {
                  _addEntry(context);
                },
                tooltip: 'Add',
                child: const Icon(Icons.add),
              ) :  FloatingActionButton(
                onPressed: () {
                  setState(() {
                    recentSelected = null;
                    selected.clear();
                  });
                },
                tooltip: 'Cancel',
                child: const Icon(Icons.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Iterates through all birthday entries and checks whether an existing notification is scheduled.
  /// If not existing rescheduled a new notification for the specific birthday entry
  void updateNotifications(List<BirthdayEntry> entries) async{
    List<PendingNotificationRequest> pendingNotificationRequests = await notifications.flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for(BirthdayEntry entry in entries){
      if(pendingNotificationRequests.any((notification) => notification.id == entry.hashCode)){
        /// Do nothing
      } else {
        /// Schedule notification

        /// TODO: Disable following line on production release.
        DateTime scheduledTime = Date.now().add(Duration(days: Date.daysToBirthday(entry.getDate())));
        scheduledTime = DateTime.now().add(const Duration(hours: 0, seconds: 5));

        notifications.scheduleNotification(
          entry.hashCode,
          "Birthday",
          'Today is ${entry.name}s birthday.',
          scheduledTime,
          entry.name
        );

        Debug.log("Rescheduled notification for ${entry.name} : ${Date.now().add(Duration(days: Date.daysToBirthday(entry.getDate())))}");
      }
    }
  }

  /// Accesses database to fetch all saved birthday entries and parsing them into a list.
  Future<List<BirthdayEntry>> fetchBirthdayEntries() async {
    final entries = await persistence.getAllEntries();

    List<BirthdayEntry> fetchedEntries = entries.map((BirthdayEntry item) => BirthdayEntry(
        name: item.toMap()['name'],
        date: item.toMap()['date'],
      ),
    ).toList();

    return fetchedEntries;
  }

  /// Starting process to add another birthday entry. Calling WidgetBirthdayInput widget to be displayed.
  Future<void> _addEntry(BuildContext context) async{
    final entry = await Navigator.push(
        context,
        DialogRoute(builder: (context) => const WidgetBirthdayInput(), context: context),
    );

    if(!mounted) return;

    if(entry is! BirthdayEntry) return;

    addBirthdayEntry(entry);
  }

  /// Starting process to edit the recently selected birthday entry. Calling WidgetBirthdayInput widget to be displayed.
  Future<void> _editEntry(BuildContext context, BirthdayEntry recentSelected) async{
    final entry = await Navigator.push(
      context,
      DialogRoute(builder: (context) => WidgetBirthdayInput(entry: recentSelected), context: context),
    );

    if(!mounted) return;

    if(entry is! BirthdayEntry) return;

    editBirthdayEntry(recentSelected, entry);
  }

  /// Validation for birthday entry data fields.
  bool validateBirthdayEntry(BirthdayEntry entry){
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

  /// Deleting a birthday entry
  void deleteBirthdayEntry(BirthdayEntry entry){
    setState(() {
      birthdayEntries.remove(entry);
      persistence.deleteEntry(entry);
      notifications.deleteScheduledNotification(entry.hashCode);
    });

    Debug.log("Deleted entry: ${entry.name}");
    Debug.log("Removed scheduled notification: ${entry.name}");
  }

  /// Adding birthday to database and scheduling a notification.
  void addBirthdayEntry(BirthdayEntry entry) {
    if(!validateBirthdayEntry(entry)) return;

    /// TODO: Disable following line on production release.
    DateTime scheduledTime = Date.now().add(Duration(days: Date.daysToBirthday(entry.getDate())));
    scheduledTime = DateTime.now().add(const Duration(hours: 0, seconds: 5));

    setState(() {
      persistence.insertEntry(entry);
      notifications.scheduleNotification(
          entry.hashCode,
          "Birthday",
          'Today is ${entry.name}s birthday.',
          scheduledTime,
          entry.hashCode.toString()
      );
    });

    Debug.log("Added entry ${entry.name}");
    Debug.log("Scheduled notification for ${entry.name} : $scheduledTime");
  }

  /// Updating a birthday entry in database.
  void editBirthdayEntry(BirthdayEntry recentSelected, BirthdayEntry entry){
    if(!validateBirthdayEntry(entry)) return;

    setState(() {
      persistence.updateEntry(recentSelected, entry);
    });

    Debug.log("Edited entry: ${entry.name}");
  }

  /// Event listener to notification calls.
  void listenToNotifications(){
    notifications.onNotificationClick.stream.listen(onNotificationListen);
  }

  void onNotificationListen(String? payload){
    if (payload != null && payload.isNotEmpty) {

      int entryHash = int.parse(payload);
      BirthdayEntry notificationEntry = birthdayEntries.firstWhere((element) => element.hashCode == entryHash);

      Navigator.push(
          context,
          DialogRoute(builder: (context) => WidgetBirthdayPanel(entry: notificationEntry), context: context)
      );
    }
  }
}