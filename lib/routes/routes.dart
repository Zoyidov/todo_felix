import 'package:flutter/material.dart';
import 'package:todo/presentation/screens/add_event/add_event_screen.dart';
import 'package:todo/presentation/screens/calendar/calendar_screen.dart';
import 'package:todo/presentation/screens/home/all_tasks/all_tasks_screen.dart';
import 'package:todo/presentation/screens/home/home_screen.dart';
import 'package:todo/presentation/screens/message/message_screen.dart';
import 'package:todo/presentation/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:todo/presentation/screens/profile/profile_screen.dart';
import 'package:todo/presentation/screens/splash/splash_screen.dart';
import 'package:todo/presentation/tab_box/tab_box.dart';


class RouteNames {
  static const String splash = "/";
  static const String tab = "/tab";
  static const String home = "/home";
  static const String calendar = "/calendar";
  static const String message = "/message";
  static const String profile = "/profile";
  static const String addEvent = "/addEvent";
  static const String all = "/all";
  static const String onBoarding = "/onBoarding";
}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteNames.tab:
        return MaterialPageRoute(builder: (context) => const TabBox());
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RouteNames.calendar:
        return MaterialPageRoute(builder: (context) => const CalendarScreen());
      case RouteNames.message:
        return MaterialPageRoute(builder: (context) => const MessageScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case RouteNames.addEvent:
        return MaterialPageRoute(builder: (context) => const AddEvent());
      case RouteNames.all:
        return MaterialPageRoute(builder: (context) => const AllTasksScreen());
      case RouteNames.onBoarding:
        return MaterialPageRoute(builder: (context) => const OnBoardingScreen());
    }
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text("Route not found"),
        ),
      ),
    );
  }
}
