// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
class ProductController extends GetxController{
  RxString selectTab = "1".obs;
  TextEditingController searchController = TextEditingController();
  RxList<dynamic> modelList = [].obs;
  RxList<dynamic> categoryList = [].obs;
  RxList<dynamic> boostersList = [].obs;
  RxList<dynamic> appList = [].obs;
  RxList<dynamic> list1 = [].obs;
  RxList<dynamic> list2 = [].obs;
  RxList<dynamic> list3 = [].obs;

  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString selectCategoryId = "".obs;
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async => fetchData();

  void fetchData() async{
    isLoading.value = true;
    hasError.value = false;
    try {
      var responseData1 = await Apis.sendData1(
          "",
          "GETMODULELIST&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");
      if(responseData1 != null)
        {
          var jsonData = json.decode(responseData1.body);
          modelList.value = jsonData['records'];
          list1.value = jsonData['records'];
        }
      else
        {
          hasError.value = true;
        }


      var responseData2 = await Apis.sendData1(
          "",
          "GETAPPLIST&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");

      if(responseData2 != null)
      {
        var jsonData = json.decode(responseData2.body);
        appList.value = jsonData['records'];
        list3.value = jsonData['records'];
      }
      else
      {
        hasError.value = true;
      }



      var responseData4 = await Apis.sendData1(
          "",
          "GETBOOSTERCAT&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");
      if(responseData4 != null)
      {
        var jsonData = json.decode(responseData4.body);
        categoryList.value = jsonData['records'];
        if (categoryList.isNotEmpty) {
          selectCategoryId.value = categoryList.first['ID'].toString();
          await getBoosterData(selectCategoryId.value);
        }
      }
      else
      {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) {
        print("Products fetchData error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
  getBoosterData(String id) async{
    boostersList.value = [];
    var responseData = await Apis.sendData2(
        "GETBOOSTERLIST||$id&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");
    if(responseData != null)
    {
      var jsonData = json.decode(responseData.body);
      boostersList.value = jsonData['records'];
      list2.value = jsonData['records'];


      isLoading.value = false;
    }
    else
    {
      isLoading.value = false;
    }
    isLoading.value = false;
  }
  void searchData(String search){
    if(selectTab.value == "1")
      {
        modelList.value = list1.where((element) => element['MODULENAME'].toString().toLowerCase().contains(search.trim().toLowerCase())).toList();
      }
    else if(selectTab.value == "2")
      {
        boostersList.value = list2.where((element) => element['MODULENAME'].toString().toLowerCase().contains(search.trim().toLowerCase())).toList();
      }
    else
      {
        appList.value = list3.where((element) => element['MODULENAME'].toString().toLowerCase().contains(search.trim().toLowerCase())).toList();
      }
    update();
  }
}