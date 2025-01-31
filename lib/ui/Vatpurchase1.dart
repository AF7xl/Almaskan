import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';
import 'VatPurchase.dart';

class Vatpurchase1 extends StatefulWidget {
  const Vatpurchase1({super.key});

  @override
  State<Vatpurchase1> createState() => _Vatpurchase1State();
}

class _Vatpurchase1State extends State<Vatpurchase1> {
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  bool showcontainer = false;

  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }

  Widget container() {
    final firestore = FirebaseFirestore.instance.collection('Vatpurchase');
    return Padding(
      padding: EdgeInsets.only(top: 100.h, left: 100.w),
      child: Container(
        width: 700.w,
        height: 350.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "ADD Month",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: Colors.black),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    "Enter Month ",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Container(
                      width: 600.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          border: Border.all(color: Colors.black26)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.w, right: 15.w, bottom: 5.h),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: month,
                          cursorColor: Colors.black,
                        ),
                      )),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    "Enter Year",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Container(
                      width: 600.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          border: Border.all(color: Colors.black26)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.w, right: 15.w, bottom: 5.h),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: year,
                          cursorColor: Colors.black,
                          minLines: 1,
                          maxLines: 2,
                        ),
                      )),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: InkWell(
                onTap: () {
                  tooglecontainer();
                },
                child: InkWell(
                  onTap: () async {
                    final id = DateTime.now().microsecondsSinceEpoch.toString();
                    debugPrint('Generated ID: $id');
                    try {
                      await firestore.doc(id).set({
                        'id': id,
                        'month': month.text,
                        'year': year.text,
                        'invamount': 0,
                        'tax': 0,
                        'total': 0,
                      });
                      ToastMessage().toastmessage(message: 'Month Added');
                    } catch (e) {
                      debugPrint('Error adding client: $e');
                      ToastMessage().toastmessage(message: e.toString());
                    }
                    tooglecontainer();
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
    final firestore =
        FirebaseFirestore.instance.collection('Vatpurchase').snapshots();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
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
                        return GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 25.h, left: 20.w, right: 20.w),
                          childAspectRatio: 378.w / 202.h,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            return Card(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => Vatpurchase(
                                            id: snapshot.data!.docs[index].id,
                                            Invoiceamount: snapshot
                                                .data!.docs[index]['invamount'],
                                        Tax: snapshot
                                            .data!.docs[index]['tax'],
                                        Totalamount: snapshot
                                            .data!.docs[index]['total'], month:snapshot
                                          .data!.docs[index]['month'],
                                          )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, top: 15.h.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]['month'],
                                            style: TextStyle(
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]['year'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 26.sp),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            );
                          }),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 900.w, top: 570.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.red[900],
                padding: EdgeInsets.all(8.w),
              ),
              onPressed: () {
                tooglecontainer();
              },
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.red[900],
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 25.sp,
                    color: Colors.white,
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
