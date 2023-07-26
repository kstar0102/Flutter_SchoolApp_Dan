// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:recleatapp/src/model/dio_exception.dart';

class DioClient {
  static final _baseOptions = BaseOptions(
    // baseUrl: 'http://mobileapp.swaconnect.net/api',
    baseUrl: 'http://www.recleate.com/api',
    //connectTimeout: 10000, receiveTimeout: 10000,
    headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6Inc1YW0wQ29WVlJaUUF3V2RkUXRVaVE9PSIsInZhbHVlIjoibDkrMmRmSFFNQkxZbENybFFscXo1d3hHUXAySFVBWE1XbEthRFoybStRT0ZETk9BcXlLRXkrQmZYSnRzODZ6aHRjamtNZ1RyK2VKbmFlS3BNTGtSS1g1NnhjNjJ0RHVReUVjTFpBMzhlaytCc3hVWDBJZWxNOTVUYURrakRud3YiLCJtYWMiOiIzYzNmOTU1NDA0ODkxZTU3NWQzMDQyMmMzZThmMDU2OWQ3ODkzYTY2ZGI1ZWViNmU0M2VmMmMwZDBhYjg1YzlmIn0%3D; laravel_session=eyJpdiI6IndwREYyUnNob3B2aUtiam5JdEE0ckE9PSIsInZhbHVlIjoiL1FUejBJbUEwcG9lWnl5NmtXVlQzQ1VRVzZZWEhZZDIwbnpnNFBuSTBuclpESjBKTkhPaFdhdlFTQWFuNUh4MWErOGdSTVdkVkZyYnEvOEJ1RVhTWUEvRlA0TlRPZC9jL0NVZlRRWkRCaUZXUHlEYWNqVTIzV2hwZnBPZzhVVjEiLCJtYWMiOiIzZDczOWM1Y2ViZDE0OTE2N2M5ODYyNDdkMmRlYzMyOGUwNjU2MmY0NTcxZGU2NGI4MTM1ZTEwZWE2MGY5ZWVmIn0%3D',
    },
  );

  // * keep token for future usage.
  static String _token = '';

  // * GET: '/token'
  static Future<String> _getToken() async {
    final random = Random.secure();
    var values = List<int>.generate(8, (i) => random.nextInt(256));
    _token = base64Url.encode(values);
    return _token;
  }

  String createToken() {
    final random = Random.secure();
    var values = List<int>.generate(8, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // * POST: '/login'
  static Future<dynamic> postLogin(String email, String password) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.post('/login_action',
          data: {'schoolName': email, 'schoolCode': password});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/adminlogin'
  static Future<dynamic> postAdminLogin(String email, String password) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;

    try {
      final response = await dio.post('/adminlogin_action',
          data: {'schoolName': email, 'adminPass': password});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/adminlogin'
  static Future<dynamic> postAddItem(String brand, String size,
      String item_type, String avaImg, String baseimage, String aid) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/add_item', data: {
        'brand': brand,
        'size': size,
        'item_type': item_type,
        'image_name': avaImg,
        'image': baseimage,
        'aid': aid
      });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * GET '/Goodlist/all'

  static Future<dynamic> postInventoryAll(String uid) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    print(uid);
    try {
      final response = await dio.get('/get_good_list/$uid',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      print("response data ${response.data}");
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  // * GET '/good_list/good_id'
  static Future<dynamic> getGoodDetail(String good_id) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.get(
        '/get_good_detail/$good_id',
      );
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/borrow'
  static Future<dynamic> doBorrow(
      String name, String mail, String good_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    print(name + mail + good_id);
    try {
      final response = await dio.post('/good_borrow',
          data: {'name': name, 'mail': mail, 'good_id': good_id});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/AddSchool'
  static Future<dynamic> doSchoolRegister(
      String name, String code, String pass) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/add_school',
          data: {'name': name, 'code': code, 'pass': pass});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * GET '/AdminGoodlist/all'

  static Future<dynamic> postGoodList(String aid) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_admin_good_list/$aid',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  // * GET '/AdminGoodlist/all'

  static Future<dynamic> returnBuyer(String listId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.post('/return_buyer/$listId',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> deleteGoodData(String good_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.post('/delete_gooddata/$good_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> updateGoodData(String good_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.post('/return_gooddata/$good_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }
}
