import 'package:flutter/material.dart';

import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum LoginButtonType {
  LoginTitle,
  SchoolTitle,
  AdminTitle,
  BorrowTitle,
  UnAvailableTitle,
  FinishTitle,
  AddItemTitle,
  SchoolPageTitle
}

class LoginButton extends StatefulWidget {
  final LoginButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case LoginButtonType.LoginTitle:
        btnTitle = AppLocalizations.of(context).LoginTitle;
        break;
      case LoginButtonType.SchoolTitle:
        btnTitle = AppLocalizations.of(context).SchoolTitle;
        break;
      case LoginButtonType.AdminTitle:
        btnTitle = AppLocalizations.of(context).AdminTitle;
        break;
      case LoginButtonType.BorrowTitle:
        btnTitle = AppLocalizations.of(context).BorrowTitle;
        break;
      case LoginButtonType.UnAvailableTitle:
        btnTitle = AppLocalizations.of(context).UnAvailableTitle;
        break;
      case LoginButtonType.FinishTitle:
        btnTitle = AppLocalizations.of(context).FinishTitle;
        break;
      case LoginButtonType.SchoolPageTitle:
        btnTitle = AppLocalizations.of(context).SchoolPageTitle;
        break;
      case LoginButtonType.AddItemTitle:
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
            width: kTextfieldW / 1.05,
            height: kTextfieldH * 1.3,
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0XFFB152E0),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: Color.fromARGB(255, 233, 232, 232),
              textStyle: TextStyle(
                fontFamily: 'LeyendoDEMO',
                fontWeight: FontWeight.w600,
                fontSize: 70.sp,
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
