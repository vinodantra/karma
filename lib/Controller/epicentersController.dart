// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class EpicentersController extends GetxController {
  RxList<dynamic> mstdtlsList = [].obs;
  RxList<dynamic> list = [].obs;
  RxList<dynamic> epcdtlsList = [].obs;
  RxBool isLoading = false.obs;
  final search = TextEditingController();
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }

  void getData() async {
    isLoading.value = true;
    try {
      Api()
          .fetchApi(
              data: json.encode({
                "UID": DataInfo.userId.value,
                "UNAME": DataInfo.username.value
              }),
              action: "GETEPCDATA")
          .then((value) {
        if (value != null && value.success) {
          var response = value.data!;

          mstdtlsList.value = response['RESULT']['MSTDTLS'] ?? [];
          list.value = response['RESULT']['MSTDTLS'] ?? [];
          epcdtlsList.value = response['RESULT']['EPCDTLS'] ?? [];
          isLoading.value = false;
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: "Failed to load epicenter data");
        }
      });
    } catch (e) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "An error occurred while loading data");
    }
  }
}
