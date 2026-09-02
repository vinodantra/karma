import '../Constants/Library.dart';


class PblController extends GetxController{
  RxBool isLoading=true.obs;
  RxBool hasError = false.obs;
  RxList ansData = [].obs;
  RxList list = [].obs;
  RxList usersList = [].obs;
  RxString userName = 'Select User'.obs;
  RxString id = ''.obs;
  @override
  void onInit() {

    super.onInit();
    // getUserList();
    getAnsData();
  }
  changeData(){
    ansData.value = list.where((element)=>element['PersonName'] == userName.value).toList();
    update();
  }

  Future<void> onRefresh() async => getAnsData();

  getAnsData() async {


    isLoading.value = true;
    hasError.value = false;
    update();
    await Future.delayed(const Duration(milliseconds: 100));
    Loader();
    try {
      var value = await Api().fetchApi(
        data: json.encode({"login_id": DataInfo.userId.value}),
        action: "GETPBL",
      );

      if (value != null && value.success) {
        var jsonResponse = value.data;
        ansData.value = json.decode(jsonResponse['data']);
        list.value = json.decode(jsonResponse['data']);
        for(int i = 0;i<list.length;i++){
          if(list.isNotEmpty){
            if(usersList.any((element) => element['NAME'] == list[i]['PersonName']) == false){
              usersList.add({"ID":"1","NAME":list[i]['PersonName']});
            }
          }else{
            usersList.add({"ID":"1","NAME":list[i]['PersonName']});
          }
        }



        update();
      } else {
        ansData.value = [];
        hasError.value = true;
        update();

      }
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) {
        print("Error occurred: $e");
        update();
      }
    } finally {
      isLoading.value = false;
      Loader().hide();
      update();
    }
  }

  getUserList() async {

    isLoading.value = true;

    try {
      var value = await Api().fetchApi(
        data: json.encode({"login_id": DataInfo.userId.value}),
        action: "ANSUSER",
      );

      if (value != null && value.success) {
        var jsonResponse = value.data;
        usersList.value = json.decode(jsonResponse['data']);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}