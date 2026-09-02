// ignore_for_file: file_names

import 'dart:developer';
import '../Constants/Library.dart';
class OutstandingController extends GetxController{
  RxList<dynamic> list = [].obs;
  RxString date = "".obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async{
    isLoading.value = true;
    hasError.value = false;
    try{
      await Future.delayed(const Duration(microseconds: 500));
      final value = await Api().fetchApi(
          data: json.encode({"UNAME":DataInfo.username.value,"UID":DataInfo.userId.value,"UST":"USER"}),
          action: "USEROUTSTANDING");

      if(value != null && value.success){
        date.value = value.data['LASTUPDATE'][0]['DATE'].toString();
        list.value = value.data['MIS'];
      }else{
        hasError.value = true;
      }
    }catch(e){
      log("error:$e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}