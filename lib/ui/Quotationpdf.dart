

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
  final String date;
  final String kindatt;
  final String project;
  final String nbq;
  final List<String> sno;
  final List<String> description;
  final List<String> qty;
  final List<String> unit;
  final List<String> rate;
  final List<String> amount;
  final String subtotal;
  final String discount;
  final String taxableamount;
  final String vat;
  final String totalamount;
  final String totalamountinname;
  final String naq;
  final String name;
  final String address;

  const InvoicePdfPreviewPage({
    Key? key,
    required this.qtnno,
    required this.date,
    required this.kindatt,
    required this.project,
    required this.nbq,
    required this.sno,
    required this.description,
    required this.qty,
    required this.unit,
    required this.rate,
    required this.amount,
    required this.subtotal,
    required this.discount,
    required this.taxableamount,
    required this.vat,
    required this.totalamount,
    required this.totalamountinname,
    required this.naq,
    required this.name,
    required this.address,
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

  Future<String> generatePdf() async {
    final pdf = pw.Document();

    final image = pw.MemoryImage(
      (await rootBundle.load('assets/header.png')).buffer.asUint8List(),
    );

    final image1 = pw.MemoryImage(
      (await rootBundle.load('assets/logoin.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(image),
              pw.SizedBox(height: 5),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 200, top: 10),
                child: pw.Text(
                  "Quotation",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("To.", style: pw.TextStyle(fontSize: 12)),
                    pw.SizedBox(height: 5),
                    pw.Container(height: 16, width: 240, child: pw.Text(widget.name, style: pw.TextStyle(fontSize: 12))),
                    pw.SizedBox(height: 5),
                    pw.Container(height: 16, width: 240, child: pw.Text(widget.address, style: pw.TextStyle(fontSize: 12))),
                    pw.SizedBox(height: 5),
                    pw.Text("United Arab Emirates", style: pw.TextStyle(fontSize: 10, decoration: pw.TextDecoration.underline)),
                  ],
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 5),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 120),
                        child: pw.Text("Quotation/AMD/${widget.qtnno}", style: pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 120),
                        child: pw.Text("Date: ${widget.date}", style: pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 120),
                        child: pw.Text("TRN-100342182100003", style: pw.TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                )
              ]),
              pw.SizedBox(height: 10),
              pw.Text("Kind Att:${widget.kindatt}", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Text("Project : ${widget.project}", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Text("Dear Sir/Madam,", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Text(widget.nbq, style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 3),

              // Table headers
              pw.Container(
                color: PdfColor.fromInt(0xFFC62828),
                child: pw.Row(
                  children: [
                    pw.Expanded(flex: 1, child: pw.Text("No", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white))),
                    pw.SizedBox(width: 3),
                    pw.Expanded(flex: 5, child: pw.Text("Description", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white))),
                    pw.SizedBox(width: 5),
                    pw.Expanded(flex: 1, child: pw.Text("Qty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white))),
                    pw.SizedBox(width: 5),
                    pw.Expanded(flex: 1, child: pw.Text("Unit", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white))),
                    pw.SizedBox(width: 5),
                    pw.Expanded(flex: 1, child: pw.Text("Rate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white))),
                    pw.SizedBox(width: 5),
                    pw.Expanded(flex: 1, child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white))),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              ...List.generate(widget.sno.length, (i) {
                return pw.Column(children: [
                  pw.Row(
                    children: [
                      pw.Expanded(flex: 1, child: pw.Text(widget.sno[i], style: pw.TextStyle(fontSize: 10))),
                      pw.SizedBox(width: 3),
                      pw.Expanded(flex: 5, child: pw.Text(widget.description[i], style: pw.TextStyle(fontSize: 10))),
                      pw.SizedBox(width: 5),
                      pw.Expanded(flex: 1, child: pw.Text(widget.qty[i], style: pw.TextStyle(fontSize: 10))),
                      pw.SizedBox(width: 5),
                      pw.Expanded(flex: 1, child: pw.Text(widget.unit[i], style: pw.TextStyle(fontSize: 10))),
                      pw.SizedBox(width: 5),
                      pw.Expanded(flex: 1, child: pw.Text(widget.rate[i], style: pw.TextStyle(fontSize: 10))),
                      pw.SizedBox(width: 5),
                      pw.Expanded(flex: 1, child: pw.Text(widget.amount[i], style: pw.TextStyle(fontSize: 10))),
                    ],
                  ),
                  if (i != 0) pw.Divider(),
                  pw.SizedBox(height: 10),
                ]);
              }),

              // Subtotal and totals
              pw.Row(children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 300),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("SUBTOTAL :", style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Text("DISCOUNT :", style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Text("VAT :", style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Text("TAXABLE AMOUNT :", style: pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 50),
                  child: pw.Column(
                    children: [
                      pw.Text(widget.subtotal, style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                      pw.SizedBox(height: 5),
                      pw.Text(widget.discount, style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                      pw.SizedBox(height: 5),
                      pw.Text(widget.vat, style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                      pw.SizedBox(height: 5),
                      pw.Text(widget.taxableamount, style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                    ],
                  ),
                ),
              ]),
              pw.Divider(indent: 280),
              pw.Row(children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 300),
                  child: pw.Text("TOTAL AMOUNT :", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 60),
                  child: pw.Text(widget.totalamount, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                )
              ]),
              pw.SizedBox(height: 20),
              pw.Text(widget.totalamountinname, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
              pw.SizedBox(height: 10),
              pw.Text("Note:${widget.naq}", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Text("Payment Terms:", style: pw.TextStyle(fontSize: 10, decoration: pw.TextDecoration.underline)),
              pw.Text("50% Advance Payment,40% Work in Progress,10% Completion of Work", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Thank You & Regards\nYours Faithfully,\nAl Maskan", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 10),
                  pw.Container(
                    width: 90,
                    height: 90,
                    child: pw.Image(image1, fit: pw.BoxFit.contain),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
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
        content: TextField(controller: fileNameController, decoration: const InputDecoration(hintText: 'File name ')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Save')),
        ],
      ),
    );

    final fileName = fileNameController.text;
    if (fileName.isNotEmpty) {
      final fileNameWithExtension = fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';
      await InvoicePdfPreviewPage.save(bytes!, fileNameWithExtension);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File name cannot be empty')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
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