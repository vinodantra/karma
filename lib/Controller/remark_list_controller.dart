import 'package:karma/Constants/Library.dart';

class RemarkListController extends GetxController{
  RxList<dynamic> remarkList = [].obs;
  RxString ticketId  = "".obs;
  RxBool isLoading =  false.obs;
  RxBool hasError = false.obs;

  @override
  void onInit() {

    if(Get.arguments != null){
      ticketId.value = Get.arguments;
      update();
    }
    getList();
    super.onInit();
  }

  Future<void> onRefresh() async => getList();

  Future<void> getList() async {
    isLoading.value = true;
    hasError.value = false;
    update();
    try {
      final value = await Api().fetchApi(
          data: json.encode({
            "tckid": ticketId.value,
          }),
          action: "ANTRATICKETREMARK");
      if (value != null && value.success) {
        var jsonData = value.data;
        if (jsonData['statuscode'] == 1) {
          remarkList.value = json.decode(jsonData['data']);
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
