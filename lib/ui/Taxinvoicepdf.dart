import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Taxinvoicepdf extends StatefulWidget {
  final String invno;
  final String date;
  final String lpoqtn;
  final String advancepercent;
  final String project;
  final String nbq;
  final String subtotal;
  final String advance;
  final String vat;
  final String totalamount;
  final String totalamountinname;
  final String naq;
  final String name;
  final String address;
  final String trn;
  final String payment;
  final String selectedCompany;
  final String option;
  final String newfeild;

  const Taxinvoicepdf(
      {super.key,
      required this.invno,
      required this.date,
      required this.lpoqtn,
      required this.advancepercent,
      required this.project,
      required this.nbq,
      required this.subtotal,
      required this.advance,
      required this.vat,
      required this.totalamount,
      required this.totalamountinname,
      required this.naq,
      required this.name,
      required this.address,
      required this.trn,
      required this.payment,
      required this.selectedCompany,
      required this.option, required this.newfeild});

  @override
  State<Taxinvoicepdf> createState() => _TaxinvoicepdfState();

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

String formatIndian(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "0";
  }

  final number = double.tryParse(value.replaceAll(',', '')) ?? 0;

  final formatter = NumberFormat('#,##,##0.00', 'en_IN');
  return formatter.format(number);
}

class _TaxinvoicepdfState extends State<Taxinvoicepdf> {
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

