import 'package:almaskan/ui/statementpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class Statement extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final int index;
  final String trn;
  const Statement(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.index,
      required this.trn});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  List<TextEditingController> amountControllers = [];
  List<TextEditingController> sno = [];
  List<String> snodata = [];
  List<String> amountdata = [];
  TextEditingController projectnames = TextEditingController();
  TextEditingController invno = TextEditingController();
  TextEditingController statno = TextEditingController();
  TextEditingController lpono = TextEditingController();
  TextEditingController project = TextEditingController();
  double totalAmount = 0.0;
  TextEditingController date = TextEditingController();
  TextEditingController kindatt = TextEditingController();
  List<Map<String, dynamic>> formStructure = [];

  TextEditingController totalamountinname = TextEditingController();
  final List<StatementRow> rows = [];
  String? selectedDocumentId;

  final List<Map<String, dynamic>> options = [
    {'label': 'Sign-1', 'id': 1},
    {'label': 'Sign-2', 'id': 2},
    {'label': 'NO Sign', 'id': 3},
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Use your client-specific path for 'statementRef' when saving the quote
// The client ID must be available in your widget's state for this
  CollectionReference get statementRef => _firestore
      .collection('Clients')
      .doc(widget
          .id) // Replace 'widget.clientId' with your actual client ID variable
      .collection('statement');
  int? selectedoption;
  String selectedCompany = 'Reyah Al Maskan';
  String? selectedCompany2;

  Future<String> previewstateNo(String company) async {
    String docName = company == "Al Maskan"
        ? "state_al_maskan"
        : company == "Reyah Al Maskan"
            ? "state_reyah"
            : "state_other";

    final docRef =
        FirebaseFirestore.instance.collection('statecounters').doc(docName);
    final snap = await docRef.get();

    final year = DateTime.now().year;
    final shortYear = year % 100;

    if (!snap.exists) return "$shortYear-01";

    int last = snap.data()?['last'] ?? 0;

    return "$shortYear-${(last + 1).toString().padLeft(2, '0')}";
  }

  Future<void> loadNextstateNo() async {
    if (selectedCompany2 == null || selectedCompany2!.isEmpty) {
      setState(() {
        statno.text = "Select Company First";
      });
      return;
    }

    final next = await previewstateNo(selectedCompany2!);
    setState(() {
      statno.text = next;
    });
  }

  int extractSequence(String stateNo) {
    try {
      // stateNo format: "25-32"
      final parts = stateNo.split("-");
      return int.tryParse(parts[1]) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  void loadStatement(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    clearForm();

    statno.text = data['statement_no'] ?? '';
    date.text = data['date'] ?? '';
    kindatt.text = data['kindatt'] ?? '';
    totalamountinname.text = data['total_amount_in_name'] ?? '';
    totalAmount = (data['total_amount'] ?? 0).toDouble();

    if (data['lineItems'] != null) {
      for (final item in data['lineItems']) {
        final row = StatementRow.fromMap(item);
        row.amount.addListener(calculateTotal);
        rows.add(row);
      }
    }

    setState(() {});
  }

  Future<String> safeCompanystateCounter(
      String company, String manualstateNo) async {
    String docName = company == "Al Maskan"
        ? "state_al_maskan"
        : company == "Reyah Al Maskan"
            ? "state_reyah"
            : "state_other";

    final docRef =
        FirebaseFirestore.instance.collection('statecounters').doc(docName);

    final year = DateTime.now().year;
    final shortYear = year % 100;

    final snap = await docRef.get();

    // ✔ FIXED LINE (no syntax error)
    int last = snap.exists ? (snap.data()?['last'] ?? 0) : 0;

    int manualSeq = extractSequence(manualstateNo);

    int newSeq = manualSeq > last ? manualSeq : last + 1;

    await docRef.set({
      'year': year,
      'last': newSeq,
      'company': company,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return "$shortYear-${newSeq.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    addRow(); // first row
  }

  void addRow() {
    setState(() {
      final row = StatementRow();

      // 🔹 Listen to amount changes
      row.amount.addListener(calculateTotal);

      rows.add(row);
    });
  }

  void removeRow(int index) {
    setState(() {
      rows[index].amount.removeListener(calculateTotal);
      rows.removeAt(index);
      calculateTotal(); // 👈 recalc after delete
    });
  }

  List<Map<String, dynamic>> buildStatementLineItems() {
    return rows
        .asMap()
        .entries
        .where((e) =>
            e.value.project.text.isNotEmpty || e.value.amount.text.isNotEmpty)
        .map((e) => e.value.toMap(e.key))
        .toList();
  }

  // void calculateTotalAmount() {
  //   double sum = 0.0;

  //   for (final row in rows) {
  //     final text = row.amount.text.trim();
  //     if (text.isNotEmpty) {
  //       final value = double.tryParse(text);
  //       if (value != null) {
  //         sum += value;
  //       }
  //     }
  //   }

  //   setState(() {
  //     totalAmount = sum;
  //   });
  //   final totalInt = totalAmount.floor(); // Dirhams
  //   final totalFils = ((totalAmount - totalInt) * 100).round(); // Fils

  //   String amountInWords =
  //       NumberToWord().convert('en-in', totalInt) + 'dirhams';

  //   if (totalFils > 0) {
  //     amountInWords +=
  //         ' and ${NumberToWord().convert('en-in', totalFils)} fils';
  //   }

  //   amountInWords += ' only';

  //   // Capitalize first letter
  //   totalamountinname.text =
  //       amountInWords[0].toUpperCase() + amountInWords.substring(1);

  //   setState(() {});
  // }
  
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
  double sum = 0.0;

  for (final row in rows) {
    final text = row.amount.text.trim();
    if (text.isNotEmpty) {
      final value = double.tryParse(text);
      if (value != null) {
        sum += value;
      }
    }
  }

  totalAmount = sum;

  // ✅ convert AFTER total is calculated
  totalamountinname.text = convertToUaeWords(totalAmount);

  setState(() {});
}


  void clearForm() {
    setState(() {
      // Clear all controllers
      for (var controller in amountControllers) controller.dispose();
      for (var controller in amountControllers) controller.dispose();
      for (var controller in sno) controller.dispose();

      // Clear all lists
      project.clear();
      lpono.clear();
      invno.clear();
      amountControllers.clear();
      sno.clear();
      projectnames.clear();
      formStructure.clear();
      rows.clear();

      // Reset other fields
      date.clear();
      kindatt.clear();
      project.clear();
      totalamountinname.clear();
      totalAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFFC62828),
        title: Text(
          "Create Satement",
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
                                  value; // 🔥 This must run BEFORE calling loadNextstateNo()
                            });

                            await loadNextstateNo(); // 🔥 state updates based on correct company
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
                          "state No",
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
                          controller: statno,
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
                          "Kindatt",
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
                          controller: kindatt,
                          textInputAction: TextInputAction.next,
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
                            hintText: '',
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
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            // Add Row Button
            Padding(
              padding: EdgeInsets.only(left: 865.w),
              child: InkWell(
                onTap: () {
                  addRow();
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
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            // Table
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
                  padding: const EdgeInsets.all(12),
                  children: [
                    headerRow(),
                    ...List.generate(rows.length, (index) {
                      return dataRow(index);
                    }),
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
                    padding: EdgeInsets.only(left: 800.w, top: 10.h),
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
                            totalAmount.toStringAsFixed(2),
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
              padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Clients")
                    .doc(widget.id)
                    .collection("statement")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  var docs = snapshot.data!.docs;
                  final statementMap = {
                    for (var doc in docs)
                      doc['statement_no']?.toString() ?? 'Unknown': doc.id
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
                              return statementMap.keys
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
                                    hintText: "Search by state No"),
                              ),
                            ),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select statement to Edit",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            // In the onChanged callback of DropdownSearch<String>:
                            // In the onChanged callback of DropdownSearch<String>:
                            onChanged: (invNo) async {
                              if (invNo == null) return;

                              final selectedId = statementMap[invNo];
                              if (selectedId == null) return;

                              final selectedDoc = docs
                                  .firstWhere((doc) => doc.id == selectedId);

                              setState(() {
                                selectedDocumentId =
                                    selectedDoc.id; // 🔥 REQUIRED
                              });

                              loadStatement(selectedDoc);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 100.w),
                          child: InkWell(
                            onTap: () async {
                              try {
                                // collectFormData();

                                final id = DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString();

                                // Generate number for this statement
                                final generated = await safeCompanystateCounter(
                                    selectedCompany2!, statno.text);
                                statno.text = generated;
                                await statementRef.doc(id).set({
                                  'id': id,
                                  'company': selectedCompany2,
                                  'statement_no': statno.text,
                                  'date': date.text,
                                  'kindatt': kindatt.text,
                                  'lineItems': buildStatementLineItems(),
                                  'total_amount': totalAmount,
                                  'total_amount_in_name':
                                      totalamountinname.text,
                                  'createdAt': FieldValue.serverTimestamp(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Quote Saved"),
                                      backgroundColor: Colors.green),
                                );

                                // 🔥 Load the NEXT statement number
                                await loadNextstateNo();
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

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => statementpdfpage(
                                    date: date.text,
                                    kindatt: kindatt.text,
                                    totalamount: totalAmount.toStringAsFixed(2),
                                    totalamountinname: totalamountinname.text,
                                    name: widget.name,
                                    address: widget.address,
                                    id: widget.id,
                                    lineItems: buildStatementLineItems(),
                                    selectedCompany: selectedCompany,
                                    option: selectedoption != null
                                        ? options.firstWhere((m) =>
                                            m['id'] == selectedoption)['label']
                                        : '',
                                    trn: widget.trn, 
                                    slno: sno.toString(),
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
                            // collectFormData();
                            try {
                              await statementRef
                                  .doc(selectedDocumentId)
                                  .update({
                                'statement_no': statno.text,
                                'date': date.text,
                                'kindatt': kindatt.text,
                                'lineItems': buildStatementLineItems(),
                                'total_amount': totalAmount,
                                'total_amount_in_name': totalamountinname.text,
                                'updatedAt': FieldValue.serverTimestamp(),
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
            ),
          ],
        ),
      ),
    );
  }

  // Table Header
  Widget headerRow() {
    return Row(
      children: [
        cell("S.No", flex: 1),
        cell("Project Name", flex: 4),
        cell("Invoice No", flex: 2),
        cell("Date", flex: 2),
        cell("LPO No", flex: 2),
        cell("Amount", flex: 2),
      ],
    );
  }

  // Table Row
  Widget dataRow(int index) {
    final row = rows[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          cellText(
            "${index + 1}",
            flex: 1,
          ),
          input(row.project, flex: 4),
          input(row.invoiceNo, flex: 2),
          input(row.date, flex: 2),
          input(row.lpo, flex: 2),
          input(row.amount, flex: 2, isNumber: true),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeRow(index),
          ),
        ],
      ),
    );
  }

  // Reusable widgets
  static Widget cell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: GoogleFonts.poppins(fontSize: 15.sp)),
    );
  }

  static Widget cellText(String text, {int flex = 1}) {
    return Expanded(
        flex: flex,
        child: Text(text, style: GoogleFonts.poppins(fontSize: 15.sp)));
  }

  static Widget input(TextEditingController controller,
      {int flex = 1, bool isNumber = false}) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class StatementRow {
  TextEditingController project = TextEditingController();
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController lpo = TextEditingController();
  TextEditingController amount = TextEditingController();

  Map<String, dynamic> toMap(int index) {
    return {
      'sno': index + 1,
      'project': project.text,
      'invoiceNo': invoiceNo.text,
      'date': date.text,
      'lpo': lpo.text,
      'amount': amount.text,
    };
  }

  static StatementRow fromMap(Map<String, dynamic> map) {
    final row = StatementRow();
    row.project.text = map['project'] ?? '';
    row.invoiceNo.text = map['invoiceNo'] ?? '';
    row.date.text = map['date'] ?? '';
    row.lpo.text = map['lpo'] ?? '';
    row.amount.text = map['amount'] ?? '';
    return row;
  }
}
