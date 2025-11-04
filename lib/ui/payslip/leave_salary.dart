import 'package:almaskan/ui/payslip/leave_pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveSalary extends StatefulWidget {
  final String id;
  const LeaveSalary({super.key, required this.id});

  @override
  State<LeaveSalary> createState() => _LeaveSalaryState();
}

class _LeaveSalaryState extends State<LeaveSalary> {
  TextEditingController name = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController joindate = TextEditingController();
  TextEditingController payperiod = TextEditingController();
  TextEditingController dateofexit = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController number = TextEditingController();

  bool isclicked = false;
  List<Map<String, TextEditingController>> earningsList = [];
  List<Map<String, TextEditingController>> dedectionList = [];
  int currentNumber = 1;

  @override
  void initState() {
    super.initState();
    // Add one default empty row
    addNewRow();
    addNewRow2();
    _loadNextNumber();
  }

  Future<void> _loadNextNumber() async {
    final counterDoc = FirebaseFirestore.instance
        .collection('counters4')
        .doc('leavesalary_counter');

    final snapshot = await counterDoc.get();
    if (snapshot.exists) {
      setState(() {
        currentNumber = snapshot['currentNumber'] + 1;
        number.text = currentNumber.toString();
      });
    } else {
      // If this is the first time, create the counter doc
      await counterDoc.set({'currentNumber': 1});
      setState(() {
        currentNumber = 1;
        number.text = '1';
      });
    }
  }

  double totalpayment = 0.0;
  double totaldeduction = 0.0;
  double netpay = 0.0;
  void calculateTotals() {
    double earningsTotal = 0.0;
    double deductionsTotal = 0.0;

    // Calculate earnings total
    for (var row in earningsList) {
      double value = double.tryParse(row['amount']!.text) ?? 0.0;
      earningsTotal += value;
    }

    // Calculate deductions total
    for (var row in dedectionList) {
      double value = double.tryParse(row['amount2']!.text) ?? 0.0;
      deductionsTotal += value;
    }

    setState(() {
      totalpayment = earningsTotal;
      totaldeduction = deductionsTotal;
      netpay = (earningsTotal - deductionsTotal);
    });
  }

  void addNewRow() {
    final amountController = TextEditingController();
    amountController.addListener(calculateTotals); // 👈 auto-update
    setState(() {
      earningsList.add({
        'earnings': TextEditingController(),
        'amount': amountController,
      });
    });
  }

  void addNewRow2() {
    final amountController = TextEditingController();
    amountController.addListener(calculateTotals); // 👈 auto-update
    setState(() {
      dedectionList.add({
        'dedection': TextEditingController(),
        'amount2': amountController,
      });
    });
  }

  void removeRow(int index) {
    setState(() {
      earningsList.removeAt(index);
    });
  }

  void removeRow2(int index) {
    setState(() {
      dedectionList.removeAt(index);
    });
  }

  @override
  void dispose() {
    name.dispose();
    designation.dispose();
    joindate.dispose();
    payperiod.dispose();
    dateofexit.dispose();
    department.dispose();
    number.dispose();
    for (var row in earningsList) {
      row['earnings']?.dispose();
      row['amount']?.dispose();
    }
    for (var row in dedectionList) {
      row['dedection']?.dispose();
      row['amount2']?.dispose();
    }

    super.dispose();
  }

  String? selectedDocumentId;
  void clearForm() {
    setState(() {
      // Clear all lists
      name.clear();
      designation.clear();
      joindate.clear();
      payperiod.clear();
      dateofexit.clear();
      department.clear();
      earningsList.clear();
      dedectionList.clear();
      number.clear();
      netpay = 0.0;
      totaldeduction = 0.0;
      totalpayment = 0.0;
    });
  }

