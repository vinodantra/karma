// ignore_for_file: file_names

import '../Constants/Library.dart';
class TargetReportController extends GetxController{
  RxMap<String,dynamic> args = <String,dynamic>{}.obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> listData = [].obs;
  RxString selectData = "Current".obs;
  RxString selectId =  "1".obs;
  RxString selectUser = DataInfo.username.value.obs;
  RxString selectUserId = DataInfo.userId.value.obs;
  RxList<dynamic> userList = [].obs;
  RxList<dynamic> filterUserList = [].obs;
  RxList<dynamic> filterList = [{"ID":"1","NAME":"Current"},{"ID":"0","NAME":"Previous"}].obs;
  @override
  void onInit() {
    args.value = Get.arguments;
    getData();
    getUserData();
    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    Map<String, dynamic> data;
    isLoading.value = true;
    hasError.value = false;
    listData.value = [];
    if (args['action'] == "SLSREPORT") {
      data = {
        "UID": selectUserId.value,
        "WEEK": int.parse(selectId.value),
        "TEAMLEAD": args['teamlead']
      };
    } else if (args['action'] == "SLSMONTHREPORT") {
      data = {
        "UID": selectUserId.value,
        "MONTH": int.parse(selectId.value)
      };
    } else {
      data = {
        "UID": selectUserId.value,
        "MONTH": int.parse(selectId.value)
      };
    }
    try {
      final value = await Api()
          .fetchApi(data: json.encode(data), action: args['action']);
      if (value != null && value.success) {
        var response = value.data!;
        listData.value = response;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  getUserData() async {
    Api().fetchApi(data: DataInfo.userId.value,action: "TEAMMEMBER").then((value) {
      if(value != null && value.success) {
        var response = value.data!;

        userList.value = response;
        filterUserList.value = response;
        isLoading.value = false;

      }

    });

  }
}