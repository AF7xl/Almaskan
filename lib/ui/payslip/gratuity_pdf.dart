import 'dart:io';
import 'package:almaskan/ui/Quotationpdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Gratuitypdf extends StatefulWidget {
  final String employeeName;
  final String joindate;
  final String designation;
  final String dateofresign;
  final String department;
  final String dateofleaving;
  final String dateofjoinservice;
  final String dateofexit;
  final double totalnoofdays;
  final double lastbasicpay;
  final double lastda;
  final double noofdays;
  final String totalserviceperiod;
  final double total;
  final String month;
  final double monthsalary;
  final double subtotal;
  final double loandeduction;
  final double topay;

  const Gratuitypdf({
    super.key,
    required this.employeeName,
    required this.joindate,
    required this.designation,
    required this.dateofresign,
    required this.department,
    required this.dateofleaving,
    required this.dateofjoinservice,
    required this.dateofexit,
    required this.totalnoofdays,
    required this.lastbasicpay,
    required this.lastda,
    required this.noofdays,
    required this.totalserviceperiod,
    required this.total,
    required this.month,
    required this.monthsalary,
    required this.subtotal,
    required this.loandeduction,
    required this.topay,
  });

  @override
  State<Gratuitypdf> createState() => _GratuitypdfState();
}

class _GratuitypdfState extends State<Gratuitypdf> {
  String? pdfFilePath;
  List<int>? bytes;

  @override
  void initState() {
    super.initState();
    generatePayslipPdf().then((path) {
      setState(() {
        pdfFilePath = path;
      });
    });
  }

