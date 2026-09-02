// ignore_for_file: file_names
import 'package:karma/Constants/Library.dart';

class StatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<dynamic> reasonList = [].obs;
  RxString selectStatusId = "".obs;
  RxString selectStatus = "".obs;
  RxString selectReasonId = "".obs;
  RxString selectReason = "".obs;
  RxString selectPostponedDate = "".obs;
  RxMap data = {}.obs;
  final remarkController = TextEditingController();
  RxList<dynamic> statusList = [
    {"ID": "1", "NAME": "Close Dropped"},
    {"ID": "2", "NAME": "Close Lost"},
    {"ID": "3", "NAME": "Postponed"},
    {"ID": "4", "NAME": "Duplicate"},
  ].obs;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      try {
        data.value = Map<String, dynamic>.from(args);
      } catch (_) {
        data.value = {};
      }
    } else {
      data.value = {};
    }
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    try {
      final ApiResponse? res = await Api().fetchApi(action: "CLOSEREASONMAST");
      if (res?.success == true) {
        final d = res!.data;
        if (d is List) {
          reasonList.value = d;
        } else {
          reasonList.value = [];
        }
      } else {
        reasonList.value = [];
      }
    } catch (e) {
      if (kDebugMode) print(e);
      reasonList.value = [];
    } finally {
      isLoading.value = false;
      update();
    }
  }

  checkData() {
    if (selectStatusId.value.isEmpty) {
      CustomWidgets.snackBar(title: "Please select Status");
    } else if (selectStatusId.value == "3" &&
        selectPostponedDate.value.isEmpty) {
      CustomWidgets.snackBar(title: "Please select Postponed date");
    } else if (selectReasonId.value.isEmpty) {
      CustomWidgets.snackBar(title: "Please select close reason");
    } else if (remarkController.text.trim().isEmpty) {
      CustomWidgets.snackBar(title: "Please enter close remark");
    } else {
      updateStatus();
    }
  }

  // 20231201 ; 1 Dec 2023
  Future<void> updateStatus() async {
    isLoading.value = true;
    try {
      final payload = json.encode({
        "DPID": data['DPID']?.toString() ?? "",
        "OPPID": data['ID']?.toString() ?? "",
        "STATUS": selectStatus.value,
        "REASONID": selectReasonId.value,
        "REMARK": remarkController.text.trim(),
        "POSDATE": selectPostponedDate.value.isNotEmpty
            ? selectPostponedDate.value
            : ""
      });
      final ApiResponse? res =
          await Api().fetchApi(data: payload, action: "OPPSTATUSUPDATE");
      if (res?.success == true) {
        final r = res!.data;
        if (r == "Yes") {
          isLoading.value = false;
          update();
          Get.back(result: true);
          return;
        }
      }
      isLoading.value = false;
      update();
    } catch (e) {
      if (kDebugMode) print(e);
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    try {
      remarkController.dispose();
    } catch (_) {}
    super.onClose();
  }
}
