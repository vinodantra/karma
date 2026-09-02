// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
class VisitHistoryController extends GetxController{
  RxMap data  = {}.obs;
  RxString selectType = "1".obs;
  RxList<dynamic> list = [].obs;
  RxList<dynamic> proposalList = [].obs;
  RxString proformaData = "".obs;
  RxBool isLoading  = false.obs;
  @override
  void onInit() {
    data.value = (Get.arguments is Map) ? Map.from(Get.arguments) : {};
    getActivityData();
    super.onInit();
  }
  getActivityData()async{
    isLoading.value = true;

    Api().fetchApi(data:"${DataInfo.username.value}|${data['DPID']}",
        action: "CALLENTRYDETAILS").then((value) {
          try{
            if(value?.success == true){
              final jsonResponse = value!.data;
              if (jsonResponse is Map &&
                  jsonResponse['ROOT'] is List &&
                  (jsonResponse['ROOT'] as List).isNotEmpty) {
                final root = (jsonResponse['ROOT'] as List).first;
                list.value = (root is Map ? root['DETAILS'] : null) ?? [];
              } else {
                list.value = [];
              }
            }
            else
            {
              CustomWidgets.snackBar(title: "Failed to load visit history");
            }
          }catch(e){
            CustomWidgets.snackBar(title: "Something went wrong");
            if (kDebugMode) {
              print("error:$e");
            }
          } finally {
            isLoading.value = false;
          }
    });


  }
}