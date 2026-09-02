// ignore_for_file: file_names




import '../Constants/Library.dart';
class EpicentersPage2Controller extends GetxController{
  RxMap<String,dynamic> args = <String,dynamic>{}.obs;

  RxList<dynamic> list = [].obs;
  RxList<dynamic> list1 = [].obs;
  RxList<dynamic> listData = [].obs;
  RxString id = "".obs;
  final search =  TextEditingController();
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;


  @override
  void onInit() {
    args.value = Get.arguments;
    args.value = Get.arguments ?? {};
    id.value = (args['id'] ?? '').toString();
    list1.value = (args['data'] ?? []) as List<dynamic>;
    getData();

    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    hasError.value = false;
    try {
      final filtered = list1
          .where((element) => element['EPIID'].toString() == id.value)
          .toList();
      list.value = filtered;
      listData.value = filtered;
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) {
        print("EpicentersPage2 getData error: $e");
      }
    }
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}