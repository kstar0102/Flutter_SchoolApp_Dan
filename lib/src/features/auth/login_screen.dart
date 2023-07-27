import 'dart:math';

import 'package:recleatapp/src/features/auth/admin_login_screen.dart';
import 'package:recleatapp/src/features/auth/school_register_screen.dart';
import 'package:recleatapp/src/features/good_list/home_screen.dart';
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
// import 'package:recleatapp/src/widgets/defalut_button.dart';
import 'package:recleatapp/src/widgets/new_button.dart';
import 'package:recleatapp/src/widgets/sub_button.dart';
import 'package:recleatapp/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recleatapp/src/features/auth/auth_controllers.dart';
import 'package:recleatapp/src/features/auth/login_validators.dart';
import 'package:recleatapp/src/features/auth/school_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
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
    getLoginFlag();
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

  void loginBtn() {
    FocusManager.instance.primaryFocus?.unfocus();

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
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {}
      },
    );
    // context.goNamed(AppRoute.homeScreen.name);
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
    }
    loginBtn();
  }

  //add School
  void addSchoolBtn() {
    loginBtn();
  }

  //Admin Login
  void adminLoginBtn() {
    loginBtn();
  }

  Future<void> Dialog() async {
    Widget cancelButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.pop(context);
        SystemNavigator.pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Are you sure you want to leave the program?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Login sessioninfo
  Future<void> getLoginFlag() async {
    final controller = ref.read(loginControllerProvider.notifier);
    controller.getLoggedInID();
    bool data = await controller.isLogin();
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    print(allowRevert);
    if (!allowRevert) {
      // Disable the revert action if needed
      return false;
    }
    Dialog();
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
                        SizedBox(height: 80.h),
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
                                  Container(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 32, right: 32.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          AppLocalizations.of(context)
                                              .loginPageLable,
                                          style: LoginHeaderLabelStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 220.h),
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
                                  SizedBox(
                                    width: 100 * 3.3,
                                    child: TextField(
                                      // textAlign: TextAlign.center,
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
                                  SizedBox(height: 80.h),
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
                                      controller: _passwordController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,
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
                                        hintText: "Enter School Code",
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
                                  NewButton(
                                    btnType: NewButtonType.SchoolPageTitle,
                                    onPressed: () {
                                      loginBtn();
                                    },
                                  ),
                                  SizedBox(height: 120.h),
                                  Image.asset("assets/images/Or.png",width: 325,),
                                  SizedBox(height: 120.h),
                                  Container(
                                    child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 32, right: 32),
                                        child: Row(
                                          children: [
                                            SubButton(
                                              btnType: SubButtonType.SchoolTitle,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddSchoolScreen()),
                                                );
                                              },
                                            ),
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               const AddSchoolScreen()),
                                            //     );
                                            //   },
                                            //   child: Text('Add School',
                                            //     style:TextStyle(
                                            //       color: Color(0XFFB152E0),
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: 14
                                            //     ),
                                            //   ),
                                            //   style: ButtonStyle(
                                            //     backgroundColor: MaterialStateProperty.all<Color>(Color(0XFFEFDBFE)), // Adjust background color
                                            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            //       RoundedRectangleBorder(
                                            //         borderRadius: BorderRadius.circular(8.0), // Adjust border radius
                                            //       ),
                                            //     ),
                                            //     minimumSize: MaterialStateProperty.all<Size>(Size(160.0, 50.0)), // Adjust button size
                                            //   ),
                                            // ),
                                            SizedBox(width: 8), // Adjust the spacing between the character and the text
                                            SubButton(
                                              btnType: SubButtonType.AdminTitle,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AdminLoginScreen()),
                                                  );
                                              },
                                            ),
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               const AdminLoginScreen()),
                                            //       );
                                            //   },
                                            //   child: Text('Admin Login',
                                            //      style:TextStyle(
                                            //       color: Color(0XFFB152E0),
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: 14
                                            //     ),
                                            //   ),
                                            //   style: ButtonStyle(
                                            //     backgroundColor: MaterialStateProperty.all<Color>(Color(0XFFEFDBFE)), // Adjust background color
                                            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            //       RoundedRectangleBorder(
                                            //         borderRadius: BorderRadius.circular(8.0), // Adjust border radius
                                            //       ),
                                            //     ),
                                            //     minimumSize: MaterialStateProperty.all<Size>(Size(160.0, 50.0)), // Adjust button size
                                            //   ),
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
