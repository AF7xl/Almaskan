import 'package:almaskan/ui/Taxinvoicepdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';

class Taxinvoice1 extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String trn;
  final String? taxinvoiceid;

  const Taxinvoice1(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.trn,
      this.taxinvoiceid});

  @override
  State<Taxinvoice1> createState() => _Taxinvoice1State();
}

class _Taxinvoice1State extends State<Taxinvoice1> {
  List<String> nbqoptions = [];
  final nbqfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("nbqoptions");
  String selectednbq = '';
  TextEditingController invno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController lpoqtn = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController advancepercent = TextEditingController();
  TextEditingController nbq = TextEditingController();

  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();
  final TextEditingController subtotalController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  String selectedCompany = 'Reyah Al Maskan';

  double vat = 0.0;
  double advance = 0.0;
  double total = 0.0;

  get index => index;

  @override
  void initState() {
    super.initState();
    advanceController.addListener(() {
      setState(() {
        // Parse the input text and update the advance value
        advance = double.tryParse(advanceController.text) ?? 0.0;
        calculatetotal();
      });
    });
    fetchnbqSuggestions();
  }

  void fetchnbqSuggestions() async {
    final docSnapshot = await nbqfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      nbqoptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }

  Future<bool> doesINVNoExist(String invoiceno) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("Taxinvoice")
        .where('inv no', isEqualTo: invoiceno)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  double roundDecimalOnly(double value) {
    final intPart = value.floor();
    final decimal = value - intPart;

    if (decimal == 0.0) {
      return value; // No change if already whole number
    } else if (decimal >= 0.5) {
      return intPart + 1.0; // Round up
    } else {
      return intPart.toDouble(); // Round down
    }
  }

  void calculatetotal() {
    vat = advance * 0.05;
    total = roundDecimalOnly(advance + vat);

    String amountInWords = convertNumberToWords(total);
    totalamountinname.text = amountInWords;
    setState(() {});
  }

  String convertNumberToWords(double amount) {
    final int dirhams = amount.floor();
    final int fils = ((amount - dirhams) * 100).round();

    String dirhamsWords = _convertIntegerToWords(dirhams);
    String filsWords = fils > 0 ? _convertIntegerToWords(fils) : '';

    String result = '$dirhamsWords dirhams';
    if (fils > 0) {
      result += ' and $filsWords fils';
    }
    result += ' only.';

    // Capitalize the first letter
    return result[0].toUpperCase() + result.substring(1).toLowerCase();
  }

  String _convertIntegerToWords(int number) {
    if (number == 0) return 'zero';

    final List<String> ones = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen'
    ];

