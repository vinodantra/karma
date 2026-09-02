// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class MyCustomerCallController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> customerList = [].obs;
  RxString selectUser = "Select User".obs;
  RxString selectUserId = "".obs;
  final remark = TextEditingController();
  RxString error = "".obs;

  Future<void> onRefresh() async => getData(selectUserId.value.isEmpty
      ? DataInfo.userId.value
      : selectUserId.value);

  @override
  void onInit() {
    getData(DataInfo.userId.value);
    super.onInit();
  }

  @override
  void onClose() {
    remark.dispose();
    super.onClose();
  }

  getData(String id) {
    selectUserId.value = id;
    customerList.value = [];
    hasError.value = false;

    isLoading.value = true;
    Api()
        .fetchApi(data: json.encode({"UID": id}), action: "MYCALLDTLS")
        .then((value) {
      try {
        if (value != null && value.success) {
          final response = value.data;
          if (response is Map && response['records'] is List) {
            customerList.value = List<dynamic>.from(response['records']);
          }
        } else {
          hasError.value = true;
        }
      } catch (e) {
        hasError.value = true;
        if (kDebugMode) print(e);
      } finally {
        isLoading.value = false;
      }
    });
  }

  cancelCall(String id) async {
    isLoading.value = true;
    Api()
        .fetchApi(
            data: json.encode({"CALLID": id, "REMARK": remark.text.trim()}),
            action: "SUPCALLCANCEL")
        .then((value) {
      try {
        remark.text = "";
        if (value != null && value.success) {
          getData(selectUserId.value);
        } else {
          isLoading.value = false;

          CustomWidgets.snackBar(title: value?.data['msg'].toString() ?? "");
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to cancel call. Please try again.");
        if (kDebugMode) {
          print(e);
        }
        isLoading.value = false;
      }
    });
  }

  Color checkColor(String status) {
    if (status == "Resolved") {
      return Colors.green;
    } else if (status == "Pending") {
      return Colors.red;
    } else {
      return descriptionColor;
    }
  }

  deleteCall(Map<String, dynamic> data) {
    if (checkDate(date: data['NEWECALLDATE']) == false) {
      remark.text = "";

      CustomWidgets.snackBar(
          title:
              "⚠️ Oops! Cancellation is only allowed up to 3 hours before the call.");
    } else if (remark.text.trim().isEmpty) {
      error.value = 'Please enter remark';
      CustomWidgets.snackBar(title: error.value);
    } else {
      Get.back();
      cancelCall(data['CALLID'].toString());
    }
  }

  bool checkDate({required String date}) {
    try {
      // DateFormat format = DateFormat("MMM  d yyyy  h:mma");
      // DateTime targetDate = format.parse(date); // Convert to DateTime
      DateTime targetDate = DateTime.parse(date);
      DateTime now = DateTime.now(); // Current date and time

      // Check if the target date is after now
      bool isAfterNow = targetDate.isAfter(now);

      // Calculate the difference in days
      int differenceInHours = targetDate.difference(now).inHours;
      bool showData = false;

      if (isAfterNow == true && differenceInHours >= 3) {
        showData = true;
      } else {
        showData = false;
      }
      return showData;
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
      return false;
    }
  }

  bool showIcon({required String date}) {
    try {
      DateTime selectDate = DateTime.parse(date);
      if (selectDate.isAfter(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
