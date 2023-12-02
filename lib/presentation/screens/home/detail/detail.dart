// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gap/gap.dart';
import 'package:todo/business_logic/data/model/db_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final TodoModel todo;
  final int index;

  const TaskDetailScreen({super.key, required this.todo, required this.index});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late SharedPreferences _prefs;
  int done = 0;
  bool isTaskCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadDoneValue();
    _loadDoneValueAtIndex();
  }

  Future<void> _loadDoneValue() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      done = _prefs.getInt('done') ?? 0;
    });
  }

  Future<void> _loadDoneValueAtIndex() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isTaskCompleted = _prefs.getBool('isCompleted${widget.index}') ?? false;
    });
  }



  Future<void> _saveDoneAndIsCompleted() async {
    setState(() {
      done = done + 1;
      isTaskCompleted = true;
    });

    // Save the updated done value
    await _prefs.setInt('done', done);

    // Save the completion status for the specific task (using index)
    await _prefs.setBool('isCompleted${widget.index}', true);
  }

  String _getImportanceLevel() {
    Map<String, String> colorToImportance = {
      'FFF44336': 'High',
      'FF2196F3': 'Medium',
      'FFFF9800': 'Low',
    };

    String importance = colorToImportance[widget.todo.priorityColor.toUpperCase()] ?? 'Unknown';
    return importance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            const Text(
              'Task Detail',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.todo.name,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Importance Level:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Color(int.parse(widget.todo.priorityColor, radix: 16)).withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.token_rounded,
                      color:
                          Color(int.parse(widget.todo.priorityColor, radix: 16)).withOpacity(1.0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getImportanceLevel(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.todo.time,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Location:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.todo.location,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                children: [
                  Text(
                    widget.todo.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Gap(50),
              if (!isTaskCompleted)
                ElevatedButton(
                  onPressed: () async {
                    await _saveDoneAndIsCompleted();
                    Navigator.pushNamedAndRemoveUntil(context, '/tab', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: Text(
                        'ToDo is Completed',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
