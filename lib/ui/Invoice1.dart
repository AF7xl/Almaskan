import 'package:almaskan/ui/Invpdf.dart';
import 'package:almaskan/ui/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Toast Message.dart';

class invoice1 extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String trn;

  const invoice1(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.trn});

  @override
  State<invoice1> createState() => _invoice1State();
}

class _invoice1State extends State<invoice1> {
  List<TextEditingController> rateControllers = [];
  List<TextEditingController> qtyControllers = [];
  List<TextEditingController> amountControllers = [];
  List<TextEditingController> sno = [];
  List<TextEditingController> description = [];
  List<TextEditingController> unit = [];
  TextEditingController invno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController kindatt = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController nbq = TextEditingController();
  List<String> descriptionData = [];
  List<String> snodata = [];
  List<String> qtydata = [];
  List<String> unitdata = [];
  List<String> ratedata = [];
  List<String> amountdata = [];

  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();

  int rowCount = 1;
  double subtotal = 0.0;
  double discount = 0.0;
  double taxableAmount = 0.0;
  double vat = 0.0;
  double totalAmount = 0.0;

  get index => 0;

  @override
  void initState() {
    super.initState();
    rowCount = 1; // Start with 1 row
    initializeControllers(); // Initialize controllers for the first row
  }

  void initializeControllers({bool addNewRow = true}) {
    if (addNewRow) {
      // Add new controllers for the newly added row
      final rateController = TextEditingController();
      final qtyController = TextEditingController();
      final amountController = TextEditingController();
      final sn = TextEditingController();
      final desc = TextEditingController();
      final uni = TextEditingController();

      // Add these new controllers to the respective lists
      rateControllers.add(rateController);
      qtyControllers.add(qtyController);
      amountControllers.add(amountController);
      sno.add(sn);

      description.add(desc);

      unit.add(uni);

      // Add listeners to calculate amount (use the correct index)
      final index = rateControllers.length - 1; // Index of the newly added row
      rateController.addListener(() => calculateAmount(index));
      qtyController.addListener(() => calculateAmount(index));
    } else {
      // Initialize controllers for the first row
      rateControllers.clear();
      qtyControllers.clear();
      amountControllers.clear();

      final rateController = TextEditingController();
      final qtyController = TextEditingController();
      final amountController = TextEditingController();

      rateControllers.add(rateController);
      qtyControllers.add(qtyController);
      amountControllers.add(amountController);

      // Add listeners to calculate amount
      rateController.addListener(() => calculateAmount(0));
      qtyController.addListener(() => calculateAmount(0));
    }
  }

  void calculateAmount(int index) {
    final rateText = rateControllers[index].text;
    final qtyText = qtyControllers[index].text;

    if (rateText.isNotEmpty && qtyText.isNotEmpty) {
      final rate = double.tryParse(rateText) ?? 0.0;
      final qty = double.tryParse(qtyText) ?? 0.0;
      final amount = rate * qty;
      setState(() {
        // Update the corresponding amount controller for the row
        amountControllers[index].text = amount.toStringAsFixed(2);
      });

      calculateSubtotal(); // Recalculate subtotal after updating the amount
    }
  }

  void calculateSubtotal() {
    List<double> amounts = amountControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();
    print(amounts);
    setState(() {
      subtotal = amounts.fold(0, (sum, item) => sum + item);
    });
    calculateTotal(); // Recalculate total after updating subtotal
  }

  void calculateTotal() {
    taxableAmount = subtotal - discount;
    vat = taxableAmount * 0.05;
    totalAmount = taxableAmount + vat;
    setState(() {}); // Update UI
  }

  List<Widget> rows = [];

  void addNewRow() {
    setState(() {
      rowCount++; // Increment rowCount
      initializeControllers(addNewRow: true); // Add controllers for the new row
      rows.add(buildRow(rowCount - 1)); // Add the new row widget
    });
  }

