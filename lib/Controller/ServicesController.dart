// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class ServicesController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap data = {}.obs;
  RxList<dynamic> boosterList = [].obs;
  RxList<dynamic> addonsList = [].obs;
  @override
  void onInit() {
    data.value = Get.arguments;
    getData(data);
    super.onInit();
  }

  void getData(var data) async {
    isLoading.value = true;

    Api()
        .fetchApi(
            data: json.encode({"DPID": data['DPID']}),
            action: "GETDPPRODUCTINFO")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;
          addonsList.value = jsonResponse['ADDONS'] ?? [];
          if (jsonResponse.containsKey('BOOSTER')) {
            boosterList.value = jsonResponse['BOOSTER'] ?? [];
          }

          isLoading.value = false;
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: "Failed to load products");
        }
      } catch (e) {
        isLoading.value = false;
        CustomWidgets.snackBar(title: "Something went wrong");
        CustomWidgets.snackBar(title: "Something went wrong");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }
}
