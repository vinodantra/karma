// ignore_for_file: file_names



import 'package:karma/Constants/Library.dart';

class SupportListController extends GetxController {
  RxMap callId = {}.obs;
  RxList<dynamic> supportEntries = [].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  @override
  void onInit() {
    callId.value = Get.arguments;
    getData();
    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final value =
          await Api().fetchApi(data: callId['ID'], action: "EXISTSUPENTRY");
      if (value != null && value.success) {
        var jsonResponse = value.data;
        if (jsonResponse != null &&
            jsonResponse['ROOT'] != null &&
            jsonResponse['ROOT'].isNotEmpty &&
            jsonResponse['ROOT'][0] != null &&
            jsonResponse['ROOT'][0]['DETAILS'] != null) {
          supportEntries.value = jsonResponse['ROOT'][0]['DETAILS'];
        } else {
          supportEntries.value = [];
        }
      } else {
        supportEntries.value = [];
        hasError.value = true;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load support list. Please try again.");
      hasError.value = true;
      if (kDebugMode) {
        print("error:$e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    getData();
  }
}
