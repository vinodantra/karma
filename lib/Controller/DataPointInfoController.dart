// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class DataPointInfoController extends GetxController {
  RxMap data = {}.obs;
  RxBool isLoading = false.obs;
  RxMap info = {}.obs;
  RxList<dynamic> brochureList = [].obs;
  RxList<dynamic> emailList = [].obs;
  RxList<dynamic> addressList = [].obs;
  RxString selectBrochure = "Select".obs;
  RxString selectBrochureId = "".obs;
  RxString selectEmail = "Select".obs;
  RxString selectId = "".obs;
  RxString selectCntName = "".obs;
  RxBool showBrochure = false.obs;
  RxBool showEmail = false.obs;

  @override
  void onInit() {
    data.value = Get.arguments;
    fetchData();

    super.onInit();
  }

  Future<void> fetchData() async {
    List<Future> apis = [
      getData(),
      getAddressDetails(),
      getBrochureData(),
      getEmailData(),
    ];
    isLoading.value = true;
    await Future.wait(apis);
    isLoading.value = false;
  }

  getData() async {
    Api()
        .fetchApi(
            data: json.encode({"DPID": data['DPID'].toString()}),
            action: "GETDPINF")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          var data1 = jsonResponse['records'][0];
          info.value = data1;

          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  getAddressDetails() async {
    Api()
        .fetchApi(data: data['DPID'].toString(), action: "GETCALLENTRYDATA")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          var data1 = jsonResponse['ROOT'][0]['ADDRESS'];
          //info.value = data1;
          addressList.value = data1;
          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  getBrochureData() async {
    Api().fetchApi(action: "BROCHUREMASTER").then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          brochureList.value = jsonResponse;

          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  getEmailData() async {
    Api()
        .fetchApi(data: data['DPID'].toString(), action: "GETUSER")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          emailList.value = jsonResponse['records'];

          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  void sendData() async {
    isLoading.value = true;

    Api()
        .fetchApi(
            data: json.encode({
              "CNTNAME": selectCntName.value.trim(),
              "CNTEMAIL": selectEmail.value.trim(),
              "OWNEREMAIL": info['CONTEMAIL1'].trim(),
              "BROCHURE": selectBrochure.value,
              "BROCHUREID": selectBrochureId.value,
              "DPID": data['DPID']
            }),
            action: "BROCHEREMAIL")
        .then((value) {
      try {
        if (value != null && value.success) {
          isLoading.value = false;
          update();
          CustomWidgets.snackBar(title: "Brochure sent successfully");
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: "Failed to send brochure");
        }
      } catch (e) {
        isLoading.value = false;
        CustomWidgets.snackBar(title: "Something went wrong");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }
}
