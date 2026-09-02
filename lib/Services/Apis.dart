// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:karma/Constants/dataInfo.dart';
import 'package:karma/Services/webApis.dart';
import 'package:dio/dio.dart' as di;


class Apis {
  static dynamic sendData(String data, String action) async {
    http.Response response;

    try {

      var url = Uri.parse("${WebApis.baseUrl}DATA=$data&ACTION=$action");

      response = await http.get(url).timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );

      if (response.statusCode == 200) {

        return response;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:${e.toString()}");
      }
      return null;
    }
  }

  static dynamic sendData1(String data, String action) async {
    http.Response response;

    try {

      var url = Uri.parse("${WebApis.customerBaseUrl}DATA=$data&ACTION=$action");

      response = await http.get(url).timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );

      if (response.statusCode == 200) {

        return response;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:${e.toString()}");
      }
      return null;
    }
  }

  static dynamic sendData2(String action) async {
    http.Response response;

    try {
      if (kDebugMode) log("url:${"${WebApis.customerBaseUrl}ACTION=$action"}");
      var url = Uri.parse("${WebApis.customerBaseUrl}ACTION=$action");

      response = await http.get(url).timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) log("response:${response.body.toString()}");
        return response;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:${e.toString()}");
      }
      return null;
    }
  }

  static dynamic sendData4(String data, String action) async {
    http.Response response;

    try {
      if (kDebugMode) {
        log("url:${"${WebApis.baseUrl}DATA=$data&ACTION=$action&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA"}");
      }
      var url = Uri.parse("${WebApis.baseUrl}DATA=$data&ACTION=$action&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");

      response = await http.get(url).timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );

      if (kDebugMode) log("response:${response.body.toString()}");
      if (response.statusCode == 200) {

        return response;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:${e.toString()}");
      }
      return null;
    }
  }

  static dynamic sendData5(String data) async {
    http.Response response;

    try {
      if (kDebugMode) {
        log("url:${"${WebApis.customerBaseUrl}data=$data"}&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");
      }

      var url = Uri.parse("${WebApis.customerBaseUrl}data=$data&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");

      response = await http.get(url).timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) log("response:${response.body.toString()}");

        return response;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:${e.toString()}");
      }
      return null;
    }
  }

  static dynamic sendDataPost(String action, Map<String, dynamic> body) async {
    try {
      final url =
          "${WebApis.baseUrl}ACTION=$action&DATA=&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA";
      if (kDebugMode) log("url:$url body:$body");
      final dio = di.Dio();
      final response = await dio.post(
        url,
        data: body,
        options: di.Options(
          contentType: di.Headers.jsonContentType,
          sendTimeout: const Duration(seconds: 50),
          receiveTimeout: const Duration(seconds: 50),
        ),
      );
      if (kDebugMode) log("response:${response.data}");
      return response;
    } catch (e) {
      if (kDebugMode) print("sendDataPost error:${e.toString()}");
      return null;
    }
  }

  static dynamic chatGptApi({required String message})async{
    di.Dio dio = di.Dio();
    try{
      var response = await dio.post("http://gateway.tallyhelp.com/crm/chatgtp.aspx?ACTION=STD_ENG&DATA=",
          data: {"MSG":message.trim()});


      if(response.data != null){
        Map<String,dynamic> apiData  = json.decode(response.data);
        if(apiData['STATUS'] == "1"){
          return apiData;
          // message.value = remark.text;
          // message1.value = response.data['MSG'];
          // remark.text  = response.data['MSG'];
          // update();


        }
        else{
          return null;
        }
      }
      else{
        return null;
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
