import 'dart:math';

import 'package:recleatapp/src/features/auth/admin_login_screen.dart';
import 'package:recleatapp/src/features/auth/login_screen.dart';
import 'package:recleatapp/src/features/auth/school_register_screen.dart';
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
import 'package:recleatapp/src/widgets/defalut_button.dart';
import 'package:recleatapp/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recleatapp/src/features/auth/auth_controllers.dart';
import 'package:recleatapp/src/features/auth/login_validators.dart';
import 'package:recleatapp/src/features/auth/school_screen.dart';
import 'package:recleatapp/src/features/auth/school_register_screen.dart';
import 'package:recleatapp/src/features/good_list/home_screen.dart';

class SchoolLoginScreen extends ConsumerStatefulWidget {
  const SchoolLoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SchoolLoginScreen> createState() => _SchoolLoginScreenState();
}

class _SchoolLoginScreenState extends ConsumerState<SchoolLoginScreen>
    with
        EmailAndPasswordValidators,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  final _node = FocusScopeNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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

  void addSchoolBtn() {
    FocusManager.instance.primaryFocus?.unfocus();

    // check username textfield's validation.
    final emailError = emailErrorText(username, context);
    if (emailError != null) {
      showToastMessage(emailError);
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
    controller.doLogin(username, password).then(
      (value) {
        // go home only if login success.
        if (value == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSchoolScreen()),
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

  void _passwordEditingComplete() {
    if (!canSubmitEmail(username)) {
      _node.previousFocus();
      return;
    }
    addSchoolBtn();
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    print(allowRevert);
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
      screenHeight = 550;
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
                                      textAlign: TextAlign.center,
                                      controller: _usernameController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _emailEditingComplete(),
                                      inputFormatters: <TextInputFormatter>[
                                        ValidatorInputFormatter(
                                            editingValidator:
                                                EmailEditingRegexValidator()),
                                      ],
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "School Name",
                                        hintStyle: TextStyle(
                                          fontSize:
                                              20.0, // Adjust font size as needed
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        // Align the text within the TextField vertically and horizontally
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 17.0),
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 100.h),
                                  SizedBox(
                                    width: 100 * 3.3,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: _passwordController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _passwordEditingComplete(),
                                      inputFormatters: <TextInputFormatter>[
                                        ValidatorInputFormatter(
                                            editingValidator:
                                                EmailEditingRegexValidator()),
                                      ],
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "School Code",
                                        hintStyle: TextStyle(
                                          fontSize:
                                              20.0, // Adjust font size as needed
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        // Align the text within the TextField vertically and horizontally
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 17.0),
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 100.h * 9.5),
                                  LoginButton(
                                    btnType: LoginButtonType.SchoolTitle,
                                    onPressed: () {
                                      addSchoolBtn();
                                    },
                                  ),
                                  // SizedBox(height: 50.h),
                                  // LoginButton(
                                  //   btnType: LoginButtonType.AdminTitle,
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               const AdminLoginScreen()),
                                  //     );
                                  //   },
                                  // ),
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
