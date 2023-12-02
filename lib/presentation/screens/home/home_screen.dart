import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gap/gap.dart';
import 'package:todo/business_logic/bloc/todo_bloc.dart';
import 'package:todo/presentation/screens/home/detail/detail.dart';
import 'package:todo/utils/icons/icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int done;

  @override
  void initState() {
    super.initState();
    _loadDoneValue();
  }

  Future<void> _loadDoneValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      done = prefs.getInt('done') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
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
              child: const Icon(Icons.menu),
            ),
            const Text('Homepage', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.notifications_none_sharp),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoaded) {
                final today = DateTime.now();
                final todayTodos = state.todos
                    .where((todo) =>
                todo.dateCreated.day == today.day &&
                    todo.dateCreated.month == today.month &&
                    todo.dateCreated.year == today.year)
                    .toList();
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.lightBlue.withOpacity(0.7),
                            Colors.blue.withOpacity(0.5),
                            Colors.indigoAccent,
                          ],
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's progress summary",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "${todayTodos.length} tasks",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                AppIcons.logo,
                                height: 50,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Progress ${done > 0 ? (done / todayTodos.length * 100).toStringAsFixed(0) : 0}%",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: LinearProgressIndicator(
                                      value: done > 0 ? done / state.todos.length.toDouble() : 0,
                                      color: Colors.white,
                                      backgroundColor: Colors.white38,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's tasks",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/all');
                          },
                          child: const Text(
                            "See all",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoLoaded) {
                          final today = DateTime.now();

                          final todayTodos = state.todos
                              .where((todo) =>
                                  todo.dateCreated.day == today.day &&
                                  todo.dateCreated.month == today.month &&
                                  todo.dateCreated.year == today.year)
                              .toList();

                          return todayTodos.isEmpty ? Center(child: Lottie.asset(AppIcons.empty, height: 200,repeat: false))
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: todayTodos.length,
                            itemBuilder: (context, index) => Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TaskDetailScreen(
                                              todo: todayTodos[index],
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(int.parse(todayTodos[index].priorityColor,
                                                  radix: 16))
                                              .withOpacity(0.3),
                                        ),
                                        child: Icon(
                                          Icons.token_rounded,
                                          color: Color(int.parse(todayTodos[index].priorityColor,
                                                  radix: 16))
                                              .withOpacity(1.0),
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            todayTodos[index].name,
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          Text(todayTodos[index].time),
                                        ],
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                                    ),
                                  ),
                          );
                        } else if (state is TodoLoading) {
                          return const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          );
                        } else if (state is TodoError) {
                          return Center(
                            child: Text('Error: ${state.errorMessage}'),
                          );
                        }
                        return Center(
                          child: Text('Unknown state: ${state.toString()}'),
                        );
                      },
                    )
                  ],
                );
              } else if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoError) {
                return Center(
                  child: Text('Error: ${state.errorMessage}'),
                );
              }
              return Center(child: Text('Unknown state: ${state.toString()}'));
            },
          ),
        ),
      ),
    );
  }
}
