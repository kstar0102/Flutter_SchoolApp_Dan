import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:recleatapp/src/constants/app_constants.dart';
import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:recleatapp/src/widgets/gradient_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(40.h)));
final titlePadding = EdgeInsets.only(top: 80.h);
final contentPadding = EdgeInsets.symmetric(horizontal: 30.w, vertical: 80.h);
final actionsPadding = EdgeInsets.only(bottom: 70.h);
final yesTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 26.sp,
);

final btnW = 280.w;
final btnH = 84.h;

Widget _buildDialogTitle(String companyName, String tripName) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        companyName,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 46.sp,
          color: const Color(0xFF333333),
        ),
      ),
      Text(
        tripName,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 38.sp,
          color: kColorPrimaryGrey,
        ),
      ),
    ],
  );
}

// * ---------------------------------------------------------------------------
// * Show Toast Message
// * ---------------------------------------------------------------------------

void showToastMessage(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: kColorPrimaryBlue,
    textColor: Colors.white,
    fontSize: 40.sp,
  );
}
