// ignore_for_file: file_names

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:karma/Application/Utilities/Utilities.dart';
import 'package:karma/Services/webApis.dart';
import 'package:karma/Widgets/CustomWidgets.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../Constants/dataInfo.dart';

class Api {
  final Dio _dio = Dio();

  final String baseUrl;
  Map<String, dynamic> defaultHeader = {'Content-Type': 'application/json'};
  Api({this.baseUrl = ""}) {
    _dio.options.headers = defaultHeader;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(minutes: 5);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['_slowTimer'] = Timer(
          SlowNetworkNotifier.threshold,
          SlowNetworkNotifier.notify,
        );
        handler.next(options);
      },
      onResponse: (response, handler) {
        (response.requestOptions.extra['_slowTimer'] as Timer?)?.cancel();
        handler.next(response);
      },
      onError: (e, handler) {
        (e.requestOptions.extra['_slowTimer'] as Timer?)?.cancel();
        handler.next(e);
      },
    ));
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        request: false,
        requestBody: true,
        requestHeader: false,
        responseBody: true,
        responseHeader: false,
      ));
    }
  }

  Dio get sendRequest => _dio;

  Future<ApiResponse?> _fetchApi(
      {String? data = "",
      required String action,
      bool isSubmit = false}) async {
    // if (kDebugMode) {
    //   print("send request:${DateTime.now()}");
    // }
    if (kDebugMode) {
      print(
          "Send data :- ${WebApis.baseUrl}DATA=$data&ACTION=$action&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA&ISNEW=YES");
    }

    Response response = await Api().sendRequest.get(
        "${WebApis.baseUrl}DATA=$data&ACTION=$action&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA&ISNEW=YES",
        onReceiveProgress: (a, b) {});
    // if (kDebugMode) {
    //   print("get request:${DateTime.now()}");
    // }
    return ApiResponse.fromResponse(response, isSubmit: isSubmit);
  }

  Future<ApiResponse?> _postApi(
      {String? data = "",
      required String action,
      bool isSubmit = false}) async {
    // if (kDebugMode) {
    //   print("send request:${DateTime.now()}");
    // }

    Response response = await Api().sendRequest.post(
        "${WebApis.baseUrl}ACTION=$action&DATA=",
        data: "${data!}&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA&ISNEW=YES");
    // if (kDebugMode) {
    //   print("get request:${DateTime.now()}");
    // }
    return ApiResponse.fromResponse(response, isSubmit: isSubmit);
  }

  Future<ApiResponse?> _postApi1(
      {String? data = "",
      required String action,
      bool isSubmit = false}) async {
    // if (kDebugMode) {
    //   print("send request:${DateTime.now()}");
    // }

    Response response = await Api().sendRequest.post(
        "${WebApis.baseUrl}ACTION=$action&DATA=&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA&ISNEW=YES",
        data: data!);
    // if (kDebugMode) {
    //   print("get request:${DateTime.now()}");
    // }
    return ApiResponse.fromResponse(response, isSubmit: isSubmit);
  }

  Future<ApiResponse?> fetchApi(
      {String? data = "",
      required String action,
      bool isSubmit = false}) async {
    ApiResponse? apiResponse;
    apiResponse =
        await _fetchApi(data: data, action: action, isSubmit: isSubmit);
    /*data = 10.0.0 Action = APPVERSION*/
    if (apiResponse!.success == true) {
      return apiResponse;
    } else {
      CustomWidgets.snackBar(
          title: apiResponse.message!.isNotEmpty
              ? apiResponse.message!
              : apiResponse.data);
      return apiResponse;
    }
  }

  Future<ApiResponse?> postApi(
      {String? data = "",
      required String action,
      bool isSubmit = false}) async {
    ApiResponse? apiResponse;
    apiResponse =
        await _postApi(data: data, action: action, isSubmit: isSubmit);

    if (apiResponse!.success == true) {
      return apiResponse;
    } else {
      CustomWidgets.snackBar(
          title: apiResponse.message!.isNotEmpty
              ? apiResponse.message!
              : apiResponse.data);
      return apiResponse;
    }
  }

  Future<ApiResponse?> postApi1(
      {String? data = "",
      required String action,
      bool isSubmit = false}) async {
    ApiResponse? apiResponse;
    apiResponse =
        await _postApi1(data: data, action: action, isSubmit: isSubmit);

    if (apiResponse!.success == true) {
      return apiResponse;
    } else {
      CustomWidgets.snackBar(
          title: apiResponse.message!.isNotEmpty
              ? apiResponse.message!
              : apiResponse.data);
      return apiResponse;
    }
  }
}

class SlowNetworkNotifier {
  static const Duration threshold = Duration(seconds: 5);
  static const Duration cooldown = Duration(seconds: 10);
  static DateTime? _lastShown;

  static void notify() {
    final now = DateTime.now();
    if (_lastShown != null && now.difference(_lastShown!) < cooldown) return;
    _lastShown = now;
    CustomWidgets.snackBar(
      title: 'Slow internet connection. Please wait...',
    );
  }
}

class ApiResponse {
  bool success;
  dynamic data;
  String? message;
  ApiResponse({required this.success, this.data, this.message});

  factory ApiResponse.fromResponse(Response response, {bool isSubmit = false}) {
    final data = response.data;

    return isSubmit
        ? ApiResponse(
            success: data.toString().toLowerCase() == "yes" ? true : false,
            data: data,
            message: "")
        : ApiResponse(
            success: Check.data(data)
                ? response.statusCode != 200 ||
                        Utilities.decodeResponse(data) is String
                    ? data.toString().toLowerCase() == "yes" ||
                            data.toString().contains('Create') ||
                            data.toString().toLowerCase().contains('reopen')
                        ? true
                        : false
                    : true
                : false,
            data: Check.data(data) ? Utilities.decodeResponse(data) : "",
            message: Check.data(data)
                ? Utilities.decodeResponse(data) is String
                    ? data.trim()
                    : ""
                : data.toString().contains("Cannot login in this device")
                    ? data.toString()
                    : "Server Error");
  }
}
