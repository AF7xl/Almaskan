import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Statementpdf extends StatefulWidget {
  const Statementpdf({super.key});

  @override
  State<Statementpdf> createState() => _StatementpdfState();

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

class _StatementpdfState extends State<Statementpdf> {
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
                    "STATEMENT",
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
                        pw.Text("Cherwell Interior Decoration (L.L.C)",
                            style: pw.TextStyle(
                              fontSize: 12,
                            )),
                        pw.SizedBox(height: 5),
                        pw.Text("Dubai Investment Park",
                            style: pw.TextStyle(
                              fontSize: 12,
                            )),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "TRN-100342182100003",
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
                            "Date: 27/June/2024",
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
                  "Kind Att: Mr.Baskar",
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 10),

                pw.Text(
                  "Subject : Statement Of Account",
                  style: pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 10),

                pw.Row(
                  children: [
                    pw.Container(
                      width: 25,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "Sno",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 200,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "Project Name",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 60,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "INV NO",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 60,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "Date",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 70,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "LPO No",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 70,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "Amount",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
                pw.ListView(children: [
                  pw.Row(
                    children: [
                      pw.Container(
                          width: 25,
                          height: 20,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Center(
                            child: pw.Text(
                              "1",
                              style: pw.TextStyle(

                                  fontSize: 8),
                            ),
                          )),pw.Container(
                          width: 200,
                          height: 20,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color:  PdfColors.black)),
                          child: pw.Center(
                            child: pw.Text(
                              "G026-HALBERS EXTENSION ABU DHABI",
                              style: pw.TextStyle(

                                  fontSize: 8),
                            ),
                          )),
                      pw.Container(
                          width: 60,
                          height: 20,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Center(
                            child: pw.Text(
                              "24/62",
                              style: pw.TextStyle(

                                  fontSize: 8),
                            ),
                          )),
                      pw.Container(
                          width: 60,
                          height: 20,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Center(
                            child: pw.Text(
                              "30/20/24",
                              style: pw.TextStyle(

                                  fontSize: 8),
                            ),
                          )),
                      pw.Container(
                          width: 70,
                          height: 20,
                          decoration: pw.BoxDecoration(
                              border:pw. Border.all(color:  PdfColors.black)),
                          child: pw.Center(
                            child: pw.Text(
                              "POIA012721",
                              style: pw.TextStyle(

                                  fontSize: 8),
                            ),
                          )),
                      pw.Container(
                          width: 70,
                          height: 20,
                          decoration:pw. BoxDecoration(
                              border: pw.Border.all(color:  PdfColors.black)),
                          child: pw.Center(
                            child: pw.Text(
                              "36004",
                              style: pw.TextStyle(

                                  fontSize: 8),
                            ),
                          ))
                    ],
                  )
                ]),pw.Row(
                  children: [
                    pw.Container(
                      width: 25,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),

                    ),pw.Container(
                      width: 200,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color:  PdfColors.black)),
                      child: pw.Center(
                        child:pw. Text(
                          "TOTAL AMOUNT (AED)",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 9),
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 60,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),

                    ),
                    pw.Container(
                      width: 60,
                      height: 20,
                      decoration:pw. BoxDecoration(
                          border: pw.Border.all(color:  PdfColors.black)),

                    ),
                    pw.Container(
                      width: 70,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border:pw. Border.all(color:  PdfColors.black)),

                    ),
                    pw.Container(
                      width: 70,
                      height: 20,
                      decoration: pw.BoxDecoration(
                          border:pw. Border.all(color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text(
                          "365,451.50",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 9),
                        ),
                      ),
                    )
                  ],
                ),



                // Subtotal and Total


                pw.SizedBox(height: 10),
                pw.Text(
                  "Total Dirham Fourty Three thousand And Fifty Fills Only",
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    decoration:
                        pw.TextDecoration.underline, // Adds the underline
                  ),
                ),

              pw.SizedBox(height: 20),

                // Footer
                pw.Stack(children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Text without Expanded, keeping natural width
                      pw.Text(
                        "Thank You & Regards,\nYours Faithfully,\nAl Maskan",
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
      await Statementpdf.save(bytes!, fileNameWithExtension);
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
        backgroundColor: Colors.grey,
        title: const Text('Invoice PDF Preview'),
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
          Padding(
            padding: EdgeInsets.only(right: 50.w),
            child: IconButton(
              icon: Icon(
                Icons.print,
                size: 25.sp,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: pdfFilePath == null
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(File(pdfFilePath!)),
    );
  }
}
