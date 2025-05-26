import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Vatpurchase extends StatefulWidget {
  const Vatpurchase({super.key});

  @override
  State<Vatpurchase> createState() => _VatpurchaseState();
}

class _VatpurchaseState extends State<Vatpurchase> {
  List<String> Invnooptions = [];
  final Invnofirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("Invnooptions");
  List<String> Supplieroption = [];
  final Supplierfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("Supplieroptions");
  List<String> Projectoption = [];
  final Projectfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("Projectoption");
  final currentdate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(
      File('assets/Logo.png').readAsBytesSync(),
    );
    final image1 = pw.MemoryImage(
      File('assets/logoin.png').readAsBytesSync(),
    );
    final headerStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 8,
      color: PdfColors.white,
    );
    final textstyle = pw.TextStyle(
      fontWeight: pw.FontWeight.normal,
      fontSize: 8,
      color: PdfColors.black,
    );

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Container(width: 160, height: 160, child: pw.Image(image)),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("AL MASKAN PLASTER & TILE CONT",
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 3),
                pw.Text("Industrial-8", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("Sharjah", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("United Arab Emirates",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("TRN 100342182100003",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("0508089505", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("almaskandecor@gmail.com",
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
                padding: pw.EdgeInsets.only(left: 200),
                child: pw.Text(
                  "Vat Purchase",
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                )),
            pw.SizedBox(height: 20),
            pw.Padding(
              padding: pw.EdgeInsets.only(left: 400),
              child: pw.Text("Date: $currentdate",
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.normal)),
            ),
            pw.SizedBox(height: 20),

            // Header Row
            pw.Container(
              width: double.infinity,
              height: 20,
              color: PdfColors.red800,
              child: pw.Row(
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(left: 5),
                      child: pw.SizedBox(
                          width: 50,
                          child: pw.Text("Date", style: headerStyle))),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(left: 5),
                    child: pw.SizedBox(
                        width: 70,
                        child: pw.Text("Invoice no", style: headerStyle)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(left: 5),
                    child: pw.SizedBox(
                        width: 80,
                        child: pw.Text("Supplier", style: headerStyle)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(left: 12),
                    child: pw.SizedBox(
                        width: 70,
                        child: pw.Text("Project", style: headerStyle)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(left: 5),
                    child: pw.SizedBox(
                        width: 75,
                        child: pw.Text("Invoice Amount", style: headerStyle)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(left: 6),
                    child: pw.SizedBox(
                        width: 30, child: pw.Text("Tax", style: headerStyle)),
                  ),
                  pw.SizedBox(
                      width: 70,
                      child: pw.Text("Total Amount", style: headerStyle)),
                ],
              ),
            ),

            // Data rows
            ...filteredData.map((data) {
              return pw.Container(
                width: double.infinity,
                height: 25,
                color: filteredData.indexOf(data) % 2 == 0
                    ? PdfColors.grey100
                    : PdfColors.white,
                child: pw.Row(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 5),
                      child: pw.SizedBox(
                          width: 50,
                          child: pw.Text(data['Date'] ?? '', style: textstyle)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 5),
                      child: pw.SizedBox(
                          width: 75,
                          child: pw.Text(data['Invoice no'] ?? '',
                              style: textstyle)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 1),
                      child: pw.SizedBox(
                          width: 90,
                          child: pw.Text(data['Supplier'] ?? '',
                              style: textstyle)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 2),
                      child: pw.SizedBox(
                          width: 75,
                          child:
                              pw.Text(data['Project'] ?? '', style: textstyle)),
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(left: 2),
                        child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(data['Invoice Amount'] ?? '',
                                style: textstyle))),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(left: 32),
                        child: pw.SizedBox(
                            width: 25,
                            child:
                                pw.Text(data['Tax'] ?? '', style: textstyle))),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 6),
                      child: pw.SizedBox(
                          width: 40,
                          child: pw.Text(data['Total Amount'] ?? '',
                              style: textstyle)),
                    ),
                  ],
                ),
              );
            }).toList(),

            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Padding(
                padding: pw.EdgeInsets.only(left: 350),
                child: pw.Text("Invoice Amount: $totalInvoice",
                    style: pw.TextStyle(fontSize: 10))),
            pw.SizedBox(height: 2),
            pw.Padding(
                padding: pw.EdgeInsets.only(left: 350),
                child: pw.Text("Tax (5%):           $totalTax",
                    style: pw.TextStyle(fontSize: 10))),
            pw.SizedBox(height: 2),

            pw.Padding(
                padding: pw.EdgeInsets.only(left: 350),
                child: pw.Text("Total Amount:     $totalAmount",
                    style: pw.TextStyle(fontSize: 10))),



          ])
        ],  footer: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Divider(
                thickness: 1.5,
                color: PdfColors.grey,
                endIndent: 22,
                indent: 22),
            pw.SizedBox(height: 5)
          ],
        );
      }
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  TextEditingController date = TextEditingController();
  TextEditingController invoiceno = TextEditingController();
  TextEditingController supplier = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController invoiceamount = TextEditingController();
  TextEditingController tax = TextEditingController();
  TextEditingController totalamount = TextEditingController();
  String selectedInvno = '';
  String selectedSupplier = '';
  String selectedProject = '';

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  double totalInvoice = 0;
  double totalTax = 0;
  double totalAmount = 0;

  List<Map<String, dynamic>> filteredData = [];
  bool showfiltercontainer = false;
  final firestore = FirebaseFirestore.instance.collection('Vat Purchase');

  void initState() {
    super.initState();
    invoiceamount.addListener(_updatetotal);
    tax.addListener(_updatetotal);
    _fetchFilteredData();
    fetchInvnoSuggestions();
    fetchSupplierSuggestion();
    fetchprojectsuggestion();
  }
  void fetchInvnoSuggestions() async {
    final docSnapshot = await Invnofirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      Invnooptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }
  void fetchSupplierSuggestion() async {
    final docSnapshot = await Supplierfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      Supplieroption = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }
  void fetchprojectsuggestion() async {
    final docSnapshot = await Projectfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      Projectoption = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }
  void _updatetotal() {
    double invoiceAmountValue = double.tryParse(invoiceamount.text) ?? 0.00;

    // Automatically calculate 5% tax
    double taxValue = invoiceAmountValue * 0.05;

    // Set tax text field
    tax.text = taxValue.toStringAsFixed(2);

    // Calculate total amount
    double total = invoiceAmountValue + taxValue;
    totalamount.text = total.toStringAsFixed(2);
  }

  void dispose() {
    invoiceamount.removeListener(_updatetotal);
    tax.removeListener(_updatetotal);

    invoiceamount.dispose();
    tax.dispose();
    totalamount.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });

      await _fetchFilteredData();
    }
  }

  Future<void> _fetchFilteredData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Vat Purchase').get();

    final dateFormat = DateFormat('dd-MM-yyyy');
    final List<Map<String, dynamic>> loadedData = [];

    double invoiceSum = 0;
    double taxSum = 0;
    double totalSum = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dateStr = data['Date'] ?? '';
      try {
        final date = dateFormat.parse(dateStr);

        // ✅ Only skip if filtering and the date is out of range
        if (_startDate != null && _endDate != null) {
          if (date.isBefore(_startDate!) || date.isAfter(_endDate!)) {
            continue;
          }
        }

        final invoice = double.tryParse(data['Invoice Amount'] ?? '0') ?? 0;
        final tax = double.tryParse(data['Tax'] ?? '0') ?? 0;
        final total = double.tryParse(data['Total Amount'] ?? '0') ?? 0;

        invoiceSum += invoice;
        taxSum += tax;
        totalSum += total;

        loadedData.add({
          'id': doc.id,
          ...data,
        });
      } catch (e) {
        print('Invalid date: $dateStr');
      }
    }

    setState(() {
      filteredData = loadedData;
      totalInvoice = invoiceSum;
      totalTax = taxSum;
      totalAmount = totalSum;
    });
  }

  void _editcontainer(
      BuildContext context, String docId, Map<String, dynamic> data) {
    final date = TextEditingController(text: data['Date']);
    final invoiceno = TextEditingController(text: data['Invoice no']);
    final supplier = TextEditingController(text: data['Supplier']);
    final project = TextEditingController(text: data['Project']);
    final invoiceamount = TextEditingController(text: data['Invoice Amount']);
    final tax = TextEditingController(text: data['Tax']);
    final totalamount = TextEditingController(text: data['Total Amount']);

    // Auto-calculate tax and total when invoice amount is changed
    void calculateVAT() {
      final value = double.tryParse(invoiceamount.text);
      if (value != null) {
        final vat = value * 0.05;
        final total = value + vat;
        tax.text = vat.toStringAsFixed(2);
        totalamount.text = total.toStringAsFixed(2);
      } else {
        tax.text = '';
        totalamount.text = '';
      }
    }

    invoiceamount.addListener(calculateVAT); // Attach listener

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Entry"),
        content: Container(
          width: 400.w,
          height: 390.h,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: date,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Date"),
                ),
                TextField(
                  controller: invoiceno,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Invoice no"),
                ),
                TextField(
                  controller: supplier,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Supplier"),
                ),
                TextField(
                  controller: project,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Project"),
                ),
                TextField(
                  controller: invoiceamount,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Invoice Amount"),
                ),
                TextField(
                  controller: tax,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Tax (5%)"),
                ),
                TextField(
                  controller: totalamount,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Total Amount"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Vat Purchase')
                  .doc(docId)
                  .update({
                'Date': date.text,
                'Invoice no': invoiceno.text,
                'Supplier': supplier.text,
                'Project': project.text,
                'Invoice Amount': invoiceamount.text,
                'Tax': tax.text,
                'Total Amount': totalamount.text,
              });
              Navigator.pop(context);
              _fetchFilteredData(); // Refresh
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: Colors.black,
            )),
        title: Text(
          "Vat Purchase",
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 20.sp),
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                showfiltercontainer = !showfiltercontainer;
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 16.sp,
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Text(
                    "Filter",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showfiltercontainer
              ? Container(
                  width: double.infinity,
                  height: 80.h,
                  color: Colors.blueGrey[100],
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Text(
                                  "Date",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                width: 90.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: TextFormField(
                                    controller: date,
                                    readOnly: true, // Prevents keyboard from appearing
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                        date.text = formattedDate;
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    cursorHeight: 20.h,
                                    cursorWidth: 0.5,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                    ),
                                    textAlign: TextAlign.start,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        top: 2.h,
                                        left: 5.w,
                                        bottom: 18.h,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Select Date',
                                    ),
                                  )
                                  ,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "Invoice no",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12.sp,
                                          color: Colors.black),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController _InvnosuggestionController =
                                              TextEditingController();
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4.r)),
                                                title: Text("Add INVNO Suggestion"),
                                                insetPadding: EdgeInsets.symmetric(
                                                    horizontal: 40, vertical: 24),
                                                // Controls width and height
                                                content: SizedBox(
                                                  width: 400.w, // Custom width
                                                  height: 90.h, // Custom height
                                                  child: TextFormField(
                                                    controller: _InvnosuggestionController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                      "Enter your Suggestion here...",
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    maxLines: null,
                                                    expands: true,
                                                    // Expands to fill the height
                                                    keyboardType:
                                                    TextInputType.multiline,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      final suggestion =
                                                      _InvnosuggestionController.text.trim();
                                                      if (suggestion.isEmpty) return;

                                                      try {
                                                        await Invnofirestore.update({
                                                          'suggestions':
                                                          FieldValue.arrayUnion(
                                                              [suggestion])
                                                        }).catchError((_) async {
                                                          await Invnofirestore.set({
                                                            'suggestions': [suggestion]
                                                          });
                                                        });

                                                        Navigator.of(context).pop();
                                                        fetchInvnoSuggestions(); // Refresh the local list

                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Suggestion Saved'),
                                                            duration:
                                                            Duration(seconds: 2),
                                                            backgroundColor:
                                                            Colors.green,
                                                            behavior: SnackBarBehavior
                                                                .floating,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                            ),
                                                            margin: EdgeInsets.all(15),
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Failed to Save: $e'),
                                                            backgroundColor: Colors.red,
                                                            duration:
                                                            Duration(seconds: 2),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text("Add"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child:
                                        Icon(Icons.add_circle, color: Colors.blue,size: 15.sp,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 130.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Autocomplete(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<String>.empty();
                                      }
                                      return Invnooptions.where((String option) {
                                        return option.toLowerCase().contains(
                                            textEditingValue.text.toLowerCase());
                                      });
                                    },
                                    onSelected: (String selection) {
                                      invoiceno.text = selection;
                                      selectedInvno = selection;
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      // Sync text initially
                                      textEditingController.text = invoiceno.text;

                                      // Sync both ways
                                      textEditingController.addListener(() {
                                        invoiceno.text = textEditingController.text;
                                      });

                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        maxLines: null,
                                        onFieldSubmitted: (v) {
                                          setState(() {
                                            selectedInvno = v;
                                          });
                                        },
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.multiline,
                                        cursorHeight: 25.h,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.start,
                                        cursorColor: Colors.black45,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 2.h, left: 5.w, bottom: 15.h),
                                          border: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                          hintText: "",
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },optionsViewBuilder: (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4,
                                        child: Container(
                                          width: 130.w,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final option = options.elementAt(index);
                                              return InkWell(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                  child: Text(option),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "Supplier",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12.sp,
                                          color: Colors.black),
                                    ),Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController _suppliersuggestioncontroller =
                                              TextEditingController();
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4.r)),
                                                title: Text("Add Supplier Suggestion"),
                                                insetPadding: EdgeInsets.symmetric(
                                                    horizontal: 40, vertical: 24),
                                                // Controls width and height
                                                content: SizedBox(
                                                  width: 400.w, // Custom width
                                                  height: 90.h, // Custom height
                                                  child: TextFormField(
                                                    controller: _suppliersuggestioncontroller,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                      "Enter your Suggestion here...",
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    maxLines: null,
                                                    expands: true,
                                                    // Expands to fill the height
                                                    keyboardType:
                                                    TextInputType.multiline,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      final suggestion =
                                                      _suppliersuggestioncontroller.text.trim();
                                                      if (suggestion.isEmpty) return;

                                                      try {
                                                        await Supplierfirestore.update({
                                                          'suggestions':
                                                          FieldValue.arrayUnion(
                                                              [suggestion])
                                                        }).catchError((_) async {
                                                          await Supplierfirestore.set({
                                                            'suggestions': [suggestion]
                                                          });
                                                        });

                                                        Navigator.of(context).pop();
                                                        fetchSupplierSuggestion(); // Refresh the local list

                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Suggestion Saved'),
                                                            duration:
                                                            Duration(seconds: 2),
                                                            backgroundColor:
                                                            Colors.green,
                                                            behavior: SnackBarBehavior
                                                                .floating,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                            ),
                                                            margin: EdgeInsets.all(15),
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Failed to Save: $e'),
                                                            backgroundColor: Colors.red,
                                                            duration:
                                                            Duration(seconds: 2),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text("Add"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child:
                                        Icon(Icons.add_circle, color: Colors.blue,size: 15.sp,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 130.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Autocomplete(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<String>.empty();
                                      }
                                      return Supplieroption.where((String option) {
                                        return option.toLowerCase().contains(
                                            textEditingValue.text.toLowerCase());
                                      });
                                    },
                                    onSelected: (String selection) {
                                      supplier.text = selection;
                                      selectedSupplier = selection;
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      // Sync text initially
                                      textEditingController.text = supplier.text;

                                      // Sync both ways
                                      textEditingController.addListener(() {
                                        supplier.text = textEditingController.text;
                                      });

                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        maxLines: null,
                                        onFieldSubmitted: (v) {
                                          setState(() {
                                            selectedSupplier = v;
                                          });
                                        },
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.multiline,
                                        cursorHeight: 25.h,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.start,
                                        cursorColor: Colors.black45,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 2.h, left: 5.w, bottom: 15.h),
                                          border: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                          hintText: "",
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },optionsViewBuilder: (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4,
                                        child: Container(
                                          width: 130.w,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final option = options.elementAt(index);
                                              return InkWell(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                  child: Text(option),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "Project",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12.sp,
                                          color: Colors.black),
                                    ),Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController _projectsuggestioncontroller =
                                              TextEditingController();
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4.r)),
                                                title: Text("Add Project Suggestion"),
                                                insetPadding: EdgeInsets.symmetric(
                                                    horizontal: 40, vertical: 24),
                                                // Controls width and height
                                                content: SizedBox(
                                                  width: 400.w, // Custom width
                                                  height: 90.h, // Custom height
                                                  child: TextFormField(
                                                    controller: _projectsuggestioncontroller,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                      "Enter your Suggestion here...",
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    maxLines: null,
                                                    expands: true,
                                                    // Expands to fill the height
                                                    keyboardType:
                                                    TextInputType.multiline,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      final suggestion =
                                                      _projectsuggestioncontroller.text.trim();
                                                      if (suggestion.isEmpty) return;

                                                      try {
                                                        await Projectfirestore.update({
                                                          'suggestions':
                                                          FieldValue.arrayUnion(
                                                              [suggestion])
                                                        }).catchError((_) async {
                                                          await Projectfirestore.set({
                                                            'suggestions': [suggestion]
                                                          });
                                                        });

                                                        Navigator.of(context).pop();
                                                        fetchprojectsuggestion(); // Refresh the local list

                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Suggestion Saved'),
                                                            duration:
                                                            Duration(seconds: 2),
                                                            backgroundColor:
                                                            Colors.green,
                                                            behavior: SnackBarBehavior
                                                                .floating,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                            ),
                                                            margin: EdgeInsets.all(15),
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Failed to Save: $e'),
                                                            backgroundColor: Colors.red,
                                                            duration:
                                                            Duration(seconds: 2),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text("Add"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child:
                                        Icon(Icons.add_circle, color: Colors.blue,size: 15.sp,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 130.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child:Autocomplete(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<String>.empty();
                                      }
                                      return Projectoption.where((String option) {
                                        return option.toLowerCase().contains(
                                            textEditingValue.text.toLowerCase());
                                      });
                                    },
                                    onSelected: (String selection) {
                                      project.text = selection;
                                      selectedProject = selection;
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      // Sync text initially
                                      textEditingController.text = project.text;

                                      // Sync both ways
                                      textEditingController.addListener(() {
                                        project.text = textEditingController.text;
                                      });

                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        maxLines: null,
                                        onFieldSubmitted: (v) {
                                          setState(() {
                                            selectedProject = v;
                                          });
                                        },
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.multiline,
                                        cursorHeight: 25.h,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.start,
                                        cursorColor: Colors.black45,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 2.h, left: 5.w, bottom: 15.h),
                                          border: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                          hintText: "",
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },optionsViewBuilder: (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4,
                                        child: Container(
                                          width: 130.w,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final option = options.elementAt(index);
                                              return InkWell(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                  child: Text(option),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Text(
                                  "Invoice Amount",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                width: 130.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: TextFormField(
                                    controller: invoiceamount,
                                    textInputAction: TextInputAction.next,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    cursorHeight: 20.h,
                                    cursorWidth: 0.5,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.sp),
                                    textAlign: TextAlign.start,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2.h, left: 5.w, bottom: 18.h),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Text(
                                  "Tax(5%)",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                width: 100.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: TextFormField(
                                    controller: tax,
                                    textInputAction: TextInputAction.next,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    cursorHeight: 20.h,
                                    cursorWidth: 0.5,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.sp),
                                    textAlign: TextAlign.start,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2.h, left: 5.w, bottom: 18.h),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Text(
                                  "Total Amount",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                width: 130.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: TextFormField(
                                    controller: totalamount,
                                    textInputAction: TextInputAction.next,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    cursorHeight: 20.h,
                                    cursorWidth: 0.5,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.sp),
                                    textAlign: TextAlign.start,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2.h, left: 5.w, bottom: 18.h),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 35.w, top: 25.h),
                          child: InkWell(
                            onTap: () async {
                              final id = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();

                              await firestore.doc(id).set({
                                id: id,
                                'Date': date.text,
                                'Invoice no': invoiceno.text,
                                'Supplier': supplier.text,
                                'Project': project.text,
                                'Invoice Amount': invoiceamount.text,
                                'Tax': tax.text,
                                'Total Amount': totalamount.text
                              });
                              date.clear();
                              invoiceno.clear();
                              supplier.clear();
                              project.clear();
                              invoiceamount.clear();
                              tax.clear();
                              totalamount.clear();
                              setState(() {
                                _fetchFilteredData();
                              });
                            },
                            child: Card(
                              child: Container(
                                width: 70.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(3.r)),
                                child: Center(
                                    child: Text(
                                  "ADD",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 80.h,
                  color: Colors.blueGrey[100],
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                "From",
                                style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _pickDateRange(),
                              child: Container(
                                width: 140.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    _startDate != null
                                        ? _formatter.format(_startDate!)
                                        : 'Select',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 8.h),
                        child: Icon(
                          Icons.arrow_right_alt,
                          size: 40.sp,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                "To",
                                style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _pickDateRange(),
                              child: Container(
                                width: 140.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    _endDate != null
                                        ? _formatter.format(_endDate!)
                                        : 'Select',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 10.h),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _startDate = null;
                              _endDate = null;
                            });
                            _fetchFilteredData();
                          },
                          child: Text(
                            "Cancel Filter",
                            style: GoogleFonts.workSans(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 650.w, top: 10.h),
                        child: InkWell(
                          onTap: () {
                            generatePdf();
                          },
                          child: Text(
                            "Generate PDF",
                            style: GoogleFonts.workSans(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          Container(
            width: double.infinity,
            height: 40.h,
            color: Colors.blueGrey[300],
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: SizedBox(width: 98.w,
                    child: Text(
                      "Date",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: SizedBox(width: 135.w,
                    child: Text(
                      "Invoice no",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50.w),
                  child: SizedBox(width: 130.w,
                    child: Text(
                      "Supplier",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40.w),
                  child: SizedBox(width: 120.w,
                    child: Text(
                      "Project",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: SizedBox(width: 130.w,
                    child: Text(
                      "Invoice Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 55.w),
                  child: SizedBox(width: 70.w,
                    child: Text(
                      "Tax",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40.w),
                  child: SizedBox(width: 120.w,
                    child: Text(
                      "Total Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = filteredData[index];
                  return Container(
                    width: double.infinity,
                    height: 40.h,
                    color: index % 2 == 0 ? Colors.blueGrey[100] : Colors.white,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Center(
                              child: SizedBox(
                                width: 98.w,
                                child: Text(
                                  data['Date'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: Center(
                              child:SizedBox(
                                width: 135.w,
                                child: Text(
                                  data['Invoice no'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 52.w),
                            child: Center(
                              child:SizedBox(
                                width: 160.w,
                                child: Text(
                                  data['Supplier'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Center(
                              child: SizedBox(
                                width: 160.w,
                                child: Text(
                                  data['Project'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Center(
                              child: SizedBox(
                                width: 120.w,
                                child: Text(
                                  data['Invoice Amount'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 60.w),
                            child: Center(
                              child: SizedBox(
                                width: 90.w,
                                child: Text(
                                  data['Tax'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.w),
                            child: Center(
                              child:SizedBox(
                                width: 120.w,
                                child: Text(
                                  data['Total Amount'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 60.w),
                            child: PopupMenuButton(
                                onSelected: (value) async {
                                  final docid = data['id'];
                                  if (value == 'delete') {
                                    await FirebaseFirestore.instance
                                        .collection('Vat Purchase')
                                        .doc(docid)
                                        .delete();

                                    _fetchFilteredData();
                                  } else if (value == 'edit') {
                                    _editcontainer(context, docid, data);
                                  }
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 15.sp,
                                ),
                                offset: const Offset(0, 40),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: SizedBox(
                                            width: 40.w,
                                            height: 20.h,
                                            child: Text("Delete")),
                                        value: 'delete',
                                      ),
                                      PopupMenuItem(
                                        child: SizedBox(
                                            width: 40.w,
                                            height: 20.h,
                                            child: Text("Edit")),
                                        value: 'edit',
                                      )
                                    ]),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 720.w),
                  child: Container(
                    width: 120.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Text(
                        totalInvoice.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Container(
                    width: 120.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Text(
                        totalTax.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Container(
                    width: 120.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Text(
                        totalAmount.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
