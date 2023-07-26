import 'package:flutter/material.dart';

import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum NewButtonType {
  LoginTitle,
  SchoolTitle,
  AdminTitle,
  BorrowTitle,
  UnAvailableTitle,
  FinishTitle,
  AddItemTitle,
  SchoolPageTitle
}

class NewButton extends StatefulWidget {
  final NewButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const NewButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<NewButton> createState() => _NewButtonState();
}

class _NewButtonState extends State<NewButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case NewButtonType.LoginTitle:
        btnTitle = AppLocalizations.of(context).LoginTitle;
        break;
      case NewButtonType.SchoolTitle:
        btnTitle = AppLocalizations.of(context).SchoolTitle;
        break;
      case NewButtonType.AdminTitle:
        btnTitle = AppLocalizations.of(context).AdminTitle;
        break;
      case NewButtonType.BorrowTitle:
        btnTitle = AppLocalizations.of(context).BorrowTitle;
        break;
      case NewButtonType.UnAvailableTitle:
        btnTitle = AppLocalizations.of(context).UnAvailableTitle;
        break;
      case NewButtonType.FinishTitle:
        btnTitle = AppLocalizations.of(context).FinishTitle;
        break;
      case NewButtonType.SchoolPageTitle:
        btnTitle = AppLocalizations.of(context).SchoolPageTitle;
        break;
      case NewButtonType.AddItemTitle:
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
