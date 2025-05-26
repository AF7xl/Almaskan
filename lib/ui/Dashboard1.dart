import 'package:almaskan/ui/Invoice.dart';
import 'package:almaskan/ui/Taxinvoice1.dart';
import 'package:almaskan/ui/quotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard2 extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String trn;

  const Dashboard2(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.trn});

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey[300],
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 20.sp,
              color: Colors.black,
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 400.w),
          child: Text(
            widget.name,
            style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Container(
                    color: Colors.blueGrey[100],
                    child: TabBar(
                        labelColor: Colors.red[900],
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.red[900],
                        tabs: const [
                          Tab(text: "Quotation"),
                          Tab(text: "Invoice"),
                          Tab(text: "Tax Invoice"),
                        ]),
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      Quotation2(
                        id: widget.id,
                        name: widget.name,
                        address: widget.address ,
                      ),
                      invoice1(
                        id: widget.id,
                        name: widget.name,
                        address: widget.address,
                        trn: widget.trn,
                      ),
                      Taxinvoice1(
                        id: widget.id,
                        name: widget.name,
                        address: widget.address,
                        trn: widget.trn,
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
