import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //for add textfield
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController companyno = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController emiratsid = TextEditingController();
  TextEditingController joindate = TextEditingController();
  TextEditingController visareniewdate = TextEditingController();
  TextEditingController vacationdate = TextEditingController();
  TextEditingController nationality = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.72.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 120.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150.h,
                width: 500.w,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 55.r,
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 80.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alexa Rawles',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.72.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'work',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            "Fullname",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: name,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
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
                            "Nationality",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: nationality,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            "Work",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: work,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
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
                            "Date of birth",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: dob,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            "Emirates id",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: emiratsid,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
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
                            "Join date",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: joindate,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            "Visa Reniew date",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: visareniewdate,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
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
                            "Vacation Date",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 450.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: address,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 25.h,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 2.h, left: 5.w, bottom: 15.h),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "",
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 65.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    width: 65.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
