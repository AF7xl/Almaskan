import 'package:almaskan/ui/Taxinvoicepdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  String? selectedCompany2;
  bool isSaving = false;

  double vat = 0.0;
  double advance = 0.0;
  double total = 0.0;

  get index => index;

  //for new add button

  bool isclicked = false;
  final List<Map<String, dynamic>> options = [
    {'label': 'Sign-1', 'id': 1},
    {'label': 'Sign-2', 'id': 2},
    {'label': 'NO Sign', 'id': 3},
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
  Future<String> previewInvNo(String company) async {
    String docName = company == "Al Maskan"
        ? "inv_al_maskan"
        : company == "Reyah Al Maskan"
            ? "inv_reyah"
            : "inv_other";

    final docRef =
        FirebaseFirestore.instance.collection('counters2').doc(docName);
    final snap = await docRef.get();

    final year = DateTime.now().year;
    final shortYear = year % 100;

    if (!snap.exists) return "$shortYear-01";

    int last = snap.data()?['last'] ?? 0;

    return "$shortYear-${(last + 1).toString().padLeft(2, '0')}";
  }

// 1. QTN Load function (for initState)
  Future<void> loadNextInvNo() async {
    if (selectedCompany2 == null || selectedCompany2!.isEmpty) {
      setState(() {
        invno.text = "Select Company First";
      });
      return;
    }

    final next = await previewInvNo(selectedCompany2!);
    setState(() {
      invno.text = next;
    });
  }

  int extractSequence(String invNo) {
    try {
      final parts = invNo.split("-");
      if (parts.length != 2) return 0;
      return int.parse(parts[1]);
    } catch (_) {
      return 0;
    }
  }

  Future<String> safeCompanyInvCounter(
      String company, String manualInvNo) async {
    String docName = company == "Al Maskan"
        ? "inv_al_maskan"
        : company == "Reyah Al Maskan"
            ? "inv_reyah"
            : "inv_other";

    final docRef =
        FirebaseFirestore.instance.collection('counters2').doc(docName);

    final year = DateTime.now().year;
    final shortYear = year % 100;

    final snap = await docRef.get();
    int last = snap.exists ? (snap.data()?['last'] ?? 0) : 0;

    int manualSeq = extractSequence(manualInvNo);
    if (manualSeq <= 0) {
      throw Exception("Invalid Invoice Number format");
    }

    // 🔥 ALWAYS trust manual input
    int newLast = manualSeq;

    await docRef.set({
      'year': year,
      'last': newLast,
      'company': company,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 🔹 Return NEXT invoice number
    return "$shortYear-${(newLast + 1).toString().padLeft(2, '0')}";
  }

  void fetchnbqSuggestions() async {
    final docSnapshot = await nbqfirestore.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      nbqoptions = List<String>.from(data?['suggestions'] ?? []);
      setState(() {}); // Trigger rebuild so Autocomplete sees updates
    }
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

  void calculatetotal() {
    vat = advance * 0.05;
    total = advance + vat;

    // ✅ UAE format only
    totalamountinname.text = convertToUaeWords(total);

    setState(() {});
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
        titleSpacing: 1,
        toolbarHeight: 60.h,
        title: Text(
          "Create TaxInvoice",
          style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
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

                            await loadNextInvNo(); // 🔥 QTN updates based on correct company
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
                          "INV No",
                          style: GoogleFonts.poppins(
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
                        child: Text(
                          "Date",
                          style: GoogleFonts.poppins(
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
                                  DateFormat('d/MM/yyyy').format(pickedDate);
                              date.text = formattedDate;
                            }
                          },
                          cursorHeight: 25.h,
                          style: GoogleFonts.poppins(color: Colors.black),
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
                          "LPO/QTN #",
                          style: GoogleFonts.poppins(
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
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () async {
                    TextEditingController duplicateInvController =
                        TextEditingController(text: invno.text);

                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Duplicate Invoice"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Customize Invoice Number",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: duplicateInvController,
                                decoration: const InputDecoration(
                                  labelText: "Invoice Number",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text("Duplicate",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm != true) return;

                    try {
                      // collectFormData();

                      final newId =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      final customInv = duplicateInvController.text.trim();
             

                      // await safeCompanyInvCounter(selectedCompany2!, customInv);
                      await firestore.doc(newId).set({
                        'id': newId,
                        'inv no': customInv,
                        'date': date.text,
                        'payment': _controller.text.trim(),
                        'LpoQtn#': lpoqtn.text,
                        'project': project.text,
                        'note before quote': nbq.text,
                        'subtotal taxable amount': subtotalController.text,
                        'advance payment': advanceController.text,
                        'vat 5%': vat.toString(),
                        'total amount': total.toString(),
                        'total amount in name': totalamountinname.text,
                        'note after quote': naq.text,
                        'newfield': newfeild.text,
                      });

                      setState(() {
                        invno.text = customInv;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invoice duplicated successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Duplicate failed: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 80.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Colors.red[900],
                    ),
                    child: Center(
                      child: Text(
                        "Duplicate",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                          "Project:",
                          style: GoogleFonts.poppins(
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
                        child: Text(
                          "NOTE Before Quote",
                          style: GoogleFonts.poppins(
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Amount (AED)',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.sp),
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
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16.sp),
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
                        style: GoogleFonts.poppins(
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
                                  // If user types, clear selectedpaymentId (so typed value is authoritative)
                                  setState(() {
                                    selectedpaymentId = null;
                                  });

                                  // If they typed a percentage like "40%" or "40", parse it
                                  final numeric = double.tryParse(
                                      value.replaceAll(RegExp(r'[^0-9.]'), ''));
                                  if (numeric != null) {
                                    selectedPercentage = numeric;
                                    updateAdvanceAmount(); // your existing function that updates advance value
                                  } else {
                                    selectedPercentage = null;
                                    updateAdvanceAmount();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<int>(
                              underline: const SizedBox(),
                              items: paymentOptions.map((option) {
                                return DropdownMenuItem<int>(
                                  value: option['id'] as int,
                                  child: Text(option['label'] as String),
                                );
                              }).toList(),
                              onChanged: (id) {
                                final selectedOption =
                                    paymentOptions.firstWhere(
                                  (opt) => opt['id'] == id,
                                  orElse: () =>
                                      <String, dynamic>{}, // Safe fallback
                                );

                                if (selectedOption.isEmpty)
                                  return; // No matching option found

                                setState(() {
                                  selectedpaymentId = id;

                                  // Extract numeric percentage
                                  selectedPercentage = (selectedOption['value']
                                          is num)
                                      ? (selectedOption['value'] as num)
                                          .toDouble()
                                      : double.tryParse(
                                          selectedOption['value'].toString());

                                  // Update text field
                                  _controller.text =
                                      selectedOption['label'].toString();

                                  updateAdvanceAmount();
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
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 15.sp),
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
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.sp,
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
                            style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.sp,
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
                            style: GoogleFonts.poppins(
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
                        style: GoogleFonts.poppins(color: Colors.black),
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
                    style: GoogleFonts.poppins(
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
                        style: GoogleFonts.poppins(color: Colors.black),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black45,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2.h, left: 5.w, bottom: 15.h),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
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
                          width: 300.w,
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
                                newfeild.text = data['newfield'] ?? '';
                                vat =
                                    double.tryParse(data['vat 5%'] ?? '0') ?? 0;
                                total = double.tryParse(
                                        data['total amount'] ?? '0') ??
                                    0;

                                final paymentLabel = data['payment'] ?? '';

                                _controller.text =
                                    paymentLabel; // 👈 Fills TextField correctly

                                final paymentMatch = paymentOptions.firstWhere(
                                  (opt) => opt['label'] == paymentLabel,
                                  orElse: () => {},
                                );

                                if (paymentMatch.isNotEmpty) {
                                  selectedpaymentId = paymentMatch['id'];
                                  selectedPercentage = paymentMatch['value'];
                                  updateAdvanceAmount();
                                } else {
                                  // 👇 If text is custom (not in dropdown), parse it
                                  selectedpaymentId = null;

                                  // Extract numeric % if exists → "40%" or "40" etc.
                                  final numeric = double.tryParse(paymentLabel
                                      .replaceAll(RegExp(r'[^0-9]'), ''));

                                  if (numeric != null) {
                                    selectedPercentage = numeric;
                                    updateAdvanceAmount();
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (isSaving) return;
                            setState(() => isSaving = true);

                            try {
                              final id = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              final nextInv = await safeCompanyInvCounter(
                                selectedCompany2!,
                                invno.text, // 👈 whatever user typed
                              );

                              invno.text = nextInv;
                              await firestore.doc(id).set({
                                'id': id,
                                'inv no': invno.text,
                                'date': date.text,
                                'payment': _controller.text.trim(),
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
                              await loadNextInvNo();
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

                            if (selected != null) {
                              selectedCompany = selected;

                              final paymentLabel =
                                  _controller.text.trim(); // what user sees
                              final advancePercentString =
                                  selectedPercentage != null
                                      ? selectedPercentage!
                                          .toStringAsFixed(0) // "40"
                                      : (advancepercent.text.isNotEmpty
                                          ? advancepercent.text
                                          : '');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Taxinvoicepdf(
                                    invno: invno.text,
                                    date: date.text,
                                    lpoqtn: lpoqtn.text,
                                    advancepercent:
                                        advancePercentString, // numeric percent string
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
                                    payment:
                                        paymentLabel, // pass the actual label
                                    selectedCompany: selectedCompany,
                                    option: selectedoption != null
                                        ? options.firstWhere((m) =>
                                            m['id'] == selectedoption)['label']
                                        : '',
                                    newfeild: newfeild.text,
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
                                  content: const Text(
                                      'Please select a document to update'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.black54,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: const EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            }

                            try {
                              await firestore.doc(selectedDocumentId).update({
                                'inv no': invno.text,
                                'date': date.text,
                                'LpoQtn#': lpoqtn.text,
                                'payment': _controller.text.trim(),
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
                                  content: const Text('Tax Invoice Updated'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: const EdgeInsets.all(
                                      15), // only works with floating behavior
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update ${e}'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.black54,
                                  behavior: SnackBarBehavior.floating,
                                  // optional for a floating snackbar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: const EdgeInsets.all(
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
