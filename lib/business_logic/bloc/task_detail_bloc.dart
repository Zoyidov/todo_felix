import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskDetailEvent {}

class SaveDoneAndIsCompletedEvent extends TaskDetailEvent {}

class TaskDetailState {
  final int done;
  final bool isTaskCompleted;

  TaskDetailState(this.done, this.isTaskCompleted);

  double getProgress(int totalTasks) {
    return done / totalTasks * 100;
  }
}

class TaskDetailCubit extends Cubit<TaskDetailState> {
  final SharedPreferences _prefs;
  final int index;
  final int totalTasks;

  TaskDetailCubit(this._prefs, this.index, this.totalTasks)
      : super(TaskDetailState(0, false));

  void loadDoneValue() {
    emit(TaskDetailState(_prefs.getInt('done') ?? 0, state.isTaskCompleted));
  }

  void loadDoneValueAtIndex() {
    emit(TaskDetailState(state.done, _prefs.getBool('isCompleted$index') ?? false));
  }

  void saveDoneValue() async {
    await _prefs.setInt('done', state.done);
    emit(TaskDetailState(state.done, state.isTaskCompleted));
  }

  void saveIsCompletedValue() async {
    await _prefs.setBool('isCompleted$index', true);
    emit(TaskDetailState(state.done, true));
  }

  void saveDoneAndIsCompleted() async {
    emit(TaskDetailState(state.done + 1, true));
    await _prefs.setInt('done', state.done + 1);
    await _prefs.setBool('isCompleted$index', true);
  }
}
