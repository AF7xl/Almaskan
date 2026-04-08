import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSalesPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> salesData;

  const EditSalesPage({
    super.key,
    required this.docId,
    required this.salesData,
  });

  @override
  State<EditSalesPage> createState() => _EditSalesPageState();
}

class _EditSalesPageState extends State<EditSalesPage> {
  late TextEditingController customer;
  late TextEditingController invoice;
  late TextEditingController total;

  @override
  void initState() {
    super.initState();
    customer =
        TextEditingController(text: widget.salesData['Customer Name']);
    invoice =
        TextEditingController(text: widget.salesData['Invoice Number']);
    total =
        TextEditingController(text: widget.salesData['Total Amount']);
  }

  Future<void> _updateSale() async {
    await FirebaseFirestore.instance
        .collection('Sales')
        .doc(widget.docId)
        .update({
      'Customer Name': customer.text,
      'Invoice Number': invoice.text,
      'Total Amount': total.text,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
        content: Text("Receipt updated successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Receipt Voucher",style: GoogleFonts.poppins(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: customer,
              decoration: InputDecoration(labelText: "Customer Name",  labelStyle: GoogleFonts.poppins(color: Colors.black),),
            ),
            TextField(
              controller: invoice,
              decoration: InputDecoration(labelText: "Invoice Number", labelStyle: GoogleFonts.poppins(color: Colors.black)),
            ),
            TextField(
              controller: total,
              decoration: InputDecoration(labelText: "Total Amount", labelStyle: GoogleFonts.poppins(color: Colors.black)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828)),
              onPressed: _updateSale,
              child: Text("Update",  style: GoogleFonts.poppins(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
