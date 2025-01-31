import 'package:almaskan/ui/Statement2.dart';
import 'package:almaskan/ui/Statementpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';

class Statement1 extends StatefulWidget {
  final String project;
  final String id1;
  final String id;
  final num amountrecieved;
  final num totalamount;

  const Statement1(
      {super.key,
      required this.project,
      required this.id1,
      required this.id,
      required this.amountrecieved,
      required this.totalamount});

  @override
  State<Statement1> createState() => _Statement1State();
}

class _Statement1State extends State<Statement1> {
  final List<double> amounts = [];
  double Amount = 0.0;
  double total = 0.0;
  num pendingamout = 0.0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    calculateRecievedamount();
    calculatependingamount();
  }

  void calculatependingamount() {
    setState(() {
      pendingamout = widget.totalamount - widget.amountrecieved;
    });
    print(pendingamout);
  }

  void calculateRecievedamount() {
    setState(() {
      Amount = amounts.fold(0, (sum, amount) => sum + amount);
    });
  }

  void Amounts() {
    setState(() {
      calculateRecievedamount();
      calculatependingamount();
    });
  }

  bool showcontainer = false;

  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }

  TextEditingController sno = TextEditingController();
  TextEditingController invno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController lpono = TextEditingController();
  TextEditingController recievedamount = TextEditingController();
  TextEditingController totalamount = TextEditingController();

  Widget container() {

    final firestore = FirebaseFirestore.instance
        .collection('Clients')
        .doc(widget.id)
        .collection('statement')
        .doc(widget.id1)
        .collection('projectstatement');
    return Padding(
      padding: EdgeInsets.only(top: 100.h, left: 50.w),
      child: Container(
        width: 900.w,
        height: 300.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "Payment Recieved",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(
                              "Sno",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15.sp),
                            ),
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
                            "INV NO",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.sp),
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
                            "Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.sp),
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
                            "LPO No",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.sp),
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
                            "Recieved Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.sp),
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
                            "Total Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: TextFormField(
                                controller: sno,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextFormField(
                              controller: invno,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextFormField(
                              controller: date,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextFormField(
                              controller: lpono,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                amounts.add(double.parse(v));
                              },
                              controller: recievedamount,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextFormField(
                              controller: totalamount,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: InkWell(
                onTap: () {
                  tooglecontainer();
                },
                child: InkWell(
                  onTap: () async {
                    {
                      final id =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      debugPrint('Generated ID: $id');
                      try {
                        await firestore.doc(id).set({
                          'id': id,
                          'sno': sno.text,
                          'invoice no': invno.text,
                          'date': date.text,
                          'lpo no': lpono.text,
                          'recieved amount': recievedamount.text,
                          'total amount': totalamount.text,
                        });
                        FirebaseFirestore.instance
                            .collection('Clients')
                            .doc(widget.id)
                            .collection('statement')
                            .doc(widget.id1)
                            .update({
                          'amountReceived': widget.amountrecieved +
                              num.parse(recievedamount.text)
                        });

                        ToastMessage().toastmessage(message: 'payment Added');
                        tooglecontainer();
                      } catch (e) {
                        debugPrint('Error adding client: $e');
                        ToastMessage().toastmessage(message: e.toString());
                      }
                    }
                  },
                  child: Container(
                    width: 90.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        color: Colors.red[900],
                        borderRadius: BorderRadius.circular(2.r)),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController totalamount =
        TextEditingController(text: widget.totalamount.toString());
    final firestor = FirebaseFirestore.instance
        .collection('Clients')
        .doc(widget.id)
        .collection('statement')
        .doc(widget.id1)
        .collection('projectstatement');
    final firestore = FirebaseFirestore.instance
        .collection('Clients')
        .doc(widget.id)
        .collection('statement')
        .doc(widget.id1)
        .collection('projectstatement')
        .snapshots();
    final fire = FirebaseFirestore.instance
        .collection('Clients')
        .doc(widget.id)
        .collection('statement')
        .snapshots();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.sp),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 18.sp,
                            color: Colors.black,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Container(
                        width: 650.w,
                        height: 30.h,
                        child: Text(
                          widget.project,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: StreamBuilder<QuerySnapshot>(
                    stream: fire,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
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
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Container(
                                width: 300.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.r),
                                    border: Border.all(color: Colors.black26)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Text(
                                          "Total Amount ",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100.w,
                                                height: 50.h,
                                                child: TextFormField(
                                                  onFieldSubmitted: (v) {
                                                    setState(() {
                                                      num.parse(totalamount
                                                              .text =
                                                          snapshot
                                                              .data!
                                                              .docs[0][
                                                                  'total amount of the project']
                                                              .toString());
                                                    });
                                                    calculatependingamount();
                                                  },
                                                  controller: totalamount,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22.sp),
                                                )),
                                            Text(
                                              "Dhs",
                                              style: TextStyle(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Container(
                                width: 300.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.r),
                                    border: Border.all(color: Colors.black26)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Text(
                                          "Recieved Amount ",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 200.w,
                                                height: 50.h,
                                                child: Text(
                                                  widget.amountrecieved
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22.sp),
                                                )),
                                            Text(
                                              "Dhs",
                                              style: TextStyle(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Container(
                                width: 300.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.r),
                                    border: Border.all(color: Colors.black26)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Text(
                                          "Pending Amount ",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 200.w,
                                                height: 50.h,
                                                child: Text(
                                                  pendingamout.toString(),
                                                  style: TextStyle(
                                                      fontSize: 22.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            Text(
                                              "Dhs",
                                              style: TextStyle(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(right: 150.w, top: 20.h),
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'error',
                          style: TextStyle(color: Colors.purple),
                        );
                      }
                      if (snapshot.hasData) {
                        return Container(
                          width: 1100.w,
                          height: 460.h,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: Container(
                                        width: 50.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                          child: Text(
                                            "Sno",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text(
                                          "INV NO",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text(
                                          "LPO No",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text(
                                          "Amount Recieved",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text(
                                          "Total Amount",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 75.h),
                                child: Expanded(
                                  child: ListView.separated(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: Container(
                                                width: 50.w,
                                                height: 50.h,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['sno'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15.sp),
                                                  ),
                                                )),
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
                                                      ['invoice no'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.sp),
                                                ),
                                              )),
                                          Container(
                                              width: 150.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['date'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.sp),
                                                ),
                                              )),
                                          Container(
                                              width: 150.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['lpo no'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.sp),
                                                ),
                                              )),
                                          Container(
                                              width: 150.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['recieved amount'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.sp),
                                                ),
                                              )),
                                          Container(
                                              width: 150.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['total amount'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.sp),
                                                ),
                                              )),
                                          Container(
                                              width: 150.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Center(
                                                  child: IconButton(
                                                onPressed: () {

                                                  FirebaseFirestore.instance
                                                      .collection('Clients')
                                                      .doc(widget.id)
                                                      .collection('statement')
                                                      .doc(widget.id1)
                                                      .update({
                                                    'amountReceived': widget.amountrecieved -
                                                        num.parse(snapshot.data!.docs[index]
                                                        ['recieved amount'])
                                                  });
                                                  firestor
                                                      .doc(snapshot.data!
                                                          .docs[index]['id']
                                                          .toString())
                                                      .delete().then((onValue){ });
                                                },
                                                icon: Icon(
                                                  CupertinoIcons.delete,
                                                  size: 20.sp,
                                                  color: Colors.black,
                                                ),
                                              )))
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 3.h,
                                      );
                                    },
                                    itemCount: snapshot.data!.docs.length,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 950.w, top: 100),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.red[900],
                padding: EdgeInsets.all(8.w),
              ),
              onPressed: () {
                tooglecontainer();
              },
              child: Container(
                width: 180.w,
                height: 50.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.r),
                    color: Colors.red[900]),
                child: Center(
                  child: Text(
                    "Payment Recieved",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          if (showcontainer) container()
        ],
      ),
    );
  }
}
