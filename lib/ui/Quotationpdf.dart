import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoicePdfPreviewPage extends StatefulWidget {
  final String qtnno;
  final String id;
  final String quotationId;
  final String date;
  final String kindatt;
  final String project;
  final String nbq;
  final String TAC;
  final String selectedCompany;
  final List<Map<String, dynamic>> lineItems;
  final String newfeild;
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
  final String option;

  const InvoicePdfPreviewPage({
    Key? key,
    required this.qtnno,
    required this.date,
    required this.kindatt,
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
    required this.quotationId,
    this.fromSaved = false,
    required this.lineItems,
    required this.TAC,
    required this.selectedCompany,
    required this.newfeild,
    required this.option,
  }) : super(key: key);

  @override
  State<InvoicePdfPreviewPage> createState() => _InvoicePdfPreviewPageState();

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

class _InvoicePdfPreviewPageState extends State<InvoicePdfPreviewPage> {
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
                        pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 20),
                                  child: pw.Container(
                                      width: 160,
                                      height: 160,
                                      child: pw.Image(image))),
                              pw.SizedBox(width: 310),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                        padding: pw.EdgeInsets.only(top: 25.h),
                                        child: pw.Text("Quote",
                                            style: pw.TextStyle(
                                                fontSize: 20,
                                                fontWeight:
                                                    pw.FontWeight.bold))),
                                    pw.Padding(
                                        padding: pw.EdgeInsets.only(left: 3.w),
                                        child: pw.Text("No-QT-${widget.qtnno}",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                fontSize: 11)))
                                  ])
                            ]),
                        pw.SizedBox(height: 10),
                        buildCompanyDetails(),
                        pw.SizedBox(height: 20),
                        pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("To",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 10)),
                                    pw.SizedBox(height: 3),
                                    pw.Text(widget.name,
                                        style: pw.TextStyle(
                                            fontSize: 11,
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text(widget.address,
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 3),
                                    pw.Text("United Arab Emirates",
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                  ]),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 160),
                                  child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text("Quote Date : ${widget.date}",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                fontSize: 9,
                                                letterSpacing: 0.5)),
                                        pw.SizedBox(height: 3),
                                        pw.Text("kind att : ${widget.kindatt}",
                                            style: pw.TextStyle(
                                                fontSize: 9,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                letterSpacing: 0.5)),
                                        pw.SizedBox(height: 3),
                                        pw.Text("Project : ${widget.project}",
                                            style: pw.TextStyle(
                                                fontSize: 9,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                letterSpacing: 0.5))
                                      ]))
                            ]),

                        pw.SizedBox(height: 10),
                        pw.Text("Subject :",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10)),
                        pw.SizedBox(height: 3),
                        pw.Text(widget.nbq,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10)),
                        pw.SizedBox(height: 5),
                        // Table headers
                        pw.Container(
                          height: 25,
                          color: widget.selectedCompany == 'Al Maskan'
                              ? PdfColors.black
                              : PdfColor.fromInt(
                                  0xFFC62828), // Reyah default red
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
                                flex: 5,
                                child: pw.Text("Description",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10)),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Qty",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10)),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Unit",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10)),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Rate",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                      fontSize: 10,
                                    )),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Amount",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10)),
                              ),
                            ],
                          ),
                        ),

                        pw.SizedBox(height: 4),
                        ...widget.lineItems.map((item) {
                          if (item['type'] == 'header') {
                            return pw.Column(children: [
                              pw.Container(
                                  width: double.infinity,
                                  height: 10,
                                  child: pw.Text(item['text'] ?? '',
                                      style: pw.TextStyle(
                                          fontSize: 9,
                                          fontWeight: pw.FontWeight.bold))),
                              pw.Divider(thickness: 0.2)
                            ]);
                          } else {
                            return pw.Column(children: [
                              pw.Row(
                                children: [
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(item['sno'] ?? '',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ))),
                                  pw.SizedBox(width: 3),
                                  pw.Expanded(
                                      flex: 5,
                                      child: pw.Text(item['description'] ?? '',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(item['quantity'] ?? '',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(item['unit'] ?? '',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(item['rate'] ?? '',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ))),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(item['amount'] ?? '',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ))),
                                ],
                              ),
                              pw.Divider(thickness: 0.2),
                            ]);
                          }
                        }).toList(),

                        // Subtotal and totals
                        pw.Container(
                          child: pw.Row(
                            children: [
                              // Label Column
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 370),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("SUBTOTAL :",
                                        style:
                                            const pw.TextStyle(fontSize: 10)),
                                    pw.SizedBox(height: 5),
                                    if (showDiscount) ...[
                                      pw.Text("DISCOUNT :",
                                          style:
                                              const pw.TextStyle(fontSize: 9)),
                                      pw.SizedBox(height: 5),
                                    ],
                                    pw.Text("VAT :",
                                        style: const pw.TextStyle(fontSize: 9)),
                                    pw.SizedBox(height: 5),
                                    pw.Text("TAXABLE AMOUNT :",
                                        style: const pw.TextStyle(fontSize: 9)),
                                  ],
                                ),
                              ),
                              // Value Column
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 40),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  // Align values to right
                                  children: [
                                    pw.Text(widget.subtotal,
                                        style: pw.TextStyle(fontSize: 9),
                                        textAlign: pw.TextAlign.right),
                                    pw.SizedBox(height: 5),
                                    if (showDiscount) ...[
                                      pw.Text(widget.discount,
                                          style: pw.TextStyle(fontSize: 9),
                                          textAlign: pw.TextAlign.right),
                                      pw.SizedBox(height: 5),
                                    ],
                                    pw.Text(widget.vat,
                                        style: pw.TextStyle(fontSize: 9),
                                        textAlign: pw.TextAlign.right),
                                    pw.SizedBox(height: 5),
                                    pw.Text(widget.taxableamount,
                                        style: pw.TextStyle(fontSize: 9),
                                        textAlign: pw.TextAlign.right),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        pw.SizedBox(height: 5),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(left: 365),
                          child: pw.Container(
                            width: 200,
                            height: 25,
                            color: PdfColors.grey100,
                            child: pw.Row(
                              children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 5),
                                  child: pw.Text(
                                    "TOTAL AMOUNT :",
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Spacer(),
                                // Push the total amount to the right edge
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(right: 5),
                                  child: pw.Text(
                                    "${widget.totalamount} AED",
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        pw.SizedBox(height: 8),
                        pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 365),
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

                        pw.Text("Notes", style: pw.TextStyle(fontSize: 10)),
                        pw.SizedBox(height: 5),
                        pw.Text(widget.naq, style: pw.TextStyle(fontSize: 10)),
                        pw.SizedBox(height: 10),
                        pw.Text("Terms & Conditions",
                            style: pw.TextStyle(
                              fontSize: 10,
                            )),
                        pw.SizedBox(height: 5),
                        pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                  width: 400,
                                  height: 50,
                                  child: pw.Text(widget.TAC,
                                      style: pw.TextStyle(fontSize: 10))),
                              widget.option.trim().toLowerCase() == 'yes'
                                  ? pw.Column(children: [
                                      pw.Container(
                                          width: 160,
                                          height: 160,
                                          child: pw.Image(sign)),
                                      pw.Text("Authorized Signature",
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              fontWeight: pw.FontWeight.normal))
                                    ])
                                  : widget.option.trim().toLowerCase() == 'no'
                                      ? pw.Wrap(children: [
                                          pw.Text(
                                              'This is computer generated\ncode This not need to Sign'),
                                        ])
                                      : pw.SizedBox()
                            ])
                      ],
                    )),
              ],
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
        title: const Text('Quotation PDF Preview'),
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
