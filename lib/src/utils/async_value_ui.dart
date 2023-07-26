import 'package:recleatapp/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/exceptions/app_exception.dart';
//import 'package:membership_app/src/widgets/alert_dialogs.dart';
//import 'package:membership_app/src/utils/string_hardcoded.dart';

extension AsyncValueUI on AsyncValue {
  bool showAlertDialogOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      final message = _errorMessage(error, context);
      showToastMessage(message);
      // showExceptionAlertDialog(
      //   context: context,o
      //   title: AppLocalizations.of(context).err,
      //   exception: message,
      // );
      return true;
    }
    return false;
  }

  String _errorMessage(Object? error, BuildContext context) {
    if (error is AppException) {
      return error.getDetails(context).message;
    } else {
      return error.toString();
    }
  }
}
