import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'Invoice.dart';
import 'Quotationpdf.dart';

class Quotation2 extends StatefulWidget {
  final String id;
  final String name;
  final String address;

  const Quotation2({
    super.key,
    required this.id,
    required this.name,
    required this.address,
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

  final List<String> TACoptions = [
    'a) 50% Advance Payment,40% Work in Progress,10% Completion of Work\nb) The work will be only starting after getting LPO and advance payment\nc) Quote is per boq.any changes or extra work will be treated as variation'
  ];
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
  TextEditingController kindatt = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController nbq = TextEditingController();

  TextEditingController discountcontroller = TextEditingController();

  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();
  TextEditingController termsandconditioncontroller = TextEditingController();

  List<TextEditingController> headerControllers = [];
  List<Map<String, dynamic>> formStructure = [];
  bool isDiscountEnabled = false;
  String selectedCompany = 'Reyah Al Maskan';

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

  void calculateTotal() {
    taxableAmount = subtotal - discount;
    vat = taxableAmount * 0.05;
    totalAmount = taxableAmount + vat;

    // Convert amount to words and update the controller
    final totalInt = totalAmount.floor(); // Dirhams
    final totalFils = ((totalAmount - totalInt) * 100).round(); // Fils

    String amountInWords =
        NumberToWord().convert('en-in', totalInt) + 'dirhams';

    if (totalFils > 0) {
      amountInWords +=
          ' and ${NumberToWord().convert('en-in', totalFils)} fils';
    }

    amountInWords += ' only';

    // Capitalize first letter
    totalamountinname.text =
        amountInWords[0].toUpperCase() + amountInWords.substring(1);

    setState(() {});
  }

  void rebuildRows() {
    rows.clear();

    for (int i = 0; i < formStructure.length; i++) {
      final item = formStructure[i];
      if (item['type'] == 'header') {
        final controller = item['controller'] as TextEditingController;

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
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration.collapsed(
                              hintText: ' Header Title',
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.cancel_outlined, color: Colors.black),
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
                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
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
                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
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
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  ratedata.add(value);
                },
                controller: rateControllers[index],
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
          // Remove Row Icon
          IconButton(
            icon: Icon(Icons.cancel_outlined, color: Colors.black),
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
        ],
      ),
    );
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
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          "Create Quotation",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
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
                ),
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'convert') {
                    navigateToInvoicePage();
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
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
                          "QTN No",
                          style: TextStyle(
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
                                    colorScheme: ColorScheme.light(
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
                                  DateFormat('dMMMyyyy').format(pickedDate);
                              date.text = formattedDate;
                            }
                          },
                          textInputAction: TextInputAction.next,
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
                            hintText: 'Select date',
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
                          "Kind Att",
                          style: TextStyle(
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
                          "Project:",
                          style: TextStyle(
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
                        child: Row(
                          children: [
                            Text(
                              "NOTE Before Quote",
                              style: TextStyle(
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
                                        title: Text("Add Note Before Quote"),
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 24),
                                        // Controls width and height
                                        content: SizedBox(
                                          width: 400.w, // Custom width
                                          height: 90.h, // Custom height
                                          child: TextFormField(
                                            controller: _noteController,
                                            decoration: InputDecoration(
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
                                            child: Text("Cancel"),
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
                                    Icon(Icons.add_circle, color: Colors.blue),
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
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 865.w),
                    child: InkWell(
                      onTap: () {
                        addNewRow();
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
                                color: Colors.blue,
                                size: 15.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Text(
                                "Add New Row",
                                style: GoogleFonts.workSans(
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
                              style: GoogleFonts.workSans(
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
                          child: Text("SNo", style: TextStyle(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40.w),
                          child: Row(
                            children: [
                              Text("Description",
                                  style: TextStyle(fontSize: 15.sp)),
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
                                          title: Text("Add Description"),
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 24),
                                          // Controls width and height
                                          content: SizedBox(
                                            width: 400.w, // Custom width
                                            height: 90.h, // Custom height
                                            child: TextFormField(
                                              controller:
                                                  _descsuggesstioncontroller,
                                              decoration: InputDecoration(
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
                                              child: Text("Cancel"),
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
                                  child: Icon(Icons.add_circle,
                                      color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 440.w),
                          child: Text("qty", style: TextStyle(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60.w),
                          child: Row(
                            children: [
                              Text("Unit", style: TextStyle(fontSize: 15.sp)),
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
                                          title: Text("Add Unit"),
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 24),
                                          // Controls width and height
                                          content: SizedBox(
                                            width: 400.w, // Custom width
                                            height: 90.h, // Custom height
                                            child: TextFormField(
                                              controller:
                                                  _unitsuggestioncontroller,
                                              decoration: InputDecoration(
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
                                  child: Icon(Icons.add_circle,
                                      color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 70.w),
                          child:
                              Text("Rate", style: TextStyle(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 70.w),
                          child:
                              Text("Amount", style: TextStyle(fontSize: 15.sp)),
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
                      style: TextStyle(
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
                            style: TextStyle(
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
                          style: TextStyle(
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
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          prefixStyle: TextStyle(
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
                      style: TextStyle(
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
                            style: TextStyle(
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
                      style: TextStyle(
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
                            style: TextStyle(
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
                      style: TextStyle(
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
                            style: TextStyle(
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
                    style: TextStyle(
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
              padding: EdgeInsets.only(top: 15.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terms & Conditions",
                    style: TextStyle(
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
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    hintText: "Search by QTN No"),
                              ),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select Quotation to Edit",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            // In the onChanged callback of DropdownSearch<String>:
                            // In the onChanged callback of DropdownSearch<String>:
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
                                  selectedDocumentId = selectedDoc.id;
                                  qtnno.text = data['qtn no'] ?? '';
                                  date.text = data['date'] ?? '';
                                  kindatt.text = data['kindatt'] ?? '';
                                  project.text = data['project'] ?? '';
                                  nbq.text = data['note before quote'] ?? '';
                                  selectednbq = data['note before quote'] ?? '';
                                  termsandconditioncontroller.text =
                                      data['termsandcondition'] ?? '';
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
                              collectFormData();
                              final id = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              try {
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
                                      termsandconditioncontroller.text
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Quote Saved'),
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
                                    content: Text('Failed to Save ${e}'),
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
                                    termsandconditioncontroller.text
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
