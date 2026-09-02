// ignore_for_file: file_names

import 'package:karma/Controller/NotificationListProvider.dart';
import 'package:karma/Services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/Library.dart';

class NotificationListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> list = [].obs;

  RxInt badgesCount = 0.obs;
  RxBool isReadNotification = false.obs;
  @override
  void onInit() {
    // Get.find<DashboardController>().badgesCount = 0;
    DataInfo.isReadNotification.value = true;
    isReadNotification.value = true;
    getData();

    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      list.clear();
      update();
      await SharedPrefHelper.saveBool("isReadNotification", true);

      await Future.delayed(const Duration(seconds: 1));

      String? data = await SharedPrefHelper.getString(DataInfo.notificationKey);

      if (data != null) {
        try {
          final parsed = json.decode(data);
          if (parsed is List) {
            DataInfo.notificationList = parsed;
            try {
              DataInfo.notificationList.sort((a, b) {
                try {
                  return DateTime.parse(b['date'].toString())
                      .compareTo(DateTime.parse(a['date'].toString()));
                } catch (_) {
                  return b.toString().compareTo(a.toString());
                }
              });
            } catch (_) {
              // ignore sort errors
            }
            list.value = DataInfo.notificationList;
            update();
          }
        } catch (e) {
          if (kDebugMode) debugPrint('notification parse error: $e');
          hasError.value = true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      hasError.value = true;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> clearNotification() async {
    list.clear();
    // DataInfo.notificationList.clear();
    await SharedPrefHelper.remove(DataInfo.notificationKey);
    // DataInfo.box.remove(DataInfo.notificationKey);
    update();
  }

  Future<void> removeItemData({required int index}) async {
    int i = index;
    list.removeAt(i);

    await SharedPrefHelper.saveString(
        DataInfo.notificationKey, json.encode(list));
    // DataInfo.box.write(DataInfo.notificationKey,list);
    update();
  }

  Future<void> updateNotificationBadgesCount() async {
    badgesCount.value = 0;
    isReadNotification.value = true;
    DBHelper().markAllAsRead();
    await SharedPrefHelper.saveBool("isReadNotification", true);
    await PrefsService().setNotificationCount(0);
    final ctx = DataInfo.navKey.currentContext;
    if (ctx != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          ctx
              .read<NotificationListProvider>()
              .updateNotificationData(list: list, count: 0);
        } catch (e) {
          if (kDebugMode) debugPrint('provider update error: $e');
        }
      });
    }
  }
}

class PrefsService {
  static final PrefsService _instance = PrefsService._internal();

  factory PrefsService() => _instance;

  PrefsService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int getNotificationCount() {
    return _prefs.getInt("badgesCount") ?? 0;
  }

  Future<void> setNotificationCount(int count) async {
    await _prefs.setInt("badgesCount", count);
  }

  Future<void> setNotificationData(List<dynamic> list) async {
    await _prefs.setString(DataInfo.notificationKey, json.encode(list));
  }

  List<dynamic> getNotificationData() {
    try {
      String? data = _prefs.getString(DataInfo.notificationKey);
      if (data != null) {
        List<dynamic> de = json.decode(data);
        return de;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
