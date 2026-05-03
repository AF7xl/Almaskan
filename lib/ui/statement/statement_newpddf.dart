import 'dart:io';
import 'package:almaskan/ui/Taxinvoicepdf.dart';
import 'package:almaskan/ui/statementpdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StatementNewpddf extends StatefulWidget {
  final String date;
  final String project;
  final String selectedCompany;
  final List<Map<String, dynamic>> lineItems;
  final String totalamount;
  final String companyname;
  final String place;

  const StatementNewpddf(
      {super.key,
      required this.date,
      required this.project,
      required this.selectedCompany,
      required this.lineItems,
      required this.totalamount,
      required this.companyname,
      required this.place});

  @override
  State<StatementNewpddf> createState() => _StatementNewpddfState();
  static Future<void> save(List<int> bytes, String fileName) async {
    String? directory = await FilePicker.platform.getDirectoryPath();

    if (directory != null) {
      final File file = File('$directory/$fileName');

      if (file.existsSync()) {
        await file.delete();
      }
      await file.writeAsBytes(bytes);
    }
  }
}

class _StatementNewpddfState extends State<StatementNewpddf> {
  String? pdfFilePath;
  List<int>? bytes;

  @override
  void initState() {
    super.initState();
    generatePdf().then((path) {
      setState(() {
        pdfFilePath = path;
      });
    });
  }

  bool isDiscountVisible(String? discount) {
    if (discount == null) return false;
    final cleaned = discount.trim();
    if (cleaned.isEmpty) return false;

    // Try parsing to double
    final value = double.tryParse(cleaned);
    return value != null && value != 0.0;
  }

  Future<String> generatePdf() async {
    final pdf = pw.Document();

    final image = pw.MemoryImage(
      (await rootBundle.load('assets/Logo.png')).buffer.asUint8List(),
    );

    // final sign = pw.MemoryImage(
    //   (await rootBundle.load(widget.selectedCompany == 'Al Maskan'
    //           ? 'assets/sign.png'
    //           : 'assets/sign2.jpg'))
    //       .buffer
    //       .asUint8List(),
    // );

    // final sign2 = pw.MemoryImage(
    //   (await rootBundle.load(widget.selectedCompany == 'Al Maskan'
    //           ? 'assets/sign3.jpg'
    //           : 'assets/sign4.jpg'))
    //       .buffer
    //       .asUint8List(),
    // );

    pw.Widget buildCompanyDetails() {
      if (widget.selectedCompany == 'Al Maskan') {
        return pw.Column(
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
        );
      } else {
        return pw.Column(
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
            pw.Text("TRN 104688415900003",
                style: pw.TextStyle(fontSize: 10.sp)),
            pw.SizedBox(height: 3.h),
            pw.Text("0508089505", style: pw.TextStyle(fontSize: 10.sp)),
            pw.SizedBox(height: 3.h),
            pw.Text("reyahalmaskan@gmail.com",
                style: pw.TextStyle(fontSize: 10.sp)),
          ],
        );
      }
    }

    pw.Widget tableCell(
      String text, {
      pw.TextAlign align = pw.TextAlign.left,
      bool bold = false,
    }) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(22),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        pw.Row(children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.only(top: 10.h),
                              child: pw.Container(
                                  width: 120.w, child: pw.Image(image))),
                          pw.SizedBox(width: 10.w),
                          buildCompanyDetails(),
                        ]),

                        pw.SizedBox(height: 10.h),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Center(
                              child: pw.Text('STATEMENT OF ACCOUNT',
                                  style: pw.TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: pw.FontWeight.bold,
                                  )),
                            )
                          ],
                        ),

                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(widget.companyname,
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text(widget.place,
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text("UNITED ARAB EMIRATES",
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text("PROJECT -${widget.project}",
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                  ]),
                              pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                pw.Text("Statement Date : ${widget.date}",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 9.sp,
                                        letterSpacing: 0.5)),
                              ])
                            ]),

                        pw.SizedBox(height: 10.h),
                        pw.Table(
                          border: pw.TableBorder.all(
                              width: 0.5, color: PdfColors.grey),
                          columnWidths: {
                            0: const pw.FlexColumnWidth(2),
                            1: const pw.FlexColumnWidth(5),
                            2: const pw.FlexColumnWidth(2),
                            3: const pw.FlexColumnWidth(2),
                            4: const pw.FlexColumnWidth(2),
                          },
                          children: [
                            /// HEADER
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.grey300),
                              children: [
                                tableCell("DATE", bold: true),
                                tableCell("DESCRIPTION", bold: true),
                                tableCell("INVOICE\nAMOUNT",
                                    bold: true, align: pw.TextAlign.center),
                                tableCell("RECEIVED\nAMOUND",
                                    bold: true, align: pw.TextAlign.center),
                                tableCell("ACCOUNT\nBALANCE",
                                    bold: true, align: pw.TextAlign.center),
                              ],
                            ),

                            /// DATA ROWS
                            ...widget.lineItems.map((item) {
                              return pw.TableRow(
                                children: [
                                  tableCell(item['date'] ?? ''),
                                  tableCell(item['description'] ?? ''),
                                  tableCell( formatIndian(item['invoiceamount']) ?? '',
                                      align: pw.TextAlign.right),
                                  tableCell( formatIndian(item['receivedamount']) ?? '',
                                      align: pw.TextAlign.right),
                                  tableCell( formatIndian(item['accountbalance']) ?? '',
                                      align: pw.TextAlign.right),
                                ],
                              );
                            }).toList(),

                            /// TOTAL ROW
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.grey200),
                              children: [
                                tableCell(""),
                                tableCell("TOTAL AMOUNT", bold: true),
                                tableCell(""),
                                tableCell(""),
                                tableCell(formatIndian(widget.totalamount),
                                    bold: true, align: pw.TextAlign.right),
                              ],
                            ),
                          ],
                        ),
                        // 
                        pw.Divider(thickness: 0.2),
                      ],
                    )),
              ],
          footer: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Divider(
                    thickness: 1,
                    color: PdfColors.grey,
                    endIndent: 22,
                    indent: 22),
                pw.SizedBox(height: 10.h)
              ],
            );
          }),
    );

    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/invoice_preview.pdf';
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
      await statementpdfpage.save(bytes!, fileNameWithExtension);
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
          'Statement PDF Preview',
          style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w) , 
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
