import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({
    required this.uid,
    required this.title,
    required this.isCompleted,
  });

  final String uid;
  final String title;
  final bool isCompleted;

  @override
  List<Object?> get props => [uid, title, isCompleted];
}
