import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo/business_logic/bloc/todo_bloc.dart';
import 'package:todo/business_logic/data/local/db.dart';
import 'package:todo/business_logic/data/model/db_model.dart';
import 'package:todo/widgets/textfield.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final LocalDatabase databaseHelper = LocalDatabase.getInstance;
  Color? _selectedColor = Colors.blue;

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventStartTimeController = TextEditingController();
  final TextEditingController eventEndTimeController = TextEditingController();

  final bool _isSaving = false;
  bool _eventNameValid = false;
  bool _eventTimeValid = false;

  @override
  void initState() {
    super.initState();
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorOption('High', Colors.red),
            _buildColorOption('Medium', Colors.blue),
            _buildColorOption('Low', Colors.orange),
            _buildColorOption('', Colors.transparent),
          ],
        );
      },
    );
  }

  Widget _buildColorOption(String colorName, Color color) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      title: Text(colorName),
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
        Navigator.pop(context);
      },
    );
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
                  child: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            const Text(
                'Create New Task'
                '',
                style: TextStyle(fontWeight: FontWeight.w600)),
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
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalTextField(
                controller: eventNameController,
                caption: 'Task name',
                hintText: "UI Design",
                onChanged: (text) {
                  setState(() {
                    _eventNameValid = text.isNotEmpty;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GlobalTextField(
                controller: eventLocationController,
                caption: 'Event location',
                hintText: 'Uzbekistan, Tashkent',
                suffixIcon: CupertinoIcons.location_solid,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text("Importance color"),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  _showColorPicker(context);
                },
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _selectedColor ?? Colors.red,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: GlobalTextField(
                      controller: eventStartTimeController,
                      hintText: '09:00',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      caption: 'Start time',
                      onChanged: (text) {
                        setState(() {
                          _eventTimeValid = text.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: GlobalTextField(
                      controller: eventEndTimeController,
                      hintText: '11:00',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      caption: 'End time',
                      onChanged: (text) {
                        setState(() {
                          _eventTimeValid = text.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              GlobalTextField(
                controller: eventDescriptionController,
                hintText: 'Research design paths. There are many \ncarer paths within the field of design...',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                caption: 'Event description',
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isSaving) {
                    return;
                  } else if (_selectedColor == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a color."),
                      ),
                    );
                  } else if (!_eventNameValid || !_eventTimeValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        backgroundColor: Colors.red,
                        content: Text("Event name and time are required."),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    context.read<TodoBloc>().add(AddTodo(TodoModel(
                          name: eventNameController.text,
                          description: eventDescriptionController.text,
                          location: eventLocationController.text,
                          time: "${eventStartTimeController.text} - ${eventEndTimeController.text}",
                          priorityColor: _selectedColor?.value.toRadixString(16) ?? "FFFFFF",
                          dateCreated: DateTime.now(),
                          // dateCreated: DateTime.now(),
                        )));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Create Task",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Gap(100)
            ],
          ),
        ),
      ),
    );
  }
}
