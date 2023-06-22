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

  TodoModel copyWith({String? uid, String? title, bool? isCompleted}) {
    return TodoModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [uid, title, isCompleted];
}
