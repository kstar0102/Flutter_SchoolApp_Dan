import 'package:recleatapp/src/utils/string_validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator =
      NonEmptyStringValidator(); //EmailSubmitRegexValidator();
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password) {
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email, BuildContext context) {
    final bool showErrorText = !canSubmitEmail(email);
    // final String errorText = email.isEmpty
    //     ? AppLocalizations.of(context).emailCantBeEmpty
    //     : AppLocalizations.of(context).invalidEmailAddr;
    // return showErrorText ? errorText : null;
    return showErrorText ? AppLocalizations.of(context).emailCantBeEmpty : null;
  }

  String? passwordErrorText(String email, BuildContext context) {
    final bool showErrorText = !canSubmitEmail(email);
    // final String errorText = email.isEmpty
    //     ? AppLocalizations.of(context).emailCantBeEmpty
    //     : AppLocalizations.of(context).invalidEmailAddr;
    // return showErrorText ? errorText : null;
    return showErrorText ? AppLocalizations.of(context).codeCantBeEmpty : null;
  }

  String? codeErrorText(String code, BuildContext context) {
    final bool showErrorText = !canSubmitEmail(code);
    // final String errorText = email.isEmpty
    //     ? AppLocalizations.of(context).emailCantBeEmpty
    //     : AppLocalizations.of(context).invalidEmailAddr;
    // return showErrorText ? errorText : null;
    return showErrorText ? AppLocalizations.of(context).pwdCantBeEmpty : null;
  }
}
