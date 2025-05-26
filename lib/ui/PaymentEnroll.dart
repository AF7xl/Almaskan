import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Paymentenroll extends StatefulWidget {
  const Paymentenroll({super.key});

  @override
  State<Paymentenroll> createState() => _PaymentenrollState();
}

class _PaymentenrollState extends State<Paymentenroll> {
  //focus nodes of record payment
  FocusNode customerNameFocusNode = FocusNode();
  FocusNode trnNumberFocusNode = FocusNode();
  FocusNode ProjectFocusNOde = FocusNode();
  FocusNode invoiceNumberFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode invoiceAmountFocusNode = FocusNode();
  FocusNode taxFocusNode = FocusNode();
  FocusNode totalAmountFocusNode = FocusNode();

  //focus node of overdue payment
  FocusNode customerNamedueFocusNode = FocusNode();
  FocusNode projectnameduefocusnode = FocusNode();
  FocusNode invoiceNumberdueFocusNode = FocusNode();
  FocusNode datedueFocusNode = FocusNode();
  FocusNode lponumberduefocusnode = FocusNode();
  FocusNode totalAmountdueFocusNode = FocusNode();

  bool showcontainer = false;
  bool showcontainer1 = false;
  TextEditingController customername = TextEditingController();
  String paymentType = 'Cash'; //dropdown for selecting cash/bank transfer
  String emirate = 'Dubai';
  TextEditingController Project = TextEditingController();
  TextEditingController TRN = TextEditingController();
  TextEditingController invoicenumber = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController Invoiceamount = TextEditingController();
  TextEditingController Tax = TextEditingController();
  TextEditingController Totalamount = TextEditingController();
  TextEditingController customernamedue = TextEditingController();
  TextEditingController projectnamedue = TextEditingController();
  TextEditingController datedue = TextEditingController();
  TextEditingController invoicenumberdue = TextEditingController();
  TextEditingController lponumberdue = TextEditingController();
  TextEditingController amountdue = TextEditingController();
  String? selectedcontainer;

  //for chart
  int selectedYear = DateTime.now().year;
  int? selectedMonth; // null means all months
  final List<int> availableYears = [for (int y = 2025; y <= 2030; y++) y];
  final List<int> months = [for (int m = 1; m <= 12; m++) m];

