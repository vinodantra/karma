// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class ContactDetailsController extends GetxController {
  RxList<dynamic> contactList = [].obs;
  RxBool isLoading = false.obs;

  RxMap data = {}.obs;
  List<dynamic> salutationList = [
    {"ID": "1", "NAME": "Mr."},
    {"ID": "2", "NAME": "Mrs"},
    {"ID": "3", "NAME": "Miss"},
    {"ID": "4", "NAME": "Smt."},
    {"ID": "5", "NAME": "Shri."},
  ];
  RxString selectSalutation = "Select".obs;

  final name = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final designation = TextEditingController();
  @override
  void onInit() {
    data.value = (Get.arguments is Map) ? Map.from(Get.arguments) : {};
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    mobile.dispose();
    designation.dispose();
    super.onClose();
  }

  void getData() async {
    isLoading.value = true;

    Api()
        .fetchApi(data: data['DPID'].toString(), action: "GETUSER")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          var data = jsonResponse['records'];
          contactList.value = data;

          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  addContact(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Loader();
    Api()
        .fetchApi(
            data: json.encode({
              "DPID": data['DPID'],
              "UID": DataInfo.userId.value,
              "SALUTATION": selectSalutation.value,
              "NAME": name.text,
              "NUMBER": mobile.text,
              "EMAIL": email.text,
              "DESIGNATION": designation.text
            }),
            action: "ADDCONTACT")
        .then((value) {
      try {
        if (value != null && value.success) {
          Loader().hide();
          var jsonResponse = value.data;

          if (jsonResponse.toString() == "Yes") {
            Get.back();
            getData();
          } else {
            CustomWidgets.snackBar(title: jsonResponse.toString());
          }
        } else {
          var jsonResponse = value?.data;

          VxToast.show(context,
              msg: jsonResponse.toString(),
              bgColor: Colors.black,
              textColor: Colors.white);

          Loader().hide();
        }
      } catch (e) {
        Loader().hide();
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }
}
