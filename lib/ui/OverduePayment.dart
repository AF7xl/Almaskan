import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Overduepayment extends StatefulWidget {
  const Overduepayment({super.key});

  @override
  State<Overduepayment> createState() => _OverduepaymentState();
}

//model class for overdue payment model
class OverduePaymentModel {
  final String customerName;
  final String date;
  final String invoiceNumber;
  final String lpoNumber;
  final String projectName;
  final String totalAmount;
  final String id;

  OverduePaymentModel({
    required this.customerName,
    required this.date,
    required this.invoiceNumber,
    required this.lpoNumber,
    required this.projectName,
    required this.totalAmount,
    required this.id,
  });

  factory OverduePaymentModel.fromMap(Map<String, dynamic> map) {
    return OverduePaymentModel(
      customerName: map['Customer Nama'] ?? '',
      date: map['Date'] ?? '',
      invoiceNumber: map['Invoice Number'] ?? '',
      lpoNumber: map['LPO Number'] ?? '',
      projectName: map['Project Name'] ?? '',
      totalAmount: map['Total Amount'] ?? '',
      id: map['id'] ?? '',
    );
  }
}

Future<List<OverduePaymentModel>> Fetchoverduepayment() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('Overdue Payment').get();

  return snapshot.docs.map((doc) {
    return OverduePaymentModel.fromMap(doc.data());
  }).toList();
}

class _OverduepaymentState extends State<Overduepayment> {
  final currentdate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Future<void> generatePdf({
    required String selectedCompany,
    required String note,
    required String customerName,
    required String address,
    required String trnNumber,
    required String kindAttn,
  }) async {
    final pdf = pw.Document();
    final image1 = pw.MemoryImage(
      (await rootBundle.load('assets/Logo.png')).buffer.asUint8List(),
    );

    final image2 = pw.MemoryImage(
      (await rootBundle.load('assets/sign.png')).buffer.asUint8List(),
    );
    final amount = getTotalAmount();
    pw.Widget buildCompanyDetails() {
      if (selectedCompany == 'almaskan') {
        return pw.Padding(
            padding: pw.EdgeInsets.only(top: 40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("AL MASKAN PLASTER & TILE CONT L.L.C.SP",
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
            ));
      } else {
        return pw.Padding(
            padding: pw.EdgeInsets.only(top: 40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("REYAH AL MASKAN TECHNICAL SERVICES L.L.C",
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 3),
                pw.Text("Dubai", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("United Arab Emirates",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("TRN 100342182100003",
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("0508089505", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 3),
                pw.Text("reyahalmaskan@gmail.com",
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ));
      }
    }

    final formattedAmount =
        NumberFormat('#,##0.00').format(double.tryParse(amount) ?? 0);
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.only(top: 15),
          build: (pw.Context context) => [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(22),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.only(top: 20),
                              child: pw.Container(
                                  width: 160,
                                  height: 160,
                                  child: pw.Image(image1))),

                          buildCompanyDetails(), pw.SizedBox(height: 10),
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 250),
                            child: pw.Text(
                              "Statement",
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 450),
                            child: pw.Text("Date: $currentdate",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.normal)),
                          ),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("To",
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                                pw.SizedBox(height: 5),
                                pw.Text(customerName,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)),
                                pw.SizedBox(height: 5),
                                pw.Text(address,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)),
                                pw.SizedBox(height: 5),
                                pw.Text(trnNumber,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)),
                                pw.SizedBox(height: 5),
                                pw.Text("United Arab Emirates",
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black))
                              ]),
                          pw.SizedBox(height: 10),
                          pw.Text("Kind Attn: ${kindAttn}",
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            note,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                          pw.SizedBox(height: 8),

                          // Table Header
                          pw.Container(
                            width: double.infinity,
                            height: 20,
                            color: selectedCompany == 'almaskan'
                                ? PdfColors.black
                                : PdfColor.fromInt(0xFFC62828),
                            child: pw.Row(
                              children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 10),
                                  child: pw.Text("Date", style: _headerStyle),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 63),
                                  child: pw.Text("Project Name",
                                      style: _headerStyle),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 105),
                                  child:
                                      pw.Text("Invoice#", style: _headerStyle),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 26),
                                  child: pw.Text("LPO#", style: _headerStyle),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 72),
                                  child: pw.Text("Total Amount",
                                      style: _headerStyle),
                                ),
                              ],
                            ),
                          ),

                          // Table Body
                          ...filteredPayments.asMap().entries.map((entry) {
                            final index = entry.key;
                            final payment = entry.value;
                            return pw.Container(
                                width: double.infinity,
                                height: 25,
                                color: index % 2 == 0
                                    ? PdfColors.grey100
                                    : PdfColors.white,
                                child: pw.Padding(
                                    padding: pw.EdgeInsets.only(top: 5),
                                    child: pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(left: 10),
                                          child: pw.Container(

                                            width: 65,
                                            height: 20,
                                            child: pw.Text(payment.date,
                                                style: pw.TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  color: PdfColors.black,
                                                )),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(left: 20),
                                          child: pw.Container(

                                            width: 150,
                                            height: 20,
                                            child: pw.Text(payment.projectName,
                                                style: pw.TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  color: PdfColors.black,
                                                )),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(left: 20),
                                          child: pw.Container(

                                            width: 45,
                                            height: 20,
                                            child:
                                                pw.Text(payment.invoiceNumber,
                                                    style: pw.TextStyle(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          pw.FontWeight.normal,
                                                      color: PdfColors.black,
                                                    )),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(left: 20),
                                          child: pw.Container(

                                            width: 80,
                                            height: 20,
                                            child: pw.Text(payment.lpoNumber,
                                                style: pw.TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  color: PdfColors.black,
                                                )),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(left: 20),
                                          child: pw.Container(

                                            width: 100,
                                            height: 20,
                                            child: pw.Text(
                                                NumberFormat('#,##0.00').format(
                                                    double.tryParse(payment
                                                            .totalAmount) ??
                                                        0),
                                                style: pw.TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  color: PdfColors.black,
                                                )),
                                          ),
                                        ),
                                      ],
                                    )));
                          }).toList(),

                          pw.Divider(color: PdfColors.black, indent: 375),
                          pw.SizedBox(height: 5),
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 375),
                            child: pw.Container(
                                width: 200,
                                height: 25,
                                color: PdfColors.grey300,
                                child: pw.Padding(
                                    padding:
                                        pw.EdgeInsets.only(top: 5, left: 3),
                                    child: pw.Text(
                                        "Total Amount (AED): ${formattedAmount} ",
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.bold)))),
                          ),
                        ])),
                pw.SizedBox(height: 20),
                pw.Container(width: 160, height: 160, child: pw.Image(image2)),
                pw.Padding(
                    padding: pw.EdgeInsets.only(left: 22),
                    child: pw.Text("Authorized Signature",
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.normal)))
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

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

