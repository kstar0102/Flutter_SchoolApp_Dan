import 'package:flutter/material.dart';

import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SubButtonType {
  LoginTitle,
  SchoolTitle,
  AdminTitle,
  BorrowTitle,
  UnAvailableTitle,
  FinishTitle,
  AddItemTitle,
  SchoolPageTitle
}

class SubButton extends StatefulWidget {
  final SubButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const SubButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<SubButton> createState() => _SubButtonState();
}

class _SubButtonState extends State<SubButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case SubButtonType.LoginTitle:
        btnTitle = AppLocalizations.of(context).LoginTitle;
        break;
      case SubButtonType.SchoolTitle:
        btnTitle = AppLocalizations.of(context).SchoolTitle;
        break;
      case SubButtonType.AdminTitle:
        btnTitle = AppLocalizations.of(context).AdminTitle;
        break;
      case SubButtonType.BorrowTitle:
        btnTitle = AppLocalizations.of(context).BorrowTitle;
        break;
      case SubButtonType.UnAvailableTitle:
        btnTitle = AppLocalizations.of(context).UnAvailableTitle;
        break;
      case SubButtonType.FinishTitle:
        btnTitle = AppLocalizations.of(context).FinishTitle;
        break;
      case SubButtonType.SchoolPageTitle:
        btnTitle = AppLocalizations.of(context).SchoolPageTitle;
        break;
      case SubButtonType.AddItemTitle:
        btnTitle = AppLocalizations.of(context).AddItemTitle;
        break;
      default:
        btnTitle = AppLocalizations.of(context).unknown;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: SizedBox(
            width: kTextfieldW / 2.18,
            height: kTextfieldH * 1.1,
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0XFFEFDBFE),
                // border: Border.all(
                //   width: 1,
                // ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: Color(0XFFB152E0),
              textStyle: TextStyle(
                fontFamily: 'LeyendoDEMO',
                fontWeight: FontWeight.w600,
                fontSize: 45.sp,
              ),
            ),
            onPressed: widget.onPressed,
            child: Text(btnTitle),
          ),
        ),
      ],
    );
  }
}
