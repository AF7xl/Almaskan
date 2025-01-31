



import 'package:almaskan/ui/VatPurchase.dart';
import 'package:almaskan/ui/Vatpurchase1.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Dashboard.dart';
import 'VatM.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  PageController pageController = PageController();
  SideMenuController sideMenuController = SideMenuController();

  void initState() {
    // Connect SideMenuController and PageController together
    sideMenuController.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar with EasySideMenu
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 15.h, left: 10.h),
            child: Container(
              width: 250.w,
              child: SideMenu(
                style: SideMenuStyle(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                  displayMode: SideMenuDisplayMode.auto,
                  backgroundColor: Colors.red[900],
                  selectedTitleTextStyle: TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  unselectedIconColor: Colors.white70,
                  unselectedTitleTextStyle: TextStyle(color: Colors.white70),
                  showHamburger: true,
                ),
                controller: sideMenuController,
                items: [
                  // Dashboard Menu Item
                  SideMenuItem(
                    title: 'Dashboard',
                    icon: Icon(Icons.dashboard),
                    onTap: (index, controller) {
                      pageController.jumpToPage(index);
                    },
                  ),

                  SideMenuItem(
                      title: 'VAT Admin Expense',
                      icon: Icon(Icons.receipt),
                      onTap: (index, controller) {
                        pageController.jumpToPage(index);
                      }),
                  SideMenuItem(
                      title: 'VAT Purchase',
                      icon: Icon(Icons.receipt),
                      onTap: (index, controller) {
                        pageController.jumpToPage(index);
                      })
                ],
              ),
            ),
          ),

          // Page View to show content for each menu item
          Expanded(
            child: PageView(
              controller: pageController,
              children: [Dashboard(), Vatm(),Vatpurchase1()],
            ),
          ),
        ],
      ),
    );
  }
}
