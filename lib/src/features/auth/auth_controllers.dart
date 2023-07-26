import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recleatapp/src/features/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// * ---------------------------------------------------------------------------
// * LoginController
// * ---------------------------------------------------------------------------

class LoginController extends StateNotifier<AsyncValue<bool>> {
  LoginController({required this.authRepo}) : super(const AsyncData(false));

  final AuthRepository authRepo;
  late BuildContext context;

  //bool isAuthenticated() => authRepo.uid

  Future<bool> doLogin(String email, String password) async {
    // if (authRepo.uid != null &&
    //     authRepo.uid!.isNotEmpty &&
    //     authRepo.uid != 'not') {
    //   // already logined!
    //   state = const AsyncData(true);
    //   return true;
    // }
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doLogIn(email, password));

    // Check if the controller is mounted before setting the state to prevent:
    // Bad state: Tried to use Controller after `dispose` was called.
    if (mounted) {
      state = newState;
    }
    if (state.value == false) {
      return newState.hasError;
    }
    return newState.hasValue;
  }

  Future<bool> doAdminLogin(String email, String password) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doAdminLogin(email, password));

    if (mounted) {
      state = newState;
    }
    if (state.value == false) {
      return newState.hasError;
    }
    return newState.hasValue;
  }

  Future<bool> doBorrow(String name, String mail, String good_id) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doBorrow(name, mail, good_id));

    if (mounted) {
      state = newState;
    }
    if (state.value == false) {
      return newState.hasError;
    }
    return newState.hasValue;
  }

  Future<bool> doSchoolRegister(
      String name, String code, String password) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doSchoolRegister(name, code, password));

    if (mounted) {
      state = newState;
    }
    if (state.value == false) {
      return newState.hasError;
    }
    return newState.hasValue;
  }

  Future<bool> doAddItem(String brand, String size, String item_type,
      String avaImg, String baseimage) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doAddItem(brand, size, item_type, avaImg, baseimage));

    if (mounted) {
      state = newState;
    }
    if (state.value == false) {
      return newState.hasError;
    }
    return newState.hasValue;
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  Future<String> getLoggedInID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString('login_id') ?? 'not';
    authRepo.setUid = str;
    return str;
  }

  Future<void> doLogout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepo.doLogout());
  }
}

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<bool>>((ref) {
  return LoginController(authRepo: ref.watch(authRepositoryProvider));
});
