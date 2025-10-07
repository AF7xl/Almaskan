import 'package:almaskan/ui/quotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Invoice.dart';
import 'Taxinvoice1.dart';

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
  //Text editing controllers
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController trn = TextEditingController();
  //focus nodes
  FocusNode namefocusnode = FocusNode();
  FocusNode addressfocusnode = FocusNode();
  FocusNode trnfocusnode = FocusNode();
  //firestore
  final firestore = FirebaseFirestore.instance.collection('Clients');
  final ref = FirebaseFirestore.instance.collection('Clients');
  final firestor = FirebaseFirestore.instance.collection('Clients').snapshots();
  //for container
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
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: namefocusnode,
                          controller: name,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(addressfocusnode);
                          },
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
                          focusNode: addressfocusnode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(trnfocusnode);
                          },
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
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: trnfocusnode,
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

                  final clientData = {
                    'id': id,
                    'name': name.text,
                    'address': address.text,
                    'TRN NO': trn.text,
                  };

                  try {
                    // Save to Clients and Customers with the same ID
                    await FirebaseFirestore.instance
                        .collection('Clients')
                        .doc(id)
                        .set(clientData);
                    await FirebaseFirestore.instance
                        .collection('Customers')
                        .doc(id)
                        .set(clientData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Client Created'),
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
                    tooglecontainer();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to Create Client ${e}'),
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

                  name.clear();
                  address.clear();
                  trn.clear();
                },
                child: Container(
                  width: 90.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[300],
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Text(
                          "RECENTLY",
                          style: GoogleFonts.workSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 20.w),
                    child: Row(
                      children: [
                        Container(
                          height: 60.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          child: Center(
                            child: Text(
                              "QTN no:  25-01",
                              style: GoogleFonts.workSans(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Container(
                          height: 60.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          child: Center(
                            child: Text(
                              "INV no:  25-01",
                              style: GoogleFonts.workSans(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
                    child:const Divider(),
                  ),
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
                            padding: EdgeInsets.only(
                                top: 25.h, left: 20.w, right: 20.w),
                            childAspectRatio: 378.w / 250.h,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(snapshot.data!.docs.length,
                                (index) {
                              return Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[100],
                                      borderRadius: BorderRadius.circular(4.r),
                                      border:
                                          Border.all(color: Colors.black12)),
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
                                            style: GoogleFonts.workSans(
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
                                            snapshot.data!.docs[index]
                                                ['address'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Text("United Arab Emirates",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black))),
                                        Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Text(
                                                "TRN : ${snapshot.data!.docs[index]['TRN NO']}",
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
                                                  ),
                                                  offset: const Offset(0, 40),
                                                  onSelected: (value) {
                                                    if (value == 'quote') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  Quotation2(
                                                                    id: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id,
                                                                    name: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'name'],
                                                                    address: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'address'],
                                                                    index:
                                                                        index,
                                                                  )));
                                                    }
                                                    if (value == 'invoice') {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      invoice1(
                                                                        id: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id,
                                                                        name: snapshot
                                                                            .data!
                                                                            .docs[index]['name'],
                                                                        address: snapshot
                                                                            .data!
                                                                            .docs[index]['address'],
                                                                        trn: snapshot
                                                                            .data!
                                                                            .docs[index]['TRN NO'],
                                                                        index:
                                                                            index,
                                                                      )));
                                                    }
                                                    if (value == 'taxinvoice') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  Taxinvoice1(
                                                                    id: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id,
                                                                    name: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'name'],
                                                                    address: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'address'],
                                                                    trn: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'TRN NO'],
                                                                    index:
                                                                        index,
                                                                  )));
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          child: Text(
                                                              "Create Quote"),
                                                          value: 'quote',
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text(
                                                              "Create Invoice"),
                                                          value: 'invoice',
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text(
                                                              "Create Tax Invoice"),
                                                          value: 'taxinvoice',
                                                        )
                                                      ]),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.w),
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
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        title: Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .warning_amber_rounded,
                                                                color:
                                                                    Colors.red,
                                                                size: 24.sp),
                                                            SizedBox(
                                                                width: 8.w),
                                                            Text(
                                                              "Confirm Delete",
                                                              style: TextStyle(
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
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                        actionsPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.w,
                                                                    vertical:
                                                                        5.h),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .blueGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
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
                                                            onPressed: () {
                                                              firestore
                                                                  .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]['id'])
                                                                  .delete();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Client Deleted Successfully'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  // optional for a floating snackbar
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .all(
                                                                          30), // only works with floating behavior
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp,
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
                                                    color: Colors.blueGrey[100],
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
                                                  TextEditingController updtrn =
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
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 10
                                                                              .h),
                                                                  child: Text(
                                                                    "UPDATE BENIFICIERY",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize: 18
                                                                            .sp,
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
                                                                      child:
                                                                          Text(
                                                                        "Name",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 5
                                                                              .h),
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
                                                                      padding: EdgeInsets.only(
                                                                          top: 20
                                                                              .h),
                                                                      child:
                                                                          Text(
                                                                        "Address",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 5
                                                                              .h),
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
                                                                      padding: EdgeInsets.only(
                                                                          top: 20
                                                                              .h),
                                                                      child:
                                                                          Text(
                                                                        "Tax Registration Number (TRN)",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 5
                                                                              .h),
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
                                                                              controller: updtrn,
                                                                              cursorColor: Colors.black,
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
                                                                  child:
                                                                      InkWell(
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
                                                                        'name':
                                                                            updname.text,
                                                                        'address':
                                                                            updaddress.text,
                                                                        'TRN NO':
                                                                            updtrn.text
                                                                      };

                                                                      try {
                                                                        // Update Clients
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('Clients')
                                                                            .doc(docId)
                                                                            .update(updatedData);

                                                                        // Update Customers using the same ID
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('Customers')
                                                                            .doc(docId)
                                                                            .update(updatedData);

                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text('Client Data Updated'),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            behavior:
                                                                                SnackBarBehavior.floating, // optional for a floating snackbar
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.all(16), // only works with floating behavior
                                                                          ),
                                                                        );
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      } catch (e) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text('Update Failed ${e}'),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            behavior:
                                                                                SnackBarBehavior.floating, // optional for a floating snackbar
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.all(16), // only works with floating behavior
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          90.w,
                                                                      height:
                                                                          35.h,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.blueGrey[
                                                                              300],
                                                                          borderRadius:
                                                                              BorderRadius.circular(2.r)),
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
                                                    color: Colors.blueGrey[100],
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
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(8.w),
                ),
                onPressed: () {
                  tooglecontainer();
                },
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.blueGrey[300],
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