// Styles
  final _headerStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 10,
    color: PdfColors.white,
  );

  List<OverduePaymentModel> allPayments = [];
  List<OverduePaymentModel> filteredPayments = [];
  String query = "";

  void initState() {
    super.initState();
    Fetchoverduepayment().then((payment) {
      setState(() {
        allPayments = payment;
        filteredPayments = payment;
      });
    });
  }

  //function for update search
  void updateSearch(String searchText) {
    setState(() {
      query = searchText.toLowerCase();
      filteredPayments = allPayments.where((payment) {
        return payment.customerName.toLowerCase().contains(query) ||
            payment.invoiceNumber.toLowerCase().contains(query) ||
            payment.lpoNumber.toLowerCase().contains(query) ||
            payment.projectName.toLowerCase().contains(query);
      }).toList();
    });
  }

  //function to delete
  Future<void> deletePayment(String id) async {
    await FirebaseFirestore.instance
        .collection('Overdue Payment')
        .where('id', isEqualTo: id)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    final updatedList = await Fetchoverduepayment();
    setState(() {
      allPayments = updatedList;
      filteredPayments = updatedList.where((payment) {
        return payment.customerName.toLowerCase().contains(query) ||
            payment.invoiceNumber.toLowerCase().contains(query) ||
            payment.lpoNumber.toLowerCase().contains(query) ||
            payment.projectName.toLowerCase().contains(query);
      }).toList();
    });
  }

  //function to show total
  String getTotalAmount() {
    double total = 0;

    for (var payment in filteredPayments) {
      // Parse and remove currency symbols if needed
      final cleaned = payment.totalAmount.replaceAll(RegExp(r'[^\d.]'), '');
      final value = double.tryParse(cleaned);
      if (value != null) total += value;
    }

    return total.toStringAsFixed(2); // format to 2 decimal places
  }

  String selectednote = '';
  List<String> noteoptions = [
    'Statement of Account',
    'We kindly request you to release the outstanding payments related to the below mentioned LPOs at your earliest convenience'
  ];
  final customerNameController = TextEditingController();
  final addressController = TextEditingController();
  final trnController = TextEditingController();
  final kindAttController = TextEditingController();
  final noteController = TextEditingController();

  //to store fetched customer data
  List<Map<String, dynamic>> customerDataList = [];

  //to fetch customer data
  Future<void> fetchCustomerData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Customers').get();
    customerDataList =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void showCustomerNoteDialog(BuildContext context, String company) async {
    await fetchCustomerData(); // Load customer data before showing dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            width: 790.w,
            height: 500.h,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Enter Note", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                color: Colors.black)),
                        Container(
                          width: 210.w,
                          height: 60.h,
                          child: Autocomplete<String>(optionsBuilder:
                              (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '')
                              return const Iterable<String>.empty();
                            return customerDataList
                                .map((e) => e['name'].toString())
                                .where((name) => name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase()));
                          }, onSelected: (String selection) {
                            final selectedCustomer = customerDataList
                                .firstWhere((e) => e['name'] == selection);
                            customerNameController.text =
                                selectedCustomer['name'] ?? '';
                            addressController.text =
                                selectedCustomer['address'] ?? '';
                            trnController.text =
                                selectedCustomer['TRN NO'] ?? '';
                          }, fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            textEditingController.text =
                                customerNameController.text;
                            textEditingController.addListener(() {
                              customerNameController.text =
                                  textEditingController.text;
                            });
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                            );
                          }, optionsViewBuilder:
                              (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4,
                                child: Container(
                                  width: 210.w,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final option = options.elementAt(index);
                                      return InkWell(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 10),
                                          child: Text(option),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                color: Colors.black)),
                        Container(
                          width: 210.w,
                          height: 60.h,
                          child: TextFormField(
                            controller: addressController,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TRN Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                color: Colors.black)),
                        Container(
                          width: 210.w,
                          height: 60.h,
                          child: TextFormField(
                            controller: trnController,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kind att",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Colors.black)),
                    Container(
                      width: 210.w,
                      height: 60.h,
                      child: TextFormField(
                        controller: kindAttController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Note Before Quote",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Colors.black)),
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty)
                          return const Iterable<String>.empty();
                        return noteoptions.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        noteController.text = selection;
                        selectednote = selection;
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        textEditingController.text = noteController.text;
                        textEditingController.addListener(() {
                          noteController.text = textEditingController.text;
                        });
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Type your note...",
                              border: OutlineInputBorder()),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            child: Container(
                              width: 760.w,
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      child: Text(option),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        customerNameController.clear();
                        addressController.clear();
                        trnController.clear();
                        kindAttController.clear();
                        noteController.clear();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        final note = noteController.text.trim();
                        generatePdf(
                          selectedCompany: company,
                          note: note,
                          customerName: customerNameController.text.trim(),
                          address: addressController.text.trim(),
                          trnNumber: trnController.text.trim(),
                          kindAttn: kindAttController.text.trim(),
                        );
                        customerNameController.clear();
                        addressController.clear();
                        trnController.clear();
                        kindAttController.clear();
                        noteController.clear();
                      },
                      child: Text("Generate"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          "Overdue Payments",
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20.sp),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 75.h,
            color: Colors.blueGrey[100],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          "Search",
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 400.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: TextFormField(
                            onChanged: updateSearch,
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            cursorHeight: 20.h,
                            cursorWidth: 0.5,
                            textAlignVertical: TextAlignVertical.center,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 2.h, left: 5.w, bottom: 18.h),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText:
                                    "Search using customer name,inv no,lpo no",
                                hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 15.sp,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 20.w),
                  child: InkWell(
                    onTap: () {
                      final rootContext = context;
                      showDialog(
                        context: rootContext,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Choose Company"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pop(); // Close current dialog
                                    await Future.delayed(Duration(
                                        milliseconds:
                                            200)); // Let the UI settle
                                    if (mounted) {
                                      showCustomerNoteDialog(
                                          rootContext, "almaskan");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 6,
                                  ),
                                  child: Text(
                                    "Al maskan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pop(); // Close current dialog
                                    await Future.delayed(Duration(
                                        milliseconds:
                                            200)); // Let the UI settle
                                    if (mounted) {
                                      showCustomerNoteDialog(
                                          rootContext, "reyah_almaskan");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 6,
                                  ),
                                  child: Text(
                                    "Reyah Almaskan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Generate PDF",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 530.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          "Total Amount",
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 200.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text(
                            getTotalAmount(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
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
                  padding: EdgeInsets.only(left: 20.w),
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      "Date",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: SizedBox(
                    width: 220.w,
                    child: Text(
                      "Customer Name",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 75.w),
                  child: SizedBox(
                    width: 100.w,
                    child: Text(
                      "Invoice#",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 58.w),
                  child: SizedBox(
                    width: 60.w,
                    child: Text(
                      "LPO#",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: SizedBox(
                    width: 150.w,
                    child: Text(
                      "Project Name",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: SizedBox(
                    width: 170.w,
                    child: Text(
                      "Total Amount",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredPayments.length,
                itemBuilder: (BuildContext context, int index) {
                  final payment = filteredPayments[index];
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
                                width: 125.w,
                                child: Text(
                                  payment.date,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Center(
                              child: SizedBox(
                                width: 300.w,
                                child: Text(
                                  payment.customerName,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Center(
                              child: SizedBox(
                                width: 60.w,
                                child: Text(
                                  payment.invoiceNumber,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 80.w),
                            child: Center(
                              child: SizedBox(
                                width: 90.w,
                                child: Text(
                                  payment.lpoNumber,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: Center(
                              child: SizedBox(
                                width: 210.w,
                                child: Text(
                                  payment.projectName,
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
                                width: 90.w,
                                child: Text(
                                  payment.totalAmount,
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
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 15.sp,
                                ),
                                offset: const Offset(0, 40),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    deletePayment(payment.id);
                                  }
                                },
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: SizedBox(
                                            width: 45.w,
                                            height: 20.h,
                                            child: Text("Delete")),
                                        value: 'delete',
                                      )
                                    ]),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
