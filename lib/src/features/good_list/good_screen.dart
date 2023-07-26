import 'dart:math';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
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
import 'package:recleatapp/src/widgets/add_button.dart';
import 'package:recleatapp/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recleatapp/src/features/auth/auth_controllers.dart';
import 'package:recleatapp/src/features/auth/login_validators.dart';
import 'package:recleatapp/src/features/good_list/good_detail.dart';
import 'package:recleatapp/src/features/good_list/add_good_screen.dart';
import 'package:recleatapp/src/features/good_list/admin_good_controller.dart';
import 'package:recleatapp/src/features/good_list/good_card.dart';
import 'package:recleatapp/src/features/auth/admin_login_screen.dart';

class AddGoodScreen extends ConsumerStatefulWidget {
  const AddGoodScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddGoodScreen> createState() => _AddGoodScreenState();
}

class _AddGoodScreenState extends ConsumerState<AddGoodScreen>
    with
        EmailAndPasswordValidators,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    ref.read(AdminGoodProvider.notifier).doGoodList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> DialogModal() async {
    Widget cancelButton = TextButton(
      child: Text("Return"),
      onPressed: () {
        // UpdateImage();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        Navigator.pop(context);
        // RemoveImage();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("notice"),
      content: Text("notice_content"),
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
    ref.listen<AsyncValue>(AdminGoodProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(AdminGoodProvider);
    final goods = state.value;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false, // Set this to false
          body: SafeArea(
            child: ProgressHUD(
              inAsyncCall: state.isLoading,
              child: SizedBox.expand(
                child: FocusScope(
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
                                            const AdminLoginScreen()),
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
                        AddButton(
                          btnType: AddButtonType.AddItemTitle,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddGoodItemScreen()),
                            );
                          },
                        ),
                       
                        SizedBox(height: 50.h),
                        Expanded(
                          // physics: const AlwaysScrollableScrollPhysics(),
                          child: goods != null && goods.isNotEmpty
                              ? GroupedListView(
                                  order: GroupedListOrder.ASC,
                                  elements: goods,
                                  groupBy: (good) => good.id,
                                  groupSeparatorBuilder: (value) {
                                    final now = DateTime.now();
                                    return Container(
                                      child: SizedBox(),
                                    );
                                  },
                                  itemBuilder: (context, element) {
                                    return GoodCard(
                                      info: element,
                                      onPressed: () {},
                                    );
                                  },
                                )
                              : const SizedBox(
                                  child: Text(
                                    "No data",
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
