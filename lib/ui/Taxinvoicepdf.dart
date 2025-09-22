import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      required this.selectedCompany});

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
      (await rootBundle.load('assets/sign.png')).buffer.asUint8List(),
    );
    pw.Widget buildCompanyDetails() {
      if (widget.selectedCompany == 'Al Maskan') {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("AL MASKAN PLASTER & TILE CONT L.L.C.SP",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 3),
            pw.Text("Industrial-8", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("Sharjah", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("United Arab Emirates", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("TRN 100342182100003", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("0508089505", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("almaskandecor@gmail.com",
                style: pw.TextStyle(fontSize: 10)),
          ],
        );
      } else {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("REYAH AL MASKAN TECHNICAL SERVICES L.L.C",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 3),
            pw.Text("Dubai", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("United Arab Emirates", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("TRN 100342182100003", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("0508089505", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text("reyahalmaskan@gmail.com",
                style: pw.TextStyle(fontSize: 10)),
          ],
        );
      }
    }
    final formattedSubtotal = NumberFormat('#,##0.00', 'en_US')
        .format(double.tryParse(widget.subtotal) ?? 0);
    final formattedAdvance = NumberFormat('#,##0.00', 'en_US')
        .format(double.tryParse(widget.advance) ?? 0);
    final formattedvat = NumberFormat('#,##0.00', 'en_US')
        .format(double.tryParse(widget.vat) ?? 0);
    final formattedtotal = NumberFormat('#,##0.00', 'en_US')
        .format(double.tryParse(widget.totalamount) ?? 0);

    pw.Widget bankdetails() {
      if (widget.selectedCompany == 'Al Maskan') {
        return pw.SizedBox(
            width: 300,
            height: 90,
            child: pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account Name :",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Al Maskan Plaster & Tiles Cont.",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Bank :", style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Sharjah Islamic Bank",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account No :",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("001-2079331-001",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("IBN :", style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("AE48 0410 0000 1207 9331 001",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Branch :", style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Al Wasit", style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
              ],
            ));
      } else {
        return pw.SizedBox(
            width: 300,
            height: 100,
            child: pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account Name :",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("REYAH AL MASKAN TECHNICAL SER LLC.",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Bank :", style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Sharjah Islamic Bank",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Account No :",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("0012364478001",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("IBN :", style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("AE0606410000012364478001",
                        style: pw.TextStyle(fontSize: 7)),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Branch :", style: pw.TextStyle(fontSize: 7)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child:
                        pw.Text("Al Wasit", style: pw.TextStyle(fontSize: 7)),
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
                                    width: 160,
                                    height: 160,
                                    child: pw.Image(image))),
                            pw.SizedBox(width: 290),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                      padding: pw.EdgeInsets.only(top: 25.h),
                                      child: pw.Text("Tax Invoice",
                                          style: pw.TextStyle(
                                              fontSize: 20,
                                              fontWeight: pw.FontWeight.bold))),
                                  pw.Padding(
                                      padding: pw.EdgeInsets.only(left: 3.w),
                                      child: pw.Text("# INV-${widget.invno}",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 9)))
                                ])
                          ]),
                      pw.SizedBox(height: 10),
                      buildCompanyDetails(),
                      pw.SizedBox(height: 20),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("To",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 10)),
                                  pw.SizedBox(height: 3),
                                  pw.Container(
                                      width: 300,
                                      child: pw.Text(widget.name,
                                          style: pw.TextStyle(
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold))),
                                  pw.SizedBox(height: 3),
                                  pw.Container(
                                      width: 200,
                                      child: pw.Text(widget.address,
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              fontWeight: pw.FontWeight.normal,
                                              letterSpacing: 0.5))),
                                  pw.SizedBox(height: 3),
                                  pw.Container(
                                      width: 200,
                                      child: pw.Text("TRN-${widget.trn}",
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              fontWeight: pw.FontWeight.normal,
                                              letterSpacing: 0.5))),
                                  pw.SizedBox(height: 3),
                                  pw.Text("United Arab Emirates",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal,
                                          letterSpacing: 0.5)),
                                ]),

                            pw.Column(
                                crossAxisAlignment:
                                pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                      crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Padding(
                                            padding: pw.EdgeInsets.only(
                                                left: 105),
                                            child: pw.Container(
                                                alignment: pw
                                                    .Alignment.centerRight,
                                                width: 50,
                                                child:
                                                pw.Text("Invoice Date :",
                                                    style: pw.TextStyle(
                                                      fontWeight: pw
                                                          .FontWeight
                                                          .normal,
                                                      fontSize: 8,
                                                    )))),
                                        pw.Container(
                                            alignment:
                                            pw.Alignment.centerRight,
                                            width: 90,
                                            child: pw.Text(widget.date,
                                                style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.normal,
                                                  fontSize: 8,
                                                )))
                                      ]),
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                      crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Padding(
                                            padding: pw.EdgeInsets.only(
                                                left: 85),
                                            child: pw.Container(
                                                alignment: pw
                                                    .Alignment.centerRight,
                                                width: 70,
                                                child: pw.Text(
                                                    "P.O(OR)QTN NO :",
                                                    style: pw.TextStyle(
                                                      fontWeight: pw
                                                          .FontWeight
                                                          .normal,
                                                      fontSize: 8,
                                                    )))),
                                        pw.Container(
                                            alignment:
                                            pw.Alignment.centerRight,
                                            width: 90,
                                            child: pw.Text(widget.lpoqtn,
                                                style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.normal,
                                                  fontSize: 8,
                                                )))
                                      ]),
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                      crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Padding(
                                            padding: pw.EdgeInsets.only(
                                                left: 105),
                                            child: pw.Container(
                                                alignment: pw
                                                    .Alignment.centerRight,
                                                width: 50,
                                                child: pw.Text("Project :",
                                                    style: pw.TextStyle(
                                                      fontWeight: pw
                                                          .FontWeight
                                                          .normal,
                                                      fontSize: 8,
                                                    )))),
                                        pw.Container(
                                          width: 90,
                                          child: pw.Text(
                                            widget.project,
                                            textAlign: pw.TextAlign.right,
                                            // This aligns the text inside
                                            style: pw.TextStyle(
                                              fontWeight:
                                              pw.FontWeight.normal,
                                              fontSize: 8,
                                            ),
                                          ),
                                        )
                                      ])
                                ])
                          ]),
                      pw.SizedBox(height: 10),
                      pw.Text("Subject :",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 10)),
                      pw.SizedBox(height: 3),
                      pw.Text(widget.nbq,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 10)),
                      pw.SizedBox(height: 10),

                      pw.Container(
                        height: 25,
                        color: widget.selectedCompany == 'Al Maskan'
                            ? PdfColors.black
                            : PdfColor.fromInt(0xFFC62828), // Reyah default red
                        child: pw.Row(
                          children: [
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("#",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10,
                                      color: PdfColors.white)),
                            ),
                            pw.SizedBox(width: 3),
                            pw.Expanded(
                              flex: 6,
                              child: pw.Text("Description",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                      fontSize: 10)),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text("Rate",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white,
                                    fontSize: 10,
                                  )),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text("Amount",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        color: PdfColors.white, // Reyah default red
                        child: pw.Row(
                          children: [
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("1",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      color: PdfColors.black)),
                            ),
                            pw.SizedBox(width: 3),
                            pw.Expanded(
                              flex: 6,
                              child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      "${widget.payment} - ${widget.advancepercent}%",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10,
                                          color: PdfColors.black),
                                    ),
                                    pw.Text(
                                      "SUBTOTAL TAXABLE QTN AMOUNT - $formattedSubtotal",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 8,
                                          color: PdfColors.black),
                                    ),
                                  ]),
                            ),

                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(formattedAdvance,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black,
                                    fontSize: 10,
                                  )),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(formattedAdvance,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      pw.Divider(thickness: 0.3), pw.SizedBox(height: 5),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 308),
                        child: pw.Container(
                          width: 200, // adjust width as needed
                          padding: pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          color: PdfColors.white, // optional background color
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // Left labels column
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    "Total Taxable Amount",
                                    style: pw.TextStyle(fontSize: 10),
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Text(
                                    "VAT (5%)",
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ],
                              ),

                              pw.Spacer(), // pushes next column to the right

                              // Right amounts column
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    formattedAdvance,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Text(
                                    formattedvat,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 313),
                        child: pw.Container(
                          width: 200,
                          height: 25,
                          color: PdfColors.grey100,
                          child: pw.Row(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  "TOTAL AMOUNT (AED)",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Spacer(),
                              // <-- This pushes the next widget to the right edge
                              pw.Padding(
                                padding: pw.EdgeInsets.only(right: 5),
                                child: pw.Text(
                                  "${formattedtotal}",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      pw.SizedBox(height: 8),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 318),
                                child: pw.Text("Total In Words:",
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.normal,
                                    ))),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Container(
                                    width: 100,
                                    height: 50,
                                    child: pw.Text(widget.totalamountinname,
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 9,
                                            color: PdfColors.black,
                                            fontStyle: pw.FontStyle.italic))))
                          ]),

                      // Notes
                      pw.SizedBox(height: 2),
                      pw.Text("Notes", style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 2),
                      pw.Text(widget.naq, style: pw.TextStyle(fontSize: 8.5)),
                      pw.SizedBox(height: 5),

                      pw.Text("Bank Details:",
                          style: pw.TextStyle(
                            fontSize: 8,
                            decoration: pw.TextDecoration.underline,
                          )),
                      pw.SizedBox(height: 5),

                      bankdetails(), pw.SizedBox(height: 20),
                      pw.Container(
                          width: 160, height: 160, child: pw.Image(sign)),
                      pw.Text("Authorized Signature",
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.normal))
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Tax Invoice PDF Preview'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: IconButton(
              icon: Icon(
                Icons.download,
                size: 25.sp,
                color: Colors.black,
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
