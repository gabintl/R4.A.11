import 'user.dart';

class Poll {
  Poll({
    required this.id,
    required this.name,
    required this.description,
    required this.eventDate,
    this.imageName,
    this.user,
  });

  final int id;
  final String name;
  final String description;
  final DateTime eventDate;
  final String? imageName;
  final User? user;

  Poll.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as int,
          name: json['name'] as String,
          description: json['description'] as String,
          eventDate: DateTime.parse(json['eventDate'] as String),
          imageName: json['imageName'] as String?,
          user: json['user'] != null ? User.fromJson(json['user']) : null,
        );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'eventDate': eventDate.toIso8601String(),
  };
}