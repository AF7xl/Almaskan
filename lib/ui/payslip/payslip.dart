import 'package:almaskan/ui/payslip/Gratuity.dart';
import 'package:almaskan/ui/payslip/PayslipMain.dart';
import 'package:almaskan/ui/payslip/leave_salary.dart';
import 'package:almaskan/ui/payslip/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Payslip extends StatefulWidget {
  const Payslip({super.key});

  @override
  State<Payslip> createState() => _PayslipState();
}

class _PayslipState extends State<Payslip> {
  //Text editing controllers
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController cno = TextEditingController();
  //
  TextEditingController nationality = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController emiratsid = TextEditingController();
  TextEditingController joindate = TextEditingController();
  TextEditingController visareniewdate = TextEditingController();
  TextEditingController vacationdate = TextEditingController();

  //firestore
  final firestore = FirebaseFirestore.instance.collection('Employee');
  final ref = FirebaseFirestore.instance.collection('Employee');
  final firestor =
      FirebaseFirestore.instance.collection('Employee').snapshots();
  //
  bool showcontainer = false;
  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }

  //container
  Widget container() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h, left: 100.w),
      child: Container(
        width: 700.w,
        height: 550.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ADD EMPLOYEE",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                  IconButton(
                      onPressed: () {
                        tooglecontainer();
                      },
                      icon: Icon(Icons.close))
                ],
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
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
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
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
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
                    "Work",
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
                          controller: work,
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
                    "Company No",
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
                          controller: cno,
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

                  final clientData = {
                    'id': id,
                    'name': name.text,
                    'address': address.text,
                    'work': work.text,
                    'Company NO': cno.text,
                    'Nationality': '',
                    'Dateofbirth': '',
                    'Emiratedid': '',
                    'joindate': '',
                    'visareniewdate': '',
                    'Vacationdate': '',
                  };

                  try {
                    // Save to Clients and Customers with the same ID

                    await FirebaseFirestore.instance
                        .collection('Employee')
                        .doc(id)
                        .set(clientData);
                    await FirebaseFirestore.instance
                        .collection('profile')
                        .doc(id)
                        .set(clientData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Employee Created'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        // optional for a floating snackbar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(
                            30), // only works with floating behavior
                      ),
                    );
                    tooglecontainer();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to Create Employee ${e}'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.black54,
                        behavior: SnackBarBehavior.floating,
                        // optional for a floating snackbar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        margin: const EdgeInsets.all(
                            30), // only works with floating behavior
                      ),
                    );
                  }

                  name.clear();
                  address.clear();
                  work.clear();
                  cno.clear();
                },
                child: Container(
                  width: 90.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      color:const Color(0xFFC62828),
                      borderRadius: BorderRadius.circular(8.r)),
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
          "Payslip Section",
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 20.sp,color: Colors.white),
        ),
        backgroundColor: const Color(0xFFC62828),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: firestor,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Text(
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
                          childAspectRatio: 378.w / 230.h,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
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
                                        style: GoogleFonts.poppins(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                            letterSpacing: 0.5),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Text(
                                        snapshot.data!.docs[index]['address'],
                                        style: GoogleFonts.poppins(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                            snapshot.data!.docs[index]
                                                ['work'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black))),
                                    Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                            "COMPANY NO : ${snapshot.data!.docs[index]['Company NO']}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black))),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 180.w),
                                          child: PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 20.sp,
                                                color: Colors.black,
                                              ),
                                              offset: const Offset(0, 40),
                                              onSelected: (value) {
                                                if (value == 'payslip') {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder:
                                                              (_) =>
                                                                  Payslipmain(
                                                                    id: snapshot
                                                                        .data!
                                                                        .docs[index]['id'],
                                                                  )));
                                                }
                                                if (value == 'leavesalary') {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder:
                                                              (_) =>
                                                                  LeaveSalary(
                                                                    id: snapshot
                                                                        .data!
                                                                        .docs[index]['id'],
                                                                  )));
                                                }
                                                if (value == 'Gratuity') {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder:
                                                              (_) => Gratuity(
                                                                    id: snapshot
                                                                        .data!
                                                                        .docs[index]['id'],
                                                                  )));
                                                }
                                                if (value == 'profile') {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (_) => Profile(
                                                          name: snapshot.data!.docs[index]
                                                              ['name'],
                                                          address: snapshot.data!.docs[index]
                                                              ['address'],
                                                          companyno: snapshot.data!.docs[index]
                                                              ['Company NO'],
                                                          work: snapshot.data!.docs[index]
                                                              ['work'],
                                                          dob: snapshot.data!.docs[index]
                                                              ['Dateofbirth'],
                                                          emirates: snapshot.data!.docs[index]
                                                              ['Emiratedid'],
                                                          joindate: snapshot.data!.docs[index]
                                                              ['joindate'],
                                                          visareniewdate: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['visareniewdate'],
                                                          vacationdate: snapshot.data!.docs[index]['Vacationdate'],
                                                          nationality: snapshot.data!.docs[index]['Nationality'],
                                                          id: snapshot.data!.docs[index]['id'])));
                                                }
                                              },
                                              itemBuilder: (context) =>
                                                  const [
                                                    PopupMenuItem(
                                                      value: 'payslip',
                                                      child: Text(
                                                          "Create Payslip"),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'leavesalary',
                                                      child: Text(
                                                          "Create Leave salary"),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'Gratuity',
                                                      child: Text(
                                                          "Create Gratuity"),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'profile',
                                                      child: Text("Profile"),
                                                    )
                                                  ]),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10.r),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .warning_amber_rounded,
                                                            color: Colors.red,
                                                            size: 24.sp),
                                                        SizedBox(width: 8.w),
                                                        Text(
                                                          "Confirm Delete",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            color: Colors
                                                                .black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: Text(
                                                      "Are you sure you want to delete this item?",
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 14.sp,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    actionsPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 5.h),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text(
                                                          "Cancel",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 14.sp,
                                                            color: Colors
                                                                .blueGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          final employeeId =
                                                              snapshot.data!
                                                                      .docs[
                                                                  index]['id'];
                            
                                                          try {
                                                            // Delete from both Employee and Profile collections
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Employee')
                                                                .doc(
                                                                    employeeId)
                                                                .delete();
                            
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'profile')
                                                                .doc(
                                                                    employeeId)
                                                                .delete();
                            
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                            
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content:
                                                                    const Text(
                                                                        'Employee Deleted Successfully from both databases'),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    Colors
                                                                        .red,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(8),
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        30),
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                            
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Failed to delete employee: $e'),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    Colors
                                                                        .black54,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(8),
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        30),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 14.sp,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: 30.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        2.r),
                                         
                                              ),
                                              child: Icon(
                                                CupertinoIcons.delete,
                                                size: 25.sp,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: InkWell(
                                            onTap: () {
                                              TextEditingController updname =
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
                                              TextEditingController updwork =
                                                  TextEditingController(
                                                      text: snapshot.data!
                                                              .docs[index]
                                                          ['work']);
                                              TextEditingController
                                                  updcompno =
                                                  TextEditingController(
                                                      text: snapshot.data!
                                                              .docs[index]
                                                          ['Company NO']);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.r)),
                                                      child: Container(
                                                        width: 700.w,
                                                        height: 550.h,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r)),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10
                                                                          .h),
                                                              child: Text(
                                                                "UPDATE EMPLOYEE",
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18.sp,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 20
                                                                          .h),
                                                                  child: Text(
                                                                    "Name",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 16
                                                                            .sp,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5.h),
                                                                  child: Container(
                                                                      width: 600.w,
                                                                      height: 50.h,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 15.w,
                                                                            right: 15.w,
                                                                            bottom: 5.h),
                                                                        child:
                                                                            TextFormField(
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          controller:
                                                                              updname,
                                                                          cursorColor:
                                                                              Colors.black,
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
                                                                  padding: EdgeInsets.only(
                                                                      top: 20
                                                                          .h),
                                                                  child: Text(
                                                                    "Address",
                                                                    style: TextStyle(
                                                                        fontSize: 16
                                                                            .sp,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5.h),
                                                                  child: Container(
                                                                      width: 600.w,
                                                                      height: 50.h,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 15.w,
                                                                            right: 15.w,
                                                                            bottom: 5.h),
                                                                        child:
                                                                            TextFormField(
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          controller:
                                                                              updaddress,
                                                                          cursorColor:
                                                                              Colors.black,
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
                                                                  padding: EdgeInsets.only(
                                                                      top: 20
                                                                          .h),
                                                                  child: Text(
                                                                    "Work",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 16
                                                                            .sp,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5.h),
                                                                  child: Container(
                                                                      width: 600.w,
                                                                      height: 50.h,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 15.w,
                                                                            right: 15.w,
                                                                            bottom: 5.h),
                                                                        child:
                                                                            TextFormField(
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          controller:
                                                                              updwork,
                                                                          cursorColor:
                                                                              Colors.black,
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
                                                                  padding: EdgeInsets.only(
                                                                      top: 20
                                                                          .h),
                                                                  child: Text(
                                                                    "Company No",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 16
                                                                            .sp,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5.h),
                                                                  child: Container(
                                                                      width: 600.w,
                                                                      height: 50.h,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), border: Border.all(color: Colors.black26)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 15.w,
                                                                            right: 15.w,
                                                                            bottom: 5.h),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              updcompno,
                                                                          cursorColor:
                                                                              Colors.black,
                                                                        ),
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 30
                                                                          .h),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  final docId = snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'id']
                                                                      .toString();
                            
                                                                  final updatedData =
                                                                      {
                                                                    'name': updname
                                                                        .text,
                                                                    'address':
                                                                        updaddress
                                                                            .text,
                                                                    'work': updwork
                                                                        .text,
                                                                    'Company NO':
                                                                        updcompno
                                                                            .text,
                                                                    'Nationality':
                                                                        '',
                                                                    'Dateofbirth':
                                                                        '',
                                                                    'Emiratedid':
                                                                        '',
                                                                    'joindate':
                                                                        '',
                                                                    'visareniewdate':
                                                                        '',
                                                                    'Vacationdate':
                                                                        '',
                                                                  };
                            
                                                                  try {
                                                                    // Update Clients
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Employee')
                                                                        .doc(
                                                                            docId)
                                                                        .update(
                                                                            updatedData);
                            
                                                                    // Update Customers using the same ID
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'profile')
                                                                        .doc(
                                                                            docId)
                                                                        .update(
                                                                            updatedData);
                            
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            const Text('Client Data Updated'),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                        behavior:
                                                                            SnackBarBehavior.floating, // optional for a floating snackbar
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            16), // only works with floating behavior
                                                                      ),
                                                                    );
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  } catch (e) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text('Update Failed ${e}'),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                        behavior:
                                                                            SnackBarBehavior.floating, // optional for a floating snackbar
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            16), // only works with floating behavior
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 90.w,
                                                                  height:
                                                                      35.h,
                                                                  decoration: BoxDecoration(
                                                                      color:const Color(0xFFC62828),
                                                                      borderRadius:
                                                                          BorderRadius.circular(8.r)),
                                                                  child:
                                                                      Center(
                                                                    child:
                                                                        Text(
                                                                      "Update",
                                                                      style: GoogleFonts.poppins(
                                                                          fontWeight:
                                                                              FontWeight.w400,
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
                                         
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                size: 25.sp,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 1200.w, top: 570.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(8.w),
              ),
              onPressed: () {
                tooglecontainer();
              },
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: const Color(0xFFC62828),
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