  Widget buildRow(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Row(
        children: [
          // SNo Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 50.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  snodata.add(value);
                },
                controller: sno[index],
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Description Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 500.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  descriptionData.add(value);
                },
                controller: description[index],
                maxLines: null,
                keyboardType: TextInputType.text,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Qty Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 80.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  qtydata.add(value);
                },
                controller: qtyControllers[index],
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Unit Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 70.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  unitdata.add(value);
                },
                controller: unit[index],
                maxLines: null,
                keyboardType: TextInputType.text,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Rate Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 100.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  ratedata.add(value);
                },
                controller: rateControllers[index],
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Amount Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 100.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.none,
                onFieldSubmitted: (value) {
                  amountdata.add(value);
                },
                readOnly: false,
                controller: amountControllers[index],
                onChanged: (value) {
                  calculateSubtotal();
                },
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Remove Row Icon
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("invoice");
    final firestor = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("invoice").snapshots();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "INV No",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: invno,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "23/156",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Date",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: date,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "06-June-2023",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Kind Att:",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          controller: kindatt,
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Kind att",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Project:",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          controller: project,
                          maxLines: null,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Project",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "NOTE Before Quote",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 790.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          controller: nbq,
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Add Note",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 850.w, top: 15.h),
              child: ElevatedButton(
                onPressed: () {
                  addNewRow();
                },
                child: Container(
                  width: 150.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      "ADD ROW",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Container(
                width: 1060.w,
                height: (70 * rowCount).h,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Text(
                                "SNo",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40.w),
                              child: Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 440.w),
                              child: Text(
                                "qty",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 60.w),
                              child: Text(
                                "Unit",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 70.w),
                              child: Text(
                                "Rate",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 70.w),
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      ...rows
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 750.w, top: 10.h),
                    child: Text(
                      "Sub Total",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Container(
                        width: 250.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Text(
                          subtotal.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                              color: Colors.black),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 750.w, top: 10.h),
                    child: Text(
                      "Discount",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Container(
                      width: 250.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        onChanged: (value) {
                          discount = double.tryParse(value) ?? 0.0;
                          calculateTotal();
                        },
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black45),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 700.w, top: 10.h),
                    child: Text(
                      "Taxable Amount",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Container(
                        width: 250.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Text(
                          taxableAmount.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                              color: Colors.black),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 770.w, top: 10.h),
                    child: Text(
                      "Vat 5%",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Container(
                        width: 250.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Text(
                          vat.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                              color: Colors.black),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 725.w, top: 10.h),
                    child: Text(
                      "Total Amount",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Container(
                        width: 250.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Text(
                          totalAmount.toStringAsFixed(2),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount in Name",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 790.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        controller: totalamountinname,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note after quote",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 790.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        controller: naq,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black45),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestor,
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 500.w),
                        child: ElevatedButton(
                            onPressed: () async {
                              {
                                final id = DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString();
                                debugPrint('Generated ID: $id');
                                try {
                                  await firestore.doc(id).set({
                                    'id': id,
                                    'project': project.text,
                                    'kindatt': kindatt.text,
                                    'date': date.text,
                                    'qyn no': invno.text,
                                    'note before quote': nbq.text,
                                    'date': date.text,
                                    'sno': snodata,
                                    'description': descriptionData,
                                    'unit': unitdata,
                                    'rate': ratedata,
                                    'quantity': qtydata,
                                    'amount': amountdata,
                                    'subtotal': subtotal.toString(),
                                    'discount': discount.toString(),
                                    'taxable amount': taxableAmount.toString(),
                                    'vat': vat.toString(),
                                    'total amount': totalAmount.toString(),
                                    'total amount in name': totalamountinname.text,
                                    'note after quote': naq.text
                                  });
                                  ToastMessage()
                                      .toastmessage(message: 'Quotation Added');
                                } catch (e) {
                                  debugPrint('Error adding client: $e');
                                  ToastMessage()
                                      .toastmessage(message: e.toString());
                                }
                              }
                            },
                            child: Text("Save")),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Invpdf(
                                          invno: invno.text,
                                          date: date.text,
                                          kindatt: kindatt.text,
                                          project: project.text,
                                          nbq: nbq.text,
                                          sno: snodata,
                                          description: descriptionData,
                                          qty: qtydata,
                                          unit: unitdata,
                                          rate: ratedata,
                                          amount: amountdata,
                                          subtotal: subtotal.toString(),
                                          discount: discount.toString(),
                                          taxableamount: taxableAmount.toString(),
                                          vat: vat.toString(),
                                          totalamount: totalAmount.toString(),
                                          totalamountinname: totalamountinname.text,
                                          naq: naq.text,
                                          name: widget.name,
                                          address: widget.address,
                                          trn: widget.trn,
                                        )),
                              );
                            },
                            child: Text("Preview")),
                      ),Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: ElevatedButton(
                            onPressed: (){
                              firestore.doc(snapshot.data!.docs[index]['id'].toString()).update(
                                  {
                                    'project': project.text,
                                    'kindatt': kindatt.text,
                                    'date': date.text,
                                    'qyn no': invno.text,
                                    'note before quote': nbq.text,
                                    'date': date.text,
                                    'sno': snodata,
                                    'description': descriptionData,
                                    'unit': unitdata,
                                    'rate': ratedata,
                                    'quantity': qtydata,
                                    'amount': amountdata,
                                    'subtotal': subtotal.toString(),
                                    'discount': discount.toString(),
                                    'taxable amount': taxableAmount.toString(),
                                    'vat': vat.toString(),
                                    'total amount': totalAmount.toString(),
                                    'total amount in name': totalamountinname.text,
                                    'note after quote': naq.text
                                  });
                            },
                            child: Text("Update")),
                      ),
                    ],
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