  Widget buildRow(int index) {
    final earnings = earningsList[index]['earnings']!;
    final amount = earningsList[index]['amount']!;
    return Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: Row(children: [
          // SNo Field
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: earnings,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
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
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Container(
              width: 120.w,
              height: 53.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: amount,
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
                      const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // ❌ Remove Button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => removeRow(index),
          ),
        ]));
  }

  Widget buildRow2(int index) {
    final dedections = dedectionList[index]['dedection']!;
    final amount2 = dedectionList[index]['amount2']!;
    return Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: Row(children: [
          // SNo Field
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: dedections,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
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
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Container(
              width: 120.w,
              height: 53.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: amount2,
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
                      const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // ❌ Remove Button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => removeRow2(index),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final leavesalaryRef = FirebaseFirestore.instance
        .collection("Employee")
        .doc(widget.id)
        .collection("leavesalary");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          'Create Leave Salary',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.72.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
                          "Numbers",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: number,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: const TextStyle(
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
                          "Employee name",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: name,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: const TextStyle(
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
                          "Designation",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          controller: designation,
                     
                          // Make the field non-editable so only date picker is used
                          onTap: () async {},
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: '',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black,
                            ),
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
                          "Date of join",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: joindate,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: const TextStyle(
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
                          "Pay Period",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: payperiod,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: const TextStyle(
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
                          "Date of Exit",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: dateofexit,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: const TextStyle(
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
                          "Department",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          controller: department,
                  
                          // Make the field non-editable so only date picker is used
                          onTap: () async {},
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: '',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 865.w),
              child: InkWell(
                onTap: () {
                  addNewRow();
                },
                child: Container(
                  width: 130.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.r),
                          bottomLeft: Radius.circular(5.r)),
                      color: Colors.grey[200]),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                          size: 15.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          "Add New Row",
                          style: GoogleFonts.workSans(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
                padding: EdgeInsets.only(top: 15.h, left: 20.w),
                child: Container(
                  width: 1100.w,
                  height: 500.h, // Fixed scrollable height
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                  ),

                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Earnings",
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Total",
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: earningsList.length,
                        itemBuilder: (context, index) {
                          return buildRow(index);
                        },
                      )),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Toatal Amount",
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              totalpayment.toStringAsFixed(2),
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 865.w),
              child: InkWell(
                onTap: () {
                  addNewRow2();
                },
                child: Container(
                  width: 130.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.r),
                          bottomLeft: Radius.circular(5.r)),
                      color: Colors.grey[200]),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                          size: 15.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          "Add New Row",
                          style: GoogleFonts.workSans(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
                padding: EdgeInsets.only(top: 15.h, left: 20.w),
                child: Container(
                  width: 1100.w,
                  height: 500.h, // Fixed scrollable height
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                  ),

                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dedaction",
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Total",
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: dedectionList.length,
                        itemBuilder: (context, index) {
                          return buildRow2(index);
                        },
                      )),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Toatal Deduction",
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              totaldeduction.toStringAsFixed(2),
                              style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 820.w, top: 10.h),
                    child: Text(
                      "Net Pay",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Container(
                        width: 200.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w, top: 8.h),
                          child: Text(
                            netpay.toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Employee")
                    .doc(widget.id)
                    .collection("leavesalary")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  var docs = snapshot.data!.docs;
                  final payslipMap = {
                    for (var doc in docs)
                      doc['numbers']?.toString() ?? 'Unknown': doc.id
                  };

                  return Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 300.w,
                        // Give a fixed width to prevent stretching
                        child: DropdownSearch<String>(
                          asyncItems: (String? filter) async {
                            return payslipMap.keys
                                .where((key) =>
                                    filter == null ||
                                    key
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()))
                                .toList();
                          },
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                  hintText: "Search by leavesalary No"),
                            ),
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select leavesalary to Edit",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          // In the onChanged callback of DropdownSearch<String>:
                          // In the onChanged callback of DropdownSearch<String>:
                          onChanged: (invNo) async {
                            if (invNo == null) return;

                            final selectedId = payslipMap[invNo];
                            if (selectedId == null) return;

                            try {
                              final selectedDoc = docs
                                  .firstWhere((doc) => doc.id == selectedId);
                              final data =
                                  selectedDoc.data() as Map<String, dynamic>;

                              // Clear existing form + lists
                              clearForm();
                              setState(() {
                                // Text controllers
                                selectedDocumentId = selectedDoc.id;
                                number.text = data['numbers']?.toString() ?? '';
                                name.text =
                                    data['employeeName']?.toString() ?? '';
                                designation.text =
                                    data['designation']?.toString() ?? '';
                                joindate.text =
                                    data['dateofjoin']?.toString() ?? '';
                                dateofexit.text =
                                    data['dateofexit']?.toString() ?? '';
                                department.text =
                                    data['department']?.toString() ?? '';
                                 payperiod.text =
                                    data['payperiod']?.toString() ?? '';
                                netpay = data['netPay'] ?? '';
                                totalpayment = double.tryParse(
                                        data['totalEarnings']?.toString() ??
                                            '0') ??
                                    0;
                                totaldeduction = double.tryParse(
                                        data['totalDeductions']?.toString() ??
                                            '0') ??
                                    0;

                                earningsList = (data['earnings'] ?? [])
                                    .map<Map<String, TextEditingController>>(
                                        (e) {
                                  return {
                                    'earnings': TextEditingController(
                                        text: e['earnings']?.toString() ?? ''),
                                    'amount': TextEditingController(
                                        text: e['amount']?.toString() ?? ''),
                                  };
                                }).toList();

                                dedectionList = (data['deductions'] ?? [])
                                    .map<Map<String, TextEditingController>>(
                                        (d) {
                                  return {
                                    'dedection': TextEditingController(
                                        text: d['dedection']?.toString() ?? ''),
                                    'amount2': TextEditingController(
                                        text: d['amount2']?.toString() ?? ''),
                                  };
                                }).toList();
                              });

                              // If you have UI widgets showing these lists, rebuild them
                            } catch (e) {
                              print('Error loading payslip: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to load payslip: ${e.toString()}')),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 250.w,
                      ),
                      InkWell(
                        onTap: () async {
                          final id =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          await leavesalaryRef.doc(id).set({
                            'id': id,
                            'employeeName': name.text,
                            'dateofjoin': joindate.text,
                            'payperiod': payperiod.text,
                            'designation': designation.text,
                            'dateofexit': dateofexit.text,
                            'department': department.text,
                            'earnings': earningsList
                                .map((e) => {
                                      'earnings': e['earnings']!.text,
                                      'amount': e['amount']!.text,
                                    })
                                .toList(),
                            'deductions': dedectionList
                                .map((e) => {
                                      'dedection': e['dedection']!.text,
                                      'amount2': e['amount2']!.text,
                                    })
                                .toList(),
                            'totalEarnings': totalpayment,
                            'totalDeductions': totaldeduction,
                            'netPay': netpay,
                            'numbers': currentNumber
                          }).then((value) async {
                            // ✅ 2. Update counter for next time
                            final counterDoc = FirebaseFirestore.instance
                                .collection('counters4')
                                .doc('payslip_counter');
                            await counterDoc
                                .update({'currentNumber': currentNumber});

                            // ✅ 3. Increase for UI immediately
                            setState(() {
                              currentNumber++;
                              number.text = currentNumber.toString();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Payslip Saved Succesfully'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                // optional for a floating snackbar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.all(
                                    15), // only works with floating behavior
                              ),
                            );
                          });
                        },
                        child: Container(
                          width: 65.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              "save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeavePdf(
                                  employeeName: name.text,
                                  dateofjoin: joindate.text,
                                  payperiod: payperiod.text,
                                  designation: designation.text,
                                  dateofexit: dateofexit.text,
                                  department: department.text,
                                  earnings: earningsList
                                      .map((e) => {
                                            'earnings': e['earnings']!.text,
                                            'amount': e['amount']!.text,
                                          })
                                      .toList(),
                                  deductions: dedectionList
                                      .map((e) => {
                                            'dedection': e['dedection']!.text,
                                            'amount2': e['amount2']!.text,
                                          })
                                      .toList(),
                                  totalEarnings: totalpayment,
                                  totalDeductions: totaldeduction,
                                  netPay: netpay,
                                ),
                              ));
                        },
                        child: Container(
                          width: 65.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text(
                              "Generate",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedDocumentId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please select a document to update'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.black54,
                                behavior: SnackBarBehavior.floating,
                                // optional for a floating snackbar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.all(
                                    15), // only works with floating behavior
                              ),
                            );
                          }
                          // collectFormData();
                          try {
                            await leavesalaryRef
                                .doc(selectedDocumentId)
                                .update({
                          
                              'employeeName': name.text,
                              'dateofjoin': joindate.text,
                              'payperiod': payperiod.text,
                              'designation': designation.text,
                              'dateofexit': dateofexit.text,
                              'department': department.text,
                              'earnings': earningsList
                                  .map((e) => {
                                        'earnings': e['earnings']!.text,
                                        'amount': e['amount']!.text,
                                      })
                                  .toList(),
                              'deductions': dedectionList
                                  .map((e) => {
                                        'dedection': e['dedection']!.text,
                                        'amount2': e['amount2']!.text,
                                      })
                                  .toList(),
                              'totalEarnings': totalpayment,
                              'totalDeductions': totaldeduction,
                              'netPay': netpay,
                              'numbers': number.text
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('leavesalary Updated'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                // optional for a floating snackbar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.all(
                                    30), // only works with floating behavior
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update ${e}'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.black54,
                                behavior: SnackBarBehavior.floating,
                                // optional for a floating snackbar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.all(
                                    30), // only works with floating behavior
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 65.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
