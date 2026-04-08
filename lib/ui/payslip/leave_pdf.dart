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

class LeavePdf extends StatefulWidget {
  final String employeeName;
  final String dateofjoin;
  final String payperiod;
  final String designation;
  final String dateofexit;
  final String department;
  final List<Map<String, dynamic>> earnings;
  final List<Map<String, dynamic>> deductions;
  final double totalEarnings;
  final double totalDeductions;
  final double netPay;
  final String selectedCompany;

  const LeavePdf(
      {super.key,
      required this.employeeName,
      required this.earnings,
      required this.deductions,
      required this.totalEarnings,
      required this.totalDeductions,
      required this.netPay,
      required this.dateofjoin,
      required this.payperiod,
      required this.designation,
      required this.dateofexit,
      required this.department,
      required this.selectedCompany});

  @override
  State<LeavePdf> createState() => _LeavePdfState();
}

class _LeavePdfState extends State<LeavePdf> {
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

    final smallStyle =
        pw.TextStyle(fontSize: 9.sp, color: PdfColor.fromInt(0xFFC62828));

    pw.Widget buildCompanyDetails() {
      if (widget.selectedCompany == 'Al Maskan') {
        return pw.Column(
          children: [
            pw.SizedBox(height: 10.h),
            pw.Text('LEAVE SALARY',
                style: pw.TextStyle(
                    fontSize: 15.sp,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black)),
            pw.SizedBox(height: 6.h),
            pw.Text('AL MASKAN',
                style: pw.TextStyle(
                  fontSize: 10.sp,
                  color: PdfColors.black,
                )),
            pw.SizedBox(height: 6.h),
            pw.Text('PLASTER & TILE CONTRACTING',
                style: pw.TextStyle(
                  fontSize: 10.sp,
                  color: PdfColors.black,
                )),
          ],
        );
      } else {
        return pw.Column(
          children: [
            pw.SizedBox(height: 10.h),
            pw.Text('LEAVE SALARY',
                style: pw.TextStyle(
                    fontSize: 15.sp,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black)),
            pw.SizedBox(height: 6.h),
            pw.Text('REYAH AL MASKAN',
                style: pw.TextStyle(
                  fontSize: 10.sp,
                  color: PdfColors.black,
                )),
            pw.SizedBox(height: 6.h),
            pw.Text('TECHNICAL SERVICES L.L.C',
                style: pw.TextStyle(
                  fontSize: 10.sp,
                  color: PdfColors.black,
                )),
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
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 30.w,
                  ),
                  pw.Container(
                    width: 150.w,
                    height: 80.h,
                    child: pw.Image(logoImage, fit: pw.BoxFit.fill),
                  ),
                  pw.SizedBox(
                    width: 20.w,
                  ),
                  pw.Expanded(
                    child: buildCompanyDetails()
                  ),
                  // logo
                ],
              ),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1.h)),
              ),

              pw.SizedBox(height: 15.h),

// --- START OF THE ALIGNED WIDGET ---
              pw.Table(
                // Define column widths: Label | Colon | Value | Spacer | Label | Colon | Value
                columnWidths: {
                  0: pw.FlexColumnWidth(0.25.w), // Left Label
                  1: pw.FlexColumnWidth(0.02.w), // Colon
                  2: pw.FlexColumnWidth(0.23.w), // Left Value
                  3: pw.FlexColumnWidth(0.05.w), // Spacer between columns
                  4: pw.FlexColumnWidth(0.25.w), // Right Label
                  5: pw.FlexColumnWidth(0.02.w), // Colon
                  6: pw.FlexColumnWidth(0.23.w), // Right Value
                },
                children: [
                  // --- ROW 1: Date of Joining & Employee Name ---
                  pw.TableRow(
                    children: [
                      // Left Side: Date of Joining
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(
                            "Date of joining",
                          )),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 3.w, top: 3.h, bottom: 3.h),
                          child: pw.Text(":")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(widget.dateofjoin)),

                      // Spacer Column (Empty)
                      pw.Container(),

                      // Right Side: Employee Name
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text("Employee name")),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 3.w, top: 3.h, bottom: 3.h),
                          child: pw.Text(":")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(widget.employeeName)),
                    ],
                  ),

                  // --- ROW 2: Pay Period & Designation ---
                  pw.TableRow(
                    children: [
                      // Left Side: Pay Period
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text("Pay Period")),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 3.w, top: 3.h, bottom: 3.h),
                          child: pw.Text(":")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(widget.payperiod)),

                      // Spacer Column (Empty)
                      pw.Container(),

                      // Right Side: Designation
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text("Designation")),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 3.w, top: 3.h, bottom: 3.h),
                          child: pw.Text(":")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(widget.designation)),
                    ],
                  ),

                  // --- ROW 3: Date of Exit & Department ---
                  pw.TableRow(
                    children: [
                      // Left Side: Date of Exit
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text("Date of Exit")),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 3.w, top: 3.h, bottom: 3.h),
                          child: pw.Text(":")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(widget.dateofexit)),

                      // Spacer Column (Empty)
                      pw.Container(),

                      // Right Side: Department
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text("Department")),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 3.w, top: 3.h, bottom: 3.h),
                          child: pw.Text(":")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(widget.department)),
                    ],
                  ),
                ],
              ),
