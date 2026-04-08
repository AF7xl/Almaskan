import 'package:almaskan/ui/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'Invoice.dart';

import 'Quotationpdf.dart';

class Quotation2 extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final int index;

  const Quotation2({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.index,
  });

  @override
  State<Quotation2> createState() => _Quotation2State();
}

class _Quotation2State extends State<Quotation2> {
  List<String> nbqoptions = [];
  final nbqfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("nbqoptions");

  List<TextEditingController> description = [];
  List<String> descriptionData = [];
  List<String> desoptions = [];
  final desfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("dessuggestion");
  List<String> unitoptions = [];
  final unitfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("unitsuggestion");
  List<String> rateoptions = [];
  final ratefirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("ratesuggestion");

  final List<String> TACoptions = [
    'a) 50% Advance Payment,40% Work in Progress,10% Completion of Work\nb) The work will be only starting after getting LPO and advance payment\nc) Quote is per boq.any changes or extra work will be treated as variation'
  ];

  final List<Map<String, dynamic>> options = [
    {'label': 'Sign-1', 'id': 1},
    {'label': 'Sign-2', 'id': 2},
    {'label': 'NO Sign', 'id': 3},
  ];

  int? selectedoption;

  String selectednbq = '';
  String selectedTAC = '';
  List<TextEditingController> rateControllers = [];
  List<TextEditingController> qtyControllers = [];
  List<TextEditingController> amountControllers = [];
  List<TextEditingController> sno = [];

  List<String> snodata = [];
  List<String> qtydata = [];
  List<String> unitdata = [];
  List<String> ratedata = [];
  List<String> amountdata = [];
  List<TextEditingController> unit = [];
  TextEditingController qtnno = TextEditingController();
  TextEditingController date = TextEditingController();
  //for add textfield
  TextEditingController newfeild = TextEditingController();
  TextEditingController kindatt = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController nbq = TextEditingController();
  TextEditingController snoCtrl = TextEditingController();

  TextEditingController discountcontroller = TextEditingController();

  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();
  TextEditingController termsandconditioncontroller = TextEditingController();

  List<TextEditingController> headerControllers = [];
  List<Map<String, dynamic>> formStructure = [];
  bool isDiscountEnabled = false;
  String selectedCompany = 'Reyah Al Maskan';
  String? selectedCompany2;

  //function to add header text
  void addNewHeader() {
    setState(() {
      final controller = TextEditingController();
      headerControllers.add(controller);
      formStructure.add({
        'type': 'header',
        'controller': controller,
      });
      rebuildRows();
    });
  }

  //for new add button

  bool isclicked = false;

  double subtotal = 0.0;
  double discount = 0.0;
  double taxableAmount = 0.0;
  double vat = 0.0;
  double totalAmount = 0.0;

  get index => 1;

  @override
  void initState() {
    super.initState();
    fetchnbqSuggestions();
    fetchdescSuggestions();
    fetchunitSuggestions();
    fetchrateSuggestions();

    // loadNextQtnNo();
  }

// Add a helper function to handle async initialization
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Use your client-specific path for 'quotationRef' when saving the quote
// The client ID must be available in your widget's state for this
  CollectionReference get quotationRef => _firestore
      .collection('Clients')
      .doc(widget
          .id) // Replace 'widget.clientId' with your actual client ID variable
      .collection('quotation');

  Future<String> previewQtnNo(String company) async {
    String docName = company == "Al Maskan"
        ? "qtn_al_maskan"
        : company == "Reyah Al Maskan"
            ? "qtn_reyah"
            : "qtn_other";

    final docRef =
        FirebaseFirestore.instance.collection('counters').doc(docName);
    final snap = await docRef.get();

    final year = DateTime.now().year;
    final shortYear = year % 100;

    if (!snap.exists) return "$shortYear-01";

    int last = snap.data()?['last'] ?? 0;
return "$shortYear-${last.toString().padLeft(2, '0')}";
  }

// 1. QTN Load function (for initState)
  Future<void> loadNextQtnNo() async {
    if (selectedCompany2 == null || selectedCompany2!.isEmpty) {
      setState(() {
        qtnno.text = "Select Company First";
      });
      return;
    }

    final next = await previewQtnNo(selectedCompany2!);
    setState(() {
      qtnno.text = next;
    });
  }

  int extractSequence(String qtnNo) {
    try {
      final parts = qtnNo.split("-");
      if (parts.length != 2) return 0;
      return int.parse(parts[1]);
    } catch (_) {
      return 0;
    }
  }

