// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:karma/Application/Dashboard/DashboardNew.dart';

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/notificationController.dart';
import 'package:karma/Services/SecureCredentials.dart';
import 'package:unique_identifier/unique_identifier.dart';

class AuthController extends GetxController {
  final NotificationController notificationController =
      NotificationController();

  @override
  void onReady() async {
    await Utilities.getPackageInfo();
    notificationController.requestNotificationPermission();
    await checkData();
    super.onReady();
  }

  Future<void> getDeviceInfo() async {
    try {
      if (!kIsWeb) {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          final androidId = await UniqueIdentifier.serial;
          DataInfo.isPhysicalDevice.value = androidInfo.isPhysicalDevice;
          DataInfo.deviceName.value =
              "${androidInfo.manufacturer} ${androidInfo.product}";
          DataInfo.platform.value = "ANDROID";
          DataInfo.device.value = DataInfo.deviceName.value;
          DataInfo.deviceId.value = androidId ?? "";
          DataInfo.deviceToken.value = "";
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          DataInfo.isPhysicalDevice.value = iosInfo.isPhysicalDevice;
          DataInfo.deviceName.value = iosInfo.name;
          DataInfo.platform.value = "IOS";
          DataInfo.device.value = iosInfo.name;
          DataInfo.deviceId.value = iosInfo.identifierForVendor ?? "";
          DataInfo.deviceToken.value = "";
        }
      }
    } catch (e) {
      log("Device info error: $e");
    }
  }

  Future<void> checkData() async {
    final watchdog = Timer(const Duration(seconds: 45), () {
      if (Get.currentRoute == "/") {
        CustomWidgets.snackBar(
            title:
                "Connection timeout. Please check your internet and try again.");
        Get.offAll(() => const LoginPage());
      }
    });
    try {
      await getDeviceInfo();
      await updateTheme();
      await checkUpdate();
      if (DataInfo.box.hasData('userId') && DataInfo.box.hasData("userInfo")) {
        final raw = DataInfo.box.read('userData');
        final userDataMap = (raw is String) ? json.decode(raw) : raw;
        if (userDataMap is! Map) {
          Get.offAll(() => const LoginPage());
          return;
        }

        // Password lives in secure storage now. Migration is handled inside
        // SecureCredentials.readPassword().
        final pwd = await SecureCredentials.readPassword();
        final username =
            userDataMap['username']?.toString() ?? DataInfo.box.read('username');
        if (pwd == null || pwd.isEmpty || username == null) {
          Get.offAll(() => const LoginPage());
          return;
        }

        final loginData = {
          'username': username,
          'password': pwd,
        };
        await login(loginData);
      } else {
        Get.offAll(() => const LoginPage());
      }
    } catch (e) {
      log("Check data error: $e");
      Get.offAll(() => const LoginPage());
    } finally {
      watchdog.cancel();
    }
  }

  Future<void> login(Map<String, dynamic> loginData) async {
    try {
      final value = await Api().fetchApi(
        data: Uri.encodeComponent(json.encode({
          "USER": loginData['username'],
          "PWD": loginData['password'],
          "VERSION": "536",
          "DEVICETYPE": Platform.isAndroid ? "ANDROID" : 'IOS'
        })),
        action: "LOGIN",
      );
      if (value?.success != true ||
          value!.data.toString().contains("Invalid Username or Password")) {
        CustomWidgets.snackBar(title: value?.data.toString() ?? "Login failed");
        Get.offAll(() => const LoginPage());
        return;
      }

      final jsonResponse = value.data;
      final records = (jsonResponse is Map) ? jsonResponse['records'] : null;
      if (records is! List || records.isEmpty) {
        CustomWidgets.snackBar(
            title: "Unexpected response from server. Please log in again.");
        Get.offAll(() => const LoginPage());
        return;
      }

      final userData = records.first;
      if (userData is! Map || userData['STATUS'] != "Yes") {
        CustomWidgets.snackBar(
            title: "Session expired. Please log in again.");
        Get.offAll(() => const LoginPage());
        return;
      }

      _assignUserData(loginData, Map<String, dynamic>.from(userData));
      await registerData(Map<String, dynamic>.from(userData));
    } catch (e) {
      log("Login error: $e");
      CustomWidgets.snackBar(
          title: "Connection problem. Please check your internet and try again.");
      Get.offAll(() => const LoginPage());
    }
  }

  void _assignUserData(
      Map<String, dynamic> loginData, Map<String, dynamic> userData) {
    DataInfo.username.value = loginData['username'].toString();
    DataInfo.username1.value = loginData['username'].toString();
    DataInfo.profileName.value = loginData['username'].toString();
    DataInfo.password.value =
        loginData['password'].toString(); // Consider encrypting
    DataInfo.userId.value = userData['UID'].toString();
    DataInfo.profileId.value = userData['UID'].toString();
    DataInfo.enrollId.value = userData['ENROLLID'].toString();
    DataInfo.rollId.value = userData['ROLLID'].toString();
    DataInfo.imageUrl.value = userData['IMGURL'].toString();
    DataInfo.pid.value = userData['PID'].toString();
    DataInfo.desCat.value = userData['DESCAT'].toString();
    DataInfo.encKey.value = userData['ENCKEY'].toString();
    DataInfo.tcId.value = userData['TCID'].toString();
    DataInfo.titleId.value = userData['TITLEID'].toString();

    final data = DataInfo.box.read("userInfo");
    DataInfo.fullName.value = data['FULLNAME'].toString().trim();
    DataInfo.name.value = data['NAME'].toString().trim();
    DataInfo.designation.value = data['DESIGNATION'].toString().trim();
    DataInfo.mobile.value = data['MOBILE'].toString().trim();
    DataInfo.email.value = data['USEREMAIL'].toString().trim();
    DataInfo.box.write("status", 1);
  }

  Future<void> registerData(Map<String, dynamic> userData) async {
    String? deviceToken;
    try {
      deviceToken = await notificationController.getToken();
      if (kDebugMode) print("token:$deviceToken");
    } catch (e) {
      if (kDebugMode) print("Notification token error: $e");
    }

    if (kDebugMode) log("Device Token: $deviceToken");

    try {
      final value = await Api().fetchApi(
        data: json.encode({
          "Uid": DataInfo.userId.value,
          "tokenID": DataInfo.deviceId.value,
          "device": DataInfo.platform.value,
          "UUID": deviceToken ?? "",
        }),
        action: "REGISTERID",
      );
      if (value?.data == "YES") {
        DataInfo.box.write("userId", DataInfo.userId.value);
        userData['username'] = DataInfo.username.value;
        userData.remove('password');
        DataInfo.box.write("userData", json.encode(userData));
        DataInfo.box.write("username", DataInfo.username.value);
        await SecureCredentials.savePassword(DataInfo.password.value);
        await getUserData();
        Get.offAll(() => const DashboardNew());
      } else {
        CustomWidgets.snackBar(title: "Server Error");
        Get.offAll(() => const LoginPage());
      }
    } catch (e) {
      log("Register error: $e");
      CustomWidgets.snackBar(
          title: "Connection problem. Please check your internet and try again.");
      Get.offAll(() => const LoginPage());
    }
  }

  Future<void> getUserData() async {
    try {
      final responseData = await Apis.sendData(
        DataInfo.username.value,
        "GETUSERDITAILS&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA",
      );
      final de = json.decode(responseData.body);
      final data = de[0];
      DataInfo.box.write("userInfo", data);
      DataInfo.fullName.value = data['FULLNAME'].toString().trim();
      DataInfo.name.value = data['NAME'].toString().trim();
      DataInfo.designation.value = data['DESIGNATION'].toString().trim();
      DataInfo.mobile.value = data['MOBILE'].toString().trim();
      DataInfo.email.value = data['USEREMAIL'].toString().trim();
      DataInfo.aboutMe.value = data['ABOUTME'].toString().trim();
    } catch (e) {
      log("Get user data error: $e");
    }
  }

  Future<void> updateTheme() async {
    final themeController =
        Provider.of<AppThemeController>(Get.context!, listen: false);
    if (DataInfo.box.hasData("theme")) {
      final index = DataInfo.box.read("theme");
      DataInfo.selectTheme.value = index;
      appGradientColor.value = appTheme[index - 1];
      appColor.value = appColorList[index - 1];
      final theme = Get.put(AppTheme());
      theme.appGradientColor.value = appTheme[index - 1];
      theme.appColor.value = appColorList[index - 1];
      theme.changeTheme(appTheme[index - 1]);
      themeController.changeTheme(appTheme[index - 1]);
      update();
    } else {
      DataInfo.selectTheme.value = 1;
      appGradientColor.value = appTheme.first;
      appColor.value = appColorList.first;
      final theme = Get.put(AppTheme());
      theme.appGradientColor.value = appTheme.first;
      theme.appColor.value = appColorList.first;
      theme.changeTheme(appTheme.first);
      themeController.changeTheme(appTheme.first);
      update();
    }
  }

  Future<void> checkUpdate() async {
    try {
      final value = await Api().fetchApi(
        data: DataInfo.appVersion.value,
        action: "APPVERSION",
      );
      if (value?.success == true && value!.data['STATUS'] == "UPDATE") {
        DataInfo.updateAvailable.value = true;
        DataInfo.downloadUrl.value = value.data['URL'];
        DataInfo.hashKey.value = value.data['HASHKEY'];
      }
    } catch (e) {
      log("Check update error: $e");
    }
  }
}
