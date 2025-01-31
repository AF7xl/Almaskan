import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Taxinvoicepdf extends StatefulWidget {
  final String invno;
  final String date;
  final String kindatt;
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

  const Taxinvoicepdf(
      {super.key,
      required this.invno,
      required this.date,
      required this.kindatt,
      required this.advancepercent,
      required this.project,
      required this.nbq,
      required this.subtotal,
      required this.advance,
      required this.vat,
      required this.totalamount,
      required this.totalamountinname,
      required this.naq, required this.name, required this.address, required this.trn});

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
      File('assets/header.png').readAsBytesSync(),
    );
    final image1 = pw.MemoryImage(
      File('assets/logoin.png').readAsBytesSync(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(image),
                pw.SizedBox(height: 5),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 200, top: 10),
                  child: pw.Text(
                    "TAX INVOICE",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw
                          .TextDecoration.underline, // Add underline decoration
                    ),
                  ),
                ),

                pw.SizedBox(height: 20.h),
                // To Section
                pw.Row(children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("To.",
                            style: pw.TextStyle(
                              fontSize: 12,
                            )),
                        pw.SizedBox(height: 5),
                        pw.Container(
                            height: 16,
                            width: 240,
                            child: pw.Text(widget.name,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ))),
                        pw.SizedBox(height: 5),
                        pw.Container(
                            height: 16,
                            width: 240,
                            child: pw.Text(widget.address,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ))),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "TRN-${widget.trn}",
                          style: pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "United Arab Emirates",
                          style: pw.TextStyle(
                            fontSize: 10,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                      ]),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(left: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 120),
                          child: pw.Text(
                            "Page : 1 of 1",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 120),
                          child: pw.Text(
                            "Invoice/AMD/${widget.invno}",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 120),
                          child: pw.Text(
                            "Date:${widget.date}",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 120),
                          child: pw.Text(
                            "TRN-100342182100003",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Kind Att: ${widget.kindatt}",
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 10),

                pw.Text(
                  "Dear Sir/Madam,",
                  style: pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 10),

                pw.Text(
                  widget.nbq,
                  style: pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 3),
                pw.Table(border: pw.TableBorder.all(), columnWidths: const {
                  0: pw.FlexColumnWidth(2), // First column width (flexible)
                  1: pw.FlexColumnWidth(2), // Second column width (flexible)
                }, children: [
                  pw.TableRow(
                    decoration:
                        pw.BoxDecoration(color: PdfColor.fromInt(0xFFC62828)),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Description',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                              fontSize: 14),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Amount (AED)',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                              fontSize: 14),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.white),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Sub Total Taxable LPO Amount',
                          style: pw.TextStyle(
                              color: PdfColors.black, fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          widget.subtotal,
                          style: pw.TextStyle(
                              color: PdfColors.black, fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.white),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          '${widget.advancepercent}% Advance Payment',
                          style: pw.TextStyle(
                              color: PdfColors.black, fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          widget.advance,
                          style: pw.TextStyle(
                              color: PdfColors.black, fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.white),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Vat (5%)',
                          style: pw.TextStyle(
                              color: PdfColors.black, fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          widget.vat,
                          style: pw.TextStyle(
                              color: PdfColors.black, fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.white),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'TOTAL AMOUNT (AED)',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                              fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          widget.totalamount,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                              fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ]),

                pw.SizedBox(height: 20),
                pw.Text(
                  widget.totalamountinname,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    decoration:
                        pw.TextDecoration.underline, // Adds the underline
                  ),
                ),

                // Notes
                pw.SizedBox(height: 10),
                pw.Text("Note:${widget.naq}", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.Text("Bank Details:",
                    style: pw.TextStyle(
                      fontSize: 10,
                      decoration: pw.TextDecoration.underline,
                    )),
                pw.SizedBox(height: 5),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text("Account Name :",
                            style: pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(width: 5),
                        pw.Text("Al Maskan Plaster & Tiles Cont.",
                            style: pw.TextStyle(fontSize: 8)),
                      ]),
                      pw.SizedBox(height: 5),
                      pw.Row(children: [
                        pw.Text("Bank :", style: pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(width: 39),
                        pw.Text("Sharjah Islamic Bank",
                            style: pw.TextStyle(fontSize: 8)),
                      ]),
                      pw.SizedBox(height: 5),
                      pw.Row(children: [
                        pw.Text("Account No :",
                            style: pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(width: 16),
                        pw.Text("001-2079331-001",
                            style: pw.TextStyle(fontSize: 8)),
                      ]),
                      pw.SizedBox(height: 5),
                      pw.Row(children: [
                        pw.Text("IBN :", style: pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(width: 44),
                        pw.Text("AE48 0410 0000 1207 9331 001",
                            style: pw.TextStyle(fontSize: 8)),
                      ]),
                      pw.SizedBox(height: 5),
                      pw.Row(children: [
                        pw.Text("Branch :", style: pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(width: 32),
                        pw.Text("Al Wasit", style: pw.TextStyle(fontSize: 8)),
                      ])
                    ]),
                pw.SizedBox(height: 20),

                // Footer
                pw.Stack(children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Text without Expanded, keeping natural width
                      pw.Text(
                        "Thank You & Regards\nYours Faithfully,\nAl Maskan",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      // Add some spacing between text and image
                      // Image with fixed width of 140
                      pw.Container(
                        width: 90, // Set container width for the image
                        height: 90, // Adjust the image height
                        child: pw.Image(
                          image1,
                          fit: pw.BoxFit
                              .contain, // Ensure the image fits within the container
                        ),
                      ),
                    ],
                  )
                ])
              ],
            )
          ];
        },
      ),
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
