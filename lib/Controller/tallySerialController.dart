// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class TallySerialController extends GetxController {
  RxMap data = {}.obs;
  RxList<dynamic> tallySerialList = [].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    data.value = Get.arguments;
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading.value = true;

    Api()
        .fetchApi(data: data['DPID'].toString(), action: "GETCALLENTRYDATA")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          var jsonData = jsonResponse['ROOT'][0];

          tallySerialList.value = jsonData['TALLYSRNO'] ?? [];

          isLoading.value = false;
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: "Failed to load tally serials");
        }
      } catch (e) {
        isLoading.value = false;
        CustomWidgets.snackBar(title: "Something went wrong");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }
}
