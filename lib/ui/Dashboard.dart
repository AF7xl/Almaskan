import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';
import 'Dashboard2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController trn = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('Clients');
  final ref = FirebaseFirestore.instance.collection('Clients');
  final firestor = FirebaseFirestore.instance.collection('Clients').snapshots();
  bool showcontainer = false;

  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }

  Widget container() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h, left: 100.w),
      child: Container(
        width: 700.w,
        height: 450.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "ADD BENIFICIERY",
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
                    "Name",
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
                        child: TextFormField(textInputAction: TextInputAction.next,
                          controller: name,
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
                    "Address",
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
                        child: TextFormField(textInputAction: TextInputAction.next,
                          controller: address,
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
                    "Tax Registration Number (TRN)",
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
                        child: TextFormField(textInputAction: TextInputAction.next,
                          controller: trn,
                          cursorColor: Colors.black,
                        ),
                      )),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: InkWell(
                onTap: () async {
                  final id = DateTime.now().microsecondsSinceEpoch.toString();
                  debugPrint('Generated ID: $id');
                  try {
                    await firestore.doc(id).set({
                      'id': id,
                      'name': name.text,
                      'address': address.text,
                      'TRN NO': trn.text,
                    });
                    ToastMessage().toastmessage(message: 'Client Added');
                    tooglecontainer();
                  } catch (e) {
                    debugPrint('Error adding client: $e');
                    ToastMessage().toastmessage(message: e.toString());
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
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: firestor,
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
                        padding:
                            EdgeInsets.only(top: 25.h, left: 20.w, right: 20.w),
                        childAspectRatio: 378.w / 202.h,
                        physics: NeverScrollableScrollPhysics(),
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                          return Card(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Dashboard2(
                                          id: snapshot.data!.docs[index].id,
                                          name: snapshot.data!.docs[index]
                                              ['name'],
                                          address: snapshot.data!.docs[index]
                                              ['address'],
                                          trn: snapshot.data!.docs[index]
                                              ['TRN NO'],
                                        )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: Colors.black12)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.h),
                                        child: Text(
                                          snapshot.data!.docs[index]['name'],
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Text(
                                          snapshot.data!.docs[index]['address'],
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Text(
                                            "United Arab Emirates",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Text(
                                            "TRN : ${snapshot.data!.docs[index]['TRN NO']}",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          )),
                                      Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 5.h),
                                              child: Container(
                                                width: 100.w,
                                                height: 25.h,
                                                child: Text(
                                                  "Projects : 1533",
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black),
                                                ),
                                              )),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 110.w),
                                                child: InkWell(
                                                  onTap: () {

                                                    firestore
                                                        .doc(snapshot.data!
                                                            .docs[index]['id'])
                                                        .delete();
                                                  },
                                                  child: Container(
                                                    width: 30.w,
                                                    height: 30.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.r),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(
                                                      CupertinoIcons.delete,
                                                      size: 25.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.w),
                                                child: InkWell(
                                                  onTap: () {
                                                    TextEditingController
                                                        updname =
                                                        TextEditingController(
                                                            text: snapshot.data!
                                                                    .docs[index]
                                                                ['name']);
                                                    TextEditingController
                                                        updaddress =
                                                        TextEditingController(
                                                            text: snapshot.data!
                                                                    .docs[index]
                                                                ['address']);
                                                    TextEditingController
                                                        updtrn =
                                                        TextEditingController(
                                                            text: snapshot.data!
                                                                    .docs[index]
                                                                ['TRN NO']);
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.r)),
                                                            child: Container(
                                                              width: 700.w,
                                                              height: 450.h,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.r)),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 10
                                                                            .h),
                                                                    child: Text(
                                                                      "UPDATE BENIFICIERY",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize: 18
                                                                              .sp,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 20.h),
                                                                        child:
                                                                            Text(
                                                                          "Name",
                                                                          style: TextStyle(
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5.h),
                                                                        child: Container(
                                                                            width: 600.w,
                                                                            height: 50.h,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updname,
                                                                                cursorColor: Colors.black,
                                                                              ),
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 20.h),
                                                                        child:
                                                                            Text(
                                                                          "Address",
                                                                          style: TextStyle(
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5.h),
                                                                        child: Container(
                                                                            width: 600.w,
                                                                            height: 50.h,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
                                                                              child: TextFormField(
                                                                                textInputAction: TextInputAction.next,
                                                                                controller: updaddress,
                                                                                cursorColor: Colors.black,
                                                                              ),
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 20.h),
                                                                        child:
                                                                            Text(
                                                                          "Tax Registration Number (TRN)",
                                                                          style: TextStyle(
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5.h),
                                                                        child: Container(
                                                                            width: 600.w,
                                                                            height: 50.h,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
                                                                              child: TextFormField(
                                                                                controller: updtrn,
                                                                                cursorColor: Colors.black,
                                                                              ),
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 30
                                                                            .h),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        firestore
                                                                            .doc(snapshot.data!.docs[index]['id']
                                                                                .toString())
                                                                            .update({
                                                                          'name':
                                                                              updname.text,
                                                                          'address':
                                                                              updaddress.text,
                                                                          'TRN NO':
                                                                              updtrn.text
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            90.w,
                                                                        height:
                                                                            35.h,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red[900],
                                                                            borderRadius: BorderRadius.circular(2.r)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Update",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12.sp,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    width: 30.w,
                                                    height: 30.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.r),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 25.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    } else
                      return SizedBox();
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
    ));
  }
}
