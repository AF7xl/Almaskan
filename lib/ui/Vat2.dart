import 'package:almaskan/ui/VatAdminExpense.dart';
import 'package:almaskan/ui/VatPurchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Vat2 extends StatefulWidget {
  final String id;
  final num Invoiceamount;
  final num Tax;
  final num Total;

  const Vat2(
      {super.key,
      required this.id,
      required this.Invoiceamount,
      required this.Tax, required this.Total});

  @override
  State<Vat2> createState() => _Vat2State();
}

class _Vat2State extends State<Vat2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 25.sp,
                          color: Colors.black,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 500.w),
                    child: Text(
                      "January - March",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      "2024",
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                      labelColor: Colors.red[900],
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.red[900],
                      tabs: const [
                        Tab(text: "Admin Expense"),
                        Tab(text: "Purchase"),
                      ]),
                  Expanded(
                      child: TabBarView(children: [
                    Vatadminexpense(
                      id: widget.id,
                      Invoiceamount: num.parse(widget.Invoiceamount.toString()),
                      Tax: num.parse(widget.Tax.toString()), Total: widget.Total,
                    ),

                  ]))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
