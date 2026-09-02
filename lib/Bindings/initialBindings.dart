// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/NotificationListController.dart';


class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController(),permanent: true);
    Get.put(LoginController());
    Get.put(AppTheme());
    Get.put(NotificationListController());
    // Get.lazyPut(() => DeviceInfo());
    // Get.lazyPut(() => UserInfo());


  }
}