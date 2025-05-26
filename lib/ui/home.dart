import 'package:almaskan/ui/OverduePayment.dart';
import 'package:almaskan/ui/PaymentEnroll.dart';
import 'package:almaskan/ui/Sales.dart';
import 'package:almaskan/ui/VatAdmin.dart';
import 'package:almaskan/ui/VatPurchase.dart';
import 'package:almaskan/ui/vatadminReyah.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'DashboardMain.dart';
import 'Vatpurchasereyah.dart';


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

  bool isVatAdminExpanded = false;
  bool isVatpurchaseExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar with EasySideMenu
          Container(
            width: 235.w,
            child: SideMenu(
              style: SideMenuStyle(
                selectedTitleTextStyle: GoogleFonts.workSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                unselectedTitleTextStyle: GoogleFonts.workSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                displayMode: SideMenuDisplayMode.auto,
                backgroundColor: Colors.blueGrey[300],
                showHamburger: true,
                hoverColor: Colors.blue[300],
              ),
              controller: sideMenuController,
              items: [
                SideMenuItem(
                  title: 'Payment',
                  onTap: (index, controller) {
                    pageController.jumpToPage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Dashboard',
                  onTap: (index, controller) {
                    pageController.jumpToPage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Sales',
                  onTap: (index, controller) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Sales()),
                    );
                  },
                ),
                SideMenuItem(
                  title: 'Overdue Payment',
                  onTap: (index, controller) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Overduepayment()),
                    );
                  },
                ),
                // Parent Item
                SideMenuItem(
                  title: 'Vat Admin Expense',
                  onTap: (index, controller) {
                    setState(() {
                      isVatAdminExpanded = !isVatAdminExpanded;
                    });
                  },
                ),

                // Conditionally shown sub-items
                if (isVatAdminExpanded)
                  SideMenuItem(
                    title: '   └ Almaskan',
                    onTap: (index, controller) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Vatadmin()),
                      );
                    },
                  ),
                if (isVatAdminExpanded)
                  SideMenuItem(
                    title: '   └ Reyah Almaskan',
                    onTap: (index, controller) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Vatadminreyah()),
                      );
                    },
                  ),

                SideMenuItem(
                  title: 'Vat Admin Purchase',
                  onTap: (index, controller) {
                    setState(() {
                      isVatpurchaseExpanded = !isVatpurchaseExpanded;
                    });
                  },
                ),

                // Conditionally shown sub-items
                if (isVatpurchaseExpanded)
                  SideMenuItem(
                    title: '   └ Almaskan',
                    onTap: (index, controller) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Vatpurchase()),
                      );
                    },
                  ),
                if (isVatpurchaseExpanded)
                  SideMenuItem(
                    title: '   └ Reyah Almaskan',
                    onTap: (index, controller) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Vatpurchasereyah()),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Page View to show content for each menu item
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Paymentenroll(),
                Dashboard(),
                Sales(),
                Overduepayment(),
                Vatadmin(),
                Vatpurchase(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
