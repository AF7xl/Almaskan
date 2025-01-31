import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';

class Vatpurchase extends StatefulWidget {
  final String id;
  final num Invoiceamount;
  final num Tax;
  final num Totalamount;
  final String month;

  const Vatpurchase({
    super.key,
    required this.id,
    required this.Invoiceamount,
    required this.Tax,
    required this.Totalamount,
    required this.month,
  });

  @override
  State<Vatpurchase> createState() => _VatpurchaseState();
}

class _VatpurchaseState extends State<Vatpurchase> {
  TextEditingController date1=TextEditingController();
  TextEditingController invoiceno1=TextEditingController();
  TextEditingController suppler1=TextEditingController();
  TextEditingController project1=TextEditingController();
  TextEditingController invamt1=TextEditingController();
  TextEditingController tax1=TextEditingController();
  TextEditingController totalamount1=TextEditingController();
  final List<double> invamount = [];
  final List<double> tax = [];
  final List<double> total = [];
  double Invamount = 0.0;
  double Tax = 0.0;
  double Total = 0.0;

  @override
  void initState() {
    super.initState();

    calculateAmount();
  }

  void calculateAmount() {
    setState(() {
      Invamount = invamount.fold(0, (sum, invamount) => sum + invamount);
      Tax = tax.fold(0, (sum, tax) => sum + tax);
      Total = total.fold(0, (sum, total) => sum + total);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance
        .collection('Vatpurchase')
        .doc(widget.id)
        .collection('vatpurchase');
    final firestor = FirebaseFirestore.instance
        .collection('Vatpurchase')
        .doc(widget.id)
        .collection('vatpurchase')
        .snapshots();
    TextEditingController date = TextEditingController();
    TextEditingController invoiceno = TextEditingController();
    TextEditingController supplier = TextEditingController();
    TextEditingController project = TextEditingController();
    TextEditingController invoiceamount = TextEditingController();
    TextEditingController taxcontroller = TextEditingController();
    TextEditingController totalamountcontroller = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25.sp,
                        color: Colors.black,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 600.w),
                  child: Text(
                    widget.month,
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 300.w,
                  height: double.infinity.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: date,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "INV No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: invoiceno,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "SUPPLIER",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: supplier,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "PROJECT",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: project,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "INV AMOUNT",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                onFieldSubmitted: (v) {
                                  invamount.add(double.parse(v));
                                },
                                textInputAction: TextInputAction.next,
                                controller: invoiceamount,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "Tax 5%",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                onFieldSubmitted: (v) {
                                  tax.add(double.parse(v));
                                },
                                textInputAction: TextInputAction.next,
                                controller: taxcontroller,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "TOTAL AMOUNT",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 250.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(color: Colors.black)),
                              child: TextFormField(
                                onFieldSubmitted: (v) {
                                  total.add(double.parse(v));
                                },
                                textInputAction: TextInputAction.next,
                                controller: totalamountcontroller,
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
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 80.w, top: 10.h),
                        child: InkWell(
                          onTap: () async {
                            final id = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            debugPrint('Generated ID: $id');
                            try {
                              await firestore.doc(id).set({
                                'id': id,
                                'date': date.text,
                                'invoiceno': invoiceno.text,
                                'Supplier': supplier.text,
                                'project': project.text,
                                'invoiceamount': invoiceamount.text,
                                'tax': taxcontroller.text,
                                'totalamount': totalamountcontroller.text
                              });
                              FirebaseFirestore.instance
                                  .collection('Vatpurchase')
                                  .doc(widget.id)
                                  .update({
                                'invamount': widget.Invoiceamount +
                                    num.parse(invoiceamount.text),
                                'tax':
                                    widget.Tax + num.parse(taxcontroller.text),
                                'total': widget.Totalamount +
                                    num.parse(totalamountcontroller.text)
                              });
                              ToastMessage()
                                  .toastmessage(message: 'Client Added');
                            } catch (e) {
                              debugPrint('Error adding client: $e');
                              ToastMessage()
                                  .toastmessage(message: e.toString());
                            }
                          },
                          child: Container(
                            width: 120.w,
                            height: 40.h,
                            color: Colors.red[900],
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 980.w,
                  height: 750.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 120.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 160.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Inv NO.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 168.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Supplier",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 150.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Project",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 110.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Inv Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 90.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Tax 5%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 120.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 60.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(),
                          )
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestor,
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Text(
                                        'error',
                                        style: TextStyle(color: Colors.purple),
                                      );
                                    }
                                    if (snapshot.hasData) {
                                      return Row(
                                        children: [
                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['date'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 160.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['invoiceno'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 168.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['Supplier'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['project'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 110.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['invoiceamount'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 90.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['tax'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['totalamount'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 60.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: IconButton(
                                                onPressed: (){
                                                  {
                                                    TextEditingController
                                                    upddate =
                                                    TextEditingController(
                                                        text: snapshot
                                                            .data!
                                                            .docs[index]
                                                        ['date']);
                                                    TextEditingController
                                                    updinvoiceno =
                                                    TextEditingController(
                                                        text: snapshot
                                                            .data!
                                                            .docs[index]
                                                        [
                                                        'invoiceno']);
                                                    TextEditingController
                                                    updSupplier =
                                                    TextEditingController(
                                                        text: snapshot
                                                            .data!
                                                            .docs[index]
                                                        [
                                                        'Supplier']);
                                                    TextEditingController

                                                    updproject =
                                                    TextEditingController(
                                                        text: snapshot
                                                            .data!
                                                            .docs[index]
                                                        [
                                                        'project']);
                                                   TextEditingController updinvoiceamount =
                                                        TextEditingController(
                                                            text: snapshot
                                                                .data!
                                                                .docs[index]
                                                            [
                                                            'invoiceamount']);
                                                    TextEditingController
                                                    updtax =
                                                    TextEditingController(
                                                        text: snapshot
                                                            .data!
                                                            .docs[
                                                        index]['tax']);
                                                    TextEditingController
                                                    updtotalamount =
                                                    TextEditingController(
                                                        text: snapshot
                                                            .data!
                                                            .docs[index]
                                                        [
                                                        'totalamount']);
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                        context) {
                                                          return Dialog(
                                                            shape:
                                                            RoundedRectangleBorder(),
                                                            child:
                                                            Container(
                                                              width: 1100.w,
                                                              height: 200.h,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      5.r)),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    "Update",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.w600,
                                                                        fontSize: 18.sp),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                    child:
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width: 150.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: upddate,
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width: 190.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updinvoiceno,
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width: 180.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updSupplier,
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width: 130.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updproject,
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width: 110.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updinvoiceamount,
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width: 150.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updtax,
                                                                              )),
                                                                        ), Container(
                                                                          width: 150.w,
                                                                          height: 50.h,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                          child: Center(
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updtotalamount,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                    EdgeInsets.only(top: 30.h),
                                                                    child:
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        firestore.doc(snapshot.data!.docs[index]['id'].toString()).update({
                                                                          'date': upddate.text,
                                                                          'invoiceno': updinvoiceno.text,
                                                                          'Supplier': updSupplier.text,
                                                                          'project': updproject.text,
                                                                          'invoiceamount': updinvoiceamount.text,
                                                                          'tax': updtax.text,
                                                                          'totalamount': updtotalamount.text
                                                                        });
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        width:
                                                                        120.w,
                                                                        height:
                                                                        40.h,
                                                                        color:
                                                                        Colors.red[900],
                                                                        child:
                                                                        Center(
                                                                          child: Text(
                                                                            "Update",
                                                                            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }
                                                },
                                                icon: Icon(Icons.edit),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  });
                            }),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 120.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 160.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "TOTAL",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 168.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 150.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 110.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                widget.Invoiceamount.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 90.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                widget.Tax.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 120.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                widget.Totalamount.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Container(
                            width: 60.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
