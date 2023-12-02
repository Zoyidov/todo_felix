import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/screens/calendar/calendar_screen.dart';
import 'package:todo/presentation/screens/home/home_screen.dart';
import 'package:todo/presentation/screens/message/message_screen.dart';
import 'package:todo/presentation/screens/profile/profile_screen.dart';

class TabCubit extends Cubit<int> {
  TabCubit() : super(0);
  List<Widget> pages = [
    const HomeScreen(),
    const CalendarScreen(),
    const MessageScreen(),
     const ProfileScreen(),
  ];

  void changeTab(int tabIndex) {
    emit(tabIndex);
  }
}
