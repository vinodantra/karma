// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class TicketController extends GetxController {
  RxMap data = {}.obs;

  RxList<dynamic> list = [].obs;
  RxList<dynamic> list1 = [].obs;
  TextEditingController searchController = TextEditingController();
  RxString search = "".obs;
  RxString selectData = "All".obs;

  RxBool isLoading = false.obs;
  @override
  void onInit() {
    data.value = Get.arguments;
    getActivityData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> getActivityData() async {
    isLoading.value = true;
    try {
      var responseData = await Apis.sendData5(
        "GETSUPPALLTICKET|30|${DataInfo.dpId.value}",
      );
      if (responseData != null) {
        var jsonResponse = json.decode(responseData.body);
        list.value = jsonResponse['records'] ?? [];
        list1.value = jsonResponse['records'] ?? [];

        isLoading.value = false;
      } else {
        isLoading.value = false;
        CustomWidgets.snackBar(title: "Failed to load tickets");
      }
    } catch (e) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Something went wrong");
      if (kDebugMode) {
        print("error:$e");
      }
    }
  }

  filterDataList() {
    list.value = selectData.value != "All"
        ? list1
            .where((element) =>
                (element['TICKET']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(search.value.trim().toLowerCase()) ||
                    element['CAT']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(search.value.trim().toLowerCase()) ||
                    element['CREATEDBY']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(search.value.trim().toLowerCase())) &&
                element['STATUS'] == selectData.value)
            .toList()
        : list1
            .where((element) =>
                element['TICKET']
                    .toString()
                    .trim()
                    .toLowerCase()
                    .contains(search.value.trim().toLowerCase()) ||
                element['CAT']
                    .toString()
                    .trim()
                    .toLowerCase()
                    .contains(search.value.trim().toLowerCase()) ||
                element['CREATEDBY']
                    .toString()
                    .trim()
                    .toLowerCase()
                    .contains(search.value.trim().toLowerCase()))
            .toList();
  }

  String checkDate(date) {
    try {
      String result = date.replaceFirst(RegExp(r':(?!.*:)'), '');
      return result;
    } catch (e) {
      return date;
    }
  }
}