  Map<int, MonthlyFinance> monthlyFinance = {};

  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }

  void tooglecontainer1() {
    setState(() {
      showcontainer1 = !showcontainer1;
    });
  }

  final firestore1 = FirebaseFirestore.instance
      .collection('Sales'); //firestore for record payment
  final firestore2 = FirebaseFirestore.instance
      .collection('Overdue Payment'); //firestore for overdue payment

  Widget container() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 80.w, top: 20.h),
        child: Container(
          width: 800.w,
          height: 600.h,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.blueGrey, width: 0.5)),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, top: 15.h),
                    child: Text(
                      "Record Payment",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 560.w),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedcontainer = null;
                            showcontainer = false;
                          });
                          customername.clear();
                          TRN.clear();
                          invoicenumber.clear();
                          date.clear();
                          Invoiceamount.clear();
                          Totalamount.clear();
                          Project.clear();
                        },
                        icon: Icon(
                          CupertinoIcons.xmark,
                          size: 20.sp,
                          color: Colors.black,
                        )),
                  )
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 0.5,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.sp),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Customer Name",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: Container(
                        width: 250.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: customerNameFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(ProjectFocusNOde);
                          },
                          controller: customername,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 20.h,
                          cursorWidth: 0.5,
                          textAlignVertical: TextAlignVertical.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 18.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Payment Type",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Container(
                        width: 150.w,
                        height: 35.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: paymentType,
                            items:
                                ['Cash', 'Bank Transfer'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.black)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                paymentType = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), //Customer Name
              Padding(
                padding: EdgeInsets.only(top: 30.sp),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Text(
                            "Project",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 112.w),
                          child: Container(
                            width: 250.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                    color: Colors.black, width: 0.3)),
                            child: Center(
                              child: TextFormField(
                                focusNode: ProjectFocusNOde,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(invoiceNumberFocusNode);
                                },
                                textInputAction: TextInputAction.next,
                                controller: Project,
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                cursorHeight: 20.h,
                                cursorWidth: 0.5,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                                textAlign: TextAlign.start,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 2.h, left: 5.w, bottom: 18.h),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Emirate",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Container(
                        width: 150.w,
                        height: 35.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: emirate,
                            items: [
                              'Dubai',
                              'Abu Dhabi',
                              'Sharjah',
                              'Ajman',
                              'Umm Al Quwain',
                              'Ras Al Khaimah',
                              'Fujairah'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.black)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                emirate = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ), //TRN NUMBER
              Padding(
                padding: EdgeInsets.only(top: 30.sp),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Invoice Number",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 51.w),
                      child: Container(
                        width: 250.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: Center(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: invoiceNumberFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(dateFocusNode);
                            },
                            controller: invoicenumber,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            cursorHeight: 20.h,
                            cursorWidth: 0.5,
                            textAlignVertical: TextAlignVertical.center,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 18.h),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), //InvoiceNumber
              Padding(
                padding: EdgeInsets.only(top: 30.sp),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 130.w),
                      child: Container(
                        width: 250.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.black, width: 0.3),
                        ),
                        child: Center(
                          child: TextFormField(
                            readOnly: true,
                            controller: date,
                            focusNode: dateFocusNode,
                            onTap: () async {
                              FocusScope.of(context)
                                  .unfocus(); // Dismiss keyboard
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (selectedDate != null) {
                                date.text = DateFormat('dd-MM-yyyy')
                                    .format(selectedDate);
                                FocusScope.of(context)
                                    .requestFocus(invoiceAmountFocusNode);
                              }
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(invoiceAmountFocusNode);
                            },
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            cursorHeight: 20.h,
                            cursorWidth: 0.5,
                            textAlignVertical: TextAlignVertical.center,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 18.h),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ), //Date
              Padding(
                padding: EdgeInsets.only(top: 30.sp),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Invoice Amount",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 52.w),
                      child: Container(
                        width: 45.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.r),
                                topLeft: Radius.circular(5.r)),
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: Center(
                          child: Text(
                            "AED",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 205.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.r),
                              bottomRight: Radius.circular(5.r)),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: Invoiceamount,
                        focusNode: invoiceAmountFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(totalAmountFocusNode);
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        cursorHeight: 20.h,
                        cursorWidth: 0.5,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 18.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    )
                  ],
                ),
              ), //Invoice Amount

              Padding(
                padding: EdgeInsets.only(top: 30.sp),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Total Amount",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 70.w),
                      child: Container(
                        width: 45.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.r),
                                topLeft: Radius.circular(5.r)),
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: Center(
                          child: Text(
                            "AED",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 205.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.r),
                              bottomRight: Radius.circular(5.r)),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: TextFormField(
                        focusNode: totalAmountFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: Totalamount,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        cursorHeight: 20.h,
                        cursorWidth: 0.5,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 18.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    )
                  ],
                ),
              ), //Total Amount
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 610.w),
                      child: InkWell(
                        onTap: () async {
                          try {
                            final id = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            await firestore1.doc().set({
                              'id': id,
                              'Customer Name': customername.text,
                              'Project': Project.text,
                              'Payment Type': paymentType,
                              'Emirate': emirate,
                              'TRN Number': TRN.text,
                              'Invoice Number': invoicenumber.text,
                              'Date': date.text,
                              'Invoice Amount': Invoiceamount.text,
                              'Tax': Tax.text,
                              'Total Amount': Totalamount.text
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Payment Added to Sales Successfully"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Error :$e"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ));
                          }
                          customername.clear();
                          TRN.clear();
                          invoicenumber.clear();
                          date.clear();
                          Invoiceamount.clear();
                          Totalamount.clear();
                          Project.clear();

                          setState(() {
                            showcontainer = false;
                            selectedcontainer = null;
                          });
                        },
                        child: Container(
                          width: 65.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.lightBlue[600]),
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget container1() {
    return Padding(
      padding: EdgeInsets.only(left: 80.w, top: 20.h),
      child: Container(
        width: 800.w,
        height: 600.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.blueGrey, width: 0.5)),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 15.h),
                  child: Text(
                    "OVERDUE Payment",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 540.w),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectedcontainer = null;
                          showcontainer1 = false;
                        });
                        customernamedue.clear();
                        projectnamedue.clear();
                        invoicenumberdue.clear();
                        datedue.clear();
                        lponumberdue.clear();
                        amountdue.clear();
                      },
                      icon: Icon(
                        CupertinoIcons.xmark,
                        size: 20.sp,
                        color: Colors.black,
                      )),
                )
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Customer Name",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50.w),
                    child: Container(
                      width: 250.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: Center(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: customerNamedueFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(projectnameduefocusnode);
                          },
                          controller: customernamedue,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 20.h,
                          cursorWidth: 0.5,
                          textAlignVertical: TextAlignVertical.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 18.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), //Customer Name
            Padding(
              padding: EdgeInsets.only(top: 30.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Project Name",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 70.w),
                    child: Container(
                      width: 250.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: Center(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: projectnamedue,
                          focusNode: projectnameduefocusnode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(invoiceNumberdueFocusNode);
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 20.h,
                          cursorWidth: 0.5,
                          textAlignVertical: TextAlignVertical.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 18.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), //TRN NUMBER
            Padding(
              padding: EdgeInsets.only(top: 30.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Invoice Number",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 51.w),
                    child: Container(
                      width: 250.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: Center(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: invoiceNumberdueFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(datedueFocusNode);
                          },
                          controller: invoicenumberdue,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 20.h,
                          cursorWidth: 0.5,
                          textAlignVertical: TextAlignVertical.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 18.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), //InvoiceNumber
            Padding(
              padding: EdgeInsets.only(top: 30.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Date",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 130.w),
                    child: Container(
                      width: 250.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: Center(
                        child: TextFormField(
                          focusNode: datedueFocusNode,
                          controller: datedue,
                          readOnly: true,
                          // Disable manual typing
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(FocusNode()); // Close keyboard
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              datedue.text = formattedDate;
                              FocusScope.of(context)
                                  .requestFocus(lponumberduefocusnode);
                            }
                          },
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 20.h,
                          cursorWidth: 0.5,
                          textAlignVertical: TextAlignVertical.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 18.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), //Date
            Padding(
              padding: EdgeInsets.only(top: 30.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "LPO Number",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 76.w),
                    child: Container(
                      width: 250.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: Center(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: lponumberdue,
                          focusNode: lponumberduefocusnode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(totalAmountdueFocusNode);
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 20.h,
                          cursorWidth: 0.5,
                          textAlignVertical: TextAlignVertical.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 18.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Total Amount",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 70.w),
                    child: Container(
                      width: 45.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.r),
                              topLeft: Radius.circular(5.r)),
                          border: Border.all(color: Colors.black, width: 0.3)),
                      child: Center(
                        child: Text(
                          "AED",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 205.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.r),
                            bottomRight: Radius.circular(5.r)),
                        border: Border.all(color: Colors.black, width: 0.3)),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: amountdue,
                      focusNode: totalAmountdueFocusNode,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      cursorHeight: 20.h,
                      cursorWidth: 0.5,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      textAlign: TextAlign.start,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 2.h, left: 5.w, bottom: 18.h),
                        border: InputBorder.none,
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  )
                ],
              ),
            ), //Total Amount
            Padding(
              padding: EdgeInsets.only(top: 80.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 610.w),
                    child: InkWell(
                      onTap: () async {
                        try {
                          final id =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          await firestore2.doc().set({
                            'id': id,
                            'Customer Nama': customernamedue.text,
                            'Project Name': projectnamedue.text,
                            'Invoice Number': invoicenumberdue.text,
                            'Date': datedue.text,
                            'LPO Number': lponumberdue.text,
                            'Total Amount': amountdue.text
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Payment Added to Overdue"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 3),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ERROR :$e"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ));
                        }
                        customernamedue.clear();
                        projectnamedue.clear();
                        invoicenumberdue.clear();
                        datedue.clear();
                        lponumberdue.clear();
                        amountdue.clear();
                        setState(() {
                          showcontainer1 = false;
                          selectedcontainer = null;
                        });
                      },
                      child: Container(
                        width: 65.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.lightBlue[600]),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  //function for chart
  Future<void> _loadData() async {
    final data = await fetchFinancialData(selectedYear);
    setState(() {
      monthlyFinance = data;
    });
  }

  Future<Map<int, MonthlyFinance>> fetchFinancialData(int year) async {
    final firestore = FirebaseFirestore.instance;
    Map<int, MonthlyFinance> monthlyData = {
      for (int i = 1; i <= 12; i++) i: MonthlyFinance(i)
    };

    // Helper to parse date safely
    DateTime? parseDate(dynamic value) {
      if (value is String) {
        try {
          return DateFormat('dd-MM-yyyy').parse(value);
        } catch (_) {
          return null;
        }
      } else if (value is Timestamp) {
        return value.toDate();
      }
      return null;
    }

    try {
      final sales = await firestore.collection('Sales').get();
      for (var doc in sales.docs) {
        final date = parseDate(doc['Date']);
        if (date != null && date.year == year) {
          monthlyData[date.month]?.income +=
              double.tryParse(doc['Total Amount'].toString()) ?? 0;
        }
      }

      final expenseSources = [
        'Vat Admin Expense',
        'Vat Purchase',
        'Vat Admin Expense Reyah',
        'Vat Purchase Reyah'
      ];
      for (var collection in expenseSources) {
        final expenses = await firestore.collection(collection).get();
        for (var doc in expenses.docs) {
          final date = parseDate(doc['Date']);
          if (date != null && date.year == year) {
            monthlyData[date.month]?.expenses +=
                double.tryParse(doc['Total Amount'].toString()) ?? 0;
          }
        }
      }
    } catch (e) {
      print("Error fetching financial data: $e");
    }

    return monthlyData;
  }

  double get filteredIncome {
    if (selectedMonth != null)
      return monthlyFinance[selectedMonth!]?.income ?? 0;
    return monthlyFinance.values.fold(0, (sum, m) => sum + m.income);
  }

  double get filteredExpenses {
    if (selectedMonth != null)
      return monthlyFinance[selectedMonth!]?.expenses ?? 0;
    return monthlyFinance.values.fold(0, (sum, m) => sum + m.expenses);
  }

  double get filteredProfit => filteredIncome - filteredExpenses;

  //function to add all total amount from sales
  Stream<double> totalAmountStream() {
    return FirebaseFirestore.instance
        .collection('Sales')
        .snapshots()
        .map((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final totalamountstr = data['Total Amount'] ?? 0.00;
        final amount = double.tryParse(totalamountstr.toString()) ?? 0.00;
        total += amount;
      }
      return total;
    });
  }

  // function to add all total amount from overdue
  Stream<double> totalamountfromoverdue() {
    return FirebaseFirestore.instance
        .collection('Overdue Payment')
        .snapshots()
        .map((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final totalamountfordue = data['Total Amount'] ?? 0.00;
        final amount = double.tryParse(totalamountfordue.toString()) ?? 0.00;
        total += amount;
      }
      return total;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        StreamBuilder<double>(
            stream: totalAmountStream(),
            builder: (context, snapshot) {
              String totalText = "0.00";
              if (snapshot.hasData) {
                final formatter = NumberFormat.currency(
                  locale: 'en_AE', // UAE style
                  symbol: 'AED ', // Currency symbol with space
                  decimalDigits: 2,
                );
                totalText = formatter.format(snapshot.data);
              }
              return StreamBuilder<double>(
                  stream: totalamountfromoverdue(),
                  builder: (context, snapshot) {
                    String overduetotaltext = "0.00";
                    if (snapshot.hasData) {
                      final formatter = NumberFormat.currency(
                          locale: 'en_AE', symbol: 'AED ', decimalDigits: 2);
                      overduetotaltext = formatter.format(snapshot.data);
                    }
                    return LayoutBuilder(builder: (context, constraints){return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 20.w),
                            child: Text(
                              "PAYMENT ENROLLMENT",
                              style: GoogleFonts.workSans(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.h, left: 20.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 550.w,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: Colors.grey, width: 0.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Top Header with "Total Receivables" and Dropdown
                                      Container(
                                        width: 550.w,
                                        height: 60.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.r),
                                            topRight: Radius.circular(8.r),
                                          ),
                                          color: Colors.grey[300],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 10.w),
                                              child: InkWell(
                                                onTap: tooglecontainer1,
                                                child: Text(
                                                  "Total Receivables",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: 10.w),
                                              child: DropdownButton<String>(
                                                dropdownColor: Colors.white,
                                                hint: Text(
                                                  "ADD PAYMENT",
                                                  style: GoogleFonts.workSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                                icon: Icon(
                                                  Icons.add_circle_rounded,
                                                  size: 20.sp,
                                                  color: Colors.blue,
                                                ),
                                                value: selectedcontainer,
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "Container 1",
                                                    child: Text("New Payment"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Container 2",
                                                    child: Text("OVERDUE"),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedcontainer = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Data Rows: CURRENT and OVERDUE
                                      Expanded(
                                        child: Row(
                                          children: [
                                            // Current Column
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 20.w, top: 25.h),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "CURRENT",
                                                      style: GoogleFonts.workSans(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 15.sp,
                                                        color: Colors.lightBlue,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                      totalText,
                                                      style: GoogleFonts.workSans(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Divider
                                            Container(
                                              width: 1.w,
                                              height: 100.h,
                                              color: Colors.grey,
                                            ),

                                            // Overdue Column
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 20.w, top: 25.h),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "OVERDUE",
                                                      style: GoogleFonts.workSans(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 15.sp,
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                      overduetotaltext,
                                                      style: GoogleFonts.workSans(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                ,
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, top: 20.h),
                            child: Text(
                              "FINANCIAL DASHBOARD",
                              style: GoogleFonts.workSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: Colors.black),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 800.w),
                                child: DropdownButton<int>(
                                  value: selectedYear,
                                  items: availableYears
                                      .map((year) => DropdownMenuItem(
                                      value: year, child: Text('$year')))
                                      .toList(),
                                  onChanged: (year) {
                                    if (year != null) {
                                      setState(() {
                                        selectedYear = year;
                                        selectedMonth = null; // reset month
                                      });
                                      _loadData();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 16.w),
                              DropdownButton<int?>(
                                value: selectedMonth,
                                hint: Text("All Months"),
                                items: [
                                  DropdownMenuItem(
                                      value: null, child: Text("All Months")),
                                  ...months.map((m) => DropdownMenuItem(
                                    value: m,
                                    child: Text(DateFormat.MMMM()
                                        .format(DateTime(0, m))),
                                  ))
                                ],
                                onChanged: (month) {
                                  setState(() {
                                    selectedMonth = month;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 25.h),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, bottom: 20.h),
                            child: Container(
                              width: 1000.w,
                              height: 380.h,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Stack(
                                children: [
                                  if (selectedMonth == null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.h),
                                      child: SizedBox(
                                        width: 745.w,
                                        height: 300.h,
                                        child: buildChart(monthlyFinance),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      child: Text(
                                        "Chart disabled in month view. Switch to 'All Months' to view full year.",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 315.sp),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 250.w),
                                          child: Container(
                                            width: 10.w,
                                            height: 10.w,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: Text(
                                            "Income Data",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 40.w),
                                          child: Container(
                                            width: 10.w,
                                            height: 10.w,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: Text(
                                            "Expense Data",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12.sp,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 750.w),
                                    child: SummaryCard(
                                      totalIncome: filteredIncome,
                                      totalExpenses: filteredExpenses,
                                      totalProfit: filteredProfit,
                                      label: selectedMonth == null
                                          ? 'Overall Summary'
                                          : DateFormat.MMMM().format(
                                          DateTime(0, selectedMonth!)) +
                                          ' Summary',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );});
                  });
            }),
        if (selectedcontainer == "Container 1")
          container()
        else if (selectedcontainer == "Container 2")
          container1()
        else
          SizedBox(),
        if (showcontainer) container(),
        if (showcontainer1) container1(),
      ],
    ));
  }

  Widget buildChart(Map<int, MonthlyFinance> data) {
    if (data.isEmpty ||
        data.values.every((m) => m.income == 0 && m.expenses == 0)) {
      return Center(child: Text("No data available"));
    }

    return BarChart(
      BarChartData(
        groupsSpace: 12,
        barGroups: data.entries
            .where((entry) => entry.key >= 1 && entry.key <= 12)
            .map((entry) {
          final month = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(
                toY: value.income.clamp(0, double.infinity),
                width: 10,
                color: Colors.blue,
                borderRadius: BorderRadius.zero,
              ),
              BarChartRodData(
                toY: value.expenses.clamp(0, double.infinity),
                width: 10,
                color: Colors.orange,
                borderRadius: BorderRadius.zero,
              ),
            ],
            barsSpace: 6,
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (value.toInt() < 1 || value.toInt() > 12)
                  return SizedBox.shrink();
                final name =
                    DateFormat.MMM().format(DateTime(0, value.toInt()));
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(name, style: TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade400,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.transparent,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final double totalProfit;
  final String label;

  const SummaryCard({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalProfit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: 250.w,
      height: 380.h,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text("Income",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: Colors.black)),
                ),
                Text("AED ${totalIncome.toStringAsFixed(2)} +",
                    style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.green)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Text("Expenses",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: Colors.black)),
                ),
                Text("AED ${totalExpenses.toStringAsFixed(2)} -",
                    style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.red)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Text("Profit",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: Colors.black)),
                ),
                Text("AED ${totalProfit.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black)),
              ]),
            ],
          ),
        ]),
      ),
    );
  }
}

class MonthlyFinance {
  final int month;
  double income = 0;
  double expenses = 0;

  MonthlyFinance(this.month);

  double get profit => income - expenses;
}
