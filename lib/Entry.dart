class Entry {
  final String name;
  final String date;

  const Entry({required this.name, required this.date});

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
}