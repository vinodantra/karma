// ignore_for_file: file_names

import 'dart:io';



import 'Library.dart';

class DataInfo extends GetxController {
  static RxString id = "".obs;
  static RxString profileName = "".obs;
  static RxString userId = "".obs;
  static RxString errorInfo = "".obs;
  static RxBool isPhysicalDevice = true.obs;
  static RxString enrollId = "".obs;
  static RxString rollId = "".obs;
  static RxString imageUrl = "".obs;
  static RxString pid = "".obs;
  static RxString tcId = "".obs;
  static RxString encKey = "".obs;

  static RxString name = "".obs;
  static RxString username = "".obs;
  static RxString username1 = "".obs;
  static RxString fullName = "".obs;
  static RxString mobile = "".obs;
  static RxString email = "".obs;
  static RxString desCat = "".obs;
  static RxString aboutMe = "".obs;
  static RxString selectUserId = "".obs;
  static RxString selectUserName = "".obs;
  static RxString designation = "".obs;
  static RxString deviceName = "".obs;
  static RxString device  =  "".obs;
  static RxString deviceId = "".obs;
  static RxString deviceToken = "".obs;
  static RxString platform = Platform.isAndroid ? "Android".obs : "Ios".obs;
  static RxString password = "".obs;
  static RxString appVersion = "".obs;
  static RxString dpId = "".obs;
  static RxString dpName = "".obs;
  static final box = GetStorage();
  // Google Maps Geocoding API key.
  //
  // SECURITY: This key was committed to source control and must be rotated
  // in GCP. After rotation, restrict the new key to:
  //   - Application restrictions: Android (package + SHA-1) and iOS (bundle ID)
  //   - API restrictions: only Geocoding API + Maps SDK as needed
  //
  // The Maps SDK key in AndroidManifest.xml requires the same treatment.
  static String apiKey = "AIzaSyD4Jn26OMzsW0o1rgy0jA629Z9txkCs4TQ";
  static RxBool showData = true.obs;
  static RxBool isSelectUser = true.obs;
  static RxString profileId = "".obs;
  static RxInt selectTheme = 1.obs;
  static RxBool updateAvailable = false.obs;
  static RxString downloadUrl = "https://tinyurl.com/AndroidKarma  ".obs;
  static RxString hashKey = "".obs;
  static RxString titleId = "".obs;
  static RxBool isDownloadApp = false.obs;
  static RxString url = "https://verdant-vertebra-a53.notion.site/Karma-App-Release-Notes-23e3b07a78854c9eb924a2d7f5f501b8?pvs=4".obs;
  static final navKey =  GlobalKey<NavigatorState>();
  static List<dynamic> notificationList = [];
  static int badges = 0;
  static String notificationKey = "notification";
  static RxBool isReadNotification = false.obs;
  static String badgesKey = "badges";

}
