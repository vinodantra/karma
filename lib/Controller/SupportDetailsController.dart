// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class SupportDetailsController extends GetxController {
  RxMap callId = {}.obs;
  RxBool isLoading = false.obs;
  RxMap details = {}.obs;
  @override
  void onInit() {
    callId.value = Get.arguments;
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading.value = true;
    Api().fetchApi(data: callId['ID'], action: "SUPENTRY").then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          if (jsonResponse != null &&
              jsonResponse['ROOT'] != null &&
              jsonResponse['ROOT'].isNotEmpty &&
              jsonResponse['ROOT'][0]['DETAILS'] != null &&
              jsonResponse['ROOT'][0]['DETAILS'].isNotEmpty) {
            details.value = jsonResponse['ROOT'][0]['DETAILS'][0];
          } else {
            // Handle invalid response
          }

          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        Get.snackbar(
            "Error", "Failed to load support details. Please try again.");
        isLoading.value = false;
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }
}
