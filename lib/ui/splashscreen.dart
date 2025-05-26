import 'package:almaskan/ui/home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const home()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 180.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 200.w),
                  child: SizedBox(
                      width: 300.w,
                      height: 300.h,
                      child: Image.asset("assets/Logo.png")),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REYAH AL MASKAN",
                      style: GoogleFonts.workSans(
                          fontWeight: FontWeight.w700, fontSize: 60.sp),
                    ),
                    Text("THECNICAL SERVICES L.L.C",
                        style: GoogleFonts.workSans(
                            fontSize: 40.sp, fontWeight: FontWeight.w500))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
