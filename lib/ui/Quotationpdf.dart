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

  pw.Widget _th(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  pw.Widget _td(String? text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text ?? '',
        textAlign: align,
        style: pw.TextStyle(fontSize: 9),
      ),
    );
  }

  final tableColumnWidths = <int, pw.TableColumnWidth>{
    0: const pw.FixedColumnWidth(25), // #
    1: const pw.FlexColumnWidth(5), // Description
    2: const pw.FixedColumnWidth(40), // Qty
    3: const pw.FixedColumnWidth(40), // Unit
    4: const pw.FixedColumnWidth(50), // Rate
    5: const pw.FixedColumnWidth(60), // Amount
  };

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
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 20.h),
                                  child: pw.Container(
                                      width: 160.w,
                                      height: 160.h,
                                      child: pw.Image(image))),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                        padding: pw.EdgeInsets.only(top: 25.h),
                                        child: pw.Text("Quote",
                                            style: pw.TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight:
                                                    pw.FontWeight.bold))),
                                    pw.Padding(
                                        padding: pw.EdgeInsets.only(left: 3.w),
                                        child: pw.Text("No-QT-${widget.qtnno}",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                fontSize: 11.sp)))
                                  ])
                            ]),
                        pw.SizedBox(height: 10.h),
                        buildCompanyDetails(),
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
                                    pw.SizedBox(height: 3.h),
                                    pw.Text(widget.name,
                                        style: pw.TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text(widget.address,
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
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Quote Date : ${widget.date}",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 9.sp,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 3.h),
                                    pw.Text("kind att : ${widget.kindatt}",
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 3.h),
                                    pw.Text("Project : ${widget.project}",
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5)),
                                    pw.SizedBox(height: 3.h),
                                    pw.Text(widget.newfeild,
                                        style: pw.TextStyle(
                                            fontSize: 9.sp,
                                            fontWeight: pw.FontWeight.normal,
                                            letterSpacing: 0.5))
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
                        // Table headers
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
                                child: pw.Text("#",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10.sp,
                                        color: PdfColors.white)),
                              ),
                              pw.SizedBox(width: 3),
                              pw.Expanded(
                                flex: 5,
                                child: pw.Text("Description",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Qty",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text("Unit",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                        fontSize: 10.sp)),
                              ),
                              pw.SizedBox(width: 5.w),
                              pw.Expanded(
                                flex: 1,
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
                                flex: 1,
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

                        pw.SizedBox(height: 4.h),
                        ...widget.lineItems.map((item) {
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
                                          item['sno'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 3.w),
                                  pw.Expanded(
                                    flex: 5,
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text(
                                        item['description'] ?? '',
                                        style: pw.TextStyle(fontSize: 9.sp),
                                        textAlign: pw.TextAlign.left,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(width: 5.w),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.right,
                                          item['quantity'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5.w),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.right,
                                          item['unit'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5.w),
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(
                                          textAlign: pw.TextAlign.right,
                                          item['rate'] ?? '',
                                          style: pw.TextStyle(
                                            fontSize: 9.sp,
                                          ))),
                                  pw.SizedBox(width: 5.w),
                                  pw.Expanded(
                                      flex: 1,
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

                        // Subtotal and totals
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Container(
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    /// SUBTOTAL
                                    pw.Row(
                                      mainAxisSize: pw.MainAxisSize.min,
                                      children: [
                                        pw.SizedBox(
                                          width: 120.w,
                                          child: pw.Text(
                                            "SUBTOTAL",
                                            style:
                                                pw.TextStyle(fontSize: 10.sp),
                                          ),
                                        ),
                                        pw.SizedBox(
                                          width: 10.w,
                                          child: pw.Text(":",
                                              textAlign: pw.TextAlign.center),
                                        ),
                                        pw.SizedBox(
                                          width: 80.w,
                                          child: pw.Text(
                                            formatIndian(widget.subtotal),
                                            textAlign: pw.TextAlign.right,
                                            style: pw.TextStyle(fontSize: 9.sp),
                                          ),
                                        ),
                                      ],
                                    ),

                                    pw.SizedBox(height: 5.h),

                                    /// DISCOUNT
                                    if (showDiscount)
                                      pw.Row(
                                        mainAxisSize: pw.MainAxisSize.min,
                                        children: [
                                          pw.SizedBox(
                                            width: 120.w,
                                            child: pw.Text(
                                              "DISCOUNT",
                                              style:
                                                  pw.TextStyle(fontSize: 9.sp),
                                            ),
                                          ),
                                          pw.SizedBox(
                                            width: 10.w,
                                            child: pw.Text(":",
                                                textAlign: pw.TextAlign.center),
                                          ),
                                          pw.SizedBox(
                                            width: 80.w,
                                            child: pw.Text(
                                              formatIndian(widget.discount),
                                              textAlign: pw.TextAlign.right,
                                              style:
                                                  pw.TextStyle(fontSize: 9.sp),
                                            ),
                                          ),
                                        ],
                                      ),

                                    if (showDiscount) pw.SizedBox(height: 5.h),
                                    if (showDiscount)
                                      pw.Row(
                                        mainAxisSize: pw.MainAxisSize.min,
                                        children: [
                                          pw.SizedBox(
                                            width: 120.w,
                                            child: pw.Text(
                                              "TAXABLE AMOUNT",
                                              style:
                                                  pw.TextStyle(fontSize: 10.sp),
                                            ),
                                          ),
                                          pw.SizedBox(
                                            width: 10.w,
                                            child: pw.Text(":",
                                                textAlign: pw.TextAlign.center),
                                          ),
                                          pw.SizedBox(
                                            width: 80.w,
                                            child: pw.Text(
                                              formatIndian(
                                                  widget.taxableamount),
                                              textAlign: pw.TextAlign.right,
                                              style:
                                                  pw.TextStyle(fontSize: 9.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (showDiscount) pw.SizedBox(height: 5.h),

                                    /// VAT
                                    pw.Row(
                                      mainAxisSize: pw.MainAxisSize.min,
                                      children: [
                                        pw.SizedBox(
                                          width: 120.w,
                                          child: pw.Text(
                                            "VAT (5%)",
                                            style: pw.TextStyle(fontSize: 9.sp),
                                          ),
                                        ),
                                        pw.SizedBox(
                                          width: 10.w,
                                          child: pw.Text(":",
                                              textAlign: pw.TextAlign.center),
                                        ),
                                        pw.SizedBox(
                                          width: 80.w,
                                          child: pw.Text(
                                            formatIndian(widget.vat),
                                            textAlign: pw.TextAlign.right,
                                            style: pw.TextStyle(fontSize: 9.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),

                        pw.SizedBox(height: 5.h),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                              color: PdfColors.grey100,
                              child: pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: 120.w,
                                    child: pw.Text(
                                      "TOTAL AMOUNT (AED)",
                                      style: pw.TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(
                                    width: 10.w,
                                    child: pw.Text(":",
                                        textAlign: pw.TextAlign.center),
                                  ),
                                  // Push the total amount to the right edge
                                  pw.SizedBox(
                                    width: 80.w,
                                    child: pw.Text(
                                      formatIndian(widget.totalamount),
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8.h),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Total In Words:",
                                  style: pw.TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: pw.FontWeight.normal,
                                  )),
                              pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 5.w),
                                  child: pw.Container(
                                      height: 50.h,
                                      child: pw.Text(widget.totalamountinname,
                                          style: pw.TextStyle(
                                              decoration:
                                                  pw.TextDecoration.underline,
                                              fontSize: 9.sp,
                                              color: PdfColors.black,
                                              fontStyle: pw.FontStyle.italic))))
                            ]),

                        pw.Text("Notes", style: pw.TextStyle(fontSize: 10.sp)),
                        pw.SizedBox(height: 5.h),
                        pw.Text(widget.naq,
                            style: pw.TextStyle(fontSize: 10.sp)),
                        pw.SizedBox(height: 10.h),
                        pw.Text("Terms & Conditions",
                            style: pw.TextStyle(
                              fontSize: 10.sp,
                            )),
                        pw.SizedBox(height: 5.h),
                        pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                  width: 400.w,
                                  height: 50.h,
                                  child: pw.Text(widget.TAC,
                                      style: pw.TextStyle(fontSize: 10.sp))),
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
                                      height: 100.h,
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
          'Quotation PDF Preview',
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
