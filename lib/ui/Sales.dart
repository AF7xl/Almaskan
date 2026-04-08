import 'package:almaskan/ui/sales_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  Future<void> _deleteSale(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Receipt",  style: GoogleFonts.poppins(color: Colors.black),),
        content: Text(
          "Are you sure you want to delete this receipt voucher?\nThis action cannot be undone.",
            style: GoogleFonts.poppins(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828)),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Delete",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('Sales').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Receipt voucher deleted",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFC62828),
        ),
      );

      _fetchsales(); // refresh list
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

  // pdf for creating reciept voucher
  Future<void> _generateReceiptPDF(
      Map<String, dynamic> salesData, String selectedCompany) async {
    final pdf = pw.Document();
    final image1 = pw.MemoryImage(
      (await rootBundle.load('assets/Logo.png')).buffer.asUint8List(),
    );
    pw.Widget buildCompanyDetails() {
      if (selectedCompany == 'al_maskan') {
        return pw.Padding(
            padding: pw.EdgeInsets.only(top: 40.h),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("AL MASKAN PLASTER & TILE CONT",
                    style: pw.TextStyle(
                        fontSize: 10.sp, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 3.h),
                pw.Text("Industrial-8", style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("Sharjah", style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("United Arab Emirates",
                    style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("TRN 100342182100003",
                    style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("0508089505", style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("almaskandecor@gmail.com",
                    style: pw.TextStyle(fontSize: 10.sp)),
              ],
            ));
      } else {
        return pw.Padding(
            padding: pw.EdgeInsets.only(top: 40.h),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("REYAH AL MASKAN TECHNICAL SERVICES L.L.C",
                    style: pw.TextStyle(
                        fontSize: 10.sp, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 3.h),
                pw.Text("Dubai", style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("United Arab Emirates",
                    style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("TRN 100342182100003",
                    style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("0508089505", style: pw.TextStyle(fontSize: 10.sp)),
                pw.SizedBox(height: 3.h),
                pw.Text("reyahalmaskan@gmail.com",
                    style: pw.TextStyle(fontSize: 10.sp)),
              ],
            ));
      }
    }
// 🔍 Debug first (optional but helpful)
print("PDF DATA: $salesData");

// ✅ Safe parsing
double totalAmount = double.tryParse(
      salesData['Total Amount']
              ?.toString()
              .replaceAll(',', '')
              .trim() ??
          '0',
    ) ??
    0.0;

double invoiceAmount = double.tryParse(
      salesData['Invoice Amount']
              ?.toString()
              .replaceAll(',', '')
              .trim() ??
          '0',
    ) ??
    0.0;

// ✅ Format
final formattedtotalAmount =
    NumberFormat("#,##0.00", "en_US").format(totalAmount);

final formattedinvoiceAmount =
    NumberFormat("#,##0.00", "en_US").format(invoiceAmount);

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 20.h, left: 15.w),
                      child: pw.Container(
                          width: 180.w,
                          height: 180.h,
                          child: pw.Image(image1))),
                  pw.SizedBox(width: 10.w),
                  buildCompanyDetails()
                ],
              ),
              pw.SizedBox(height: 12.h),
              pw.Divider(
                  endIndent: 25,
                  indent: 25,
                  thickness: 1.5,
                  color: PdfColors.grey300),
              pw.SizedBox(height: 25.h),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 230.w),
                  child: pw.Text("PAYMENT RECEIPT",
                      style: pw.TextStyle(
                          fontSize: 13.sp,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColors.black,
                          decoration: pw.TextDecoration.underline))),
              pw.SizedBox(height: 35.sp),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40.w),
                                child: pw.Text("Payment Date",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.grey,
                                        fontSize: 12.sp))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 65.w),
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(salesData["Date"],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                              fontSize: 10.sp)),
                                      pw.Container(
                                          width: 200.w,
                                          height: 0.5.h,
                                          color: PdfColors.grey300)
                                    ]))
                          ]),
                          pw.SizedBox(height: 20.h),
                          pw.Row(children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40.w),
                                child: pw.Text("Payment Method",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.grey,
                                        fontSize: 12.sp))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40.w),
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(salesData["payment method"],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                              fontSize: 10.sp)),
                                      pw.Container(
                                          width: 200.w,
                                          height: 0.5.h,
                                          color: PdfColors.grey300)
                                    ]))
                          ]),
                          pw.SizedBox(height: 20.sp),
                          pw.Row(children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40.w),
                                child: pw.Text("Payment Mode",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.grey,
                                        fontSize: 12.sp))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 60.w),
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(salesData['Payment Type'],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                              fontSize: 10.sp)),
                                      pw.Container(
                                          width: 200.w,
                                          height: 0.5.h,
                                          color: PdfColors.grey300)
                                    ]))
                          ])
                        ]),
                    pw.SizedBox(width: 20.w),
                    pw.Container(
                        width: 120.w,
                        height: 70.w,
                        color: PdfColor.fromInt(0xFF7BC36A),
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                padding:
                                    pw.EdgeInsets.only(left: 20.w, top: 20.h),
                                child: pw.Text("Amount Received",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 10.sp,
                                        color: PdfColors.white)),
                              ),
                              pw.Padding(
                                  padding:
                                      pw.EdgeInsets.only(left: 20.w, top: 4.h),
                                  child: pw.Text("AED${formattedtotalAmount}",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 14.sp,
                                          color: PdfColors.white)))
                            ]))
                  ]),
              pw.SizedBox(height: 60.h),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40.w),
                  child: pw.Text("Received From",
                      style: pw.TextStyle(
                          fontSize: 10.sp,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey))),
              pw.SizedBox(height: 10.h),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40.w),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(salesData['Customer Name'],
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10.sp)),
                        pw.SizedBox(height: 2.h),
                        pw.Text(salesData['Project'],
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10.sp)),
                        pw.SizedBox(height: 2.h),
                        pw.Text(salesData['Emirate'],
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10.sp)),
                        pw.SizedBox(height: 2.h),
                        pw.Text("United Arab Emirates",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10.sp)),
                        pw.SizedBox(height: 2.h)
                      ])),
              pw.SizedBox(height: 60.h),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 40.h),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40.w),
                  child: pw.Text("Payment for",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12.sp,
                          color: PdfColors.black))),
              pw.SizedBox(height: 15.h),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40.w),
                  child: pw.Container(
                      height: 20.h,
                      width: double.infinity,
                      color: PdfColors.grey100,
                      child: pw.Row(children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.only(left: 6.w),
                            child: pw.Container(
                                width: 90.w,
                                child: pw.Text("Invoice Number",
                                    style: pw.TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)))),
                        pw.SizedBox(width: 25.w),
                        pw.Container(
                            width: 90.w,
                            child: pw.Text("Invoice Date",
                                style: pw.TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 50.w),
                        pw.Container(
                            width: 110.w,
                            child: pw.Text("Invoice Amount",
                                style: pw.TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 25.w),
                        pw.Container(
                            width: 110.w,
                            child: pw.Text("Payment Amount",
                                style: pw.TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black)))
                      ]))),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40.w, top: 10.h),
                  child: pw.Container(
                      height: 20.h,
                      width: double.infinity,
                      color: PdfColors.white,
                      child: pw.Row(children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.only(left: 6.w),
                            child: pw.Container(
                                width: 90.w,
                                child: pw.Text(salesData['Invoice Number'],
                                    style: pw.TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)))),
                        pw.SizedBox(width: 25.w),
                        pw.Container(
                            width: 90.w,
                            child: pw.Text(salesData['Date'],
                                style: pw.TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 50.w),
                        pw.Container(
                            width: 110.w,
                            child: pw.Text(formattedinvoiceAmount,
                                style: pw.TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 25.w),
                        pw.Container(
                            width: 110.w,
                            child: pw.Text(formattedtotalAmount,
                                style: pw.TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black)))
                      ]))),
              pw.Divider(indent: 40, color: PdfColors.grey300),
              pw.SizedBox(height: 60.h),
              pw.Divider(color: PdfColors.grey300)
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC62828),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: Colors.white,
            )),
        title: Text(
          "All Recieved Payments",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 80.h,
            color: const Color.fromARGB(255, 223, 163, 163),
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
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              _startdate != null
                                  ? _formatter.format(_startdate!)
                                  : 'Select',
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.white),
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
                    color: Colors.white,
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
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              _enddate != null
                                  ? _formatter.format(_enddate!)
                                  : 'Select',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp, color: Colors.white),
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
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
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
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 200.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.white)),
                        child: Center(
                          child: Text(
                            _totalamount.toStringAsFixed(2),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
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
            color: const Color(0xFFC62828),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      "Date",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: SizedBox(
                    width: 360.w,
                    child: Text(
                      "Customer Name",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: SizedBox(
                    width: 100.w,
                    child: Text(
                      "Invoice#",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: SizedBox(
                    width: 130.w,
                    child: Text(
                      "INV Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65.w),
                  child: SizedBox(
                    width: 150.w,
                    child: Text(
                      "Total Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.white),
                    ),
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
                    color: index % 2 == 0
                        ? const Color.fromARGB(255, 223, 163, 163)
                        : Colors.white,
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
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: SizedBox(
                              width: 360.w,
                              child: Text(
                                sales['Customer Name'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.w),
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                sales['Invoice Number'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 60.w),
                            child: SizedBox(
                              width: 130.w,
                              child: Text(
                                sales['Invoice Amount'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 65.w),
                            child: SizedBox(
                              width: 150.w,
                              child: Text(
                                sales['Total Amount'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 15.sp,
                                  color: Colors.white,
                                ),
                                onSelected: (value) async {
                                  final docId = sales.id;

                                  if (value == 'delete') {
                                    await _deleteSale(docId);
                                  }

                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditSalesPage(
                                          docId: docId,
                                          salesData: sales.data()
                                              as Map<String, dynamic>,
                                        ),
                                      ),
                                    ).then((_) =>
                                        _fetchsales()); // refresh after edit
                                  }
                                  if (value == 'download') {
                                    final selectedCompany =
                                        await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Select Company",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  "Al Maskan",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black),
                                                ),
                                                onTap: () => Navigator.pop(
                                                    context, 'al_maskan'),
                                              ),
                                              ListTile(
                                                title: Text(
                                                  "Reyah Almaskan",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black),
                                                ),
                                                onTap: () => Navigator.pop(
                                                    context, 'reyah_almaskan'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    if (selectedCompany != null) {
                                      _generateReceiptPDF(
                                        sales.data() as Map<String, dynamic>,
                                        selectedCompany,
                                      );
                                    }
                                  }
                                },
                                offset: const Offset(0, 60),
                                itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'download',
                                        child: Text("Download Reciept Voucher"),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text("Edit Reciept Voucher"),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text("Delete Reciept Voucher"),
                                      )
                                    ]),
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
