part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoModel> todos;

  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String errorMessage;

  TodoError(this.errorMessage);
}

