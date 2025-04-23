import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  DateTime? _startdate;
  DateTime? _enddate;
  List<DocumentSnapshot> _saleslist = [];
  double _totalamount = 0;
  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  //for date Picking
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context, firstDate: DateTime(2025), lastDate: DateTime(2030));
    if (picked != null) {
      setState(() {
        _startdate = picked.start;
        _enddate = picked.end;
      });
      _fetchsales();
    }
  }

  //to get data from sales firebase
  Future<void> _fetchsales() async {
    final snapshot = await FirebaseFirestore.instance.collection('Sales').get();
    final List<DocumentSnapshot> filtered = snapshot.docs.where((doc) {
      final dateString = doc['Date'] ?? '';
      try {
        final docDate = _formatter.parse(dateString);
        // If no date filter is applied, show all
        if (_startdate == null || _enddate == null) {
          return true;
        }
        return _startdate != null &&
            _enddate != null &&
            docDate.isAfter(_startdate!.subtract(Duration(days: 1))) &&
            docDate.isBefore(_enddate!.add(Duration(days: 1)));
      } catch (_) {
        return false;
      }
    }).toList();
    double sum = 0.0;
    for (var doc in filtered) {
      try {
        final amount = double.tryParse(doc['Total Amount'] ?? 0.0) ?? 0;
        sum += amount;
      } catch (_) {}
    }
    setState(() {
      _saleslist = filtered;
      _totalamount = sum;
    });
  }

  void initState() {
    super.initState();
    _fetchsales(); // Load all sales at first
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: Colors.black,
            )),
        title: Text(
          "All Recieved Payments",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 80.h,
            color: Colors.blueGrey[100],
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          "From",
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(
                              _startdate != null
                                  ? _formatter.format(_startdate!)
                                  : 'Select',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 8.h),
                  child: Icon(
                    Icons.arrow_right_alt,
                    size: 40.sp,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          "To",
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(
                              _enddate != null
                                  ? _formatter.format(_enddate!)
                                  : 'Select',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 10.h),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _startdate = null;
                        _enddate = null;
                      });
                      _fetchsales();
                    },
                    child: Text(
                      "Cancel Filter",
                      style: GoogleFonts.workSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 600.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          "Total Amount",
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 200.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text(
                            _totalamount.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 40.h,
            color: Colors.blueGrey[300],
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    "Date",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 100.w),
                  child: Text(
                    "Customer Name",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 240.w),
                  child: Text(
                    "Invoice#",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 80.w),
                  child: Text(
                    "INV Amount",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 80.w),
                  child: Text(
                    "VAT",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 80.w),
                  child: Text(
                    "Total Amount",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _saleslist.length,
                itemBuilder: (BuildContext context, int index) {
                  var sales = _saleslist[index];
                  return Container(
                    width: double.infinity,
                    height: 40.h,
                    color: index % 2 == 0 ? Colors.blueGrey[100] : Colors.white,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: SizedBox(
                              width: 125.w,
                              child: Text(
                                sales['Date'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: SizedBox(
                              width: 380.w,
                              child: Text(
                                sales['Customer Name'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                sales['Invoice Number'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 80.w),
                            child: SizedBox(
                              width: 130.w,
                              child: Text(
                                sales['Invoice Amount'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 60.w),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                sales['Tax'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: SizedBox(
                              width: 150.w,
                              child: Text(
                                sales['Total Amount'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
