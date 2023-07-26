import 'dart:math';

import 'package:recleatapp/src/features/auth/admin_login_screen.dart';
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
import 'package:recleatapp/src/widgets/new_button.dart';
import 'package:recleatapp/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recleatapp/src/features/auth/auth_controllers.dart';
import 'package:recleatapp/src/features/auth/login_validators.dart';
import 'package:recleatapp/src/features/auth/school_screen.dart';
import 'package:recleatapp/src/features/good_list/inventory.dart';
import 'package:recleatapp/src/features/good_list/home_good_controller.dart';
import 'package:recleatapp/src/features/good_list/profile_controllers.dart';
import 'package:recleatapp/src/features/good_list/profile_repository.dart';

class GoodDetailScreen extends ConsumerStatefulWidget {
  const GoodDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;
  @override
  ConsumerState<GoodDetailScreen> createState() => _GoodDetailScreenState();
}

class _GoodDetailScreenState extends ConsumerState<GoodDetailScreen>
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
    ref.read(homeAccountCtrProvider.notifier).doGetProfile(widget.id);
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

  void borrowBtn() {
    FocusManager.instance.primaryFocus?.unfocus();

    // check username textfield's validation.
    final nameError = emailErrorText(username, context);
    if (nameError != null) {
      showToastMessage("Enter a Name.");
      return;
    }

    // check password textfield's validation.
    final mailError = passwordErrorText(password, context);
    if (mailError != null) {
      showToastMessage("Enter a Email.");
      return;
    }
    // try to login with input data.
    final controller = ref.read(loginControllerProvider.notifier);
    controller.doBorrow(username, password, widget.id).then(
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const HomeScreen()),
    // );
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
    borrowBtn();
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
    final profile = ref.watch(profileStateChangesProvider).value;

    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 380;
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
                                            const HomeScreen()),
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
                          child: Padding(
                            padding: EdgeInsets.only(left: 122),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.only(
                                left: 6.0,),
                                  child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0XFFF4E7FE),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 130.0,
                                      height: 150.0,
                                      margin: EdgeInsets.zero,
                                      child: Image.network(
                                        "http://www.recleate.com/uploads/image/${profile?.good_pic ?? ""}",
                                        width: 200,
                                        height: 110,
                                      ),
                                    ),
                                  ),
                                ),
                              
                              ),]
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 50.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight - keyboardHeight,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: SizedBox(
                                      child: Text(
                                        "Brand : ${profile?.brand ?? ""}",
                                        style: LoginHeaderLabelStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      child: Text(
                                        "Size : ${profile?.size ?? ""}",
                                        style: LoginHeaderLabelStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      child: Text(
                                        "Item Type : ${profile?.item_type ?? ""}",
                                        style: LoginHeaderLabelStyle,
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   child: SizedBox(
                                  //     child: Text(
                                  //       "Total Count : ${profile?.total_count}",
                                  //       style: LoginHeaderLabelStyle,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 100.h),
                                  Container(
                                    child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 32, right: 32),
                                        child: Row(
                                          children: [
                                            Text(
                                              "User Name",
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
                                        hintText: "Enter User Name",
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
                                              "User Email",
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
                                        hintText: "Enter Email",
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
                                    btnType: NewButtonType.BorrowTitle,
                                    onPressed: () {
                                      borrowBtn();
                                    },
                                  ),
                                  SizedBox(height: 50.h),
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
