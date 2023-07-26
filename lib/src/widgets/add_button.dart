import 'package:flutter/material.dart';

import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AddButtonType {
  LoginTitle,
  SchoolTitle,
  AdminTitle,
  BorrowTitle,
  UnAvailableTitle,
  FinishTitle,
  AddItemTitle,
  SchoolPageTitle
}

class AddButton extends StatefulWidget {
  final AddButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AddButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case AddButtonType.LoginTitle:
        btnTitle = AppLocalizations.of(context).LoginTitle;
        break;
      case AddButtonType.SchoolTitle:
        btnTitle = AppLocalizations.of(context).SchoolTitle;
        break;
      case AddButtonType.AdminTitle:
        btnTitle = AppLocalizations.of(context).AdminTitle;
        break;
      case AddButtonType.BorrowTitle:
        btnTitle = AppLocalizations.of(context).BorrowTitle;
        break;
      case AddButtonType.UnAvailableTitle:
        btnTitle = AppLocalizations.of(context).UnAvailableTitle;
        break;
      case AddButtonType.FinishTitle:
        btnTitle = AppLocalizations.of(context).FinishTitle;
        break;
      case AddButtonType.SchoolPageTitle:
        btnTitle = AppLocalizations.of(context).SchoolPageTitle;
        break;
      case AddButtonType.AddItemTitle:
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
            width: kTextfieldW / 1,
            height: kTextfieldH * 1.2,
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0XFF9210F9),
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
              foregroundColor: Color.fromARGB(255, 233, 232, 232),
              textStyle: TextStyle(
                fontFamily: 'LeyendoDEMO',
                fontWeight: FontWeight.w600,
                fontSize: 55.sp,
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
