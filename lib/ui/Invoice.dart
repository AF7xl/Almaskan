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

  const invoice1({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.trn,
    this.prefillData,
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
  TextEditingController lpoqtn = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController nbq = TextEditingController();
  TextEditingController discountcontroller = TextEditingController();
  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();

  List<double> originalQty = [];
  List<double> originalAmounts = [];

  List<TextEditingController> percentageControllers = [];
  List<bool> isAmountManuallyEdited = [];

  String selectednbq = '';
  bool isVatEnabled = true;

  List<TextEditingController> headerControllers = [];
  List<Map<String, dynamic>> formStructure = [];

  String percentageMode = 'For All';
  TextEditingController globalPercentageController = TextEditingController();

  String selectedCompany = 'Reyah Al Maskan';
  bool isDiscountEnabled = false;

  double parseSafe(String input) {
    return double.tryParse(input.replaceAll(',', '').trim()) ?? 0.0;
  }

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

  @override
  void initState() {
    super.initState();
    if (widget.prefillData != null) {
      loadPrefillData(widget.prefillData!);
    }
    fetchnbqSuggestions();
    fetchdescSuggestions();
    fetchunitSuggestions();
  }

  Future<bool> doesInvNoExist(String invNo) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("invoice")
        .where('inv no', isEqualTo: invNo)
        .get();

    return snapshot.docs.isNotEmpty;
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

  double roundDecimalOnly(double value) {
    final intPart = value.floor();
    final decimal = value - intPart;

    if (decimal == 0.0)
      return value;
    else if (decimal >= 0.5)
      return intPart + 1.0;
    else
      return intPart.toDouble();
  }

  void resetQuantitiesToOriginal() {
    for (int i = 0; i < qtyControllers.length; i++) {
      final unitText = unit[i].text.trim().toLowerCase();
      final isLumpSum = unitText == 'ls' || unitText == 'l/s';

      // ✅ Only reset qty if it's not a lump sum item
      if (!isLumpSum && originalQty.length > i) {
        qtyControllers[i].text = originalQty[i].toStringAsFixed(2);
        qtyControllers[i].selection = TextSelection.fromPosition(
          TextPosition(offset: qtyControllers[i].text.length),
        );
      }

      // ✅ Always restore amount
      if (originalAmounts.length > i) {
        amountControllers[i].text = originalAmounts[i].toStringAsFixed(2);
      }

      // ✅ Clear individual % field
      if (percentageControllers.length > i) {
        percentageControllers[i].clear();
      }

      // ✅ Reset manual edit flag
      if (isAmountManuallyEdited.length > i) {
        isAmountManuallyEdited[i] = false;
      }

      // ✅ Recalculate
      calculateAmount(i);
    }

    // ✅ Reset global percentage field
    globalPercentageController.clear();
  }


  void insertRowAfter(int index) {
    setState(() {
      final rateController = TextEditingController();
      final qtyController = TextEditingController();
      final amountController = TextEditingController();
      final sn = TextEditingController();
      final desc = TextEditingController();
      final uni = TextEditingController();
      final percentageController = TextEditingController();

      rateControllers.insert(index + 1, rateController);
      qtyControllers.insert(index + 1, qtyController);
      amountControllers.insert(index + 1, amountController);
      sno.insert(index + 1, sn);
      description.insert(index + 1, desc);
      unit.insert(index + 1, uni);
      percentageControllers.insert(index + 1, percentageController);
      isAmountManuallyEdited.insert(index + 1, false);

      // Insert default quantity (0.0) into originalQty
      originalQty.insert(index + 1, 0.0);
      originalAmounts.add(0.0);

      // Add listeners
      rateController.addListener(() => calculateAmount(index + 1));
      qtyController.addListener(() {
        final parsed = double.tryParse(qtyController.text) ?? 0.0;
        originalQty[index + 1] = parsed; // update originalQty
        calculateAmount(index + 1); // trigger amount update
      });

      formStructure.insert(index + 1, {
        'type': 'row',
        'index': index + 1,
      });

      // Fix the indices for all rows
      int rowCounter = 0;
      for (var item in formStructure) {
        if (item['type'] == 'row') {
          item['index'] = rowCounter++;
        }
      }

      rebuildRows();
    });
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
        final parsedQty = double.tryParse(qty.text) ?? 0.0;
        originalQty.add(parsedQty);

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
    isAmountManuallyEdited.add(false);
    originalAmounts.add(0.0);

    rateController
        .addListener(() => calculateAmount(rateControllers.length - 1));
    qtyController
        .addListener(() => calculateAmount(rateControllers.length - 1));
  }

  void calculateAmount(int index) {
    if (index < isAmountManuallyEdited.length &&
        !isAmountManuallyEdited[index]) {
      final rate = parseSafe(rateControllers[index].text);
      final qty = parseSafe(qtyControllers[index].text);

      double amount = 0.0;
      if (rate > 0 && qty > 0) {
        amount = rate * qty;
      } else {
        amount =
            parseSafe(amountControllers[index].text); // fallback if lumpsum
      }

      amountControllers[index].text = amount.toStringAsFixed(2);

      // ✅ Store original base for %
      if (index < originalAmounts.length) {
        originalAmounts[index] = amount;
      } else {
        originalAmounts.add(amount);
      }

      calculateSubtotal();
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
    vat = isVatEnabled ? taxableAmount * 0.05 : 0.0;
    totalAmount = roundDecimalOnly(taxableAmount + vat);

    String amountInWords = convertNumberToWords(totalAmount);
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

// Helper function
  String toTitleCase(String input) {
    return input
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  List<Widget> rows = []; // List to store each row
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
                      calculateAmount(
                          index); // <-- ensure update happens here too
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 2.h, left: 5.w, bottom: 15.h),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                ),

                // Percentage field logic
                if (percentageMode == 'Individual')
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

                        double baseAmount;
                        if (index < originalAmounts.length &&
                            originalAmounts[index] > 0) {
                          baseAmount = originalAmounts[index];
                        } else {
                          baseAmount = parseSafe(amountControllers[index].text);
                          if (index < originalAmounts.length) {
                            originalAmounts[index] = baseAmount;
                          } else {
                            originalAmounts.add(baseAmount);
                          }
                        }

                        final result = baseAmount * (percent / 100);
                        amountControllers[index].text =
                            result.toStringAsFixed(2);
                        calculateSubtotal();
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
                onChanged: (value) {
                  calculateAmount(
                      index); // force re-calculation even if user types
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
                  if (index < isAmountManuallyEdited.length) {
                    isAmountManuallyEdited[index] = true;
                  }

                  // ✅ Save the manually changed amount as new original
                  final parsedAmount = double.tryParse(value) ?? 0.0;
                  if (index < originalAmounts.length) {
                    originalAmounts[index] = parsedAmount;
                  } else {
                    originalAmounts.add(parsedAmount);
                  }

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
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.green),
            tooltip: "Insert row below",
            onPressed: () {
              insertRowAfter(index);
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
            'percentage': (i < percentageControllers.length)
                ? percentageControllers[i].text.trim()
                : '',
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
      for (var controller in percentageControllers) controller.dispose();

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
      percentageControllers.clear();

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
                                  DateFormat('d/MMM/yyyy').format(pickedDate);
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
                        child: Text(
                          "NOTE Before Quote",
                          style: TextStyle(
                              fontSize: 15.sp,
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
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 25.h),
                  child: Row(
                    children: [
                      Text(
                        "% Invoice",
                        style: GoogleFonts.workSans(fontSize: 13.sp),
                      ),
                      SizedBox(width: 10.w),
                      DropdownButton<String>(
                        value: percentageMode,
                        items: ['Individual', 'For All']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            percentageMode = value!;
                            rebuildRows();
                          });
                        },
                      ),
                      if (percentageMode == 'For All')
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Container(
                            width: 80.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: TextFormField(
                              controller: globalPercentageController,
                              decoration: InputDecoration(
                                hintText: '% All',
                                contentPadding:
                                    EdgeInsets.only(left: 5.w, bottom: 10.h),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                double percent = double.tryParse(value) ?? 0.0;

                                for (int i = 0;
                                    i < amountControllers.length;
                                    i++) {
                                  double baseAmount;

                                  // Use stored original amount if available
                                  if (i < originalAmounts.length &&
                                      originalAmounts[i] > 0) {
                                    baseAmount = originalAmounts[i];
                                  } else {
                                    baseAmount =
                                        parseSafe(amountControllers[i].text);
                                    if (i < originalAmounts.length) {
                                      originalAmounts[i] = baseAmount;
                                    } else {
                                      originalAmounts.add(baseAmount);
                                    }
                                  }

                                  final result = baseAmount * (percent / 100);
                                  amountControllers[i].text =
                                      result.toStringAsFixed(2);
                                }

                                calculateSubtotal();
                              },
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          ),
                        ),
                      SizedBox(width: 10.w),
                      //cancel button
                      TextButton(
                        onPressed: () {
                          setState(() {
                            resetQuantitiesToOriginal();
                          });
                        },
                        child:
                            Text("Cancel", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 900.w),
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
                        style: TextStyle(color: Colors.black),
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
                    padding: EdgeInsets.only(left: 720.w, top: 10.h),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isVatEnabled,
                          onChanged: (value) {
                            setState(() {
                              isVatEnabled = value!;
                              calculateTotal(); // Recalculate if VAT is toggled
                            });
                          },
                        ),
                        Text(
                          "Vat 5%",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isVatEnabled)
                    Padding(
                      padding: EdgeInsets.only(left: 30.w),
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
                        controller: naq,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
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
                    .collection("invoice")
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
                                  selectedDocumentId = selectedDoc.id;
                                  selectedDocumentId = selectedDoc.id;
                                  invno.text = data['inv no'] ?? '';
                                  date.text = data['date'] ?? '';
                                  lpoqtn.text = data['lpoqtn#'] ?? '';
                                  project.text = data['project'] ?? '';
                                  nbq.text = data['note before quote'] ?? '';
                                  selectednbq = data['note before quote'] ?? '';
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
                                        final parsedQty = double.tryParse(
                                                qtyControllers[index].text) ??
                                            0.0;

                                        if (originalQty.length <= index) {
                                          originalQty.add(parsedQty);
                                        } else {
                                          originalQty[index] = parsedQty;
                                        }
                                        originalQty.add(parsedQty);

                                        unit[index].text =
                                            item['unit']?.toString() ?? '';
                                        rateControllers[index].text =
                                            item['rate']?.toString() ?? '';
                                        rateControllers[index].addListener(
                                            () => calculateAmount(index));
                                        qtyControllers[index].addListener(
                                            () => calculateAmount(index));

                                        amountControllers[index].text =
                                            item['amount']?.toString() ?? '';
                                        isAmountManuallyEdited.add(
                                            (item['rate'] == null ||
                                                    item['rate']
                                                        .toString()
                                                        .isEmpty) &&
                                                (item['quantity'] == null ||
                                                    item['quantity']
                                                        .toString()
                                                        .isEmpty));
                                      }
                                    }
                                  }
                                });

                                // Force rebuild of rows
                                rebuildRows();
                                calculateSubtotal();
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
                              final existing =
                                  await doesInvNoExist(invno.text.trim());

                              if (existing) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Duplicate INV No"),
                                    content: Text(
                                        "An invoice with INV No '${invno.text}' already exists."),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK")),
                                    ],
                                  ),
                                );
                                return; // prevent saving
                              }

                              final id = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              try {
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
                                  'note after quote': naq.text
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Invoice Saved'),
                                  backgroundColor: Colors.green,
                                ));
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Failed to save: $e'),
                                  backgroundColor: Colors.red,
                                ));
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
                                    percentageMode: percentageMode,
                                    globalPercentage:
                                        globalPercentageController.text,
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
                                'note after quote': naq.text
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
