// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:todo/business_logic/data/local/db.dart';
import 'package:todo/business_logic/data/model/db_model.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoLoading()) {
    on<AddTodo>(_addEvent);
    on<DeleteTodo>(_deleteEvent);
    on<FetchTodos>(_fetch);
    on<UpdateTodo>(_updateEvent);
  }

  _addEvent(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await LocalDatabase.insert(event.newTodo);
      final todos = await LocalDatabase.getAll();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  _fetch(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await LocalDatabase.getAll();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  _deleteEvent(DeleteTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await LocalDatabase.delete(event.id);
      final todos = await LocalDatabase.getAll();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
  _updateEvent(UpdateTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await LocalDatabase.update(eventModel: event.updatedTodo);
      final todos = await LocalDatabase.getAll();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
