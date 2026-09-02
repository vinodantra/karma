// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class SupportController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> list = [].obs;
  RxList<dynamic> list1 = [].obs;
  final ScrollController scrollController = ScrollController();
@override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final value = await Api().fetchApi(data: "", action: "AVAILABLEUSER");
      if (value != null && value.success) {
        var jsonResponse = value.data;
        list.value = jsonResponse['Table'];
        list1.value = jsonResponse['Table1'];
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) {
        print("error:$e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}