// --- END OF THE ALIGNED WIDGET ---

              pw.SizedBox(height: 15.h),

              // Earnings table header
              //1

              pw.SizedBox(height: 6.h),
              pw.Container(
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                    color: PdfColors.grey400,
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.w)),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Text('EARNINGS',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold))),
                    pw.Container(
                        width: 120.w,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text('AMOUNT',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black))),
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
                                            color: PdfColors.black))),
                                pw.Container(
                                    width: 120.w,
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text(
                                        (e['amount'] != null)
                                            ? e['amount'].toString()
                                            : '-',
                                        style: smallStyle.copyWith(
                                            color: PdfColors.black))),
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
                              child: pw.Text('Total Earnings',
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

              pw.Container(
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                    color: PdfColors.grey400,
                    border:
                        pw.Border.all(color: PdfColors.black, width: 0.8.w)),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Text('DEDUCTIONS',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold))),
                    pw.Container(
                        width: 120.w,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text('AMOUNT',
                            style: pw.TextStyle(
                                fontSize: 11.sp,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black))),
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
                                            color: PdfColors.black))),
                                pw.Container(
                                    width: 120.w,
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text(
                                        (d['amount2'] != null)
                                            ? d['amount2'].toString()
                                            : '-',
                                        style: smallStyle.copyWith(
                                            color: PdfColors.black))),
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
                              child: pw.Text('Total Amount',
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
              pw.SizedBox(height: 3.h),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Net Pay',
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFFC62828))),
                  pw.SizedBox(width: 20.w),
                  pw.Text(widget.netPay.toString(),
                      style: pw.TextStyle(
                          fontSize: 12.sp,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFFC62828))),
                ],
              ),

              pw.SizedBox(height: 12.h),

              pw.Table(
                border: pw.TableBorder.all(width: 1.w, color: PdfColors.black),
                columnWidths: {
                  0: pw.FlexColumnWidth(4.w), // Description
                  1: pw.FlexColumnWidth(1.w), // Yes/No
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'DESCRIPTION',
                          style: pw.TextStyle(
                              fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'YES/NO',
                          style: pw.TextStyle(
                              fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'TOOLS WERE GIVEN TO ALMASKAN',
                          style: pw.TextStyle(fontSize: 10.sp),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(''),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'SALARY CARD WERE GIVEN TO ALMASKAN',
                          style: pw.TextStyle(fontSize: 10.sp),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(''),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12),
                        child: pw.Text(
                          '',
                          style: pw.TextStyle(fontSize: 10.sp),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12),
                        child: pw.Text(''),
                      ),
                    ],
                  ),
                ],
              ),

              // Footer Row
              pw.Table(
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Prepared By',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Verified By',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Approved By',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Signature lines

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Suhaib Poozhithara',
                        style: smallStyle.copyWith(color: PdfColors.black)),
                    pw.Text('MD_Mohammed Shafi',
                        style: smallStyle.copyWith(color: PdfColors.black)),
                    pw.Text('Co-Founder_Shahul Hameed',
                        style: smallStyle.copyWith(color: PdfColors.black)),
                  ],
                ),
              ),

              pw.SizedBox(height: 50.h),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        width: 150.w, height: .8.h, color: PdfColors.black),
                    pw.Container(
                        width: 150.w, height: .8.h, color: PdfColors.black),
                    pw.Container(
                        width: 150.w, height: .8.h, color: PdfColors.black),
                  ],
                ),
              ),

              pw.SizedBox(height: 10.h),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                      width: 150.w, height: .5.h, color: PdfColors.black),
                  pw.Text(
                    'Receivers Name & Sign',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontSize: 10.sp, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Container(
                      width: 150.w, height: .5.h, color: PdfColors.black),
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
          'Leave Salary PDF Preview',
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
