import 'dart:math';

import 'package:recleatapp/src/features/auth/login_screen.dart';
import 'package:recleatapp/src/widgets/gnav/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:recleatapp/src/routing/app_router.dart';
import 'package:recleatapp/src/utils/async_value_ui.dart';
import 'package:recleatapp/src/utils/string_validators.dart';
import 'package:recleatapp/src/widgets/dialogs.dart';
import 'package:recleatapp/src/widgets/new_button.dart';
import 'package:recleatapp/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recleatapp/src/features/auth/auth_controllers.dart';
import 'package:recleatapp/src/features/auth/login_validators.dart';
import 'package:recleatapp/src/features/auth/school_screen.dart';

class AddSchoolScreen extends ConsumerStatefulWidget {
  const AddSchoolScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends ConsumerState<AddSchoolScreen>
    with
        EmailAndPasswordValidators,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  final _node = FocusScopeNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  String get code => _codeController.text;
  String get username => _usernameController.text;
  String get password => _passwordController.text;
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (this.mounted) {
        setState(() {
          this.keyboardHeight = keyboardHeight;
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TextEditingControllers should be always disposed.
    _node.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('App lifecycle state changed: $state');
    // Implement any functionality you need here.
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
      print(_isKeyboardVisible);
    });
  }

  void adminLoginBtn() {
    FocusManager.instance.primaryFocus?.unfocus();

    // check username textfield's validation.
    final emailError = emailErrorText(username, context);
    if (emailError != null) {
      showToastMessage(emailError);
      return;
    }

    final codeError = codeErrorText(code, context);
    if (codeError != null) {
      showToastMessage(codeError);
      return;
    }

    // check password textfield's validation.
    final pwdError = passwordErrorText(password, context);
    if (pwdError != null) {
      showToastMessage(pwdError);
      return;
    }

    // try to login with input data.
    final controller = ref.read(loginControllerProvider.notifier);
    controller.doSchoolRegister(username, code, password).then(
      (value) {
        // go home only if login success.
        if (value == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SchoolLoginScreen()),
          );
        } else {}
      },
    );
  }

  //Validation//
  void _emailEditingComplete() {
    if (canSubmitEmail(username)) {
      _node.nextFocus();
    }
  }

  void _codeEditingController() {
    if (canSubmitEmail(code)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(username)) {
      _node.previousFocus();
      return;
    }
    adminLoginBtn();
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      // Disable the revert action if needed
      return false;
    }

    // Perform additional logic if required

    return false;
  }

  //build
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(loginControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(loginControllerProvider);
    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 530;
      keyboardHeight = 0;
    }
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false, // Set this to false
          body: SafeArea(
            child: ProgressHUD(
              inAsyncCall: state.isLoading,
              child: SizedBox.expand(
                child: FocusScope(
                  node: _node,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(right: 100.0 * 3.2),
                            child: SizedBox(
                              // set the desired width here
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: Image.asset("assets/images/arrow.png"),
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                        ),
                        SizedBox(height: 100.h),
                        Container(
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 32, right: 32),
                              child: Row(
                                children: [
                                  Text(
                                    "School Name",
                                    style: TextStyle(
                                      fontFamily: 'LeyendoDEMO',
                                      fontSize: 50.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight - keyboardHeight,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 100 * 3.3,
                                    child: TextField(
                                      // textAlign: TextAlign.center,
                                      controller: _usernameController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _emailEditingComplete(),
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "Enter School Name",
                                        hintStyle: TextStyle(
                                          fontSize:
                                              15.0, 
                                              color: Colors.grey[500]
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        // Align the text within the TextField vertically and horizontally
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20),
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 100.h),
                                  Container(
                                    child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 32, right: 32),
                                        child: Row(
                                          children: [
                                            Text(
                                              "School Code",
                                              style: TextStyle(
                                                fontFamily: 'LeyendoDEMO',
                                                fontSize: 50.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  SizedBox(
                                    width: 100 * 3.3,
                                    child: TextField(
                                      // textAlign: TextAlign.center,
                                      controller: _codeController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _codeEditingController(),
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "Add School Code",
                                        hintStyle: TextStyle(
                                          fontSize:
                                              15.0, 
                                              color: Colors.grey[500]
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        // Align the text within the TextField vertically and horizontally
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20),
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 100.h),
                                  Container(
                                    child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 32, right: 32),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Admin Password",
                                              style: TextStyle(
                                                fontFamily: 'LeyendoDEMO',
                                                fontSize: 50.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  SizedBox(
                                    width: 100 * 3.3,
                                    child: TextField(
                                      // textAlign: TextAlign.center,
                                      controller: _passwordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _passwordEditingComplete(),
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "Admin Password",
                                        hintStyle: TextStyle(
                                          fontSize:
                                              15.0, 
                                              color: Colors.grey[500]
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        // Align the text within the TextField vertically and horizontally
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20),
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 280.h * 2),
                                  NewButton(
                                    btnType: NewButtonType.FinishTitle,
                                    onPressed: () {
                                      adminLoginBtn();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
