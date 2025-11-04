import 'package:almaskan/ui/Invpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';

class invoice1 extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String trn;
  final Map<String, dynamic>? prefillData;
  final int index;

  const invoice1({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.trn,
    this.prefillData,
    required this.index,
  });

  @override
  State<invoice1> createState() => _invoice1State();
}

class _invoice1State extends State<invoice1> {
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

  List<String> nbqoptions = [];
  final nbqfirestore = FirebaseFirestore.instance
      .collection("Suggestions")
      .doc("AqpEzHc1d4HIUWsj6NpR")
      .collection("SuggestionsData") // optional for clarity
      .doc("nbqoptions");

  List<TextEditingController> rateControllers = [];
  List<TextEditingController> qtyControllers = [];
  List<TextEditingController> amountControllers = [];
  List<TextEditingController> sno = [];
  List<TextEditingController> description = [];
  List<TextEditingController> unit = [];

  List<String> snodata = [];
  List<String> qtydata = [];
  List<String> unitdata = [];
  List<String> ratedata = [];
  List<String> amountdata = [];
  List<String> descriptionData = [];

  TextEditingController invno = TextEditingController();
  TextEditingController date = TextEditingController();
  //add new textfield
  TextEditingController newfeild = TextEditingController();

  TextEditingController lpoqtn = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController nbq = TextEditingController();
  TextEditingController discountcontroller = TextEditingController();
  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();

  List<double> originalQty = [];
  List<TextEditingController> percentageControllers = [];

  String selectednbq = '';

  List<TextEditingController> headerControllers = [];
  List<Map<String, dynamic>> formStructure = [];

  bool showPercentageFields = false;
  String selectedCompany = 'Reyah Al Maskan';
  bool isDiscountEnabled = false;
  bool ispaymentcheck = false;
  bool ischeked = false;

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

  int rowCount = 1;
  double subtotal = 0.0;
  double discount = 0.0;
  double taxableAmount = 0.0;
  double vat = 0.0;
  double totalAmount = 0.0;

  get index => 1;

  //for new add button
  bool isclicked = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefillData != null) {
      loadPrefillData(widget.prefillData!);
    }
    fetchnbqSuggestions();
    fetchdescSuggestions();
    fetchunitSuggestions();
    loadNewinvno();
  }

  // Add a helper function to handle async initialization
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Use your client-specific path for 'quotationRef' when saving the quote
// The client ID must be available in your widget's state for this
  CollectionReference get quotationRef => _firestore
      .collection('Clients')
      .doc(widget
          .id) // Replace 'widget.clientId' with your actual client ID variable
      .collection('invoice');

// 1. QTN Load function (for initState)
  void loadNewinvno() async {
    try {
      // Note: This calls the safe read-only fetch
      final nextinvno = await _fetchNextinvnoForDisplay(_firestore);
      if (mounted) {
        setState(() {
          invno.text = nextinvno;
        });
      }
    } catch (e) {
      print('Failed to pre-load invno No.: $e');
      if (mounted) {
        setState(() {
          invno.text = 'Failed to load';
        });
      }
    }
  }

