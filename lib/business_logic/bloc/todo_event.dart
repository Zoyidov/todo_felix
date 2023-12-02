part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoAdd extends TodoEvent {
  final TodoModel eventModel;

  TodoAdd({required this.eventModel});
}

class TodoDelete extends TodoEvent {
  final int id;

  TodoDelete({required this.id});
}
class AddTodo extends TodoEvent {
  final TodoModel newTodo;

  AddTodo(this.newTodo);

  List<Object> get props => [newTodo];
}

class DeleteTodo extends TodoEvent {
  final int id;

  DeleteTodo(this.id);

  List<Object> get props => [id];
}

class UpdateTodo extends TodoEvent {
  final TodoModel updatedTodo;

  UpdateTodo(this.updatedTodo);

  List<Object> get props => [updatedTodo];
}

class FetchTodos extends TodoEvent {}