    final List<String> tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];

    String words = '';

    if (number >= 1000000) {
      words += '${_convertIntegerToWords(number ~/ 1000000)} million ';
      number %= 1000000;
    }
    if (number >= 1000) {
      words += '${_convertIntegerToWords(number ~/ 1000)} thousand ';
      number %= 1000;
    }
    if (number >= 100) {
      words += '${_convertIntegerToWords(number ~/ 100)} hundred ';
      number %= 100;
    }
    if (number >= 20) {
      words += tens[number ~/ 10];
      if (number % 10 != 0) {
        words += '-${ones[number % 10]}';
      }
    } else if (number > 0) {
      words += ones[number];
    }

    return words.trim();
  }

  @override
  void dispose() {
    // Dispose controllers when done
    subtotalController.dispose();
    advanceController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> paymentOptions = [
    {'label': 'Advance', 'id': 1},
    {'label': 'Final Payment', 'id': 2},
    {'label': 'Work In Progress', 'id': 3},
  ];


  double? selectedPercentage;

  void updateAdvanceAmount() {
    double subtotal = double.tryParse(subtotalController.text) ?? 0;
    double percentage = double.tryParse(advancepercent.text) ?? 0;
    double advanceVal = (subtotal * percentage) / 100;
    advanceController.text = advanceVal.toStringAsFixed(2);
  }


  int? selectedpaymentId;

  String? selectedDocumentId;

  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("Taxinvoice");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        titleSpacing: 1,
        toolbarHeight: 60.h,
        title: Text(
          "Create TaxInvoice",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "INV No",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: invno,
                          maxLines: null,
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
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Date",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          controller: date,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('d/MMM/yyyy').format(pickedDate);
                              date.text = formattedDate;
                            }
                          },
                          cursorHeight: 25.h,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Select Date",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "LPO/QTN #",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: lpoqtn,
                          maxLines: null,
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
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Project:",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: project,
                          maxLines: null,
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
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "NOTE Before Quote",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 790.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Autocomplete(optionsBuilder:
                            (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return nbqoptions.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        }, onSelected: (String selection) {
                          nbq.text = selection;
                          selectednbq = selection;
                        }, fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          // Sync text initially
                          textEditingController.text = nbq.text;

                          // Sync both ways
                          textEditingController.addListener(() {
                            nbq.text = textEditingController.text;
                          });

                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            maxLines: null,
                            onFieldSubmitted: (v) {
                              setState(() {
                                selectednbq = v;
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
                        }, optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4,
                              child: Container(
                                width: 790.w,
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
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 150.w),
              child: Table(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(2), // First column width (flexible)
                  1: FlexColumnWidth(2), // Second column width (flexible)
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.red[900]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Amount (AED)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, left: 20.w),
                      child: Text(
                        'Subtotal Taxable Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: subtotalController,
                        onChanged: (val) => updateAdvanceAmount(),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15.sp),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, left: 20.w),
                      child: Row(
                        children: [
                          // Dropdown for type
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              hint: Text("Select Payment Type"),
                              items: paymentOptions.map((option) {
                                return DropdownMenuItem<int>(
                                  value: option['id'],
                                  child: Text(option['label']),
                                );
                              }).toList(),
                              onChanged: (id) {
                                setState(() {
                                  selectedpaymentId = id;
                                  updateAdvanceAmount(); // recalc
                                });
                              },
                              value: selectedpaymentId,
                            ),
                          ),
                          SizedBox(width: 10),
                          // % input
                          Container(
                            width: 80,
                            child: TextFormField(
                              controller: advancepercent,
                              decoration: InputDecoration(
                                hintText: "%",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  updateAdvanceAmount();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: advanceController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                      ),
                    ),
                  ]),

                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child: SizedBox(
                          height: 40, // Set the desired height
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'VAT (5%)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        // Ensure this matches the height of the first column
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h, left: 20.w),
                          child: Text(
                            vat.toString(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child: SizedBox(
                          height: 40, // Set the desired height
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Total Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        // Ensure this matches the height of the first column
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h, left: 20.w),
                          child: Text(
                            total.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount in Name",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 500.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: totalamountinname,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note after quote",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 500.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: naq,
                        maxLines: null,
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
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Clients")
                    .doc(widget.id)
                    .collection("Taxinvoice")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  var docs = snapshot.data!.docs;
                  final invoiceMap = {
                    for (var doc in docs)
                      doc['inv no']?.toString() ?? 'Unknown': doc.id
                  };

                  return Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          // Give a fixed width to prevent stretching
                          child: DropdownSearch<String>(
                            asyncItems: (String? filter) async {
                              return invoiceMap.keys
                                  .where((key) =>
                                      filter == null ||
                                      key
                                          .toLowerCase()
                                          .contains(filter.toLowerCase()))
                                  .toList();
                            },
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    hintText: "Search by INV No"),
                              ),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select Invoice to Edit",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            onChanged: (invNo) {
                              final selectedId = invoiceMap[invNo];
                              final selectedDoc = docs
                                  .firstWhere((doc) => doc.id == selectedId);
                              final data =
                                  selectedDoc.data() as Map<String, dynamic>;

                              setState(() {
                                selectedDocumentId = selectedDoc.id;
                                invno.text = data['inv no'] ?? '';
                                date.text = data['date'] ?? '';
                                lpoqtn.text = data['LpoQtn#'] ?? '';
                                project.text = data['project'] ?? '';
                                nbq.text = data['note before quote'] ?? '';
                                selectednbq = data['note before quote'] ?? '';
                                subtotalController.text =
                                    data['subtotal taxable amount'] ?? '';
                                advanceController.text =
                                    data['advance payment'] ?? '';
                                totalamountinname.text =
                                    data['total amount in name'] ?? '';
                                naq.text = data['note after quote'] ?? '';
                                advancepercent.text =
                                    data['advance percent'] ?? '';

                                vat =
                                    double.tryParse(data['vat 5%'] ?? '0') ?? 0;
                                total = double.tryParse(
                                        data['total amount'] ?? '0') ??
                                    0;

                                final paymentLabel = data['payment'];
                                final paymentMatch = paymentOptions.firstWhere(
                                  (opt) => opt['label'] == paymentLabel,
                                  orElse: () => {},
                                );

                                if (paymentMatch.isNotEmpty) {
                                  selectedpaymentId = paymentMatch['id'];
                                  selectedPercentage = paymentMatch['value'];
                                  updateAdvanceAmount();
                                }
                              });
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final invNo = invno.text.trim();

                            if (invNo.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("INV No cannot be empty")),
                              );
                              return;
                            }
                            final exists = await doesINVNoExist(invNo);

                            if (exists) {
                              // Show warning
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Duplicate INV No"),
                                  content: Text(
                                      "A quote with INV NO '${invno.text}' already exists."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return; // Don't continue
                            }

                            final id = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            var selectedPayment = paymentOptions.firstWhere(
                              (opt) => opt['id'] == selectedpaymentId,
                              orElse: () => {'label': '', 'value': 0},
                            );

                            try {
                              await firestore.doc(id).set({
                                'id': id,
                                'inv no': invno.text,
                                'date': date.text,
                                'payment': selectedPayment['label'],
                                'advance percent': advancepercent.text,
                                'LpoQtn#': lpoqtn.text,
                                'project': project.text,
                                'note before quote': nbq.text,
                                'subtotal taxable amount':
                                    subtotalController.text,
                                'advance payment': advanceController.text,
                                'vat 5%': vat.toString(),
                                'total amount': total.toString(),
                                'total amount in name': totalamountinname.text,
                                'note after quote': naq.text
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tax Invoice Saved'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to save ${e}'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.black54,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 200.w),
                            child: Container(
                              width: 65.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.lightBlue[600]),
                              child: Center(
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            String? selected = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                String tempSelectedCompany = selectedCompany;
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.r)),
                                  title: Text('Select Company'),
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return DropdownButtonFormField<String>(
                                        value: tempSelectedCompany,
                                        items: ['Reyah Al Maskan', 'Al Maskan']
                                            .map((company) {
                                          return DropdownMenuItem(
                                            value: company,
                                            child: Text(company),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            tempSelectedCompany = value!;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // cancel
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            tempSelectedCompany); // return selected
                                      },
                                      child: Text("Continue"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (selected != null) {
                              selectedCompany = selected;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Taxinvoicepdf(
                                    invno: invno.text,
                                    date: date.text,
                                    lpoqtn: lpoqtn.text,

                                    project: project.text,
                                    nbq: nbq.text,
                                    subtotal: subtotalController.text,
                                    advance: advanceController.text,
                                    vat: vat.toStringAsFixed(2),
                                    totalamount: total.toStringAsFixed(2),
                                    totalamountinname: totalamountinname.text,
                                    naq: naq.text,
                                    name: widget.name,
                                    address: widget.address,
                                    trn: widget.trn,
                                    advancepercent: advancepercent.text,
                                    payment: paymentOptions.firstWhere(
                                            (opt) => opt['id'] == selectedpaymentId,
                                        orElse: () => {'label': ''})['label'] ?? '',

                                    selectedCompany: selectedCompany,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 65.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                "Preview",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (selectedDocumentId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please select a document to update'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.black54,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            }

                            var selectedPayment = paymentOptions.firstWhere(
                              (opt) => opt['id'] == selectedpaymentId,
                              orElse: () => {'label': '', 'value': 0},
                            );

                            try {
                              await firestore.doc(selectedDocumentId).update({
                                'inv no': invno.text,
                                'date': date.text,
                                'LpoQtn#': lpoqtn.text,
                                'payment': selectedPayment['label'],
                                'advance percent': advancepercent.text,
                                'project': project.text,
                                'note before quote': nbq.text,
                                'subtotal taxable amount':
                                    subtotalController.text,
                                'advance payment': advanceController.text,
                                'vat 5%': vat.toString(),
                                'total amount': total.toString(),
                                'total amount in name': totalamountinname.text,
                                'note after quote': naq.text
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tax Invoice Updated'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update ${e}'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.black54,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 65.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: Colors.red[900]),
                            child: Center(
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
