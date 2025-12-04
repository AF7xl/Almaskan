import 'package:almaskan/ui/payslip/gratuity_pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Gratuity extends StatefulWidget {
  final String id;
  const Gratuity({super.key, required this.id});

  @override
  State<Gratuity> createState() => _GratuityState();
}

class _GratuityState extends State<Gratuity> {
  TextEditingController name = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController joindate = TextEditingController();
  TextEditingController dateofresign = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController dateofleaving = TextEditingController();
  TextEditingController dateofjoinservice = TextEditingController();
  TextEditingController dateofexit = TextEditingController();
  TextEditingController totalnoofdays = TextEditingController();
  TextEditingController lastbasicpay = TextEditingController();
  TextEditingController lastda = TextEditingController();
  TextEditingController noofdays = TextEditingController();
  TextEditingController totalserviceperiod = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController monthsalary = TextEditingController();
  TextEditingController subtotal = TextEditingController();
  TextEditingController loandeduction = TextEditingController();
  TextEditingController topay = TextEditingController();
  TextEditingController number = TextEditingController();
  int currentNumber = 1;

  @override
  void initState() {
    super.initState();
    // Add one default empty row
    // Add listeners to auto-update calculations
    total.addListener(_updateSubtotal);
    monthsalary.addListener(_updateSubtotal);
    loandeduction.addListener(_updateToPay);
    _loadNextNumber();
  }

