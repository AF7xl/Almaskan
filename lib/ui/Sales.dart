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
            padding: pw.EdgeInsets.only(top: 40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("AL MASKAN PLASTER & TILE CONT L.L.C.SP",
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 3),
                pw.Text("Industrial-8", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("Sharjah", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("United Arab Emirates",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("TRN 100342182100003",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("0508089505", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("almaskandecor@gmail.com",
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ));
      } else {
        return pw.Padding(
            padding: pw.EdgeInsets.only(top: 40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("REYAH AL MASKAN TECHNICAL SERVICES L.L.C",
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 3),
                pw.Text("Dubai", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("United Arab Emirates",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("TRN 100342182100003",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("0508089505", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("reyahalmaskan@gmail.com",
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ));
      }
    }
    final formattedtotalAmount = NumberFormat("#,##0.00", "en_US")
        .format(double.tryParse(salesData['Total Amount'].toString()) ?? 0);
    final formattedinvoiceAmount = NumberFormat("#,##0.00", "en_US")
        .format(double.tryParse(salesData['Invoice Amount'].toString()) ?? 0);

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
                      padding: pw.EdgeInsets.only(top: 20, left: 15),
                      child: pw.Container(
                          width: 180, height: 180, child: pw.Image(image1))),
                  pw.SizedBox(width: 10),
                  buildCompanyDetails()
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(
                  endIndent: 25,
                  indent: 25,
                  thickness: 1.5,
                  color: PdfColors.grey),
              pw.SizedBox(height: 25),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 230),
                  child: pw.Text("PAYMENT RECEIPT",
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColors.black,
                          decoration: pw.TextDecoration.underline))),
              pw.SizedBox(height: 35),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Text("Payment Date",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black,
                                        fontSize: 12))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 65),
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(salesData["Date"],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                              fontSize: 10)),
                                      pw.Container(
                                          width: 200,
                                          height: 0.5,
                                          color: PdfColors.grey300)
                                    ]))
                          ]),
                          pw.SizedBox(height: 20),
                          pw.Row(children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Text("Reference Number",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black,
                                        fontSize: 12))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                              fontSize: 10)),
                                      pw.Container(
                                          width: 200,
                                          height: 0.5,
                                          color: PdfColors.grey300)
                                    ]))
                          ]),
                          pw.SizedBox(height: 20),
                          pw.Row(children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Text("Payment Mode",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black,
                                        fontSize: 12))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 60),
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(salesData['Payment Type'],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                              fontSize: 10)),
                                      pw.Container(
                                          width: 200,
                                          height: 0.5,
                                          color: PdfColors.grey300)
                                    ]))
                          ])
                        ]),
                    pw.SizedBox(width: 20),
                    pw.Container(
                        width: 120.w,
                        height: 70.w,
                        color: PdfColor.fromInt(0xFF7BC36A),
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 20, top: 20),
                                child: pw.Text("Amount Received",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 10,
                                        color: PdfColors.white)),
                              ),
                              pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 20, top: 4),
                                  child: pw.Text(
                                      "AED${formattedtotalAmount}",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 14,
                                          color: PdfColors.white)))
                            ]))
                  ]),
              pw.SizedBox(height: 60),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40),
                  child: pw.Text("Received From",
                      style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey))),
              pw.SizedBox(height: 10),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(salesData['Customer Name'],
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.SizedBox(height: 2),
                        pw.Text(salesData['Project'],
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10)),
                        pw.SizedBox(height: 2),
                        pw.Text(salesData['Emirate'],
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10)),
                        pw.SizedBox(height: 2),
                        pw.Text("United Arab Emirates",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10)),
                        pw.SizedBox(height: 2)
                      ])),
              pw.SizedBox(height: 60),
              pw.Divider(color: PdfColors.grey),
              pw.SizedBox(height: 40),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40),
                  child: pw.Text("Payment for",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                          color: PdfColors.black))),
              pw.SizedBox(height: 15),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40),
                  child: pw.Container(
                      height: 20,
                      width: double.infinity,
                      color: PdfColors.grey400,
                      child: pw.Row(children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.only(left: 6),
                            child: pw.Container(
                                width: 90,
                                child: pw.Text("Invoice Number",
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)))),
                        pw.SizedBox(width: 25),
                        pw.Container(
                            width: 90,
                            child: pw.Text("Invoice Date",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 50),
                        pw.Container(
                            width: 110,
                            child: pw.Text("Invoice Amount",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 25),
                        pw.Container(
                            width: 110,
                            child: pw.Text("Payment Amount",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black)))
                      ]))),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 40, top: 10),
                  child: pw.Container(
                      height: 20,
                      width: double.infinity,
                      color: PdfColors.white,
                      child: pw.Row(children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.only(left: 6),
                            child: pw.Container(
                                width: 90,
                                child: pw.Text(salesData['Invoice Number'],
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)))),
                        pw.SizedBox(width: 25),
                        pw.Container(
                            width: 90,
                            child: pw.Text(salesData['Date'],
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 50),
                        pw.Container(
                            width: 110,
                            child: pw.Text(formattedinvoiceAmount,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black))),
                        pw.SizedBox(width: 25),
                        pw.Container(
                            width: 110,
                            child: pw.Text(formattedtotalAmount,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black)))
                      ]))),
              pw.Divider(indent: 40, color: PdfColors.grey400),
              pw.SizedBox(height: 60),
              pw.Divider(color: PdfColors.grey)
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
                  padding: EdgeInsets.only(left: 15.w),
                  child: SizedBox(width: 125.w,
                    child: Text(
                      "Date",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: SizedBox(width: 360.w,
                    child: Text(
                      "Customer Name",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: SizedBox(width: 100.w,
                    child: Text(
                      "Invoice#",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: SizedBox(width: 130.w,
                    child: Text(
                      "INV Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 65.w),
                  child: SizedBox(width: 150.w,
                    child: Text(
                      "Total Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
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
                    color: index % 2 == 0 ? Colors.blueGrey[100] : Colors.white,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child:  SizedBox(
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
                            child:  SizedBox(
                              width: 360.w,
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
                            padding: EdgeInsets.only(left: 25.w),
                            child:  SizedBox(
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
                            padding: EdgeInsets.only(left: 60.w),
                            child:  SizedBox(
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
                            padding: EdgeInsets.only(left: 65.w),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 15.sp,
                                ),
                                onSelected: (value) async {
                                  if (value == 'download') {
                                    final selectedCompany =
                                        await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Select Company"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text("Al Maskan"),
                                                onTap: () => Navigator.pop(
                                                    context, 'al_maskan'),
                                              ),
                                              ListTile(
                                                title: Text("Reyah Almaskan"),
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
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Text("Download Reciept Voucher"),
                                        value: 'download',
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