// 2. QTN Reserve function (for save button)
  Future<void> _reserveAndIncrementinvno(FirebaseFirestore firestore,
      TextEditingController qtnnoController) async {
    final DocumentReference invnoCounterRef =
        firestore.collection('counters2').doc('invoice_counter');

    final currentFullYear = DateTime.now().year;
    final currentShortYear = currentFullYear % 100;
    String reservedinvNumber =
        ''; // Store the number calculated inside the transaction

    await firestore.runTransaction((Transaction transaction) async {
      final counterSnapshot = await transaction.get(invnoCounterRef);

      int yearInDb = counterSnapshot.exists
          ? counterSnapshot.get('currentYear') as int
          : 0;
      int lastSequence = counterSnapshot.exists
          ? counterSnapshot.get('lastSequence') as int
          : 0;

      int newSequence;

      if (yearInDb != currentFullYear) {
        newSequence = 1;
      } else {
        newSequence = lastSequence + 1;
      }

      // 1. Format the reserved number
      final sequenceString = newSequence.toString().padLeft(2, '0');
      reservedinvNumber = '$currentShortYear-$sequenceString';

      // 2. Safely commit the new sequence to the counter
      if (yearInDb != currentFullYear) {
        transaction.set(invnoCounterRef, {
          'currentYear': currentFullYear,
          'lastSequence': newSequence,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.update(invnoCounterRef, {
          'lastSequence': newSequence,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    }); // End of Transaction

    // Update the local controller with the reserved number ONLY if the transaction succeeded
    qtnnoController.text = reservedinvNumber;
  }

  Future<String> _fetchNextinvnoForDisplay(FirebaseFirestore firestore) async {
    final DocumentReference invnoCounterRef =
        firestore.collection('counters2').doc('invoice_counter');

    final currentFullYear = DateTime.now().year;
    final currentShortYear = currentFullYear % 100;

    try {
      // Read the counter WITHOUT a transaction (it's only for display/pre-fill)
      final counterSnapshot = await invnoCounterRef.get();

      int yearInDb = counterSnapshot.exists
          ? counterSnapshot.get('currentYear') as int
          : 0;
      int lastSequence = counterSnapshot.exists
          ? counterSnapshot.get('lastSequence') as int
          : 0;

      int nextSequence;

      // Check for year change (the first number of the new year is 1)
      if (yearInDb != currentFullYear) {
        nextSequence = 1;
      } else {
        // Get the next number (e.g., if lastSequence was 5, the next is 6)
        nextSequence = lastSequence + 1;
      }

      final sequenceString = nextSequence.toString().padLeft(2, '0');
      return '$currentShortYear-$sequenceString';
    } catch (e) {
      print('Error fetching next QTN No.: $e');
      return 'XX-00'; // Return a fallback value
    }
  }

// You will need to pass the FirebaseFirestore instance to this function
  Future<bool> isinvnoUnique(
      FirebaseFirestore firestore, String invNumber) async {
    // Use a Collection Group Query to search all 'quotation' sub-collections
    // regardless of the parent client document.
    final querySnapshot = await firestore
        .collectionGroup('invoice') // Searches all 'quotation' sub-collections
        .where('inv no', isEqualTo: invNumber)
        .limit(1)
        .get();

    // If the query returns any documents, the QTN number is NOT unique
    return querySnapshot.docs.isEmpty;
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

//function to load data from quotation
  void loadPrefillData(Map<String, dynamic> data) {
    invno.text = data['invno'] ?? '';
    date.text = data['date'] ?? '';
    lpoqtn.text = data['lpoqtn#'] ?? '';
    project.text = data['project'] ?? '';
    nbq.text = data['nbq'] ?? '';
    selectednbq = data['nbq'] ?? '';
    naq.text = data['naq'] ?? '';
    totalamountinname.text = data['totalamountinname'] ?? '';
    discountcontroller.text = data['discount'] ?? '';

    subtotal = data['subtotal'] ?? 0.0;
    discount =
        double.tryParse(data['discount'] ?? '0') ?? 0.0; // ensure numeric
    taxableAmount =
        data['taxableAmount'] ?? (subtotal - discount); // ✅ Add this
    vat = data['vat'] ?? 0.0;
    totalAmount = data['totalAmount'] ?? 0.0;

    List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(data['lineItems']);
    for (var item in items) {
      if (item['type'] == 'header') {
        final controller = TextEditingController(text: item['text']);
        headerControllers.add(controller);
        formStructure.add({
          'type': 'header',
          'controller': controller,
        });
      } else if (item['type'] == 'row') {
        final i = description.length;

        final sn = TextEditingController(text: item['sno']);
        final desc = TextEditingController(text: item['description']);
        final qty = TextEditingController(text: item['quantity']);
        final unitc = TextEditingController(text: item['unit']);
        final rate = TextEditingController(text: item['rate']);
        final amount = TextEditingController(text: item['amount']);
        final percentage = TextEditingController();

        sno.add(sn);
        description.add(desc);
        qtyControllers.add(qty);
        unit.add(unitc);
        rateControllers.add(rate);
        amountControllers.add(amount);
        percentageControllers.add(percentage);

        rate.addListener(() => calculateAmount(i));
        qty.addListener(() => calculateAmount(i));

        formStructure.add({
          'type': 'row',
          'index': i,
        });
      }
    }

    rebuildRows();
  }

  void initializeControllers({bool addNewRow = true}) {
    final rateController = TextEditingController();
    final qtyController = TextEditingController();
    final amountController = TextEditingController();
    final snController = TextEditingController();
    final descController = TextEditingController();
    final unitController = TextEditingController();
    final percentageController = TextEditingController();

    rateControllers.add(rateController);
    qtyControllers.add(qtyController);
    amountControllers.add(amountController);
    sno.add(snController);
    description.add(descController);
    unit.add(unitController);
    percentageControllers.add(percentageController);

    rateController
        .addListener(() => calculateAmount(rateControllers.length - 1));
    qtyController
        .addListener(() => calculateAmount(rateControllers.length - 1));
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

  // void calculateTotal() {
  //   taxableAmount = subtotal - discount;
  //   vat = taxableAmount * 0.05;
  //   totalAmount = taxableAmount + vat;

  //   // Convert amount to words and update the controller
  //   final totalInt = totalAmount.floor(); // Dirhams
  //   final totalFils = ((totalAmount - totalInt) * 100).floor(); // Fils

  //   String amountInWords =
  //       NumberToWord().convert('en-in', totalInt) + 'dirhams';

  //   if (totalFils > 0) {
  //     amountInWords += ' and ${NumberToWord().convert('en-in', totalFils)}fils';
  //   }

  //   amountInWords += ' only';

  //   // Capitalize first letter
  //   totalamountinname.text =
  //       amountInWords[0].toUpperCase() + amountInWords.substring(1);

  //   setState(() {});
  // }

  void calculateTotal() {
    taxableAmount = subtotal - discount;

    // Use precise double math with truncation to avoid rounding up
    vat = double.parse((taxableAmount * 0.05).toStringAsFixed(2));

    totalAmount = double.parse((taxableAmount + vat).toStringAsFixed(2));

    // Convert amount to words
    final totalInt = totalAmount.floor(); // Dirhams
    final totalFils =
        ((totalAmount - totalInt) * 100).floor(); // 🔹 Use floor() not round()

    String amountInWords =
        NumberToWord().convert('en-in', totalInt) + ' dirhams';

    if (totalFils > 0) {
      amountInWords +=
          ' and ${NumberToWord().convert('en-in', totalFils)} fils';
    }

    amountInWords += ' only';

    totalamountinname.text =
        amountInWords[0].toUpperCase() + amountInWords.substring(1);

    setState(() {});
  }

  List<Widget> rows = []; // List to store each row
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

        // 1. Update the S.No. Controller with the new sequential number
        sno[index].text = currentSNo.toString();

        // 2. Increment the S.No. for the *next* row in this section
        currentSNo++;

        // 3. Build the row widget using the correct controller index
        rows.add(buildRow(index));
      }
    }
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Column(
              children: [
                // Quantity container
                Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  width: 80.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: TextFormField(
                    controller: qtyControllers[index],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      if (originalQty.length <= index) {
                        originalQty.add(parsed);
                      } else {
                        originalQty[index] = parsed;
                      }
                      // You might want to clear % field or reset any related value here if needed
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                ),

                // Percentage container below quantity container
                if (showPercentageFields)
                  Container(
                    width: 80.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: TextFormField(
                      controller: percentageControllers[index],
                      decoration: InputDecoration(
                        hintText: '%',
                        contentPadding:
                            EdgeInsets.only(left: 5.w, bottom: 10.h),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final percent = double.tryParse(value) ?? 0.0;

                        if (originalQty.length <= index) {
                          originalQty.add(
                              double.tryParse(qtyControllers[index].text) ??
                                  0.0);
                        } else if (originalQty[index] == 0.0) {
                          originalQty[index] =
                              double.tryParse(qtyControllers[index].text) ??
                                  0.0;
                        }

                        final modified = originalQty[index] * (percent / 100);

                        // Instead of directly changing text here, consider updating qtyControllers text
                        // with a small delay or inside setState to avoid input conflicts:

                        // For example:
                        Future.microtask(() {
                          qtyControllers[index].text =
                              modified.toStringAsFixed(2);
                          qtyControllers[index].selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: qtyControllers[index].text.length),
                          );
                        });
                      },
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
              ],
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
                          width: 70.w,
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
          // Remove Row Icon
          IconButton(
            icon: Icon(Icons.cancel_outlined, color: Colors.black),
            onPressed: () {
              setState(() {
                // Find the correct form structure item to remove
                final itemIndex = formStructure.indexWhere(
                    (item) => item['type'] == 'row' && item['index'] == index);

                if (itemIndex != -1) {
                  // Remove the row data
                  sno.removeAt(index);
                  description.removeAt(index);
                  qtyControllers.removeAt(index);
                  unit.removeAt(index);
                  rateControllers.removeAt(index);
                  amountControllers.removeAt(index);

                  // Remove from form structure
                  formStructure.removeAt(itemIndex);

                  // Update indices of remaining rows
                  for (var item in formStructure) {
                    if (item['type'] == 'row' && item['index'] > index) {
                      item['index'] = item['index'] - 1;
                    }
                  }

                  rebuildRows();
                  calculateSubtotal();
                }
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
            'percentage': percentageControllers[i].text.trim(),
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
      invno.clear();
      date.clear();
      lpoqtn.clear();
      project.clear();
      nbq.clear();
      naq.clear();
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

  Widget build(BuildContext context) {
    final quotationRef = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("invoice");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        titleSpacing: 1,
        toolbarHeight: 60.h,
        title: Text(
          "Create Invoice",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        ),
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
                          "INV No",
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
                          "# LPO / QTN ",
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
                ),
                // new add button for textformfield
                SizedBox(
                  width: 30.w,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isclicked = true;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40.sp,
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
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
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
                            icon: const Icon(Icons.close)),
                        SizedBox(
                          width: 20.w,
                        ),
                        ispaymentcheck == true
                            ? Row(
                                children: [
                                  Text(
                                    "Payment Done",
                                    style: GoogleFonts.workSans(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Checkbox(
                                    value: ischeked,
                                    onChanged: (value) {
                                      setState(() {
                                        ischeked = value!;
                                      });
                                    },
                                  )
                                ],
                              )
                            : const SizedBox(),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Row(
                      children: [
                        Checkbox(
                          value: showPercentageFields,
                          onChanged: (value) {
                            setState(() {
                              showPercentageFields = value!;
                              rebuildRows();
                            });
                          },
                        ),
                        Text(
                          "% Invoice",
                          style: GoogleFonts.workSans(fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),
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
                          child: Text("Description",
                              style: TextStyle(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 440.w),
                          child: Text("qty", style: TextStyle(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60.w),
                          child:
                              Text("Unit", style: TextStyle(fontSize: 15.sp)),
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
                    padding: EdgeInsets.only(left: 5.w),
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
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Container(
                      width: 200.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                        enabled: isDiscountEnabled,
                        onChanged: (value) {
                          discount = double.tryParse(value) ?? 0.0;
                          calculateTotal();
                        },
                        maxLines: null,
                        controller: discountcontroller,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 25.h,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          prefixStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintStyle: const TextStyle(
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
                    padding: EdgeInsets.only(left: 12.w),
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
                    padding: EdgeInsets.only(left: 5.w),
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
                    padding: EdgeInsets.only(left: 5.w),
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
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
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
                        controller: naq,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
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
                          hintStyle: const TextStyle(
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
                    .collection("invoice")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();

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
                                labelText: "Select Invooice to Edit",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            // In the onChanged callback of DropdownSearch<String>:
                            // In the onChanged callback of DropdownSearch<String>:
                            onChanged: (invNo) async {
                              if (invNo == null) return;

                              final selectedId = invoiceMap[invNo];
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
                                  ispaymentcheck = true;
                                  selectedDocumentId = selectedDoc.id;
                                  selectedDocumentId = selectedDoc.id;
                                  invno.text = data['inv no'] ?? '';
                                  date.text = data['date'] ?? '';
                                  lpoqtn.text = data['lpoqtn#'] ?? '';
                                  project.text = data['project'] ?? '';
                                  nbq.text = data['note before quote'] ?? '';
                                  selectednbq = data['note before quote'] ?? '';
                                  naq.text = data['note after quote'] ?? '';
                                  //new field
                                  newfeild.text =
                                      data['newfield'] ?? 'No Data foud';
                                  //new checkbox
                                  ischeked = data['paymentdone'] ?? false;

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

                                  vat = (data['vat'] is String)
                                      ? double.tryParse(data['vat'] ?? '0') ??
                                          0.0
                                      : (data['vat']?.toDouble() ?? 0.0);

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
                                await _reserveAndIncrementinvno(
                                    _firestore, invno);
                                await quotationRef.doc(id).set({
                                  'id': id,
                                  'project': project.text,
                                  'lpoqtn#': lpoqtn.text,
                                  'date': date.text,
                                  'inv no': invno.text,
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
                                  'newfield':
                                      isclicked == true ? newfeild.text : null,
                                  'paymentdone': false
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invoice Saved'),
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
                                loadNewinvno();
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
                              collectFormData();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Invpdf(
                                    invno: invno.text,
                                    date: date.text,
                                    lpoqtn: lpoqtn.text,
                                    project: project.text,
                                    nbq: nbq.text,
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
                                    trn: widget.trn,
                                    invoiceId: '',
                                    selectedCompany: selectedCompany,
                                    // newfeild: newfeild.text,
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
                                'lpoqtn#': lpoqtn.text,
                                'date': date.text,
                                'inv no': invno.text,
                                'note before quote': nbq.text,
                                'lineItems': lineItems,
                                'subtotal': subtotal.toString(),
                                'discount': discountcontroller.text,
                                'taxable amount': taxableAmount.toString(),
                                'vat': vat.toString(),
                                'total amount': totalAmount.toString(),
                                'total amount in name': totalamountinname.text,
                                'note after quote': naq.text,
                                'newfield': newfeild.text,
                                'paymentdone': ischeked
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invoice Updated'),
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