    pw.Widget bankdetails() {
      if (widget.selectedCompany == 'Al Maskan') {
        return pw.SizedBox(
            width: 300.w,
            height: 90.h,
            child: pw.Table(
              columnWidths: {
                0:const pw.FlexColumnWidth(1),
                1:const pw.FlexColumnWidth(1),
              },
              border: pw.TableBorder.all(width: 0.5.w),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding:const pw.EdgeInsets.all(4),
                    child: pw.Text("Account Name :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Al Maskan Plaster & Tiles Cont.",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Bank :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Sharjah Islamic Bank",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Account No :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("001-2079331-001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child:
                        pw.Text("IBN :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("AE480410000012079331001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Branch :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Al Wasit",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
              ],
            ));
      } else {
        return pw.SizedBox(
            width: 300.w,
            height: 100.h,
            child: pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(1.w),
                1: pw.FlexColumnWidth(1.w),
              },
              border: pw.TableBorder.all(width: 0.5.w),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Account Name :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("REYAH AL MASKAN TECHNICAL SER LLC.",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Bank :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Sharjah Islamic Bank",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Account No :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("0012364478001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child:
                        pw.Text("IBN :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("AE060410000012364478001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Branch :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Al Wasit",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
              ],
            ));
      }
    }

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return [
              pw.Padding(
                  padding: const pw.EdgeInsets.all(22),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(top: 20.h),
                                child: pw.Container(
                                    width: 160.w,
                                    height: 160.h,
                                    child: pw.Image(image))),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                      padding: pw.EdgeInsets.only(top: 25.h),
                                      child: pw.Text("Tax Invoice",
                                          style: pw.TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: pw.FontWeight.bold))),
                                  pw.Padding(
                                      padding: pw.EdgeInsets.only(left: 3.w),
                                      child: pw.Text("# INV-${widget.invno}",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 9.sp)))
                                ])
                          ]),
                      pw.SizedBox(height: 10.h),
                      buildCompanyDetails(),
                      pw.SizedBox(height: 20.h),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("To",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 10.sp)),
                                  pw.SizedBox(height: 3.h),
                                  pw.Text(widget.name,
                                      style: pw.TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 3.h),
                                  pw.Text(widget.address,
                                      style: pw.TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: pw.FontWeight.normal,
                                          letterSpacing: 0.5)),
                                  pw.SizedBox(height: 3.h),
                                  pw.Text("TRN-${widget.trn}",
                                      style: pw.TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: pw.FontWeight.normal,
                                          letterSpacing: 0.5)),
                                  pw.SizedBox(height: 3.h),
                                  pw.Text("United Arab Emirates",
                                      style: pw.TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: pw.FontWeight.normal,
                                          letterSpacing: 0.5)),
                                ]),
                           
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(top: 15.h),
                                    child:
                                        pw.Text("Invoice Date : ${widget.date}",
                                            style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 9.sp,
                                            )),
                                  ),
                                  pw.SizedBox(height: 3.h),
                                  pw.Text("P.O (OR) QTN NO: ${widget.lpoqtn}",
                                      style: pw.TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: pw.FontWeight.normal,
                                      )),
                                  pw.SizedBox(height: 3.h),
                                  pw.Text("Project: ${widget.project}",
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: pw.FontWeight.normal,
                                      )),
                                      pw.SizedBox(height: 3.h),
                                  pw.Text(widget.newfeild,
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: pw.FontWeight.normal,
                                      )),
                                ])
                          ]),
                      pw.SizedBox(height: 10.h),
                      pw.Text("Subject :",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10.sp)),
                      pw.SizedBox(height: 3.h),
                      pw.Text(widget.nbq,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10.sp)),
                      pw.SizedBox(height: 10.h),

                      pw.Container(
                        height: 25.h,
                        color: widget.selectedCompany == 'Al Maskan'
                            ? PdfColors.black
                            : const PdfColor.fromInt(0xFFC62828), // Reyah default red
                        child: pw.Row(
                          children: [
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("#",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10.sp,
                                      color: PdfColors.white)),
                            ),
                            pw.SizedBox(width: 3.w),
                            pw.Expanded(
                              flex: 6,
                              child: pw.Text("Description",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                      fontSize: 10.sp)),
                            ),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text("Rate",
                                   textAlign: pw.TextAlign.right,
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
                                    textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                    
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                      fontSize: 10.sp)),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5.h),
                      pw.Container(
                        height: 25.h,
                        color: PdfColors.white, // Reyah default red
                        child: pw.Row(
                          children: [
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("1",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10.sp,
                                      color: PdfColors.black)),
                            ),
                            pw.SizedBox(width: 3.w),
                            pw.Expanded(
                              flex: 6,
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("${widget.payment} Amount",
                                         textAlign: pw.TextAlign.right,
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 10.sp,
                                            color: PdfColors.black)),
                                    pw.Text(
                                           textAlign: pw.TextAlign.right,
                                        "SUBTOTAL TAXABLE QTN AMOUNT - ${formatIndian(widget.subtotal)}",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 8.sp,
                                            color: PdfColors.black))
                                  ]),
                            ),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(formatIndian(widget.advance),
                                 textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black,
                                    fontSize: 10.sp,
                                  )),
                            ),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(formatIndian(widget.advance),
                                 textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black,
                                      fontSize: 10.sp)),
                            ),
                          ],
                        ),
                      ),
                      pw.Divider(thickness: 0.3), pw.SizedBox(height: 5.h),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                              width: 200.w, // adjust width as needed
                              padding: pw.EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.w),
                              color:
                                  PdfColors.white, // optional background color
                              child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    // Left labels column
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          "Total Taxable Amount",
                                          style: pw.TextStyle(fontSize: 10.sp),
                                        ),
                                        pw.SizedBox(height: 8.h),
                                        pw.Text(
                                          "VAT (5%)",
                                          style: pw.TextStyle(fontSize: 9.sp),
                                        ),
                                      ],
                                    ),

                                    pw.Spacer(), // pushes next column to the right

                                    // Right amounts column

                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.end,
                                      children: [
                                        pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                              formatIndian(widget.advance),
                                              style:
                                                  pw.TextStyle(fontSize: 9.sp),
                                            ),
                                            pw.SizedBox(height: 8.h),
                                            pw.Text(
                                             formatIndian( widget.vat),
                                              style:
                                                  pw.TextStyle(fontSize: 9.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ]),

                      pw.SizedBox(height: 8.h),

                      pw.Row(
                                 mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                        pw.Container(
                          width: 200.w,
                          height: 25.h,
                          color: PdfColors.grey100,
                          child: pw.Row(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5.w),
                                child: pw.Text(
                                  "TOTAL AMOUNT ",
                                  style: pw.TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Spacer(),
                              // <-- This pushes the next widget to the right edge
                              pw.Padding(
                                padding: pw.EdgeInsets.only(right: 5.w),
                                child: pw.Text(
                                  "${formatIndian(widget.totalamount)}AED",
                                  style: pw.TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),

                      pw.SizedBox(height: 8.h),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                             pw.Text("Total In Words:",
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: pw.FontWeight.normal,
                                    )),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5.w),
                                child: pw.Container(
                                    width: 100.w,
                                    height: 50.h,
                                    child: pw.Text(widget.totalamountinname,
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 9.sp,
                                            color: PdfColors.black,
                                            fontStyle: pw.FontStyle.italic))))
                          ]),

                      // Notes
                      pw.SizedBox(height: 2.h),
                      pw.Text("Notes", style: pw.TextStyle(fontSize: 10.sp)),
                      pw.SizedBox(height: 2.h),
                      pw.Text(widget.naq, style: pw.TextStyle(fontSize: 8.sp)),
                      pw.SizedBox(height: 5.h),

                      pw.Text("Bank Details:",
                          style: pw.TextStyle(
                            fontSize: 8.sp,
                            decoration: pw.TextDecoration.underline,
                          )),

                      pw.Row(children: [
                        bankdetails(),
                        pw.SizedBox(height: 20.h),
                      ]),

                      pw.Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          if (widget.option.toLowerCase().trim() == 'sign-1')
                            pw.Column(
                              children: [
                                pw.Container(
                                    width: 100.w,
                                    height: 100.w,
                                    child: pw.Image(sign)),
                                pw.SizedBox(height: 5.h),
                                pw.Text("Authorized Signature",
                                    style: pw.TextStyle(fontSize: 10.sp))
                              ],
                            ),
                          if (widget.option.toLowerCase().trim() == 'sign-2')
                            pw.Column(
                              children: [
                                pw.Container(
                                    width: 100.w,
                                    height: 100.h,
                                    child: pw.Image(sign2)),
                                pw.SizedBox(height: 5.h),
                                pw.Text("Authorized Signature",
                                    style: pw.TextStyle(fontSize: 10.sp))
                              ],
                            ),
                          if (widget.option.toLowerCase().trim() == 'no sign')
                            pw.Text(
                              'This is a computer-generated document.\nNo signature required.',
                              style: pw.TextStyle(fontSize: 10.sp),
                            ),
                        ],
                      ),
                    ],
                  )),
            ];
          },
          footer: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Divider(
                    thickness: 1.5,
                    color: PdfColors.grey,
                    endIndent: 22,
                    indent: 22),
                pw.SizedBox(height: 20)
              ],
            );
          }),
    );

    // Get the temporary directory
    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/invoice_preview.pdf';

    // Generate the bytes from the PDF
    bytes = await pdf.save();

    // Write the bytes to the temporary file
    final file = File(filePath);
    await file.writeAsBytes(bytes!);

    // Save the file using the Invpdf class method (optional)

    return filePath;
  }

  Future<void> _saveFile() async {
    // Show a dialog to get the file name from the user
    final TextEditingController fileNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(hintText: 'File name '),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    // Get the file name entered by the user
    final fileName = fileNameController.text;

    if (fileName.isNotEmpty) {
      // Append .pdf extension if not already present
      final fileNameWithExtension =
          fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';

      // Save the file using the Invpdf class method
      await Taxinvoicepdf.save(bytes!, fileNameWithExtension);
    } else {
      // Handle case where user doesn't enter a name
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File name cannot be empty')),
      );
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
          'Tax Invoice PDF Preview',
          style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: IconButton(
              icon: Icon(
                Icons.download,
                size: 25.sp,
                color: Colors.white,
              ),
              onPressed: () {
                _saveFile();
              },
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
