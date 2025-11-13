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
  final int index;

  const Taxinvoice1(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.trn,
      this.taxinvoiceid,
      required this.index});

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

  //for new add textformfiled
  TextEditingController newfeild = TextEditingController();
  TextEditingController nbq = TextEditingController();
  TextEditingController lpoqtn = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController advancepercent = TextEditingController();
  TextEditingController _controller = TextEditingController();

  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();
  final TextEditingController subtotalController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  String selectedCompany = 'Reyah Al Maskan';

  double vat = 0.0;
  double advance = 0.0;
  double total = 0.0;

  get index => index;

  //for new add button

  bool isclicked = false;
  final List<Map<String, dynamic>> options = [
    {'label': 'YES', 'id': 1},
    {'label': 'NO', 'id': 2},
  ];

  int? selectedoption;

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
        firestore.collection('counters').doc('invoice_counter');

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
        firestore.collection('counters').doc('invoice_counter');

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

  void calculatetotal() {
    vat = advance * 0.05;
    total = advance + vat;

    final totalInt = total.floor();
    final totalFils = ((total - totalInt) * 100).round();

    String amountInWords =
        NumberToWord().convert('en-in', totalInt) + 'dirhams';

    if (totalFils > 0) {
      amountInWords += ' and ${NumberToWord().convert('en-in', totalFils)}fils';
    }

    amountInWords += ' only';

    totalamountinname.text =
        amountInWords[0].toUpperCase() + amountInWords.substring(1);
  }

  @override
  void dispose() {
    // Dispose controllers when done
    subtotalController.dispose();
    advanceController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> paymentOptions = [
    {'label': '30% Advance', 'value': 30.0, 'id': 1},
    {'label': '50% Advance', 'value': 50.0, 'id': 2},
    {'label': '50% Final Payment', 'value': 50.0, 'id': 3},
    {'label': '50% Work In Progress', 'value': 50.0, 'id': 4},
    {'label': '10% Final Payment', 'value': 10.0, 'id': 5},
    {'label': '60% Work In Progress', 'value': 60.0, 'id': 6},
  ];

  double? selectedPercentage;

  void updateAdvanceAmount() {
    double subtotal = double.tryParse(subtotalController.text) ?? 0;
    double percentage = selectedPercentage ?? 0;
    double advance = (subtotal * percentage) / 100;
    advanceController.text = advance.toStringAsFixed(2);
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
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "",
                            hintStyle: const TextStyle(
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
                                  DateFormat('dMMMyyyy').format(pickedDate);
                              date.text = formattedDate;
                            }
                          },
                          cursorHeight: 25.h,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Select Date",
                            hintStyle: const TextStyle(
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
                                        padding: const EdgeInsets.symmetric(
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
                            icon: const Icon(Icons.close))
                      ],
                    ),
                  )
                : const SizedBox(),
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
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
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
                      child: const Text(
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
                        decoration: const InputDecoration(
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
                            Expanded(
                              child: TextFormField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  labelText: "Payment Method",
                                  hintText: "Select or type manually",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Optional: detect custom percentages like "40%"
                                  if (value.contains('%')) {
                                    final numeric = double.tryParse(value
                                        .replaceAll(RegExp(r'[^0-9]'), ''));
                                    if (numeric != null) {
                                      setState(() {
                                        selectedPercentage = numeric;
                                      });
                                      updateAdvanceAmount(); // 👈 call your existing amount update function
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<int>(
                              underline: const SizedBox(),
                              items: paymentOptions.map((option) {
                                return DropdownMenuItem<int>(
                                  value: option['id'],
                                  child: Text(option['label']),
                                );
                              }).toList(),
                              onChanged: (id) {
                                final selectedOption = paymentOptions
                                    .firstWhere((opt) => opt['id'] == id);
                                setState(() {
                                  selectedpaymentId = id;
                                  selectedPercentage = selectedOption['value'];
                                  _controller.text = selectedOption['label'];
                                  updateAdvanceAmount(); // 👈 fills text field
                                });
                              },
                              value: selectedpaymentId,
                            ),
                          ],
                        )
                        //  DropdownButtonFormField<int>(
                        //   hint: Text("Select Payment Method"),
                        //   items: paymentOptions.map((option) {
                        //     return DropdownMenuItem<int>(
                        //       value: option['id'],
                        //       child: Text(option['label']),
                        //     );
                        //   }).toList(),
                        //   onChanged: (id) {

                        //     var selectedOption = paymentOptions
                        //         .firstWhere((opt) => opt['id'] == id);
                        //     setState(() {
                        //       selectedpaymentId = id;
                        //       selectedPercentage = selectedOption['value'];
                        //       updateAdvanceAmount();
                        //     });
                        //   },
                        //   value: selectedpaymentId,
                        // )

                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: advanceController,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
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
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child: const SizedBox(
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
                        child: const SizedBox(
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
                            total.toString(),
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
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 725.w, top: 10.h),
                    child: Text(
                      "Sign Section ",
                      style: TextStyle(
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
                        textInputAction: TextInputAction.next,
                        controller: naq,
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
                                //new field
                                newfeild.text =
                                    data['newfield'] ?? 'No Data foud';
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
                            final id = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            var selectedPayment = paymentOptions.firstWhere(
                              (opt) => opt['id'] == selectedpaymentId,
                              orElse: () => {'label': '', 'value': 0},
                            );

                            try {
                              await _reserveAndIncrementinvno(
                                  _firestore, invno);
                              await firestore.doc(id).set({
                                'id': id,
                                'inv no': invno.text,
                                'date': date.text,
                                'payment': selectedPayment['label'],
                                'LpoQtn#': lpoqtn.text,
                                'project': project.text,
                                'note before quote': nbq.text,
                                'subtotal taxable amount':
                                    subtotalController.text,
                                'advance payment': advanceController.text,
                                'vat 5%': vat.toString(),
                                'total amount': total.toString(),
                                'total amount in name': totalamountinname.text,
                                'note after quote': naq.text,
                                'newfield': newfeild.text,
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
                                    advancepercent: advancepercent.text,
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
                                    payment: paymentOptions.firstWhere(
                                            (opt) =>
                                                opt['id'] == selectedpaymentId,
                                            orElse: () =>
                                                {'label': ''})['label'] ??
                                        '',
                                    selectedCompany: selectedCompany,
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
                                'note after quote': naq.text,
                                'newfield': newfeild.text
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
