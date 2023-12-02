
import 'package:easy_localization/easy_localization.dart';

class TodoModel {
  final int? id;
  final String name;
  final String description;
  final String location;
  final String time;
  final String priorityColor;
  final DateTime dateCreated;

  TodoModel({
    this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.time,
    required this.priorityColor,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'time': time,
      'priorityColor': priorityColor,
      'date_created': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateCreated)
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      time: json['time'] as String,
      priorityColor: json['priorityColor'] as String,
      dateCreated: DateTime.parse(json['date_created'] as String)
    );
  }

  TodoModel copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    String? time,
    String? priorityColor,
    DateTime? dateCreated
  }) {
    return TodoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      time: time ?? this.time,
      priorityColor: priorityColor ?? this.priorityColor,
      dateCreated: dateCreated ?? this.dateCreated
    );
  }
}

class EventModelFields {
  static const String id = "id";
  static const String name = "name";
  static const String description = "description";
  static const String location = "location";
  static const String time = "time";
  static const String priorityColor = "priorityColor";
  static const String eventTable = "event_table";
  static const String dateCreated = "date_created";
}
