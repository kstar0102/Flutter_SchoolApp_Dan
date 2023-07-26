import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// *
// * main colors used in app.
// *

const Color kColorPrimaryBlue = Color(0xFF0055A6);
const Color kColorPrimaryGrey = Color(0xFF808080);
const Color kColorSecondaryGrey = Color(0xFF4E4E4E);
const Color kColorAvatarBorder = Color(0xFF0055A6);

// *
// * Background
// *

const kBgDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/bg_normal.png'),
    fit: BoxFit.cover,
  ),
);

// *
// * Main Title Text
// *

final kTitleTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w800,
  fontSize: 70.sp,
  color: Colors.white,
);

final kErrorStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w500,
  fontSize: 50.sp,
);
final kEditStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w400,
  fontSize: 50.sp,
  color: Colors.black,
);

// *
// * TextInputField
// *

final kLabelStyle = TextStyle(
  fontFamily: 'LeyendoDEMO',
  fontSize: 60.sp,
  color: Colors.black,
);

final LoginHeaderLabelStyle = TextStyle(
  fontFamily: 'LeyendoDEMO',
  fontSize: 55.sp,
  color: Colors.grey[600],
);

final goodNameLabelStyle = TextStyle(
  fontFamily: 'LeyendoDEMO',
  fontSize: 45.sp,
  // fontWeight: FontWeight.bold,
  color: Colors.black,
);

final kContentPadding = EdgeInsets.symmetric(
  horizontal: 40.w,
  vertical: 10.h,
);
final kdropdownPadding = EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
const kEnableBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color.fromARGB(255, 182, 181, 181), width: 1.2),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
const kFocusBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey, width: 1.2),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

final kTextfieldW = 1000.w;
final kTextfieldH = 140.h;