  Future<String> generatePayslipPdf() async {
    final pdf = pw.Document();

    // load logo from assets
    final Uint8List logoData = await rootBundle
        .load('assets/logo1.png')
        .then((bd) => bd.buffer.asUint8List());
    final pw.MemoryImage logoImage = pw.MemoryImage(logoData);

    // page style variables
    final headerStyle = pw.TextStyle(
        fontSize: 15.sp,
        fontWeight: pw.FontWeight.bold,
        color: const PdfColor.fromInt(0xFFC62828));

    final smallStyle = pw.TextStyle(fontSize: 9.sp, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'SETTLEMENT SATEMENT',
                      style: pw.TextStyle(
                        fontSize: 14.sp,
                        color: PdfColors.black,
                      ),
                    ),
                  )
                ],
              ),
              pw.Container(height: 1.5.h, color: PdfColors.black),
              // Header row with left text and logo on right
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 5),
                        pw.Text('AL MASKAN PLASTER & TILE CONTRACTING',
                            style: headerStyle),
                        pw.SizedBox(height: 5.h),
                        pw.Text('[Sharjah - UAE]',
                            style: smallStyle.copyWith(
                                color: const PdfColor.fromInt(0xFFC62828))),
                        pw.SizedBox(height: 3.h),
                        pw.Text('[almaskandecor@gmail.com]',
                            style: smallStyle.copyWith(
                                color: const PdfColor.fromInt(0xFFC62828))),
                        pw.SizedBox(height: 3.h),
                        pw.Text('[almaskandecor.in]',
                            style: smallStyle.copyWith(
                                color: const PdfColor.fromInt(0xFFC62828))),
                      ],
                    ),
                  ),
                  // logo
                  pw.Container(
                    width: 150.w,
                    height: 80.h,
                    child: pw.Image(logoImage, fit: pw.BoxFit.fill),
                  ),
                ],
              ),

              // Employee info box (table-like)
              pw.Container(
                child: pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(3),
                    1: pw.FlexColumnWidth(5),
                    2: pw.FlexColumnWidth(2),
                    3: pw.FlexColumnWidth(2),
                  },
                  border:
                      pw.TableBorder.all(color: PdfColors.black, width: 0.5.h),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Employee Name',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child:
                              pw.Text(widget.employeeName, style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Joining Date',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.joindate, style: smallStyle)),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Designation',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child:
                              pw.Text(widget.designation, style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Date of Resignation',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.dateofjoinservice,
                              style: smallStyle.copyWith(
                                  color: const PdfColor.fromInt(0xFFC62828)))),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Department',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.department, style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Date of Leaving',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child:
                              pw.Text(widget.dateofleaving, style: smallStyle)),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Date of Joining service',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.dateofjoinservice,
                              style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Date of Exit',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.dateofexit, style: smallStyle)),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Total No of Days',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.totalnoofdays.toString(),
                              style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Last Basic Pay(At Exit)',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.lastbasicpay.toString(),
                              style: smallStyle)),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Last DA(At Exit)',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.lastda.toString(), style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('No of Days',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.noofdays.toString(),
                              style: smallStyle)),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('Total service Period',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.totalserviceperiod,
                              style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('TOTAL',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12.sp))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.total.toString(),
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12.sp))),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('${widget.month} SALARY',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.month, style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('SUB TOTAL',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.subtotal.toString(),
                              style: smallStyle)),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('LOANDEDUCTION',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.loandeduction.toString(),
                              style: smallStyle)),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text('TO PAY',
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: const PdfColor.fromInt(0xFFC62828)))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(widget.topay.toString(),
                              style: smallStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: const PdfColor.fromInt(0xFFC62828)))),
                    ]),
                  ],
                ),
              ),
              //1
              pw.Container(
                // Optional: Add some padding or margin around the table

                child: pw.Table.fromTextArray(
                  // Border styles for all borders
                  border:
                      pw.TableBorder.all(color: PdfColors.black, width: .5.h),
                  cellPadding:
                      pw.EdgeInsets.only(bottom: 40.h, top: 2.h, left: 2.w),
                  headerPadding: const pw.EdgeInsets.all(5),

                  // Column widths to distribute space
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1.5), // Prepared By
                    1: const pw.FlexColumnWidth(1.5), // Verified By
                    2: const pw.FlexColumnWidth(
                        2.0), // Approved By (A bit wider)
                  },

                  // The header row
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10.sp,
                    color: PdfColors.black,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors
                        .grey200, // Light grey background for the header
                  ),

                  // The data (body) row style
                  cellStyle: pw.TextStyle(
                    fontSize: 10.sp,
                  ),

                  // Alignment for all cells (can be adjusted per cell if needed)
                  cellAlignments: {
                    0: pw.Alignment.topLeft,
                    1: pw.Alignment.topLeft,
                    2: pw.Alignment.topLeft,
                  },

                  // The actual table data
                  data: <List<String>>[
                    // Header Row
                    <String>['Prepared By', 'Verified By', 'Approved By'],

                    // Data Row
                    <String>[
                      'Suhaib\nPoozhithara',
                      'MD_Mohammed\nShafi',
                      'Co-Founder_Shahul Hameed',
                    ],
                  ],
                ),
              ),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    textAlign: pw.TextAlign.center,
                    'Declaration',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14.sp,
                        color: PdfColors.black,
                        decoration: pw.TextDecoration.underline),
                  ),
                ),
              ]),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.h)),
              ),
              pw.SizedBox(height: 4.h),
              pw.Stack(children: [
                pw.Wrap(children: [
                  pw.Text(
                    'I received leave salary of my account with the company and confirm that nothing is due from al maskan plaster & tile contracting',
                    style: pw.TextStyle(
                      lineSpacing: 2.h,
                      fontSize: 13.sp,
                    ),
                  ),
                  pw.SizedBox(
                    width: 190.w,
                  ),
                  pw.Container(
                    width: 100.w,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                            color: PdfColors.black, width: 0.8.h)),
                  ),
                  pw.SizedBox(width: 80.w),
                ]),
                pw.Positioned(
                  top: 20.h,
                  left: 400.w,
                  child: pw.Row(children: [
                    pw.Text(
                      'Name: ',
                      style: pw.TextStyle(
                        fontSize: 13.sp,
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(top: 7.h),
                      child: pw.Container(
                        width: 130.w,
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                                color: PdfColors.black, width: 0.8.h)),
                      ),
                    )
                  ]),
                ),
              ]),
              pw.SizedBox(height: 40.h), 

              // Signature lines
           
               pw.Row(

                  children: [
                    pw.Container(
                      width: 100.w,
                      child: pw.Row(
                        children: [
                          pw.Text('Date: ',
                              style: smallStyle.copyWith(
                                  color: PdfColors.black, fontSize: 10.sp)),
                          pw.Padding(
                            padding: pw.EdgeInsets.only(top: 8.h),
                            child: pw.Container(
                                width: 100.w,
                                height: 1.h,
                                color: PdfColors.black),
                          )
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 350.w,),  
                    pw.Container(
                      width: 100.w,
                      child: pw.Row(
                        children: [
                          pw.Text('Sign:',
                              style: smallStyle.copyWith(
                                  color: PdfColors.black, fontSize: 10.sp)),
                          pw.Padding(
                            padding: pw.EdgeInsets.only(top: 8.h),
                            child: pw.Container(
                                width: 100.w,
                                height: 1.h,
                                color: PdfColors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/payslip_preview.pdf';
    bytes = await pdf.save();
    final file = File(filePath);
    await file.writeAsBytes(bytes!);
    return filePath;
  }

  Future<void> _saveFile() async {
    final TextEditingController fileNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter File Name'),
        content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(hintText: 'File name ')),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Save')),
        ],
      ),
    );

    final fileName = fileNameController.text;
    if (fileName.isNotEmpty) {
      final fileNameWithExtension =
          fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';
      await InvoicePdfPreviewPage.save(bytes!, fileNameWithExtension);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File name cannot be empty')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: const Text('Gratuity PDF Preview'), 
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: IconButton(
              icon: Icon(Icons.download, size: 25.sp, color: Colors.black),
              onPressed: _saveFile,
            ),
          ),
        ],
      ),
      body: pdfFilePath == null
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(File(pdfFilePath!)),
    );
  }
}
