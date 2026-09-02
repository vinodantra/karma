// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unused_import
import 'dart:io';

import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Controller/notificationController.dart';
import 'package:karma/Services/SecureCredentials.dart';
import '../Constants/Library.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final isShowPassword = true.obs;
  final userNameErrorText = "".obs;
  final passwordErrorText = "".obs;
  final isLoading = false.obs;
  final isRemember = true.obs;

  late final AnimationController animationController;
  late final AnimationController animationController1;
  late final Animation<double> offsetAnimation;
  late final Animation<Alignment> alignTransaction;

  @override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    offsetAnimation =
        CurvedAnimation(parent: animationController1, curve: Curves.ease);
    alignTransaction =
        Tween<Alignment>(begin: Alignment.center, end: Alignment.topCenter)
            .animate(animationController);

    NotificationController().requestNotificationPermission();
    _restoreRememberedCredentials();
  }

  Future<void> _restoreRememberedCredentials() async {
    try {
      if (DataInfo.box.hasData('isRemember') &&
          DataInfo.box.read('isRemember') == true) {
        userNameController.text = DataInfo.box.read("username") ?? "";
        final pwd = await SecureCredentials.readPassword();
        if (pwd != null) passwordController.text = pwd;
        update();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    animationController1.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void checkData() {
    isLoading.value = true;
    userNameErrorText.value = "";  
    passwordErrorText.value = "";

    bool isValid = true;
    if (userNameController.text.trim().isEmpty) {
      isValid = false;
      userNameErrorText.value = "Please enter username";
    }
    if (passwordController.text.trim().isEmpty) {
      isValid = false;
      passwordErrorText.value = "Please enter password";
    }
    if (isValid) {
      login();
    } else {
      isLoading.value = false;
    }
  }

  void login() async {
    bool willRegister = false;
    try {
      final data = {
        "USER": userNameController.text.trim(),
        "PWD": passwordController.text.trim(),
        "VERSION": "536",
        "DEVICETYPE": Platform.isAndroid ? "ANDROID" : 'IOS',
      };
      final encodedData = Uri.encodeComponent(json.encode(data));
      final value = await Api().fetchApi(data: encodedData, action: "LOGIN");

      if (value?.success != true) {
        CustomWidgets.snackBar(title: value?.message ?? "Login failed");
        return;
      }

      isShowPassword.value = true;
      final response = value!.data;
      final records = (response is Map) ? response['records'] : null;
      if (records is! List || records.isEmpty) {
        CustomWidgets.snackBar(
            title: "Unexpected response from server. Please try again.");
        return;
      }

      final record = records.first;
      if (record is! Map || record['STATUS'] != "Yes") {
        final msg = (record is Map ? record['MESSAGE']?.toString() : null) ??
            "Invalid Username or Password";
        CustomWidgets.snackBar(title: msg);
        return;
      }

      _setUserData(Map<String, dynamic>.from(record));
      willRegister = true;
      await registerData(Map<String, dynamic>.from(record));
    } catch (e) {
      CustomWidgets.snackBar(
          title: "Login failed. Please check your internet and try again.");
      if (kDebugMode) print(e);
    } finally {
      if (!willRegister) isLoading.value = false;
    }
  }

  void _setUserData(Map<String, dynamic> userData) {
    DataInfo.username.value = userNameController.text.trim();
    DataInfo.username1.value = userNameController.text.trim();
    DataInfo.password.value = passwordController.text.trim();
    DataInfo.profileName.value = userNameController.text.trim();
    DataInfo.userId.value = userData['UID'];
    DataInfo.profileId.value = userData['UID'];
    DataInfo.enrollId.value = userData['ENROLLID'];
    DataInfo.rollId.value = userData['ROLLID'];
    DataInfo.imageUrl.value = userData['IMGURL'];
    DataInfo.pid.value = userData['PID'];
    DataInfo.desCat.value = userData['DESCAT'];
    DataInfo.encKey.value = userData['ENCKEY'];
    DataInfo.tcId.value = userData['TCID'];
    DataInfo.titleId.value = userData['TITLEID'];
    DataInfo.box.write("status", 1);
    DataInfo.showData.value = DataInfo.desCat.value == "L1";
  }

  Future<void> registerData(Map<String, dynamic> userData) async {
    final notificationController = NotificationController();
    String? deviceToken = "";
    try {
      deviceToken = await notificationController.getToken();
    } catch (e) {
      if (kDebugMode) print(e);
    }

    final regData = {
      "Uid": DataInfo.userId.value,
      "tokenID": DataInfo.deviceId.value,
      "device": DataInfo.platform.value,
      "UUID": deviceToken,
    };
    try {
      final value = await Api().fetchApi(
        data: json.encode(regData),
        action: "REGISTERID",
        isSubmit: true,
      );
      if (value?.success == true) {
        await getUserData();
        isLoading.value = false;
        if (isRemember.value) {
          DataInfo.box.write("userId", DataInfo.userId.value);
          userData['username'] = DataInfo.username.value;
          // Password is stored separately in SecureCredentials, never in
          // the GetStorage userData JSON.
          userData.remove('password');
          DataInfo.box.write("userData", json.encode(userData));
          DataInfo.box.write("username", DataInfo.username.value);
          await SecureCredentials.savePassword(DataInfo.password.value);
        } else {
          userNameController.clear();
          passwordController.clear();
          await SecureCredentials.clear();
        }
        DataInfo.box.write("isRemember", isRemember.value);
        Get.offAll(() => const DashboardNew());
      } else {
        isLoading.value = false;
        CustomWidgets.snackBar(title: value?.message ?? 'Registration failed');
      }
    } catch (e, st) {
      isLoading.value = false;
      if (kDebugMode) {
        print('registerData error: $e');
        print(st);
      }
    }
  }

  Future<void> getUserData() async {
    try {
      final responseData = await Apis.sendData(
        DataInfo.username.value,
        "GETUSERDITAILS&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA",
      );
      final de = json.decode(responseData.body);
      if (de is List && de.isNotEmpty) {
        final data = de[0];
        DataInfo.box.write("userInfo", data);
        DataInfo.fullName.value = data['FULLNAME'].toString().trim();
        DataInfo.name.value = data['NAME'].toString().trim();
        DataInfo.designation.value = data['DESIGNATION'].toString().trim();
        DataInfo.mobile.value = data['MOBILE'].toString().trim();
        DataInfo.email.value = data['USEREMAIL'].toString().trim();
        DataInfo.aboutMe.value = data['ABOUTME'].toString().trim();
      } else {
        if (kDebugMode) debugPrint('getUserData unexpected response: $de');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('getUserData error: $e');
        print(st);
      }
    }
  }
}