  Future<void> _loadNextNumber() async {
    final counterDoc = FirebaseFirestore.instance
        .collection('counters5')
        .doc('gratuity_counter');

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

  void _updateSubtotal() {
    final double totalValue = double.tryParse(total.text) ?? 0.0;
    final double monthValue = double.tryParse(monthsalary.text) ?? 0.0;

    final double sub = totalValue + monthValue;
    subtotal.text = sub.toStringAsFixed(2);

    _updateToPay(); // Also update TO PAY after subtotal changes
  }

  void _updateToPay() {
    final double subTotalValue = double.tryParse(subtotal.text) ?? 0.0;
    final double loanDeductionValue =
        double.tryParse(loandeduction.text) ?? 0.0;

    final double pay = subTotalValue - loanDeductionValue;
    topay.text = pay.toStringAsFixed(2);
  }

  final List<Map<String, dynamic>> months = [
    {'label': 'January', 'id': 1},
    {'label': 'febuary', 'id': 2},
    {'label': 'March', 'id': 3},
    {'label': 'April', 'id': 4},
    {'label': 'May', 'id': 5},
    {'label': 'June', 'id': 6},
    {'label': 'July', 'id': 7},
    {'label': 'Auguest', 'id': 8},
    {'label': 'September', 'id': 9},
    {'label': 'Octobor', 'id': 10},
    {'label': 'November', 'id': 11},
    {'label': 'Desember', 'id': 12},
  ];

  int? selectedpmonth;
  @override
  void dispose() {
    name.dispose();
    designation.dispose();
    joindate.dispose();
    dateofresign.dispose();
    department.dispose();
    dateofleaving.dispose();
    dateofjoinservice.dispose();
    dateofexit.dispose();
    totalnoofdays.dispose();
    lastbasicpay.dispose();
    lastda.dispose();
    noofdays.dispose();
    totalserviceperiod.dispose();
    total.dispose();
    monthsalary.dispose();
    subtotal.dispose();
    loandeduction.dispose();
    topay.dispose();
    number.dispose();
    super.dispose();
  }

  String? selectedDocumentId;
  void clearForm() {
    setState(() {
      // Clear all lists
      name.clear();
      designation.clear();
      joindate.clear();
      dateofresign.clear();
      department.clear();
      dateofleaving.clear();
      dateofjoinservice.clear();
      dateofexit.clear();
      totalnoofdays.clear();
      lastbasicpay.clear();
      lastda.clear();
      noofdays.clear();
      totalserviceperiod.clear();
      total.clear();
      monthsalary.clear();
      subtotal.clear();
      loandeduction.clear();
      topay.clear();
      number.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gratuityRef = FirebaseFirestore.instance
        .collection("Employee")
        .doc(widget.id)
        .collection("gratuity");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: Colors.white,
            )),
       
        backgroundColor: const Color(0xFFC62828),
        title: Text(
          'Create Gratuity',
          style:  GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.sp,
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
                          style:  GoogleFonts.poppins(
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
                          style:  GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle:  GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
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
                          style:  GoogleFonts.poppins(
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
                          style:  GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
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
                          "Joining Date",
                          style:  GoogleFonts.poppins(
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
                          controller: joindate,

                          // Make the field non-editable so only date picker is used
                          onTap: () async {},
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style:  GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: '',
                            hintStyle:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
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
                          "Designation",
                          style:  GoogleFonts.poppins(
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
                          controller: designation,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style:  GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
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
                          "Date of Resignation",
                          style:  GoogleFonts.poppins(
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
                          controller: dateofresign,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle:  GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            //2
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        "Department",
                        style:  GoogleFonts.poppins(
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
                        controller: department,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "",
                          hintStyle:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
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
                        "Date of Leaving",
                        style:  GoogleFonts.poppins(
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
                        controller: dateofleaving,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style:  GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: '',
                          hintStyle:  GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.sp,
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
                        "Date of Joining Service",
                        style:  GoogleFonts.poppins(
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
                        controller: dateofjoinservice,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style:  GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: '',
                          hintStyle:  GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.sp,
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
                        "Date of Exit",
                        style:  GoogleFonts.poppins(
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
                        controller: dateofexit,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style:  GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: '',
                          hintStyle:  GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
            //3
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        "Total No of Days",
                        style:  GoogleFonts.poppins(
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
                        controller: totalnoofdays,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "",
                          hintStyle:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
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
                        "Last Basic pay(At Exit)",
                        style:  GoogleFonts.poppins(
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
                        controller: lastbasicpay,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style:  GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: '',
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.sp,
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
                        "Last DA (At Exit)",
                        style:  GoogleFonts.poppins(
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
                        controller: lastda,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: '',
                          hintStyle:  GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.sp,
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
                        "No of days",
                        style:  GoogleFonts.poppins(
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
                        controller: noofdays,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style:  GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: '',
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        "Total Service Period",
                        style:  GoogleFonts.poppins(
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
                        controller: totalserviceperiod,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style:  GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "",
                          hintStyle:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),

            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 150.w),
              child: Table(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(2), // First column width (flexible)
                  1: FlexColumnWidth(2), // Second column width (flexible)
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.red[900]),
                    children:  [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style:  GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Amount (AED)',
                          style:  GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.sp),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, left: 20.w),
                      child:  Text(
                        'TOTAL',
                        style:  GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16.sp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: total,
                        // onChanged: (val) => updateAdvanceAmount(),
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                        style:  GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 15.sp),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, left: 20.w),
                      child: Expanded(
                        child: DropdownButtonFormField<int>(
                          hint: const Text("Select Month"),
                          items: months.map((option) {
                            return DropdownMenuItem<int>(
                              value: option['id'],
                              child: Text(option['label']),
                            );
                          }).toList(),
                          onChanged: (id) {
                            setState(() {
                              selectedpmonth = id;
                              // recalc
                            });
                          },
                          value: selectedpmonth,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: monthsalary,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                        style:  GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 15.sp),
                      ),
                    ),
                  ]),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child:  SizedBox(
                          height: 40, // Set the desired height
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'SUB TOTAL',
                              style:  GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: subtotal,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                          ),
                          keyboardType: TextInputType.number,
                          style:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 15.sp),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child:  SizedBox(
                          height: 40, // Set the desired height
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'LOAN DEDUCTION',
                              style:  GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: loandeduction,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                          ),
                          keyboardType: TextInputType.number,
                          style:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 15.sp),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child:  SizedBox(
                          height: 40.sp, // Set the desired height
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'TO PAY',
                              style:  GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: topay,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                          ),
                          keyboardType: TextInputType.number,
                          style:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 15.sp),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            ),

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Employee")
                    .doc(widget.id)
                    .collection("gratuity")
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
                                  hintText: "Search by gratuity No"),
                            ),
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select gratuity to Edit",
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
                                    data['joindate']?.toString() ?? '';
                                dateofexit.text =
                                    data['dateofexit']?.toString() ?? '';
                                dateofresign.text =
                                    data['dateofresign']?.toString() ?? '';
                                department.text =
                                    data['department']?.toString() ?? '';
                                dateofleaving.text =
                                    data['dateofleaving']?.toString() ?? '';
                                dateofjoinservice.text =
                                    data['dateofjoinservice']?.toString() ?? '';

                                totalnoofdays.text =
                                    data['totalnoofdays']?.toString() ?? '';
                                lastbasicpay.text =
                                    data['lastbasicpay']?.toString() ?? '';
                                lastda.text = data['lastda']?.toString() ?? '';
                                noofdays.text =
                                    data['noofdays']?.toString() ?? '';
                                totalserviceperiod.text =
                                    data['totalserviceperiod']?.toString() ??
                                        '';
                                total.text = data['total']?.toString() ?? '';
                                // ✅ Correct mapping
                                monthsalary.text =
                                    data['monthsalary']?.toString() ?? '';

// ✅ Restore selected month from Firestore (if any)
                                if (data['month'] != null &&
                                    data['month'].toString().isNotEmpty) {
                                  final foundMonth = months.firstWhere(
                                    (m) =>
                                        m['label'].toString().toLowerCase() ==
                                        data['month'].toString().toLowerCase(),
                                    orElse: () => {'id': null},
                                  );
                                  selectedpmonth = foundMonth['id'];
                                } else {
                                  selectedpmonth = null;
                                }

                                subtotal.text =
                                    data['subtotal']?.toString() ?? '';
                                loandeduction.text =
                                    data['loandeduction']?.toString() ?? '';
                                topay.text = data['topay']?.toString() ?? '';
                              });

                              // If you have UI widgets showing these lists, rebuild them
                            } catch (e) {
                              print('Error loading gratuity: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to load gratuity: ${e.toString()}')),
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
                          await gratuityRef.doc(id).set({
                            'id': id,
                            'employeeName': name.text,
                            'designation': designation.text,
                            'joindate': joindate.text,
                            'dateofresign': dateofresign.text,
                            'department': department.text,
                            'dateofleaving': dateofleaving.text,
                            'dateofjoinservice': dateofjoinservice.text,
                            'dateofexit': dateofexit.text,
                            'totalnoofdays': totalnoofdays.text,
                            'lastbasicpay': lastbasicpay.text,
                            'lastda': lastda.text,
                            'noofdays': noofdays.text,
                            'totalserviceperiod': totalserviceperiod.text,
                            'total': total.text,
                            'month': selectedpmonth != null
                                ? months.firstWhere(
                                    (m) => m['id'] == selectedpmonth)['label']
                                : '',
                            'monthsalary': monthsalary.text,
                            'subtotal': subtotal.text,
                            'loandeduction': loandeduction.text,
                            'topay': topay.text,
                            'numbers': currentNumber
                          }).then((value) async {
                            // ✅ 2. Update counter for next time
                            final counterDoc = FirebaseFirestore.instance
                                .collection('counters5')
                                .doc('gratuity_counter');
                            await counterDoc
                                .update({'currentNumber': currentNumber});

                            // ✅ 3. Increase for UI immediately
                            setState(() {
                              currentNumber++;
                              number.text = currentNumber.toString();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gratuity Saved Succesfully'),
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
                              style:  GoogleFonts.poppins(
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
                                builder: (context) => Gratuitypdf(
                                    employeeName: name.text,
                                    joindate: joindate.text,
                                    designation: designation.text,
                                    dateofresign: dateofresign.text,
                                    department: department.text,
                                    dateofleaving: dateofleaving.text,
                                    dateofjoinservice: dateofjoinservice.text,
                                    dateofexit: dateofexit.text,
                                    totalnoofdays:
                                        double.parse(totalnoofdays.text),
                                    lastbasicpay:
                                        double.parse(lastbasicpay.text),
                                    lastda: double.parse(lastda.text),
                                    noofdays: double.parse(noofdays.text),
                                    totalserviceperiod: totalserviceperiod.text,
                                    total: double.parse(total.text),
                                    month: selectedpmonth != null
                                        ? months.firstWhere((m) =>
                                            m['id'] == selectedpmonth)['label']
                                        : '', 
                                    monthsalary: double.parse(monthsalary.text),
                                    subtotal: double.parse(subtotal.text),
                                    loandeduction:
                                        double.parse(loandeduction.text),
                                    topay: double.parse(topay.text)),
                              ));
                        },
                        child: Container(
                          width: 80.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text(
                              "Generate",
                              style:  GoogleFonts.poppins(
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
                            await gratuityRef.doc(selectedDocumentId).update({
                              'employeeName': name.text,
                              'designation': designation.text,
                              'joindate': joindate.text,
                              'dateofresign': dateofresign.text,
                              'department': department.text,
                              'dateofleaving': dateofleaving.text,
                              'dateofjoinservice': dateofjoinservice.text,
                              'dateofexit': dateofexit.text,
                              'totalnoofdays': totalnoofdays.text,
                              'lastbasicpay': lastbasicpay.text,
                              'lastda': lastda.text,
                              'noofdays': noofdays.text,
                              'totalserviceperiod': totalserviceperiod.text,
                              'total': total.text,
                              'month': selectedpmonth != null
                                  ? months.firstWhere(
                                      (m) => m['id'] == selectedpmonth)['label']
                                  : '',
                              'monthsalary': monthsalary.text,
                              'subtotal': subtotal.text,
                              'loandeduction': loandeduction.text,
                              'topay': topay.text,
                              'numbers': number.text
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gratuity Updated'),
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
                              style:  GoogleFonts.poppins(
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
              height: 80.h,
            ),
          ],
        ),
      ),
    );
  }
}
