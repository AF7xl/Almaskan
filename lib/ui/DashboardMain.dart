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
  final counter = FirebaseFirestore.instance.collection('counters').snapshots();
  final counter2 =
      FirebaseFirestore.instance.collection('counters2').snapshots();
  //for container
  bool showcontainer = false;
  void tooglecontainer() {
    setState(() {
      showcontainer = !showcontainer;
    });
  }
Future<String> getLatestCompanyCounter(String docName) async {
  final ref = FirebaseFirestore.instance.collection("counters").doc(docName);

  final snap = await ref.get();
  if (!snap.exists) return "00-00";

  final int year = snap.data()?["year"] ?? DateTime.now().year;
  final int last = snap.data()?["last"] ?? 0;

  final String shortYear = year.toString().substring(2);

  // If last == 0, means no quotation created yet
  if (last == 0) return "00-00";

  return "$shortYear-${last.toString().padLeft(2, '0')}";
}
Future<String> getLatestCompanyCounter2(String docName) async {
  final ref = FirebaseFirestore.instance.collection("counters2").doc(docName);

  final snap = await ref.get();
  if (!snap.exists) return "00-00";

  final int year = snap.data()?["year"] ?? DateTime.now().year;
  final int last = snap.data()?["last"] ?? 0;

  final String shortYear = year.toString().substring(2);

  // If last == 0, means no quotation created yet
  if (last == 0) return "00-00";

  return "$shortYear-${last.toString().padLeft(2, '0')}";
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
                style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
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
                        content: const Text('Client Created'),
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
                        content: Text('Failed to Create Client ${e}'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.black54,
                        behavior: SnackBarBehavior.floating,
                        // optional for a floating snackbar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(
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
                      color: Color(0xFFC62828),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Center(
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(
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
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  //new table

                  FutureBuilder(
                    future: Future.wait([
                      getLatestCompanyCounter("qtn_al_maskan"),
                      getLatestCompanyCounter("qtn_reyah"),
                      getLatestCompanyCounter2("inv_al_maskan"),
                      getLatestCompanyCounter2("inv_reyah"),
                    ]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final qtnAlMaskan = snapshot.data![0];
                      final qtnReyah = snapshot.data![1];
                      final invAlMaskan = snapshot.data![2];
                      final invReyah = snapshot.data![3];

                      return Padding(
                        padding: EdgeInsets.only(
                            top: 15.h, left: 20.w, right: 150.w),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey,
                            width: 1,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Color(0xFFC62828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  topRight: Radius.circular(8.r),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Company Name',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16.sp)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('QTN No',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16.sp)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('INV No',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16.sp)),
                                ),
                              ],
                            ),

                            // Row — Al Maskan
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Al Maskan",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(qtnAlMaskan,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(invAlMaskan,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                              ),
                            ]),

                            // Row — Reyah Al Maskan
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Reyah Al Maskan",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(qtnReyah,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(invReyah,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                              ),
                            ]),
                          ],
                        ),
                      );
                    },
                  ),

                  
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: const Divider(),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: firestor,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                            childAspectRatio: 378.w / 250.h,
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
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder:
                                                                (_) =>
                                                                    Quotation2(
                                                                      id: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id,
                                                                      name: snapshot
                                                                          .data!
                                                                          .docs[index]['name'],
                                                                      address: snapshot
                                                                          .data!
                                                                          .docs[index]['address'],
                                                                      index:
                                                                          index,
                                                                    )));
                                                  }
                                                  if (value == 'invoice') {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder:
                                                                (_) => invoice1(
                                                                      id: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
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
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder:
                                                                (_) =>
                                                                    Taxinvoice1(
                                                                      id: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
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
                                                },
                                                itemBuilder: (context) =>
                                                    const [
                                                      PopupMenuItem(
                                                        value: 'quote',
                                                        child: Text(
                                                            "Create Quote"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 'invoice',
                                                        child: Text(
                                                            "Create Invoice"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 'taxinvoice',
                                                        child: Text(
                                                            "Create Tax Invoice"),
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
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .black54),
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
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                                content: const Text(
                                                                    'Client Deleted Successfully'),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    Colors.red,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                // optional for a floating snackbar
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                margin: const EdgeInsets
                                                                    .all(
                                                                    30), // only works with floating behavior
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            "Delete",
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                TextEditingController updtrn =
                                                    TextEditingController(
                                                        text: snapshot.data!
                                                                .docs[index]
                                                            ['TRN NO']);
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
                                                                      "Tax Registration Number (TRN)",
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
                                                                                updtrn,
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
                                                                      'TRN NO':
                                                                          updtrn
                                                                              .text
                                                                    };

                                                                    try {
                                                                      // Update Clients
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Clients')
                                                                          .doc(
                                                                              docId)
                                                                          .update(
                                                                              updatedData);

                                                                      // Update Customers using the same ID
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Customers')
                                                                          .doc(
                                                                              docId)
                                                                          .update(
                                                                              updatedData);

                                                                      ScaffoldMessenger.of(
                                                                              context)
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          margin:
                                                                              EdgeInsets.all(16), // only works with floating behavior
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
                                                                              Duration(seconds: 2),
                                                                          backgroundColor:
                                                                              Colors.green,
                                                                          behavior:
                                                                              SnackBarBehavior.floating, // optional for a floating snackbar
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          margin:
                                                                              EdgeInsets.all(16), // only works with floating behavior
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
                                                                        color: Color(
                                                                            0xFFC62828),
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
                        } else
                          return SizedBox();
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 930.w, top: 620.h),
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
        ));
  }
}
