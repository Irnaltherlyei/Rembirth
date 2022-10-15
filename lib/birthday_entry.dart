class BirthdayEntry {
  final String name;
  final String date;

  const BirthdayEntry({required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Entry{name: $name, date: $date}';
  }

  DateTime getDate() {
    return DateTime.parse(date);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirthdayEntry &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          date == other.date;

  @override
  int get hashCode => name.hashCode ^ date.hashCode;
}