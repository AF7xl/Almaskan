import 'package:almaskan/ui/Statementpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Toast Message.dart';
import 'Statement 1.dart';
import 'Statement2.dart';

class Statement extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String trn;

  const Statement(
      {super.key,
      required this.id,
      required this.name,
      required this.address,
      required this.trn});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  TextEditingController project = TextEditingController();
  TextEditingController totalamount = TextEditingController();
  TextEditingController projectadress = TextEditingController();
  TextEditingController invno = TextEditingController();
  bool showcontainer = false;

  int currentIndex=0;

  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }

  Widget container() {
    final firestore = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("statement");
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 100.w),
      child: Container(
        width: 700.w,
        height: 490.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "ADD Project",
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
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "Project Name",
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
                          controller: project,
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
                  padding: EdgeInsets.only(top: 10.h),
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
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: projectadress,
                          cursorColor: Colors.black,
                          minLines: 1,
                          maxLines: 2,
                        ),
                      )),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "Invoice Number (INV NO)",
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
                          controller: invno,
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
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "Total amount of the project",
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
                          controller: totalamount,
                          cursorColor: Colors.black,
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
                    {
                      final id =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      debugPrint('Generated ID: $id');
                      try {
                        await firestore.doc(id).set({
                          'id': id,
                          'project': project.text,
                          'project address': projectadress.text,
                          'invoice no': invno.text,
                          'total amount of the project': totalamount.text,
                          'amountReceived': 0,
                        });

                        ToastMessage().toastmessage(message: 'Quotation Added');
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
    final firestore = FirebaseFirestore.instance
        .collection("Clients")
        .doc(widget.id)
        .collection("statement")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
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
            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: Stack(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Stack(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          GridView.count(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                top: 25.h,
                                                left: 20.w,
                                                right: 20.w),
                                            childAspectRatio: 300.w / 100.h,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: List.generate(
                                                snapshot.data!.docs.length,
                                                (index) {
                                              return Card(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      currentIndex=index;
                                                    });
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (_) => Statement1(
                                                            project: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['project'],
                                                            id1: snapshot.data!
                                                                .docs[index].id,
                                                            id: widget.id,
                                                            amountrecieved: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'amountReceived'],
                                                            totalamount: num.parse(
                                                                snapshot.data!.docs[index]['total amount of the project']))));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black12)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 15.w),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15.h),
                                                            child: Text(
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['project'],
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5.h),
                                                            child: Text(
                                                              snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  'project address'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5.h),
                                                              child: Text(
                                                                "INV NO :${snapshot.data!.docs[index]['invoice no']}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 1100.w, top: 400.h),
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
                        ))
                      ],
                    ),
                  )
                ],
              ),
              bottomSheet: Container(
                width: double.infinity,
                height: 80.h,
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.red[900],
                      padding: EdgeInsets.all(8.w),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Statement2(
                                id: widget.id, id1: snapshot.data!.docs[currentIndex].id,
                              )));
                    },
                    child: Container(
                      width: 180.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          color: Colors.red[900]),
                      child: Center(
                        child: Text(
                          "All Statement",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }
}
