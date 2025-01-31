import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';
import 'Statementpdf.dart';

class Statement2 extends StatefulWidget {
  final String id;
  final String id1;


  const Statement2({
    super.key,
    required this.id,
    required this.id1,
  });

  @override
  State<Statement2> createState() => _Statement2State();
}

class _Statement2State extends State<Statement2> {
  TextEditingController date = TextEditingController();
  TextEditingController kindatt = TextEditingController();
  TextEditingController amountinname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance
        .collection('Clients')
        .doc(widget.id)
        .collection('statement')
        .doc(widget.id1)
        .collection('projectstatement')
        .snapshots();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back)),
          ),
          SingleChildScrollView(
            child: Column(
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
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: TextFormField(
                              controller: date,
                              textInputAction: TextInputAction.next,
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
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "06-June-2023",
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
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: TextFormField(
                              controller: kindatt,
                              textInputAction: TextInputAction.next,
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
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Kind att",
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
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              "Total Amount In Name",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            width: 500.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: TextFormField(
                              controller: amountinname,
                              textInputAction: TextInputAction.next,
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
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 20.h),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 1050.w, top: 20.h),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.red[900],
                            padding: EdgeInsets.all(8.w),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => Statementpdf()));
                          },
                          child: Container(
                            width: 180.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.r),
                                color: Colors.red[900]),
                            child: Center(
                              child: Text(
                                "Get Statement",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
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
                  width: 600.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "Project Name",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                ),
                Container(
                  width: 150.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "Amount",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
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
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                    child: Text(
                                     snapshot.data!.docs[index]['sno'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.sp),
                                    ),
                                  )),
                            ),
                            Container(
                                width: 600.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    "G026-HALBERS EXTENSION ABU DHABI",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp),
                                  ),
                                )),
                            Container(
                                width: 150.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.docs[index]['invoice no'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp),
                                  ),
                                )),
                            Container(
                                width: 150.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.docs[index]['date'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp),
                                  ),
                                )),
                            Container(
                                width: 150.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.docs[index]['lpo no'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp),
                                  ),
                                )),
                            Container(
                                width: 150.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.docs[index]['total amount'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp),
                                  ),
                                ))
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 3.h,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  } else {
                    return SizedBox();
                  }
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Text(
                        "",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15.sp),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 600.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "TOTAL AMOUNT (AED)",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                ),
                Container(
                  width: 150.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                ),
                Container(
                  width: 150.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                ),
                Container(
                  width: 150.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                ),
                Container(
                  width: 150.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "365,451.50",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 500.w),
                  child: ElevatedButton(onPressed: () {}, child: Text("Save")),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child:
                      ElevatedButton(onPressed: () {}, child: Text("Update")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
