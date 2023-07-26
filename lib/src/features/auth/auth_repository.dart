import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:recleatapp/src/exceptions/app_exception.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recleatapp/src/widgets/dialogs.dart';

class AuthRepository {
  String? _uid; // AuthRepository will not use data model.
  String? _aid;
  String? get uid => _uid;
  String? get aid => _aid;

  set setUid(String str) {
    this._uid = str;
  }

  set setAid(String str) {
    this._aid = str;
  }

  Future<bool> doLogIn(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.postLogin(username, password);
    developer.log('doLogin() returned: $data');

    await prefs.setString("login_id", 'not');
    await prefs.setBool('isLogin', false);
    var result = data['result'];
    var id = data['id'].toString();
    print(result);
    if (result == 'Login Successfully') {
      _uid = id;
      showToastMessage("Login Successfully");
      await prefs.setString("login_id", id);
      await prefs.setBool('isLogin', true);
      return true;
    } else if (result == 'Invalid School Infomation') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Code Info') {
      throw const AppException.wrongPassword();
    }
    return false;
  }

  Future<bool> doAdminLogin(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.postAdminLogin(username, password);
    await prefs.setString("admin_id", 'not');
    await prefs.setBool('isAdminid', false);
    var result = data['result'];
    var id = data['id'].toString();

    if (result == 'Login Successfully') {
      _aid = id;

      showToastMessage("Login Successfully");
      return true;
    } else if (result == 'Invalid School Infomation') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password Info') {
      showToastMessage("Invalid Password");
    }
    return false;
  }

  Future<bool> doAddItem(String brand, String size, String item_type,
      String avaImg, String baseimage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await DioClient.postAddItem(
        brand, size, item_type, avaImg, baseimage, aid!);
    var result = data['result'];
    if (result == 'Successfully') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'No Internet') {
      showToastMessage("No Internet");
    }
    return false;
  }

  Future<bool> doBorrow(String name, String mail, String good_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.doBorrow(name, mail, good_id);

    var result = data['result'];
    if (result == 'Successfully') {
      showToastMessage("Successfully");
      return true;
    } else if (result == "No Internet") {
      showToastMessage("No Internet");
    } else {
      throw const AppException.userNotFound();
    }
    return false;
  }

  Future<bool> doSchoolRegister(
      String name, String code, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.doSchoolRegister(name, code, password);

    var result = data['result'];
    if (result == 'Successfully') {
      showToastMessage("Successfully");
      return true;
    } else if (result == "No Internet") {
      showToastMessage("No Internet");
    } else {
      throw const AppException.userNotFound();
    }
    return false;
  }

  Future<bool> doLogout() async {
    // clear profile and uid, later we may need to notify server...
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login_id', 'not');
    prefs.setBool('isLogin', false);

    return true;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
