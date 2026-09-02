// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:karma/Constants/Library.dart';

class Utilities {
  static bool checkString(String value) {
    if (value == null ||
        value.trim() == "null" ||
        value.trim() == "NULL" ||
        value.trim().isEmpty ||
        value.trim() == "") {
      return false;
    }
    return true;
  }

  static speak()async{
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.speak("${greeting()} ${DataInfo.fullName}");

  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  static void onClickLink(String url, {LaunchMode mode = LaunchMode.externalNonBrowserApplication}) async{

    if (!await launchUrl(Uri.parse(url.toString().contains("www") ?"https://$url" :url),
        mode: mode,
        webViewConfiguration: const WebViewConfiguration(
      enableJavaScript: true,
      enableDomStorage: true,
    ))) {
    throw Exception('Could not launch $url');
    }
  }

  static void onClickMobile(String mobile) async{
    if (!await launchUrl(Uri.parse('tel://$mobile'))) {
      throw Exception('Could not launch $mobile');
    }
    //launch('tel://$mobile');
  }

  static void onClickEmail(String email) async{
    if (!await launchUrl(Uri.parse('mailto:$email'))) {
      throw Exception('Could not launch $email');
    }
  //  launch('mailto:$email');
  }

  static void onClickMessage(String mobile) async{
    if (!await launchUrl(Uri.parse('sms:+91 $mobile?body='))) {
      throw Exception('Could not launch $mobile');
    }
   // launch('sms:+91 $mobile?body=');
  }

  static void onGoogleMap(String lat,String log) {

    try{

      launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$log'));
    }catch(e){
      if (kDebugMode) {
        print("error:$e");
      }
    }
  }

  static Future<LocationData?> getLocation() async {
    final Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    } else if (permissionGranted == PermissionStatus.deniedForever) {
      return null;
    }

    try {
      return await location.getLocation();
    } catch (e) {
      if (kDebugMode) print('getLocation failed: $e');
      return null;
    }
  }

  static getPackageInfo()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    DataInfo.appVersion.value = packageInfo.version;
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    // log("app details:${version}");
  }

  static dynamic decodeResponse(String data){
    try{
      return json.decode(data);
    }catch(e){
      return data;
    }
  }

  static getUserLocation() async {

    try {
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {

      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {

      }
    }

   // List<geoLocation.Placemark> placemarks = await geoLocation.placemarkFromCoordinates(myLocation!.latitude!, myLocation.longitude!);

   // print('${placemarks.first}, ${placemarks.first.locality}, ${placemarks.first.subLocality}, ${placemarks.first.thoroughfare}, ${placemarks.first.subThoroughfare}');
  }

  static getAddressFromLatLng(double lat, double lng) async {

    String host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$host?key=${DataInfo.apiKey}&language=en&latlng=$lat,$lng';


    if(lat != null && lng != null){
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        String formattedAddress = data["results"][0]["formatted_address"];
        return formattedAddress;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static bool isHtml(String input) {
    final htmlTagPattern = RegExp(r'<[^>]+>'); // Matches anything in angle brackets
    return htmlTagPattern.hasMatch(input);
  }

  static  String formatAsHtml(String input) {

    try{
      final containsHtml = input.contains(RegExp(r'<[^>]+>'));

      if (containsHtml) {
        // Convert all <br> or </br> to line breaks, then wrap each line with <p>
        List<String> lines = input
            .replaceAll(RegExp(r'<\/?br\s*\/?>', caseSensitive: false), '\n')
            .split('\n');

        return lines
            .where((line) => line.trim().isNotEmpty)
            .map((line) => "<p>${line.trim()}</p>")
            .join("\n");
      } else {
        // Just wrap plain text in a paragraph
        return "<p>${input.trim()}</p>";
      }
    }catch(e){
      return input;
    }
  }
  static void onClickWhatsApp(String mobile) async {
    final phone = mobile.replaceAll(RegExp(r'[^0-9]'), '');
    final url = 'https://wa.me/$phone';
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp for $mobile');
    }
  }

}

extension Check on bool {

  static bool data(dynamic value){
    if(value  is String)
      {
        if(value != "null" && value.isNotEmpty)
          {
            return true;
          }
        else
          {
            return false;
          }
      }
    else if(value is List)
      {
        return value.isNotEmpty ? true : false;
      }
    else if(value is Map)
      {

        return value.isNotEmpty ? true : false;
      }
    else
      {

        return value != null ? true : false;
      }
  }





}