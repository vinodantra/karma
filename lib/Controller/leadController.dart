// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class LeadController extends GetxController {
  RxList<dynamic> filterData = [
    {"ID": "1", "NAME": "Given"},
    {"ID": "2", "NAME": "Received"},
  ].obs;
  RxMap<String, dynamic> leadData = <String, dynamic>{}.obs;
  RxBool isLoading = false.obs;
  RxString selectFilterData =
      DataInfo.desCat.value == "L1" ? "Received".obs : "Given".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading.value = true;
    leadData.value = {};
    try {
      await Future.delayed(const Duration(seconds: 2));
      final resp = await Api().fetchApi(
          data: json.encode({
            "LEADTYPE": selectFilterData.value.toUpperCase(),
            "UID": DataInfo.userId.value
          }),
          action: "LEADDASHBOARD");
      if (resp?.success == true) {
        final response = resp!.data;
        if (response is Map &&
            response['ROOT'] is List &&
            (response['ROOT'] as List).isNotEmpty) {
          final root0 = (response['ROOT'] as List)[0];
          if (root0 is Map &&
              root0.containsKey('DETAILS') &&
              root0['DETAILS'] is List &&
              (root0['DETAILS'] as List).isNotEmpty) {
            leadData.value =
                (root0['DETAILS'] as List)[0] as Map<String, dynamic>;
          } else {
            leadData.value = {};
          }
        } else {
          leadData.value = {};
        }
      } else {
        leadData.value = {};
      }
    } catch (e, st) {
      debugPrint('LeadController.getData error: $e');
      debugPrint(st.toString());
      leadData.value = {};
    } finally {
      isLoading.value = false;
    }
  }
}
