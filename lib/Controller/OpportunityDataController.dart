// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class OpportunityDataController extends GetxController {
  RxMap data = {}.obs;
  RxString selectType = "1".obs;
  RxList<dynamic> activityList = [].obs;
  RxList<dynamic> proposalList = [].obs;
  RxString proformaData = "".obs;

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

    getActivityData();
    getProposalData();
    getProformaData();
    super.onInit();
  }

  Future<void> getActivityData() async {
    try {
      final ApiResponse? res = await Api().fetchApi(
        data:
            json.encode({"OPPID": "${data['ID']}", "DPID": "${data['DPID']}"}),
        action: "OPPRECENTACTIVITY",
      );
      if (res?.success == true) {
        final jsonResponse = res!.data;
        if (jsonResponse is List) {
          activityList.value = jsonResponse;
        } else {
          activityList.value = [];
        }
      } else {
        activityList.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
      activityList.value = [];
    }
  }

  Future<void> getProposalData() async {
    try {
      final ApiResponse? res = await Api().fetchApi(
        data:
            json.encode({"OPPID": "${data['ID']}", "DPID": "${data['DPID']}"}),
        action: "PROPOSALLIST",
      );
      if (res?.success == true) {
        final jsonResponse = res!.data;
        if (jsonResponse is List) {
          proposalList.value = jsonResponse;
        } else {
          proposalList.value = [];
        }
      } else {
        proposalList.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
      proposalList.value = [];
    }
  }

  Future<void> getProformaData() async {
    try {
      final ApiResponse? res = await Api().fetchApi(
        data: json.encode({
          "OPPID": "${data['ID']}",
          "DPID": "${data['DPID']}",
          "ISMAIL": "220"
        }),
        action: "PREFORMAINVOIC",
      );
      if (res?.success == true) {
        final jsonResponse = res!.data;
        proformaData.value = jsonResponse?.toString() ?? '';
      } else {
        proformaData.value = '';
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
      proformaData.value = '';
    }
  }
}
