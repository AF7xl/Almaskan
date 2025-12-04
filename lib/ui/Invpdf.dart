import 'dart:core';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Invpdf extends StatefulWidget {
  final String invno;
  final String id;
  final String invoiceId;
  final String date;
  final String lpoqtn;
  final String project;
  final String nbq;
  final String selectedCompany;
  final List<Map<String, dynamic>> lineItems;
  final String subtotal;
  final String discount;
  final String taxableamount;
  final String vat;
  final String totalamount;
  final String totalamountinname;
  final String naq;
  final String name;
  final String address;
  final bool fromSaved;
  final String trn;
  final String option;

  const Invpdf(
      {Key? key,
      required this.invno,
      required this.trn,
      required this.date,
      required this.lpoqtn,
      required this.project,
      required this.nbq,
      required this.subtotal,
      required this.discount,
      required this.taxableamount,
      required this.vat,
      required this.totalamount,
      required this.totalamountinname,
      required this.naq,
      required this.name,
      required this.address,
      required this.id,
      required this.invoiceId,
      this.fromSaved = false,
      required this.lineItems,
      required this.selectedCompany,
      required this.option})
      : super(key: key);

  @override
  State<Invpdf> createState() => _InvpdfState();

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

class _InvpdfState extends State<Invpdf> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
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
    final showDiscount = isDiscountVisible(widget.discount);
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
            pw.Text("TRN 100342182100003",
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
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
              },
              border: pw.TableBorder.all(width: 0.5.w),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account Name :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Al Maskan Plaster & Tiles Cont.",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Bank :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Sharjah Islamic Bank",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account No :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("001-2079331-001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("IBN :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("AE06 0410 0000 1236 4478 001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Branch :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
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
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
              },
              border: pw.TableBorder.all(width: 0.5.w),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account Name :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("REYAH AL MASKAN TECHNICAL SER LLC.",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Bank :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Sharjah Islamic Bank",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account No :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("0012364478001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("IBN :", style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("AE060410000012364478001",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Branch :",
                        style: pw.TextStyle(fontSize: 7.sp)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
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
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(top: 20),
                                child: pw.Container(
                                    width: 160.w,
                                    height: 160.h,
                                    child: pw.Image(image))),
                            pw.SizedBox(width: 290),
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
                            pw.SizedBox(width: 160.w),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(top: 15),
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
                      // Table of Items
                      pw.Container(
                        height: 25.h,
                        color: widget.selectedCompany == 'Al Maskan'
                            ? PdfColors.black
                            : PdfColor.fromInt(0xFFC62828),
                        child: pw.Row(
                          children: [
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text("#",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp))),
                            pw.SizedBox(width: 3),
                            pw.Expanded(
                                flex: 5,
                                child: pw.Text("Description",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp))),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text("Qty",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp))),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text("Unit",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp))),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text("Rate",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp))),
                            pw.SizedBox(width: 5.w),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text("Amount",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp))),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 4.h),
                      ...widget.lineItems.map((item) {
                        if (item['type'] == 'header') {
                          return pw.Column(children: [
                            pw.Container(
                                width: double.infinity,
                                height: 10.h,
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
                                    child: pw.Text(item['sno'] ?? '',
                                        style: pw.TextStyle(fontSize: 9.sp))),
                                pw.SizedBox(width: 3.w),
                                pw.Expanded(
                                    flex: 5,
                                    child: pw.Text(item['description'] ?? '',
                                        style: pw.TextStyle(fontSize: 9.sp))),
                                pw.SizedBox(width: 5.w),
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: item['quantity'] ?? '',
                                          style: pw.TextStyle(fontSize: 9.sp),
                                        ),
                                        if (item['percentage'] != null &&
                                            item['percentage']
                                                .toString()
                                                .isNotEmpty)
                                          pw.TextSpan(
                                            text: ' (${item['percentage']}%)',
                                            style: pw.TextStyle(
                                              fontSize: 9.sp,
                                              color: PdfColors.grey700,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                pw.SizedBox(width: 5.w),
                                pw.Expanded(
                                    flex: 1,
                                    child: pw.Text(item['unit'] ?? '',
                                        style: pw.TextStyle(fontSize: 9.sp))),
                                pw.SizedBox(width: 5.w),
                                pw.Expanded(
                                    flex: 1,
                                    child: pw.Text(item['rate'] ?? '',
                                        style: pw.TextStyle(fontSize: 9.sp))),
                                pw.SizedBox(width: 5.w),
                                pw.Expanded(
                                    flex: 1,
                                    child: pw.Text(item['amount'] ?? '',
                                        style: pw.TextStyle(fontSize: 9.sp))),
                              ],
                            ),
                            pw.Divider(thickness: 0.2),
                          ]);
                        }
                      }).toList(),

                      pw.SizedBox(height: 5.h),

                      // Subtotal and Total
                      pw.Container(
                        child: pw.Row(
                          children: [
                            // Label Column
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 370.w),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("SUBTOTAL :",
                                      style: pw.TextStyle(fontSize: 10.sp)),
                                  pw.SizedBox(height: 5.h),
                                  if (showDiscount) ...[
                                    pw.Text("DISCOUNT :",
                                        style: pw.TextStyle(fontSize: 9.sp)),
                                    pw.SizedBox(height: 5.h),
                                  ],
                                  pw.Text("VAT :",
                                      style: pw.TextStyle(fontSize: 9.sp)),
                                  pw.SizedBox(height: 5.h),
                                  pw.Text("TAXABLE AMOUNT :",
                                      style: pw.TextStyle(fontSize: 9.sp)),
                                ],
                              ),
                            ),
                            // Value Column
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 40.w),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                // Align values to right
                                children: [
                                  pw.Text(widget.subtotal,
                                      style: pw.TextStyle(fontSize: 9.sp),
                                      textAlign: pw.TextAlign.right),
                                  pw.SizedBox(height: 5.h),
                                  if (showDiscount) ...[
                                    pw.Text(widget.discount,
                                        style: pw.TextStyle(fontSize: 9.sp),
                                        textAlign: pw.TextAlign.right),
                                    pw.SizedBox(height: 5.h),
                                  ],
                                  pw.Text(widget.vat,
                                      style: pw.TextStyle(fontSize: 9.sp),
                                      textAlign: pw.TextAlign.right),
                                  pw.SizedBox(height: 5.h),
                                  pw.Text(widget.taxableamount,
                                      style: pw.TextStyle(fontSize: 9.sp),
                                      textAlign: pw.TextAlign.right),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5.h),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 365.w),
                        child: pw.Container(
                          width: 200.w,
                          height: 25.h,
                          color: PdfColors.grey100,
                          child: pw.Row(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5.w),
                                child: pw.Text(
                                  "TOTAL AMOUNT :",
                                  style: pw.TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Spacer(),
                              // Push the total amount to the right edge
                              pw.Padding(
                                padding: pw.EdgeInsets.only(right: 5.w),
                                child: pw.Text(
                                  "${widget.totalamount} AED",
                                  style: pw.TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 8.h),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 365.w),
                                child: pw.Text("Total In Words:",
                                    style: pw.TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: pw.FontWeight.normal,
                                    ))),
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
                      pw.SizedBox(height: 15.h),
                      pw.Text("Notes", style: pw.TextStyle(fontSize: 8.sp)),
                      pw.SizedBox(height: 5.h),
                      pw.Text(widget.naq, style: pw.TextStyle(fontSize: 9.sp)),
                      pw.SizedBox(height: 10.h),
                      pw.Text("Bank Details:",
                          style: pw.TextStyle(
                            fontSize: 8.sp,
                            decoration: pw.TextDecoration.underline,
                          )),
                      pw.SizedBox(height: 5.h),
                      pw.Row(
                          
                          children: [
                            bankdetails(),
                            
                          ]),
                          widget.option.trim().toLowerCase() == 'yes'
                                ? pw.Column(children: [
                                    pw.Container(
                                        width: 160.w,
                                        height: 160.h,
                                        child: pw.Image(sign)),
                                    pw.Text("Authorized Signature",
                                        style: pw.TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: pw.FontWeight.normal))
                                  ])
                                : widget.option.trim().toLowerCase() == 'no'
                                    ? pw.Wrap(children: [
                                        pw.Text(
                                            'This is computer generated\ncode This not need to Sign'),
                                      ])
                                    : pw.SizedBox(),

                      pw.SizedBox(height: 20),
                    ],
                  ))
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
                pw.SizedBox(height: 40)
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
      await Invpdf.save(bytes!, fileNameWithExtension);
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
            'Invoice PDF Preview',
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: IconButton(
                icon: Icon(Icons.download, size: 25.sp, color: Colors.black),
                onPressed: _saveFile,
              ),
            ),
          ]),
      body: pdfFilePath == null
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(File(pdfFilePath!)),
    );
  }
}
