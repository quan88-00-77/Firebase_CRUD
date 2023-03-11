import 'package:bt_ve_nha/Model/giangvien.dart';
import 'package:bt_ve_nha/Model/lophoc.dart';
import 'package:bt_ve_nha/Model/sinhvien.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/monhoc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          SinhVienScreen(),
          GiangVienScreen(),
          MonHocScreen(),
          LopHocScreen(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.perm_contact_cal_outlined,
                color: _page == 0 ? Colors.yellow : Colors.white,
              ),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_pin_outlined,
                color: _page == 1 ? Colors.yellow : Colors.white,
              ),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.class_outlined,
                color: _page == 2 ? Colors.yellow : Colors.white,
              ),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.cast_for_education,
                color: _page == 3 ? Colors.yellow : Colors.white,
              ),
              label: '',
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
