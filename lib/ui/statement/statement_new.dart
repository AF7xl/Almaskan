import 'package:almaskan/ui/statement/statement_newpddf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatementNew extends StatefulWidget {
  const StatementNew({super.key});

  @override
  State<StatementNew> createState() => _StatementNewState();
}

class _StatementNewState extends State<StatementNew> {
  List<TextEditingController> accountbalanceControllers = [];
  List<String> accountbalancetdata = [];
  TextEditingController statno = TextEditingController();
  TextEditingController projectnames = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController place = TextEditingController();
  List<TextEditingController> invoiceamount = [];
  List<TextEditingController> receivedamount = [];
  double totalAmount = 0.0;
  TextEditingController date = TextEditingController();
  List<Map<String, dynamic>> formStructure = [];

  TextEditingController totalamountinname = TextEditingController();
  final List<StatementRow> rows = [];
  String? selectedDocumentId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Use your client-specific path for 'statementRef' when saving the quote
// The client ID must be available in your widget's state for this
  CollectionReference get statementRef => _firestore.collection('Statement');
  int? selectedoption;
  String selectedCompany = 'Reyah Al Maskan';
  String? selectedCompany2;

  Future<String> previewstateNo(String company) async {
    String docName = company == "Al Maskan"
        ? "statement_al_maskan"
        : company == "Reyah Al Maskan"
            ? "statement_reyah"
            : "statemente_other";

    final docRef =
        FirebaseFirestore.instance.collection('statementcounters').doc(docName);
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
    place.text = data['place'] ?? '';
    projectnames.text = data['project'] ?? '';
    companyname.text = data['company_name'] ?? '';
    totalamountinname.text = data['total_amount_in_name'] ?? '';
    totalAmount = (data['total_amount'] ?? 0).toDouble();

    if (data['lineItems'] != null) {
      for (final item in data['lineItems']) {
        final row = StatementRow.fromMap(item);
        row.accountbalance.addListener(calculateTotal);
        rows.add(row);
      }
    }

    setState(() {});
  }

  void calculateTotal() {
    double sum = 0.0;

    for (final row in rows) {
      final text = row.accountbalance.text.trim();
      if (text.isNotEmpty) {
        final value = double.tryParse(text);
        if (value != null) {
          sum += value;
        }
      }
    }

    totalAmount = sum;

    setState(() {});
  }

  Future<String> safeCompanystateCounter(
      String company, String manualstateNo) async {
    String docName = company == "Al Maskan"
        ? "statement_al_maskan"
        : company == "Reyah Al Maskan"
            ? "statement_reyah"
            : "statement_other";

    final docRef =
        FirebaseFirestore.instance.collection('statementcounters').doc(docName);

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

      int index = rows.length;

      row.invoiceamount.addListener(() {
        calculateRowBalance(index);
      });

      row.receivedamount.addListener(() {
        calculateRowBalance(index);
      });

      row.accountbalance.addListener(calculateTotal);

      rows.add(row);
    });
  }

  void removeRow(int index) {
    setState(() {
      rows[index].accountbalance.removeListener(calculateTotal);
      rows.removeAt(index);
      calculateTotal(); // 👈 recalc after delete
    });
  }

  List<Map<String, dynamic>> buildStatementLineItems() {
    return rows
        .asMap()
        .entries
        .where((e) =>
            e.value.description.text.isNotEmpty ||
            e.value.accountbalance.text.isNotEmpty)
        .map((e) => e.value.toMap(e.key))
        .toList();
  }

  void clearForm() {
    setState(() {
      // Clear all lists
      projectnames.clear();
      statno.clear();
      companyname.clear();
      place.clear();

      projectnames.clear();
      formStructure.clear();
      rows.clear();

      // Reset other fields
      date.clear();

      totalamountinname.clear();
      totalAmount = 0.0;
    });
  }

  void calculateRowBalance(int index) {
    final row = rows[index];

    double invoice = double.tryParse(row.invoiceamount.text) ?? 0;
    double received = double.tryParse(row.receivedamount.text) ?? 0;

    double balance = invoice - received;

    row.accountbalance.text = balance.toStringAsFixed(2);

    calculateTotal(); // update total also
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "Statement Section",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 20.sp,
              color: Colors.white),
        ),
        backgroundColor: const Color(0xFFC62828),
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
                          "State no",
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
                          "Place",
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
                          controller: place,
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
                          "Project",
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
                          controller: projectnames,
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
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Company name",
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
                          controller: companyname,
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
              padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Statement")
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
                                  'company_name': companyname.text,
                                  'place': place.text,
                                  'project': projectnames.text,
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
                                    builder: (context) => StatementNewpddf(
                                          date: date.text,
                                          totalamount:
                                              totalAmount.toStringAsFixed(2),
                                          lineItems: buildStatementLineItems(),
                                          selectedCompany: selectedCompany,
                                          project: projectnames.text,
                                          companyname: companyname.text,
                                          place: place.text,
                                        )),
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
                                'company_name': companyname.text,
                                'place': place.text,
                                'project': projectnames.text,
                                'lineItems': buildStatementLineItems(),
                                'total_amount': totalAmount,
                                'total_amount_in_name': totalamountinname.text,
                                'createdAt': FieldValue.serverTimestamp(),
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
        cell("Date", flex: 2),
        cell("Description", flex: 4),
        cell("Invoice Amount", flex: 2),
        cell("Received Amount", flex: 2),
        cell("Account Balance", flex: 2),
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
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.date,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  row.date.text = DateFormat('d/MM/yyyy').format(pickedDate);
                }
              },
            ),
          ),
          input(row.description, flex: 4),
          input(row.invoiceamount, flex: 2),
          input(row.receivedamount, flex: 2),
          input(row.accountbalance, flex: 2, isNumber: true, readOnly: true),
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
      {int flex = 1, bool isNumber = false, bool readOnly = false}) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
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
  TextEditingController description = TextEditingController();
  TextEditingController invoiceamount = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController receivedamount = TextEditingController();
  TextEditingController accountbalance = TextEditingController();

  Map<String, dynamic> toMap(int index) {
    return {
      'description': description.text,
      'invoiceamount': invoiceamount.text,
      'date': date.text,
      'receivedamount': receivedamount.text,
      'accountbalance': accountbalance.text,
    };
  }

  static StatementRow fromMap(Map<String, dynamic> map) {
    final row = StatementRow();
    row.description.text = map['description'] ?? '';
    row.invoiceamount.text = map['invoiceamount'] ?? '';
    row.date.text = map['date'] ?? '';
    row.receivedamount.text = map['receivedamount'] ?? '';
    row.accountbalance.text = map['accountbalance'] ?? '';
    return row;
  }
}
