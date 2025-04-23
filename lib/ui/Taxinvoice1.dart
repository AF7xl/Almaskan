import 'package:almaskan/ui/Taxinvoicepdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';
import 'Invpdf.dart';

class Taxinvoice1 extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String trn;

  const Taxinvoice1(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.trn});

  @override
  State<Taxinvoice1> createState() => _Taxinvoice1State();
}

class _Taxinvoice1State extends State<Taxinvoice1> {
  final List<String> nbqoptions = [
    'With refer to your enquiry for the above project, please find below our best quote for supply and Installation of gypsum  work  as per the drawing.',
    'With refer to your enquiry for the above project, please find below our best quote for supply and Installation of gypsum work  as per Site discussion.',
    'With refer to your enquiry for the above project, please find below our best quote for material '
  ];
  String selectednbq = '';
  TextEditingController invno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController kindatt = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController advancepercent = TextEditingController();
  TextEditingController nbq = TextEditingController();

  TextEditingController totalamountinname = TextEditingController();
  TextEditingController naq = TextEditingController();
  final TextEditingController subtotalController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();

  double vat = 0.0;
  double advance = 0.0;
  double total = 0.0;

  get index => 0;

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
  }

  void calculatetotal() {
    vat = advance * 0.05;
    total = advance + vat;
  }

  @override
  void dispose() {
    // Dispose controllers when done
    subtotalController.dispose();
    advanceController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("Taxinvoice");
    final firestor = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("Taxinvoice").snapshots();
    return Scaffold(
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
                          style: TextStyle(color: Colors.black45),
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
                          textInputAction: TextInputAction.next,
                          controller: date,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
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
                          "Kind Att:",
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
                          controller: kindatt,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
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
                  padding: EdgeInsets.only(left: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Advance % :",
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
                          controller: advancepercent,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 25.h,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 2.h, left: 5.w, bottom: 15.h),
                            border: InputBorder.none,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "  ",
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
                          style: TextStyle(color: Colors.black45),
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
                          "NOTE Before Quote",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 790.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return nbqoptions.where((String option) {
                              return option.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (String selection) {
                            nbq.text = selection;
                            selectednbq = selection;
                          },
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback) {
                            return TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: textEditingController,
                              focusNode: focusNode,
                              maxLines: null,
                              onFieldSubmitted: (v) {
                                setState(() {
                                  selectednbq = v;
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
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            );
                          },
                        ),
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
                      child: Text(
                        'Advance Payment',
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
                        controller: advanceController,
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
                      width: 790.w,
                      height: 40.h,
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
                      width: 790.w,
                      height: 40.h,
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
                        style: TextStyle(color: Colors.black45),
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
              padding: EdgeInsets.only(top: 25.h),
              child: StreamBuilder<QuerySnapshot>(
                stream: null,
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 500.w),
                        child: ElevatedButton(
                            onPressed: () async {
                              {
                                final id = DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString();
                                debugPrint('Generated ID: $id');
                                try {
                                  await firestore.doc(id).set({
                                    'id': id,
                                    'inv no': invno.text,
                                    'date': date.text,
                                    'kindatt': kindatt.text,
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
                                  ToastMessage()
                                      .toastmessage(message: 'Taxinvoice Added');
                                } catch (e) {
                                  debugPrint('Error adding client: $e');
                                  ToastMessage()
                                      .toastmessage(message: e.toString());
                                }
                              }
                            },
                            child: Text("Save")),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Taxinvoicepdf(
                                          invno: invno.text,
                                          date: date.text,
                                          kindatt: kindatt.text,
                                          advancepercent: advancepercent.text,
                                          project: project.text,
                                          nbq: nbq.text,
                                          subtotal: subtotalController.text,
                                          advance: advanceController.text,
                                          vat: vat.toString(),
                                          totalamount: total.toString(),
                                          totalamountinname: totalamountinname.text,
                                          naq: naq.text,
                                          name: widget.name,
                                          address: widget.address,
                                          trn: widget.trn,
                                        )),
                              );
                            },
                            child: Text("Preview")),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: ElevatedButton(
                            onPressed: () {
                              firestore.doc(snapshot.data!.docs[index]['id'].toString()).update(
                                  {
                                    'inv no': invno.text,
                                    'date': date.text,
                                    'kindatt': kindatt.text,
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
                            },
                            child: Text("Update")),
                      ),
                    ],
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
