// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class CreateLeadController1 extends GetxController {
  RxBool isLoading = false.obs;
  RxList<dynamic> leadSourceList = [].obs;
  RxList<dynamic> interestedDataList = [].obs;
  RxList<dynamic> itemList = [].obs;
  RxString selectLeadSourceData = "Select".obs;
  RxString selectLeadSourceId = "".obs;
  RxString selectInterestedData = "Select".obs;
  RxString selectInterestedId = "".obs;
  RxString selectItemData = "Select".obs;
  RxString selectItemId = "".obs;
  TextEditingController companyName = TextEditingController();
  TextEditingController contactName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController tallySerialNumber = TextEditingController();
  TextEditingController comment = TextEditingController();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading.value = true;
    Api().fetchApi(data: "", action: "LEADSRC").then((value) {
      if (value != null && value.success) {
        var response = value.data!;
        var data = response['ROOT'][0];
        leadSourceList.value = data['LEDSRC'];
        interestedDataList.value = data['INTRST'];
        itemList.value = data['STKMAST'];
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    });
  }

  void checkData() {
    isLoading.value = true;
    if (Utilities.checkString(selectLeadSourceId.value) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please select Lead Source");
    } else if (Utilities.checkString(selectInterestedId.value) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please select Interested In");
    } else if (Utilities.checkString(selectItemId.value) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please select Item");
    } else if (Utilities.checkString(companyName.text.trim()) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please enter Company Name");
    } else if (Utilities.checkString(companyName.text.trim()) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please enter Contact Name");
    } else if (Utilities.checkString(contactNumber.text.trim()) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please enter Contact Number");
    } else if (Utilities.checkString(email.text.trim()) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please enter Email");
    } else if (Utilities.checkString(city.text.trim()) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please enter City");
    } else if (Utilities.checkString(tallySerialNumber.text.trim()) == false) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Please enter Tally Serial Number");
    } else {
      uploadData();
    }
  }

  uploadData() async {
    final contactNum = int.tryParse(contactNumber.text.trim());
    if (contactNum == null) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Invalid contact number");
      return;
    }
    final tallyNum = int.tryParse(tallySerialNumber.text.trim());
    if (tallyNum == null) {
      isLoading.value = false;
      CustomWidgets.snackBar(title: "Invalid tally serial number");
      return;
    }

    Api()
        .fetchApi(
            data: json.encode({
              "CMPNAME": companyName.text.trim(),
              "CONTACTNAME": contactName.text.trim(),
              "CONTACTNUMBER": contactNum,
              "EMAIL": email.text.trim(),
              "CITY": city.text.trim(),
              "TALLYSERIAL": tallyNum,
              "COMMENT": comment.text.trim(),
              "LEADSOURCE": selectLeadSourceData.value,
              "UID": DataInfo.userId.value,
              "SELECTEDLEAD": selectLeadSourceId.value,
              "INTERESTID": selectInterestedId.value,
              "TALLYACTID": "",
              "TALLYNATUREID": "",
              "TALLYTYPEID": "",
              "TALYYINTERESTID": "",
              "STKID": selectItemId.value
            }),
            action: "NEWLEAD")
        .then((value) {
      if (value != null && value.success) {
        var response = value.data!;

        var data = response['records'][0];
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
                        Get.offAll(() => const Lead(), arguments: data);
                      },
                    ),
                    10.heightBox,
                  ],
                ).p24(),
              ),
            ),
            barrierDismissible: false,
          ).then((value) {
            // Get.offAll(()=>  const Lead(),arguments: data);
          });
          isLoading.value = false;
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: data['DPNAME'].toString());
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  @override
  void onClose() {
    companyName.dispose();
    contactName.dispose();
    contactNumber.dispose();
    email.dispose();
    city.dispose();
    tallySerialNumber.dispose();
    comment.dispose();
    super.onClose();
  }
}
