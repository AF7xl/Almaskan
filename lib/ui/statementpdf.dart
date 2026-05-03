import 'dart:io';
import 'package:almaskan/ui/Taxinvoicepdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class statementpdfpage extends StatefulWidget {
  final String id;
  final String trn;
  final String date;
  final String kindatt;
  final String selectedCompany;
  final List<Map<String, dynamic>> lineItems;
  final String totalamount;
  final String totalamountinname;
  final String name;
  final String address;
  final bool fromSaved;
  final String option;
  final String slno;

  const statementpdfpage({
    Key? key,
    required this.date,
    required this.kindatt,
    required this.totalamount,
    required this.totalamountinname,
    required this.name,
    required this.address,
    required this.id,
    required this.trn,
    this.fromSaved = false,
    required this.lineItems,
    required this.selectedCompany,
    required this.option,
    required this.slno,
  }) : super(key: key);

  @override
  State<statementpdfpage> createState() => _statementpdfpageState();

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

class _statementpdfpageState extends State<statementpdfpage> {
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

    final sign = pw.MemoryImage(
      (await rootBundle.load(widget.selectedCompany == 'Al Maskan'
              ? 'assets/sign.png'
              : 'assets/sign2.jpg'))
          .buffer
          .asUint8List(),
    );

    final sign2 = pw.MemoryImage(
      (await rootBundle.load(widget.selectedCompany == 'Al Maskan'
              ? 'assets/sign3.jpg'
              : 'assets/sign4.jpg'))
          .buffer
          .asUint8List(),
    );

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
                        pw.Padding(
                            padding: pw.EdgeInsets.only(top: 10.h),
                            child: pw.Container(
                                width: 120.w, child: pw.Image(image))),

                        pw.SizedBox(height: 10.h),

                        buildCompanyDetails(),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Center(
                              child: pw.Text('STATEMENT',
                                  style: pw.TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: pw.FontWeight.bold,
                                      decoration: pw.TextDecoration.underline)),
                            )
                          ],
                        ),

                        pw.SizedBox(height: 20.h),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("To",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 10.sp)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text(widget.name,
                                        style: pw.TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: pw.FontWeight.normal)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text(widget.address,
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text("TRN ${widget.trn}",
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text("United Arab Emirates",
                                        style: pw.TextStyle(
                                            decoration:
                                                pw.TextDecoration.underline,
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text("kind att : ${widget.kindatt}",
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                  ]),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Date : ${widget.date}",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 9.sp,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 8.h),
                                    pw.Text("TRN 100342182100003",
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5))
                                  ])
                            ]),

                        pw.SizedBox(height: 5.h),
                        pw.Text("Subject : Statement of Account",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10.sp)),

                        pw.SizedBox(height: 5.h),

                        pw.Container(
                          height: 25.h,
                          color: widget.selectedCompany == 'Al Maskan'
                              ? PdfColors.black
                              : PdfColor.fromInt(
                                  0xFFC62828), // Reyah default red
                          child: pw.Row(
                            children: [
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Sl No",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10.sp,
                                        color: PdfColors.white)),
                              ),
                              pw.SizedBox(width: 3),
                              pw.Expanded(
                                flex: 5,
                                child: pw.Text("Project Name",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text("Invoice No",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text("Date",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text("LPO No",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                      fontSize: 10.sp,
                                    )),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text("Amount",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 4.h),
                        ...widget.lineItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          if (item['type'] == 'header') {
                            return pw.Column(children: [
                              pw.Container(
                                  width: double.infinity,
                                  height: 10.sp,
                                  child: pw.Text(item['text'] ?? '',
                                      style: pw.TextStyle(
                                          fontSize: 9.sp,
                                          fontWeight: pw.FontWeight.bold))),
                              pw.Divider(thickness: 0.2)
                            ]);
                          } else {
                            return pw.Column(children: [
                              pw.Row(
                                children: [
                                  pw.SizedBox(width: 5.w),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.start,
                                           '${index + 1}',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 3),
                                  pw.Expanded(
                                      flex: 5,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.start,
                                          item['project'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5.w),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.start,
                                          item['invoiceNo'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.start,
                                          item['date'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.start,
                                          item['lpo'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.right,
                                          formatIndian(item['amount'] ?? ''),
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                ],
                              ),
                              pw.Divider(thickness: 0.2),
                            ]);
                          }
                        }).toList(),
                        pw.Row(
                          children: [
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    textAlign: pw.TextAlign.start,
                                    "",
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                    ))),
                            pw.SizedBox(width: 3),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(
                                    textAlign: pw.TextAlign.start,
                                    'Total Amount',
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: pw.FontWeight.bold
                                    ))),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                    textAlign: pw.TextAlign.start,
                                    '',
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                    ))),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                    textAlign: pw.TextAlign.start,
                                    '',
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                    ))),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                    textAlign: pw.TextAlign.start,
                                    '',
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                    ))),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                    textAlign: pw.TextAlign.right,
                                     formatIndian(widget.totalamount),
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: pw.FontWeight.bold
                                    ))),
                          ],
                        ),
                        pw.Divider(thickness: 0.2),
                        pw.SizedBox(height: 6.h),
                        pw.Text(widget.totalamountinname,
                            style: pw.TextStyle(
                                decoration: pw.TextDecoration.underline,
                                fontSize: 10.sp,
                                fontWeight: pw.FontWeight.normal,
                                letterSpacing: 0.5)),

                        pw.SizedBox(height: 6.h),
                        pw.Text("Thank you & Regards",
                            style: pw.TextStyle(
                                fontSize: 10.sp,
                                fontWeight: pw.FontWeight.normal,
                                letterSpacing: 0.5)),
                        pw.SizedBox(height: 6.h),
                        pw.Text(widget.selectedCompany,
                            style: pw.TextStyle(
                                fontSize: 10.sp,
                                fontWeight: pw.FontWeight.normal,
                                letterSpacing: 0.5)),
                        pw.SizedBox(height: 6.h),
                        pw.Text("Yours Faithfully",
                            style: pw.TextStyle(
                                fontSize: 10.sp,
                                fontWeight: pw.FontWeight.normal,
                                letterSpacing: 0.5)),
                        pw.Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            if (widget.option.toLowerCase().trim() == 'sign-1')
                              pw.Column(
                                children: [
                                  pw.Container(
                                      width: 150.w,
                                      height: 150.h,
                                      child: pw.Image(sign)),
                                  pw.SizedBox(height: 5.h),
                                ],
                              ),
                            if (widget.option.toLowerCase().trim() == 'sign-2')
                              pw.Column(
                                children: [
                                  pw.Container(
                                      width: 150.w,
                                      height: 150.h,
                                      child: pw.Image(sign2)),
                                  pw.SizedBox(height: 5.h),
                                ],
                              ),
                            if (widget.option.toLowerCase().trim() == 'no sign')
                              pw.Text(
                                'This is a computer-generated document.\nNo signature required.',
                                style: pw.TextStyle(fontSize: 10.sp),
                              ),
                          ],
                        )
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
