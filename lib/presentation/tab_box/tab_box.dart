// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/business_logic/cubit/tab_cubit.dart';
import 'package:todo/utils/icons/icons.dart';

class TabBox extends StatefulWidget {
  const TabBox({super.key});

  @override
  TabBoxState createState() => TabBoxState();
}

class TabBoxState extends State<TabBox> {
  final List<SvgPicture> tabIcons = [
    SvgPicture.asset(AppIcons.home, height: 22,color: Colors.grey,),
    SvgPicture.asset(AppIcons.calendar, height: 22,color: Colors.grey,),
    SvgPicture.asset(AppIcons.message, height: 22,color: Colors.grey,),
    SvgPicture.asset(AppIcons.profile, height: 22,color: Colors.grey,),
  ];

  final List<SvgPicture> tabIconsSelected = [
    SvgPicture.asset(AppIcons.home, height: 22,color: Colors.blue,),
    SvgPicture.asset(AppIcons.calendar, height: 22,color: Colors.blue,),
    SvgPicture.asset(AppIcons.message, height: 22,color: Colors.blue,),
    SvgPicture.asset(AppIcons.profile, height: 22,color: Colors.blue,),
  ];

  @override
  Widget build(BuildContext context) {
    final int selectedTab = context.watch<TabCubit>().state;

    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: context.read<TabCubit>().pages,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabIcons.length, (index) {
            final bool isSelected = selectedTab == index;

            return IconButton(
              onPressed: () {
                context.read<TabCubit>().changeTab(index);
              },
              icon: isSelected ? tabIconsSelected[index] : tabIcons[index],
            );
          }),
        ),
      ),
      floatingActionButton: selectedTab == 0
          ? FloatingActionButton(
              elevation: 0,
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
              child: const Icon(
                CupertinoIcons.add,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/addEvent');
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