  Future<String> safeCompanyQtnCounter(
      String company, String manualQtnNo) async {
    String docName = company == "Al Maskan"
        ? "qtn_al_maskan"
        : company == "Reyah Al Maskan"
            ? "qtn_reyah"
            : "qtn_other";

    final docRef =
        FirebaseFirestore.instance.collection('counters').doc(docName);

    final year = DateTime.now().year;
    final shortYear = year % 100;

    final snap = await docRef.get();

    int last = snap.exists ? (snap.data()?['last'] ?? 0) : 0;

    // 🔥 THIS IS THE FIX
    int manualSeq = extractSequence(manualQtnNo);

    if (manualSeq <= 0) {
      throw Exception("Invalid QTN format");
    }

    // ✔ Always trust the manually entered number
    int newLast = manualSeq;

    await docRef.set({
      'year': year,
      'last': newLast,
      'company': company,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 🔹 Return NEXT number
    return "$shortYear-${(newLast + 1).toString().padLeft(2, '0')}";
  }

  // ... rest of your methods ...

  void initializeControllers({bool addNewRow = true}) {
    if (addNewRow) {
      // Add new controllers for the newly added row
      final rateController = TextEditingController();
      final qtyController = TextEditingController();
      final amountController = TextEditingController();
      final sn = TextEditingController();
      final desc = TextEditingController();
      final uni = TextEditingController();

      // Add these new controllers to the respective lists
      rateControllers.add(rateController);
      qtyControllers.add(qtyController);
      amountControllers.add(amountController);
      sno.add(sn);

      description.add(desc);

      unit.add(uni);

      // Add listeners to calculate amount (use the correct index)
      final index = rateControllers.length - 1; // Index of the newly added row
      rateController.addListener(() => calculateAmount(index));
      qtyController.addListener(() => calculateAmount(index));
    } else {
      // Initialize controllers for the first row
      rateControllers.clear();
      qtyControllers.clear();
      amountControllers.clear();

      final rateController = TextEditingController();
      final qtyController = TextEditingController();
      final amountController = TextEditingController();

      rateControllers.add(rateController);
      qtyControllers.add(qtyController);
      amountControllers.add(amountController);

      // Add listeners to calculate amount
      rateController.addListener(() => calculateAmount(0));
      qtyController.addListener(() => calculateAmount(0));
    }
  }

  void calculateAmount(int index) {
    final rateText = rateControllers[index].text;
    final qtyText = qtyControllers[index].text;

    if (rateText.isNotEmpty && qtyText.isNotEmpty) {
      final rate = double.tryParse(rateText) ?? 0.0;
      final qty = double.tryParse(qtyText) ?? 0.0;
      final amount = rate * qty;
      setState(() {
        // Update the corresponding amount controller for the row
        amountControllers[index].text = amount.toStringAsFixed(2);
      });

      calculateSubtotal(); // Recalculate subtotal after updating the amount
    }
  }

  void calculateSubtotal() {
    List<double> amounts = amountControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();
    print(amounts);
    setState(() {
      subtotal = amounts.fold(0, (sum, item) => sum + item);
    });
    calculateTotal(); // Recalculate total after updating subtotal
  }

  String convertToUaeWords(double amount) {
    final int dirhams = amount.floor();
    final int fils = ((amount - dirhams) * 100).round();

    String numberToWords(int n) {
      const ones = [
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
      const tens = [
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

      if (n < 20) return ones[n];
      if (n < 100) {
        return tens[n ~/ 10] + (n % 10 != 0 ? ' ${ones[n % 10]}' : '');
      }
      if (n < 1000) {
        return '${ones[n ~/ 100]} hundred'
            '${n % 100 != 0 ? ' ${numberToWords(n % 100)}' : ''}';
      }
      if (n < 1000000) {
        return '${numberToWords(n ~/ 1000)} thousand'
            '${n % 1000 != 0 ? ' ${numberToWords(n % 1000)}' : ''}';
      }
      return '${numberToWords(n ~/ 1000000)} million'
          '${n % 1000000 != 0 ? ' ${numberToWords(n % 1000000)}' : ''}';
    }

    String result = '${numberToWords(dirhams)} dirhams';

    if (fils > 0) {
      result += ' and ${numberToWords(fils)} fils';
    }

    return '${result[0].toUpperCase()}${result.substring(1)} only';
  }

  void calculateTotal() {
    taxableAmount = subtotal - discount;
    vat = taxableAmount * 0.05;
    totalAmount = taxableAmount + vat;

    // ✅ ONLY THIS LINE for words
    totalamountinname.text = convertToUaeWords(totalAmount);

    setState(() {});
  }

  void fetchnbqSuggestions() async {
    final docSnapshot = await nbqfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      nbqoptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }

  void fetchdescSuggestions() async {
    final docSnapshot = await desfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      desoptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }

  void fetchunitSuggestions() async {
    final docSnapshot = await unitfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      unitoptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }

  void fetchrateSuggestions() async {
    final docSnapshot = await ratefirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      rateoptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
  }

  void insertHeaderAfter(int formIndex) {
    setState(() {
      final controller = TextEditingController();
      headerControllers.add(controller);

      formStructure.insert(formIndex + 1, {
        'type': 'header',
        'controller': controller,
      });

      rebuildRows();
    });
  }

  void insertRowAfter(int formIndex) {
    setState(() {
      // Create controllers for new row
      final rateController = TextEditingController();
      final qtyController = TextEditingController();
      final amountController = TextEditingController();
      final sn = TextEditingController();
      final desc = TextEditingController();
      final uni = TextEditingController();

      // Find the next row index relative to formStructure
      // (needed to insert controllers at correct place)
      int insertAtRowIndex = 0;
      for (var j = 0; j <= formIndex; j++) {
        if (formStructure[j]['type'] == 'row') {
          insertAtRowIndex++;
        }
      }

      // Insert controllers at the correct place
      rateControllers.insert(insertAtRowIndex, rateController);
      qtyControllers.insert(insertAtRowIndex, qtyController);
      amountControllers.insert(insertAtRowIndex, amountController);
      sno.insert(insertAtRowIndex, sn);
      description.insert(insertAtRowIndex, desc);
      unit.insert(insertAtRowIndex, uni);
      //isAmountManuallyEdited.insert(insertAtRowIndex, false);

      // Add listeners
      rateController.addListener(() => calculateAmount(insertAtRowIndex));
      qtyController.addListener(() => calculateAmount(insertAtRowIndex));

      // Insert into formStructure
      formStructure.insert(formIndex + 1, {
        'type': 'row',
        'index': insertAtRowIndex,
      });

      // Reindex all rows in formStructure
      int rowCounter = 0;
      for (var item in formStructure) {
        if (item['type'] == 'row') {
          item['index'] = rowCounter;
          rowCounter++;
        }
      }

      rebuildRows();
    });
  }

  void rebuildRows() {
    rows.clear();
    // Variable to keep track of the serial number for the current section
    int currentSNo = 1;

    for (int i = 0; i < formStructure.length; i++) {
      final item = formStructure[i];
      if (item['type'] == 'header') {
        // Reset S.No. when a new header is encountered
        currentSNo = 1;

        final controller = item['controller'] as TextEditingController;

        // ... (Your existing header creation code)
        // ... (No change needed here for S.No.)

        rows.add(
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 70.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: TextFormField(
                          controller: controller,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration.collapsed(
                              hintText: ' Header Title',
                              hintStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      formStructure.removeAt(i);
                      rebuildRows();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      } else if (item['type'] == 'row') {
        final index = item['index'] as int;

        // 1. Update the S.No. Controller with the new sequential number
        sno[index].text = currentSNo.toString();

        // 2. Increment the S.No. for the *next* row in this section
        currentSNo++;

        // 3. Build the row widget using the correct controller index
        rows.add(buildRow(index));
      }
    }
  }

  List<Widget> rows = []; // List to store each row

  void addNewRow() {
    setState(() {
      initializeControllers(addNewRow: true);
      final index = description.length - 1;
      formStructure.add({
        'type': 'row',
        'index': index,
      });
      rebuildRows();
    });
  }

  Widget buildRow(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Row(
        children: [
          // SNo Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 50.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  snodata.add(value);
                },
                controller: sno[index],
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Description Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 500.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return desoptions.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (String option) => option,
                  onSelected: (String selection) {
                    description[index].text = selection;
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    // Assign your controller value to keep things synced
                    textEditingController.text = description[index].text;

                    textEditingController.addListener(() {
                      description[index].text = textEditingController.text;
                    });

                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                        border: InputBorder.none,
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 15.sp),
                      cursorColor: Colors.black,
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        child: Container(
                          width: 500.w,
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
                                      horizontal: 8.w, vertical: 10.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        option,
                                      )),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTapDown:
                                            (_) {}, // 👈 Prevent autocomplete from closing
                                        child: IconButton(
                                            onPressed: () async {
                                              // The item we want to remove
                                              final optionToRemove = option;

                                              // 1. Remove locally
                                              setState(() {
                                                desoptions
                                                    .remove(optionToRemove);
                                              });

                                              // 2. Update Firestore document
                                              try {
                                                await desfirestore.update({
                                                  'suggestions':
                                                      FieldValue.arrayRemove(
                                                          [optionToRemove]),
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Item removed successfully'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                                // 👇 Close the dropdown after a small delay (auto close)
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 200), () {
                                                  FocusScope.of(context)
                                                      .unfocus(); // closes autocomplete
                                                });
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to remove item: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: Icon(Icons.close)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          // Qty Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 80.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  qtydata.add(value);
                },
                controller: qtyControllers[index],
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Unit Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 70.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return unitoptions.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (String option) => option,
                  onSelected: (String selection) {
                    unit[index].text = selection;
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    // Assign your controller value to keep things synced
                    textEditingController.text = unit[index].text;

                    textEditingController.addListener(() {
                      unit[index].text = textEditingController.text;
                    });

                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                        border: InputBorder.none,
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 15.sp),
                      cursorColor: Colors.black,
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        child: Container(
                          width: 80.w,
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
                  }),
            ),
          ),
          // Rate Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 100.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return rateoptions.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (String option) => option,
                  onSelected: (String selection) {
                    rateControllers[index].text = selection;
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    // Sync Autocomplete controller with your list controller
                    textEditingController.text = rateControllers[index].text;

                    textEditingController.addListener(() {
                      rateControllers[index].text = textEditingController.text;
                    });

                    return TextFormField(
                      controller: textEditingController, // <-- MUST USE THIS
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 15.sp),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding:
                            EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        child: Container(
                          width: 80.w,
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
                  }),
            ),
          ),

          // Amount Field
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 100.w,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  amountdata.add(value);
                },
                readOnly: false,
                controller: amountControllers[index],
                onChanged: (value) {
                  calculateSubtotal();
                },
                maxLines: null,
                keyboardType: TextInputType.number,
                cursorHeight: 25.h,
                textAlignVertical: TextAlignVertical.center,
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 15.sp),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                  border: InputBorder.none,
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Remove Row Icon
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.black),
            onPressed: () {
              setState(() {
                // Remove controllers at index
                sno.removeAt(index);
                description.removeAt(index);
                qtyControllers.removeAt(index);
                unit.removeAt(index);
                rateControllers.removeAt(index);
                amountControllers.removeAt(index);
                // Remove from formStructure where index matches
                formStructure.removeWhere(
                    (item) => item['type'] == 'row' && item['index'] == index);

                // Reassign correct index values to remaining rows
                int rowCounter = 0;
                for (var item in formStructure) {
                  if (item['type'] == 'row') {
                    item['index'] = rowCounter;
                    rowCounter++;
                  }
                }

                // Rebuild UI rows
                rebuildRows();
                calculateSubtotal();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
            onPressed: () async {
              final choice = await showMenu<String>(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  const PopupMenuItem(value: 'row', child: Text('Add Row')),
                  const PopupMenuItem(
                      value: 'header', child: Text('Add Header')),
                ],
              );

              final formIndex = formStructure.indexWhere(
                (item) => item['type'] == 'row' && item['index'] == index,
              );

              if (formIndex == -1) return;

              if (choice == 'row') {
                insertRowAfter(formIndex);
              } else if (choice == 'header') {
                insertHeaderAfter(formIndex);
              }
            },
          ),
        ],
      ),
    );
  }

  int getNextSerialNumber() {
    int serialNumber = 1;
    // Iterate backwards through the formStructure
    for (int i = formStructure.length - 1; i >= 0; i--) {
      final item = formStructure[i];
      if (item['type'] == 'row') {
        // If we find a row, increment the serial number based on its position.
        // Since we're iterating backwards, the *next* row will be +1 to the *last* row's number.
        // A simpler way is to count rows since the last header.
        serialNumber++;
      } else if (item['type'] == 'header') {
        // If a header is found, the serial number for the new row should be 1,
        // as it's the first row under this new header/section.
        // But since we incremented once already for the new row, we reset to 1
        return 1;
      }
    }
    // If no header is found, it's the first section, so the count is the total rows + 1
    return serialNumber;
  }

  List<Map<String, dynamic>> lineItems = [];

  void collectFormData() {
    lineItems.clear();

    for (final item in formStructure) {
      if (item['type'] == 'header') {
        final controller = item['controller'] as TextEditingController;
        if (controller.text.trim().isNotEmpty) {
          lineItems.add({
            'type': 'header',
            'text': controller.text.trim(),
          });
        }
      } else if (item['type'] == 'row') {
        final i = item['index'] as int;
        if (description[i].text.trim().isNotEmpty) {
          lineItems.add({
            'type': 'row',
            'sno': sno[i].text.trim(),
            'description': description[i].text.trim(),
            'unit': unit[i].text.trim(),
            'rate': rateControllers[i].text.trim(),
            'quantity': qtyControllers[i].text.trim(),
            'amount': amountControllers[i].text.trim(),
          });
        }
      }
    }
  }

  String? selectedDocumentId;

  void clearForm() {
    setState(() {
      // Clear all controllers
      for (var controller in description) controller.dispose();
      for (var controller in rateControllers) controller.dispose();
      for (var controller in qtyControllers) controller.dispose();
      for (var controller in amountControllers) controller.dispose();
      for (var controller in sno) controller.dispose();
      for (var controller in unit) controller.dispose();
      for (var controller in headerControllers) controller.dispose();

      // Clear all lists
      description.clear();
      rateControllers.clear();
      qtyControllers.clear();
      amountControllers.clear();
      sno.clear();
      unit.clear();
      headerControllers.clear();
      formStructure.clear();
      rows.clear();

      // Reset other fields
      qtnno.clear();
      date.clear();
      kindatt.clear();
      project.clear();
      nbq.clear();
      naq.clear();
      termsandconditioncontroller.clear();
      totalamountinname.clear();
      selectednbq = '';

      // Reset calculations
      subtotal = 0.0;
      discount = 0.0;
      taxableAmount = 0.0;
      vat = 0.0;
      totalAmount = 0.0;
    });
  }

  //for convertiing to invoice
  void navigateToInvoicePage() {
    collectFormData(); // Collect lineItems from formStructure

    Navigator.push(
      context,
      MaterialPageRoute(
        
        builder: (context) => invoice1(
          id: widget.id,
          name: widget.name,
          address: widget.address,
          trn: '',
          // Pass actual TRN if you have it
          prefillData: {
            'invno': qtnno.text,
            'date': date.text,
            'kindatt': kindatt.text,
            'project': project.text,
            'nbq': nbq.text,
            'naq': naq.text,
            'termsandcondition': termsandconditioncontroller.text,
            'totalamountinname': totalamountinname.text,
            'lineItems': lineItems,
            'subtotal': subtotal,
            'discount': discountcontroller.text,
            'vat': vat,
            'totalAmount': totalAmount,
          },
          index: widget.index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quotationRef = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("quotation");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => home()),
              ).then((value) {
                setState(() {}); // 🔥 rebuild dashboard when returning
              });
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFFC62828),
        title: Text(
          "Create Quotation",
          style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        titleSpacing: 1,
        toolbarHeight: 60.h,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20.sp,
                  color: Colors.white,
                ),
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'convert') {
                    navigateToInvoicePage();
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Convert to Invoice"),
                        value: 'convert',
                      )
                    ]),
          )
        ],
      ),
      backgroundColor: Colors.white,
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
                          "Select Company",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 60.h,
                        width: 250.w,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                          value: selectedCompany2,
                          items:
                              ["Al Maskan", "Reyah Al Maskan"].map((company) {
                            return DropdownMenuItem(
                              value: company,
                              child: Text(company),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            if (value == null) return;

                            setState(() {
                              selectedCompany2 =
                                  value; // 🔥 This must run BEFORE calling loadNextQtnNo()
                            });

                            await loadNextQtnNo(); // 🔥 QTN updates based on correct company
                          },
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
                          "QTN No",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
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
                          controller: qtnno,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
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
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
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
                          // Make the field non-editable so only date picker is used
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(FocusNode()); // Prevent keyboard
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.deepPurple,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('d/MM/yyyy').format(pickedDate);
                              date.text = formattedDate;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'Select date',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
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
                          "Kind Att",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
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
                          controller: kindatt,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
                          "Project:",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
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
                          style: GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
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
                        child: Row(
                          children: [
                            Text(
                              "NOTE Before Quote",
                              style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController _noteController =
                                          TextEditingController();
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.r)),
                                        title:
                                            const Text("Add Note Before Quote"),
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 24),
                                        // Controls width and height
                                        content: SizedBox(
                                          width: 400.w, // Custom width
                                          height: 90.h, // Custom height
                                          child: TextFormField(
                                            controller: _noteController,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter your note here...",
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
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              final suggestion =
                                                  _noteController.text.trim();
                                              if (suggestion.isEmpty) return;

                                              try {
                                                await nbqfirestore.update({
                                                  'suggestions':
                                                      FieldValue.arrayUnion(
                                                          [suggestion])
                                                }).catchError((_) async {
                                                  await nbqfirestore.set({
                                                    'suggestions': [suggestion]
                                                  });
                                                });

                                                Navigator.of(context).pop();
                                                fetchnbqSuggestions(); // Refresh the local list

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                        'Suggestion Saved'),
                                                    duration: const Duration(
                                                        seconds: 2),
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
                                                    margin:
                                                        const EdgeInsets.all(
                                                            15),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to Save: $e'),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text("Add"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.add_circle,
                                    color: Color(0xFFC62828)),
                              ),
                            )
                          ],
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
                            style: GoogleFonts.poppins(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              option,
                                            )),
                                            GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTapDown:
                                                  (_) {}, // 👈 Prevent autocomplete from closing
                                              child: IconButton(
                                                  onPressed: () async {
                                                    // The item we want to remove
                                                    final optionToRemove =
                                                        option
                                                            .toString()
                                                            .trim();

                                                    // 1) immediate local UI update
                                                    setState(() {
                                                      nbqoptions.removeWhere(
                                                          (e) =>
                                                              e
                                                                  .toString()
                                                                  .trim() ==
                                                              optionToRemove);
                                                    });

                                                    // 2. Update Firestore document
                                                    try {
                                                      await nbqfirestore
                                                          .update({
                                                        'suggestions':
                                                            FieldValue
                                                                .arrayRemove([
                                                          optionToRemove
                                                        ]),
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Item removed successfully'),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                      // 👇 Close the dropdown after a small delay (auto close)
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  200), () {
                                                        FocusScope.of(context)
                                                            .unfocus(); // closes autocomplete
                                                      });
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Failed to remove item: $e'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  icon: Icon(Icons.close)),
                                            )
                                          ],
                                        ),
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
                ),
                // new add button for textformfield
                SizedBox(
                  width: 30.w,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Color(0xFFC62828),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isclicked = true;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.sp,
                        )),
                  ),
                )
              ],
            ),
            isclicked == true
                ? Padding(
                    padding: EdgeInsets.only(top: 15.h, left: 20.w),
                    child: Row(
                      children: [
                        Container(
                          width: 250.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: newfeild,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: GoogleFonts.poppins(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16.sp,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isclicked = false;
                              });
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 865.w),
                    child: InkWell(
                      onTap: () {
                        addNewRow();
                        getNextSerialNumber();
                      },
                      child: Container(
                        width: 130.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.r),
                                bottomLeft: Radius.circular(5.r)),
                            color: Colors.grey[200]),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Icon(
                                Icons.add_circle,
                                color: const Color(0xFFC62828),
                                size: 15.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Text(
                                "Add New Row",
                                style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.r),
                            bottomRight: Radius.circular(5.r),
                          ),
                          color: Colors.grey[200]),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          CupertinoIcons.chevron_down,
                          size: 12.sp,
                          color: Colors.grey[600],
                        ),
                        onSelected: (value) {
                          if (value == 'header') {
                            addNewHeader();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'header',
                            child: Text(
                              "Add New Header",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Container(
                width: 1100.w,
                height: 500.h, // Fixed scrollable height
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 20.h),
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Text("SNo",
                              style: GoogleFonts.poppins(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40.w),
                          child: Row(
                            children: [
                              Text("Description",
                                  style: GoogleFonts.poppins(fontSize: 15.sp)),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController
                                            _descsuggesstioncontroller =
                                            TextEditingController();
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.r)),
                                          title: Text(
                                            "Add Description",
                                            style: GoogleFonts.poppins(),
                                          ),
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 40, vertical: 24),
                                          // Controls width and height
                                          content: SizedBox(
                                            width: 400.w, // Custom width
                                            height: 90.h, // Custom height
                                            child: TextFormField(
                                              controller:
                                                  _descsuggesstioncontroller,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Enter your Desc here...",
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
                                              child: const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final suggestion =
                                                    _descsuggesstioncontroller
                                                        .text
                                                        .trim();
                                                if (suggestion.isEmpty) return;

                                                try {
                                                  await desfirestore.update({
                                                    'suggestions':
                                                        FieldValue.arrayUnion(
                                                            [suggestion])
                                                  }).catchError((_) async {
                                                    await desfirestore.set({
                                                      'suggestions': [
                                                        suggestion
                                                      ]
                                                    });
                                                  });

                                                  Navigator.of(context).pop();
                                                  fetchdescSuggestions(); // Refresh the local list

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                          'Suggestion Saved'),
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      backgroundColor:
                                                          Colors.green,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Failed to Save: $e'),
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text("Add"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.add_circle,
                                      color: Color(0xFFC62828)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 440.w),
                          child: Text("qty",
                              style: GoogleFonts.poppins(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60.w),
                          child: Row(
                            children: [
                              Text("Unit",
                                  style: GoogleFonts.poppins(fontSize: 15.sp)),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController
                                            _unitsuggestioncontroller =
                                            TextEditingController();
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.r)),
                                          title: const Text("Add Unit"),
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 40.w, vertical: 24.w),
                                          // Controls width and height
                                          content: SizedBox(
                                            width: 400.w, // Custom width
                                            height: 90.h, // Custom height
                                            child: TextFormField(
                                              controller:
                                                  _unitsuggestioncontroller,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Enter your Unit here...",
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
                                                    _unitsuggestioncontroller
                                                        .text
                                                        .trim();
                                                if (suggestion.isEmpty) return;

                                                try {
                                                  await unitfirestore.update({
                                                    'suggestions':
                                                        FieldValue.arrayUnion(
                                                            [suggestion])
                                                  }).catchError((_) async {
                                                    await unitfirestore.set({
                                                      'suggestions': [
                                                        suggestion
                                                      ]
                                                    });
                                                  });

                                                  Navigator.of(context).pop();
                                                  fetchunitSuggestions(); // Refresh the local list

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
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      margin:
                                                          EdgeInsets.all(15),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Failed to Save: $e'),
                                                      backgroundColor:
                                                          Colors.red,
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
                                  child: const Icon(Icons.add_circle,
                                      color: Color(0xFFC62828)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 70.w),
                          child: Row(
                            children: [
                              Text("Rate",
                                  style: GoogleFonts.poppins(fontSize: 15.sp)),
                              SizedBox(
                                width: 5.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController
                                          _ratesuggestioncontroller =
                                          TextEditingController();
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.r)),
                                        title: Text("Add Rate",
                                            style: GoogleFonts.poppins()),
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 40.w, vertical: 24.w),
                                        // Controls width and height
                                        content: SizedBox(
                                          width: 400.w, // Custom width
                                          height: 90.h, // Custom height
                                          child: TextFormField(
                                            controller:
                                                _ratesuggestioncontroller,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter your Rate here...",
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
                                            child: Text("Cancel",
                                                style: GoogleFonts.poppins()),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              final suggestion =
                                                  _ratesuggestioncontroller.text
                                                      .trim();
                                              if (suggestion.isEmpty) return;

                                              try {
                                                await ratefirestore.update({
                                                  'suggestions':
                                                      FieldValue.arrayUnion(
                                                          [suggestion])
                                                }).catchError((_) async {
                                                  await ratefirestore.set({
                                                    'suggestions': [suggestion]
                                                  });
                                                });

                                                Navigator.of(context).pop();
                                                fetchunitSuggestions(); // Refresh the local list

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
                                            child: Text(
                                              "Add",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.add_circle,
                                    color: Color(0xFFC62828)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 70.w),
                          child: Text("Amount",
                              style: GoogleFonts.poppins(fontSize: 15.sp)),
                        ),
                      ],
                    ),
                    ...rows, // this should grow correctly as you add rows
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 750.w, top: 10.h),
                    child: Text(
                      "Sub Total",
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Container(
                        width: 200.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w, top: 2.h),
                          child: Text(
                            "\$ ${subtotal.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 720.w, top: 10.h),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isDiscountEnabled,
                          onChanged: (value) {
                            setState(() {
                              isDiscountEnabled = value!;
                              if (!isDiscountEnabled) {
                                discount = 0.0;
                                discountcontroller.clear();
                                calculateTotal(); // Ensure total is recalculated
                              }
                            });
                          },
                        ),
                        Text(
                          "Discount",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Container(
                      width: 200.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: TextFormField(
                        enabled: isDiscountEnabled,
                        onChanged: (value) {
                          discount = double.tryParse(value) ?? 0.0;
                          calculateTotal();
                        },
                        controller: discountcontroller,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 20),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          prefixStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 700.w, top: 10.h),
                    child: Text(
                      "Taxable Amount",
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.w),
                    child: Container(
                        width: 200.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w, top: 2.h),
                          child: Text(
                            "\$ ${taxableAmount.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 770.w, top: 10.h),
                    child: Text(
                      "Vat 5%",
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Container(
                        width: 200.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w, top: 2.h),
                          child: Text(
                            "\$ ${vat.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 725.w, top: 10.h),
                    child: Text(
                      "Total Amount",
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Container(
                        width: 200.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w, top: 2.h),
                          child: Text(
                            "\$ ${totalAmount.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 725.w, top: 10.h),
                    child: Text(
                      "Sign Section ",
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Container(
                      height: 50.h,
                      width: 150.w,
                      child: DropdownButtonFormField<int>(
                        hint: const Text("Select option"),
                        items: options.map((option) {
                          return DropdownMenuItem<int>(
                            value: option['id'],
                            child: Text(option['label']),
                          );
                        }).toList(),
                        onChanged: (id) {
                          setState(() {
                            selectedoption = id;
                            // recalc
                          });
                        },
                        value: selectedoption,
                      ),
                    ),
                  ),
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
                    style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 550.w,
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
                    style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 550.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        controller: naq,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
                              color: Colors.black),
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
                    "Terms & Conditions",
                    style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 550.w,
                      height: 150.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return TACoptions.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      }, onSelected: (String selection) {
                        termsandconditioncontroller.text = selection;
                        selectedTAC = selection;
                      }, fieldViewBuilder: (BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted) {
                        // Sync text initially
                        textEditingController.text =
                            termsandconditioncontroller.text;

                        // Sync both ways
                        textEditingController.addListener(() {
                          termsandconditioncontroller.text =
                              textEditingController.text;
                        });

                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          maxLines: 5,
                          onFieldSubmitted: (v) {
                            setState(() {
                              selectedTAC = v;
                            });
                          },
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
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
                              width: 550.w,
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
                      }),
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
                    .collection("quotation")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  var docs = snapshot.data!.docs;
                  final quotationMap = {
                    for (var doc in docs)
                      doc['qtn no']?.toString() ?? 'Unknown': doc.id
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
                              return quotationMap.keys
                                  .where((key) =>
                                      filter == null ||
                                      key
                                          .toLowerCase()
                                          .contains(filter.toLowerCase()))
                                  .toList();
                            },
                             popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    hintText: "Search by INV No"),
                              ),
                            ),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select Quotation to Edit",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            onChanged: (invNo) async {
                              if (invNo == null) return;

                              final selectedId = quotationMap[invNo];
                              if (selectedId == null) return;

                              try {
                                final selectedDoc = docs
                                    .firstWhere((doc) => doc.id == selectedId);
                                final data =
                                    selectedDoc.data() as Map<String, dynamic>;

                                // Clear existing data
                                clearForm();

                                setState(() {
                                  isclicked = true;
                                  selectedDocumentId = selectedDoc.id;
                                  qtnno.text = data['qtn no'] ?? '';
                                  date.text = data['date'] ?? '';
                                  kindatt.text = data['kindatt'] ?? '';
                                  project.text = data['project'] ?? '';
                                  nbq.text = data['note before quote'] ?? '';
                                  selectednbq = data['note before quote'] ?? '';
                                  termsandconditioncontroller.text =
                                      data['termsandcondition'] ?? '';
                                  newfeild.text = data['newfield'] ?? '';
                                  selectedTAC = data['termsandcondition'] ?? '';
                                  naq.text = data['note after quote'] ?? '';
                                  totalamountinname.text =
                                      data['total amount in name'] ?? '';

                                  // Convert numeric values
                                  subtotal = (data['subtotal'] is String)
                                      ? double.tryParse(
                                              data['subtotal'] ?? '0') ??
                                          0.0
                                      : (data['subtotal']?.toDouble() ?? 0.0);

                                  discount = (data['discount'] is String)
                                      ? double.tryParse(
                                              data['discount'] ?? '0') ??
                                          0.0
                                      : (data['discount']?.toDouble() ?? 0.0);
                                  discountcontroller.text = discount.toString();

                                  taxableAmount = (data[
                                          'taxable amount'] is String)
                                      ? double.tryParse(
                                              data['taxable amount'] ?? '0') ??
                                          0.0
                                      : (data['taxable amount']?.toDouble() ??
                                          0.0);

                                  vat = (data['vat 5%'] is String)
                                      ? double.tryParse(
                                              data['vat 5%'] ?? '0') ??
                                          0.0
                                      : (data['vat 5%']?.toDouble() ?? 0.0);

                                  totalAmount = (data['total amount'] is String)
                                      ? double.tryParse(
                                              data['total amount'] ?? '0') ??
                                          0.0
                                      : (data['total amount']?.toDouble() ??
                                          0.0);

                                  // Rebuild line items
                                  if (data['lineItems'] != null &&
                                      data['lineItems'] is List) {
                                    for (var item in data['lineItems']) {
                                      if (item['type'] == 'header') {
                                        final controller =
                                            TextEditingController(
                                                text: item['text'] ?? '');
                                        headerControllers.add(controller);
                                        formStructure.add({
                                          'type': 'header',
                                          'controller': controller,
                                        });
                                      } else if (item['type'] == 'row') {
                                        // Add new row and get its index
                                        addNewRow();
                                        final index = description.length - 1;

                                        // Set values for the new row
                                        sno[index].text =
                                            item['sno']?.toString() ?? '';
                                        description[index].text =
                                            item['description']?.toString() ??
                                                '';
                                        qtyControllers[index].text =
                                            item['quantity']?.toString() ?? '';
                                        unit[index].text =
                                            item['unit']?.toString() ?? '';
                                        rateControllers[index].text =
                                            item['rate']?.toString() ?? '';
                                        amountControllers[index].text =
                                            item['amount']?.toString() ?? '';
                                      }
                                    }
                                  }
                                });

                                // Force rebuild of rows
                                rebuildRows();
                              } catch (e) {
                                print('Error loading quotation: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to load quotation: ${e.toString()}')),
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 100.w),
                          child: InkWell(
                            onTap: () async {
                              try {
                                collectFormData();

                                final id = DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString();

                                final nextQtn = await safeCompanyQtnCounter(
                                  selectedCompany2!,
                                  qtnno.text, // 👈 whatever user typed
                                );

                                qtnno.text = nextQtn;
                                await quotationRef.doc(id).set({
                                  'id': id,
                                  'project': project.text,
                                  'kindatt': kindatt.text,
                                  'date': date.text,
                                  'qtn no': qtnno.text,
                                  'note before quote': nbq.text,
                                  'lineItems': lineItems,
                                  'subtotal': subtotal.toString(),
                                  'discount': discount.toString(),
                                  'taxable amount': taxableAmount.toString(),
                                  'vat': vat.toString(),
                                  'total amount': totalAmount.toString(),
                                  'total amount in name':
                                      totalamountinname.text,
                                  'note after quote': naq.text,
                                  'termsandcondition':
                                      termsandconditioncontroller.text,
                                  'newfield': isclicked ? newfeild.text : null,
                                  'createdAt': FieldValue.serverTimestamp(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Quote Saved"),
                                      backgroundColor: Colors.green),
                                );

                                // 🔥 Load the NEXT quotation number
                                await loadNextQtnNo();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Failed to Save $e"),
                                      backgroundColor: Colors.red),
                                );
                              }
                            },
                            child: Container(
                              width: 65.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.lightBlue[600]),
                              child: Center(
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
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

                            // If user selected a company, proceed
                            if (selected != null) {
                              selectedCompany = selected;
                              selectedTAC =
                                  termsandconditioncontroller.text.trim();
                              collectFormData();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoicePdfPreviewPage(
                                    qtnno: qtnno.text,
                                    date: date.text,
                                    kindatt: kindatt.text,
                                    project: project.text,
                                    nbq: nbq.text,
                                    TAC: termsandconditioncontroller.text,
                                    discount: discount.toString(),
                                    naq: naq.text,
                                    lineItems: lineItems,
                                    subtotal: subtotal.toStringAsFixed(2),
                                    taxableamount:
                                        taxableAmount.toStringAsFixed(2),
                                    vat: vat.toStringAsFixed(2),
                                    totalamount: totalAmount.toStringAsFixed(2),
                                    totalamountinname: totalamountinname.text,
                                    name: widget.name,
                                    address: widget.address,
                                    id: widget.id,
                                    fromSaved: false,
                                    quotationId: '',
                                    selectedCompany: selectedCompany,
                                    newfeild: newfeild.text,
                                    option: selectedoption != null
                                        ? options.firstWhere((m) =>
                                            m['id'] == selectedoption)['label']
                                        : '',
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
                                style: GoogleFonts.poppins(
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
                            collectFormData();
                            try {
                              await quotationRef
                                  .doc(selectedDocumentId)
                                  .update({
                                'project': project.text,
                                'kindatt': kindatt.text,
                                'date': date.text,
                                'qtn no': qtnno.text,
                                'note before quote': nbq.text,
                                'lineItems': lineItems,
                                'subtotal': subtotal.toString(),
                                'discount': discountcontroller.text,
                                'taxable amount': taxableAmount.toString(),
                                'vat': vat.toString(),
                                'total amount': totalAmount.toString(),
                                'total amount in name': totalamountinname.text,
                                'note after quote': naq.text,
                                'termsandcondition':
                                    termsandconditioncontroller.text,
                                'newfield': newfeild.text,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Quote Updated'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.all(
                                      30), // only works with floating behavior
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
                                      30), // only works with floating behavior
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
                                style: GoogleFonts.poppins(
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
