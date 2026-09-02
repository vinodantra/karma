// ignore_for_file: file_names

import 'package:karma/Constants/dataInfo.dart';

class WebApis {
  //static String rootUrl = "http://192.168.1.22";
  // static String rootUrl = DataInfo.isPhysicalDevice.value  == true ?
  //  "https://gateway.tallyhelp.com" : "http://192.168.1.22";
  static String rootUrl = "https://gateway.tallyhelp.com";
  static String baseUrl = "$rootUrl/crm/UpdateData.aspx?";

  static String customerBaseUrl = "$rootUrl/crm/CustomerApp.aspx?";
}
