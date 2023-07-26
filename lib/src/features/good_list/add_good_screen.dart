import 'dart:math';
import 'dart:io';

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
import 'package:recleatapp/src/features/good_list/good_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
class AddGoodItemScreen extends ConsumerStatefulWidget {
  const AddGoodItemScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddGoodItemScreen> createState() => _AddGoodItemScreenState();
}

class _AddGoodItemScreenState extends ConsumerState<AddGoodItemScreen>
    with
        EmailAndPasswordValidators,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  final _node = FocusScopeNode();
  final _brandController = TextEditingController();
  final _sizeController = TextEditingController();
  final _itemController = TextEditingController();

  String get brand => _brandController.text;
  String get size => _sizeController.text;
  String get item_type => _itemController.text;
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  File? _image;
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
    _brandController.dispose();
    _sizeController.dispose();
    _itemController.dispose();
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

  String avaImg = "";

  Future<void> UpdateImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File image = File(pickedFile.path);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      avaImg = pickedFile.path.split('/').last;
      // uploadImage(avaImg);
    }
  }

  void goodRegisterBtn() {
    FocusManager.instance.primaryFocus?.unfocus();
    print(avaImg);
    // check username textfield's validation.
    final brandError = emailErrorText(brand, context);
    if (brandError != null) {
      showToastMessage("Brand Can't be Empty ");
      return;
    }

    // check password textfield's validation.
    final sizeError = passwordErrorText(size, context);
    if (sizeError != null) {
      showToastMessage("Size Can't be Empty ");
      return;
    }

    // check password textfield's validation.
    final itemError = passwordErrorText(item_type, context);
    if (itemError != null) {
      showToastMessage("Password Can't be Empty ");
      return;
    }
    if (avaImg == "") {
      showToastMessage("Photo Can't be Empty ");
      return;
    }

    // try to login with input data.
    final controller = ref.read(loginControllerProvider.notifier);
    List<int> imageBytes = _image!.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);
    controller.doAddItem(brand, size, item_type, avaImg, baseimage).then(
      (value) {
        // go home only if login success.
        if (value == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoodScreen()),
          );
        } else {}
      },
    );
  }

  //Validation//
  void _brandEditingComplete() {
    if (canSubmitEmail(brand)) {
      _node.nextFocus();
    }
  }

  void _sizeEditingComplete() {
    if (canSubmitEmail(size)) {
      _node.nextFocus();
    }
  }

  void _itemEditingComplete() {
    if (canSubmitEmail(item_type)) {
      _node.nextFocus();
      return;
    }
    goodRegisterBtn();
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
      screenHeight = 520;
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
                                            const AddGoodScreen()),
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
                                    "Brand Name",
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
                                      controller: _brandController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _brandEditingComplete(),
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "Enter Brand Name",
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
                                              "Size",
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
                                      controller: _sizeController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _sizeEditingComplete(),
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "Enter Size",
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
                                              "Item Type",
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
                                      controller: _itemController,
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.grey,
                                      onEditingComplete: () =>
                                          _itemEditingComplete(),
                                      decoration: InputDecoration(
                                        // labelStyle: kLabelStyle,
                                        // errorStyle: kErrorStyle,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: kEnableBorder,
                                        focusedBorder: kFocusBorder,
                                        hintText: "Enter Item Type",
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
                                  DottedBorder(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        UpdateImage();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set the desired radius value
                                        ),
                                        primary:
                                            Color.fromARGB(255, 244, 231, 254),
                                        onPrimary:
                                            Colors.white, // Set the text color
                                        // side: BorderSide(
                                        //   color: Color.fromARGB(255, 146, 16, 249),
                                        //   width: 1,
                                        //   style: BorderStyle.solid,
                                        // ),
                                      ),
                                      child: Container(
                                        width: 100 * 3,
                                        height: 55,
                                        alignment: Alignment.center,
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              color: Color.fromARGB(255, 146, 16, 249),
                                              size: 15,
                                            ),
                                            SizedBox(width: 5), // Optional spacing between the icon and text
                                            Text(
                                              'Upload Photo',
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 146, 16, 249),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(15),
                                    color: Color.fromARGB(255, 146, 16, 249),
                                    dashPattern: [2,2,2,2,2,2],
                                  ),
                                 
                                  SizedBox(height: 170.h),
                                  NewButton(
                                    btnType: NewButtonType.AddItemTitle,
                                    onPressed: () {
                                      goodRegisterBtn();
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
