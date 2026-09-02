// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class CreateLeadController extends GetxController {
  RxMap data = {}.obs;
  RxList<dynamic> list = [].obs;
  RxString selectData = "Select".obs;
  RxString selectId = "".obs;
  RxBool isLoading = false.obs;
  TextEditingController contactName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController remark = TextEditingController();
  RxList<dynamic> leadList = [].obs;
  RxList<dynamic> itemList = [].obs;
  RxString selectItem = "Select".obs;
  RxString selectItemId = "".obs;

  @override
  void onInit() {
    data.value = Get.arguments;

    contactName.text = data['CONPER'].toString();
    contactNumber.text = data['MOB'].toString();
    email.text = data['CMPEMAIL'].toString();

    getData();
    getLeadData();
    getCityList();
    super.onInit();
  }

  @override
  void onClose() {
    contactName.dispose();
    contactNumber.dispose();
    email.dispose();
    city.dispose();
    remark.dispose();
    super.onClose();
  }

  getData() async {
    Api().fetchApi(action: "LEADSRC").then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;
          list.value = jsonResponse['ROOT'][0]['INTRST'];
        }
      } catch (e) {
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  void checkData() {
    isLoading.value = true;
    if (Utilities.checkString(selectId.value) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please select Interested In");
    } else if (Utilities.checkString(selectItemId.value) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please select Item");
    } else {
      uploadData();
    }
  }

  uploadData() async {
    Loader();
    try {
      Api()
          .fetchApi(
              data: Uri.encodeComponent(json.encode({
                "CMPNAME": data['CMP'],
                "CONTACTNAME": contactName.text.trim(),
                "CONTACTNUMBER": int.parse(contactNumber.text.trim()),
                "EMAIL": email.text.trim(),
                "CITY": city.text.trim(),
                "TALLYSERIAL":
                    Utilities.checkString(data['TALLYSRLNO'].toString())
                        ? int.parse(data['TALLYSRLNO'].toString())
                        : "",
                "COMMENT": remark.text.trim(),
                "LEADSOURCE": "Cust. Reference",
                "UID": DataInfo.userId.value,
                "SELECTEDLEAD": "22",
                "INTERESTID": selectId.value,
                "TALLYACTID": "",
                "TALLYNATUREID": "",
                "TALLYTYPEID": "",
                "TALYYINTERESTID": "",
                "STKID": selectItemId.value
              })),
              action: "NEWLEAD")
          .then((value) {
        if (value != null && value.success) {
          var response = value.data!;

          var data = response['records'][0];
          Loader().hide();
          if (data['STATUS'] == "Yes") {
            Get.dialog(
              Center(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.lightGreen,
                        size: 50,
                      ),
                      20.heightBox,
                      TextWidget(
                        "Well Done!",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      15.heightBox,
                      TextWidget(
                        "Successfully Updated.",
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      20.heightBox,
                      CustomButton(
                        text: "Ok",
                        onPressed: () {
                          Get.back();
                          // Get.offAll(()=>  const Lead(),arguments: data);
                        },
                      ),
                      10.heightBox,
                    ],
                  ).p24(),
                ),
              ),
              barrierDismissible: false,
            ).then((value) {
              Get.back();

              // Get.offAll(()=>  const Lead(),arguments: data);
            });
            isLoading.value = false;
          } else {
            Loader().hide();
            isLoading.value = false;
            CustomWidgets.snackBar(title: data['DPNAME'].toString());
          }
        } else {
          Loader().hide();
          isLoading.value = false;
        }
      });
    } catch (e) {
      Loader().hide();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getLeadData() async {
    Api().fetchApi(action: "LEADSRC").then((value) {
      if (value != null && value.success) {
        var response = value.data!;

        leadList.value = response['ROOT'][0]['LEDSRC'];
        itemList.value = response['ROOT'][0]['STKMAST'];
      } else {
        isLoading.value = false;
      }
    });
  }

  void getCityList() async {
    Api()
        .fetchApi(
            data: json.encode({"TALLYSRNO": data['TALLYSRLNO'].toString()}),
            action: "GETTALLYSRLOC")
        .then((value) {
      if (value != null && value.success) {
        var response = value.data!;

        city.text = response['records'][0]['LOCATION'].toString().trim();
      } else {
        isLoading.value = false;
      }
    });
  }
}
