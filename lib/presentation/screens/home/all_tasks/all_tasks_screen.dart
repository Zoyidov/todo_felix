import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/business_logic/bloc/todo_bloc.dart';
import 'package:todo/presentation/screens/home/detail/detail.dart';


class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
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
                'All Tasks'
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
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailScreen(todo: state.todos[index], index: index,)));
                  },
                  leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(int.parse(state.todos[index].priorityColor, radix: 16)).withOpacity(0.3)
                      ),
                      child: Icon(
                          Icons.token_rounded,
                          color: Color(int.parse(state.todos[index].priorityColor, radix: 16)).withOpacity(1.0)
                      )
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.todos[index].name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      // Text(state.todos[index].time),
                      Text(DateFormat('yyyy-MM-dd').format(state.todos[index].dateCreated)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
            );
          } else if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoError) {
            return Center(
              child: Text('Error: ${state.errorMessage}'),
            );
          }
          return Center(
            child: Text('Unknown state: ${state.toString()}'),
          );
        },
      ),
    );
  }
}
