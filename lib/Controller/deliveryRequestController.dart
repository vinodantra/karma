// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class DeliveryRequestController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap data = {}.obs;
  RxList<dynamic> list = [].obs;
  RxString selectPrdId = "".obs;
  @override
  void onInit() {
    data.value = Get.arguments;

    getData();
    super.onInit();
  }

  void getData() async {
    isLoading.value = true;

    Api()
        .fetchApi(
            data: json.encode({"UID": data['CREATEDBY']}),
            action: "DELIVERYREQDATA")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;
          var data = jsonResponse['ROOT'][0]['DETAILS'];
          list.value = data;

          isLoading.value = false;
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: "Failed to load delivery requests");
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

  showProduct(int index) {
    if (selectPrdId.value != list[index]['REQID']) {
      selectPrdId.value = list[index]['REQID'];
    } else {
      selectPrdId.value = "";
    }
    update();
  }
}
