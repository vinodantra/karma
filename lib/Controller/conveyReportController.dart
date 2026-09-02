// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';
class ConveyReportController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> listData = [].obs;

  RxString selectDate = DateFormat('MMM yyyy')
      .format(DateTime.now()).obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      // fire-and-forget user details
      Api().fetchApi(data: DataInfo.username.value, action: "GETUSERDITAILS");

      final value = await Api().fetchApi(
          data: json.encode({
            "UNAME": DataInfo.username.value,
            "FROMDATE": "1 ${selectDate.value}"
          }),
          action: "CONVREPORT");
      if (value != null && value.success) {
        var response = value.data!;
        listData.value = response;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

}