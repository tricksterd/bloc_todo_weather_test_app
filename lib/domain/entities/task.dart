import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String category;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      description,
      isCompleted,
      category,
    ];
  }
}
