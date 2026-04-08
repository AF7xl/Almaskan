import 'dart:io';
import 'dart:typed_data';
import 'package:almaskan/ui/Quotationpdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Payslippdf extends StatefulWidget {
  final String employeeName;
  final String address;
  final String job;
  final String companyId;
  final String month;
  final String employeeNo;
  final String payFrom;
  final String payTo;
  final List<Map<String, dynamic>> earnings;
  final List<Map<String, dynamic>> deductions;
  final double totalEarnings;
  final double totalDeductions;
  final double netPay;
  final String loanBalance;
  final String paymentMethod;
  final String selectedCompany;

  Payslippdf(
      {super.key,
      required this.employeeName,
      required this.address,
      required this.job,
      required this.companyId,
      required this.month,
      required this.employeeNo,
      required this.payFrom,
      required this.payTo,
      required this.earnings,
      required this.deductions,
      required this.totalEarnings,
      required this.totalDeductions,
      required this.netPay,
      required this.loanBalance,
      required this.paymentMethod,
      required this.selectedCompany});

  @override
  State<Payslippdf> createState() => _PayslippdfState();
}

class _PayslippdfState extends State<Payslippdf> {
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
        fontSize: 22.sp, fontWeight: pw.FontWeight.bold, letterSpacing: 1);
    final companyStyle = pw.TextStyle(
        fontSize: 12.sp,
        color: PdfColor.fromInt(0xFFC62828),
        fontWeight: pw.FontWeight.bold);
    final smallStyle =
        pw.TextStyle(fontSize: 9.sp, color: PdfColor.fromInt(0xFFC62828));
    pw.Widget buildCompanyDetails() {
      if (widget.selectedCompany == 'Al Maskan') {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('PAYSLIP', style: headerStyle),
            pw.SizedBox(height: 6.h),
            pw.Text('AL MASKAN PLASTER & TILE CONTRACTING',
                style: companyStyle),
            pw.SizedBox(height: 2.h),
            pw.Text('Sharjah - UAE', style: smallStyle),
            pw.Text('almaskandecor@gmail.com', style: smallStyle),
          ],
        );
      } else {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('PAYSLIP', style: headerStyle),
            pw.SizedBox(height: 6.h),
            pw.Text('REYAH AL MASKAN TECHNICAL SERVICES L.L.C',
                style: companyStyle),
            pw.SizedBox(height: 2.h),
            pw.Text('Dubai - UAE', style: smallStyle),
            pw.Text('reyahalmaskan@gmail.com', style: smallStyle),
          ],
        );
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header row with left text and logo on right
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: buildCompanyDetails()
                  ),
                  // logo
                  pw.Container(
                    width: 150.w,
                    height: 80.h,
                    child: pw.Image(logoImage, fit: pw.BoxFit.fill),
                  ),
                ],
              ),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.h)),
              ),
              pw.SizedBox(height: 2.h),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.h)),
              ),
              pw.SizedBox(height: 15.h),

              // Employee info box (table-like)

              //1
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 2.w),
                      width: 450.w,
                      height: 25.h,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: .5.w,
                        ),
                      ),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "EMPLOYEE NAME",
                              style: pw.TextStyle(
                                color: PdfColors.grey,
                                fontSize: 6.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            pw.Text(
                              widget.employeeName,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 2.w),
                      width: 100.w,
                      height: 25.h,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: .5.w,
                        ),
                      ),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "COMPANY ID NO",
                              style: pw.TextStyle(
                                color: PdfColors.grey,
                                fontSize: 6.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            pw.Text(
                              widget.companyId,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ]),
                    ),
                  ]),
              pw.SizedBox(height: 15.h),
              //2
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 2.w),
                      width: 350.w,
                      height: 25.h,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: .5.w,
                        ),
                      ),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "ADDRESS",
                              style: pw.TextStyle(
                                color: PdfColors.grey,
                                fontSize: 6.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            pw.Text(
                              widget.address,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ]),
                    ),
                    pw.Container(
                      // Applies the border to the Container
                      decoration: pw.BoxDecoration(
                          border: pw.Border.fromBorderSide(
                        pw.BorderSide(
                          color: PdfColors
                              .black, // Assuming a black or dark border
                          width: .5.w,
                        ),
                      )),
                      // Gives some internal spacing

                      width: 100.w, // You can adjust the width as needed
                      height: 25.h,
                      // Using a Column to stack the "EMPLOYEE" label and the name
                      child: pw.Column(
                        children: [
                          // 1. The "EMPLOYEE" label
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(
                              'MONTH',
                              style: pw.TextStyle(
                                // Adjust color and size to mimic the image's lighter, smaller text
                                color: PdfColors.grey,
                                fontSize: 6.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          pw.Container(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 0.8.h)),
                          ),
                          // 2. The main name text
                          pw.Padding(
                            padding: pw.EdgeInsets.only(
                                top: 5.h), // Small gap between the lines
                            child: pw.Text(
                              widget.month,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 2.w),
                      width: 100.w,
                      height: 25.h,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: .5.w,
                        ),
                      ),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "EMPLOYEE NO",
                              style: pw.TextStyle(
                                color: PdfColors.grey,
                                fontSize: 6.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            pw.Text(
                              widget.employeeNo,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ]),
                    ),
                  ]),

              // pw.Padding(
              //   padding: pw.EdgeInsets.only(left: 360.w, top: 3.h, bottom: 3.h),
              //   child: pw.Text(
              //     'PAY MONTH',
              //     style: pw.TextStyle(
              //       // Adjust color and size to mimic the image's lighter, smaller text
              //       color: PdfColors.grey,
              //       fontSize: 6.sp,
              //       fontWeight: pw.FontWeight.bold,
              //       letterSpacing: 0.5,
              //     ),
              //   ),
              // ),

              //3
              pw.SizedBox(height: 15.h),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 2.w),
                      width: 350.w,
                      height: 25.h,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: .5.w,
                        ),
                      ),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "JOB",
                              style: pw.TextStyle(
                                color: PdfColors.grey,
                                fontSize: 6.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            pw.Text(
                              widget.job,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ]),
                    ),
                    pw.Container(
                      // Applies the border to the Container
                      decoration: pw.BoxDecoration(
                          border: pw.Border.fromBorderSide(
                        pw.BorderSide(
                          color: PdfColors
                              .black, // Assuming a black or dark border
                          width: .5.w,
                        ),
                      )),
                      // Gives some internal spacing

                      width: 100.w, //  You can adjust the width as needed
                      height: 25.h,
                      // Using a Column to stack the "EMPLOYEE" label and the name
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment
                            .spaceEvenly, // Align text to the start (left)
                        children: [
                          // 1. The "EMPLOYEE" label
                          pw.Padding(
                            padding: pw.EdgeInsets.all(2.3.h),
                            child: pw.Text(
                              widget.payFrom,
                              style: pw.TextStyle(
                                // Adjust color and size to mimic the image's lighter, smaller text
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          pw.Container(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 0.8.h)),
                          ),
                          // 2. The main name text
                          pw.Padding(
                            padding: pw.EdgeInsets.all(
                                2.3.h), // Small gap between the lines
                            child: pw.Text(
                              widget.payTo,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 12.sp,
                                fontWeight: pw.FontWeight
                                    .bold, // Name often appears bolder
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 100.w,
                          height: 25.h,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: PdfColors.black,
                              width: .5.w,
                            ),
                          ),
                          child: pw.Text(
                            widget.companyId,
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 12.sp,
                              fontWeight: pw
                                  .FontWeight.bold, // Name often appears bolder
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),

              pw.SizedBox(height: 15.h),

              // Earnings table header
              //1

              pw.SizedBox(height: 6.h),
              pw.Container(
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.w)),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Text('EARNINGS',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                color: PdfColors.blue,
                                fontWeight: pw.FontWeight.bold))),
                    pw.Container(
                        width: 120.w,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text('TOTAL',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                color: PdfColors.blue,
                                fontWeight: pw.FontWeight.bold))),
                  ],
                ),
              ),
              // Earnings table container
              pw.Container(
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.w)),
                child: pw.Column(
                  children: [
                    // Table rows
                    pw.ListView.builder(
                      itemCount: (widget.earnings.length < 12
                          ? 12
                          : widget.earnings
                              .length), // keep some rows for blank lines
                      itemBuilder: (context, i) {
                        if (i < widget.earnings.length) {
                          final e = widget.earnings[i];
                          return pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 6.h),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                    child: pw.Text(e['earnings'] ?? '',
                                        style: smallStyle.copyWith(
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold))),
                                pw.Container(
                                    width: 120.w,
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text(
                                        (e['amount'] != null)
                                            ? e['amount'].toString()
                                            : '-',
                                        style: smallStyle.copyWith(
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold))),
                              ],
                            ),
                          );
                        } else {
                          // empty row
                          return pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 6.h),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            color: PdfColors.black))),
                                pw.Container(
                                    width: 120.w,
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            color: PdfColors.black))),
                              ],
                            ),
                          );
                        }
                      },
                      // constrain height: let parent manage

                      // shrinkWrap: true not available -> ListView.builder here is pdf internal
                    ),

                    pw.Divider(),

                    // Totals row
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 6.h),
                      child: pw.Row(
                        children: [
                          pw.Expanded(child: pw.Container()), // spacer
                          pw.Container(
                              width: 120.w,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text('Total Payments',
                                  style: smallStyle.copyWith(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black))),
                          pw.SizedBox(width: 6.w),
                          pw.Container(
                              width: 80.w,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(widget.totalEarnings.toString(),
                                  style: smallStyle.copyWith(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 12.h),

              // DEDUCTIONS header

              pw.SizedBox(height: 6.h),
              pw.Container(
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.w)),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Text('DEDUCTIONS',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                color: PdfColor.fromInt(0xFFC62828),
                                fontWeight: pw.FontWeight.bold))),
                    pw.Container(
                        width: 120.w,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text('TOTAL',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFFC62828)))),
                  ],
                ),
              ),

              // Deductions table
              pw.Container(
                decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.w)),
                child: pw.Column(
                  children: [
                    pw.ListView.builder(
                      itemCount: (widget.deductions.length < 8
                          ? 8
                          : widget.deductions.length),
                      itemBuilder: (context, i) {
                        if (i < widget.deductions.length) {
                          final d = widget.deductions[i];
                          return pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 6.h),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                    child: pw.Text(d['dedection'] ?? '',
                                        style: smallStyle.copyWith(
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold))),
                                pw.Container(
                                    width: 120.w,
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text(
                                        (d['amount2'] != null)
                                            ? d['amount2'].toString()
                                            : '-',
                                        style: smallStyle.copyWith(
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.bold))),
                              ],
                            ),
                          );
                        } else {
                          return pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 6.h),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            color: PdfColors.black))),
                                pw.Container(
                                    width: 120.w,
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            color: PdfColors.black))),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    pw.Divider(),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 6.h),
                      child: pw.Row(
                        children: [
                          pw.Expanded(child: pw.Container()), // spacer
                          pw.Container(
                              width: 120.w,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text('Total Deductions',
                                  style: smallStyle.copyWith(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black))),
                          pw.SizedBox(width: 6.w),
                          pw.Container(
                              width: 80.w,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(widget.totalDeductions.toString(),
                                  style: smallStyle.copyWith(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 12.h),

              // Net Pay + other info
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Other information',
                              style: pw.TextStyle(
                                  fontSize: 9.sp, color: PdfColors.black)),
                          pw.SizedBox(height: 4.h),
                          pw.Text('LOAN BALANCE : ${widget.loanBalance}',
                              style: smallStyle.copyWith(
                                color: PdfColor.fromInt(0xFFC62828),
                              )),
                          pw.SizedBox(height: 4.h),
                          pw.Text('Payment Method',
                              style: pw.TextStyle(
                                  fontSize: 9.sp, color: PdfColors.black)),
                          pw.SizedBox(height: 4.h),
                          pw.Text(widget.paymentMethod,
                              style: pw.TextStyle(
                                  fontSize: 9.sp, color: PdfColors.black)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        padding: pw.EdgeInsets.only(left: 10.w),
                        child: pw.Container(
                          color: PdfColors.grey300,
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.SizedBox(width: 20.w),
                              pw.Text('NET PAY',
                                  style: pw.TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromInt(0xFFC62828))),
                              pw.SizedBox(width: 20.w),
                              pw.Text(widget.netPay.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromInt(0xFFC62828))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),

              pw.Spacer(),

              // Signature lines
              pw.Row(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                    child: pw.Column(
                      children: [
                        pw.Container(
                            width: 300.w, height: 1.h, color: PdfColors.black),
                        pw.SizedBox(height: 6.h),
                        pw.Text('Signature of Employee',
                            style: smallStyle.copyWith(color: PdfColors.black)),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                    child: pw.Column(
                      children: [
                        pw.Container(
                            width: 300.w, height: 1.h, color: PdfColors.black),
                        pw.SizedBox(height: 6.h),
                        pw.Text('Signature of Employer',
                            style: smallStyle.copyWith(color: PdfColors.black)),
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
          'Payslip PDF Preview',
          style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: IconButton(
              icon: Icon(Icons.download, size: 25.sp, color: Colors.white),
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
