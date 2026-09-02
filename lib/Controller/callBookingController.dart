// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';

class CallBookingController extends GetxController {
  RxString callDate = "".obs;
  RxMap data = {}.obs;
  RxString currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).obs;
  RxString currentTime = "".obs;
  RxString selectDate = DateTime.now().toString().obs;
  RxString selectTime = "".obs;
  RxBool isLoading = false.obs;
  RxList<dynamic> callTypeList = [].obs;
  RxList<dynamic> fCallTypeList = [].obs;
  RxList<dynamic> natureOfCall = [].obs;
  RxList<dynamic> fNatureOfCall = [].obs;
  RxList<dynamic> teamList = [].obs;
  RxList<dynamic> fTeamList = [].obs;
  RxList<dynamic> supTypeList = [].obs;
  RxList<dynamic> fSupTypeList = [].obs;
  RxList<dynamic> addressList = [].obs;
  RxList<dynamic> fAddressList = [].obs;
  RxList<dynamic> tallySrNo = [].obs;
  RxList<dynamic> fTallySrNo = [].obs;
  RxList<dynamic> contactList = [].obs;
  RxList<dynamic> fContactList = [].obs;
  RxList<dynamic> allocationManagerList = [].obs;
  RxList<dynamic> lUsersList = [].obs;
  RxList<dynamic> flUsersList = [].obs;
  RxString selectCallType = "".obs;
  RxString selectNoc = "".obs;
  RxString selectNocId = "".obs;
  RxString selectSupType = "".obs;
  RxString selectSupTypeId = "2".obs;
  RxString selectManager = "".obs;
  RxString selectManagerId = "".obs;
  RxString selectUser = "".obs;
  RxString selectUserId = "".obs;

  RxString selectAddress = "".obs;
  RxString selectPhone = "Enter Phone number".obs;
  RxString addressDetails = "Enter Address".obs;
  RxString selectRegion = "Enter region".obs;
  RxString selectTallySrNo = "".obs;
  RxString selectContact = "".obs;
  RxString selectContactEmail = "".obs;
  RxString selectContactMobile = "".obs;
  RxString selectContactId = "".obs;
  RxInt selectCheckCollection = 2.obs;
  RxString selectTeamId = "".obs;
  RxString search = "".obs;
  RxString selectCallTypeId = "".obs;
  late PageController pageController;

  TextEditingController searchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController remarkController1 = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxInt currentPage = 0.obs;
  ScrollController scrollController = ScrollController();
  String callBookingData = "";

  RxBool step1 = false.obs;
  RxBool step2 = false.obs;
  String tr = "re";
  RxString message = "".obs;
  RxString message1 = "".obs;
  RxString remarkMessage = "".obs;
  RxString remarkMessage1 = "".obs;

  @override
  void onInit() {
    if (DataInfo.desCat.value == "L1") {
      selectUser.value = DataInfo.username.value;
      selectUserId.value = DataInfo.userId.value;
    }
    pageController = PageController(initialPage: 0, viewportFraction: 1.0);

    data.value = Get.arguments;

    final ctx = Get.context;
    final now = TimeOfDay.now();
    final formatted = ctx != null ? now.format(ctx) : _fallbackTime(now);
    currentTime.value = formatted;
    selectTime.value = formatted;

    getData();
    getUserData();
    super.onInit();
  }

  String _fallbackTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  @override
  void onClose() {
    pageController.dispose();
    scrollController.dispose();
    searchController.dispose();
    remarkController.dispose();
    remarkController1.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void getData() async {
    isLoading.value = true;

    Api()
        .fetchApi(data: data['DPID'].toString(), action: "GETCALLENTRYDATA")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          if (jsonResponse != null &&
              jsonResponse['ROOT'] != null &&
              jsonResponse['ROOT'].isNotEmpty) {
            var jsonData = jsonResponse['ROOT'][0];

            callTypeList.value = jsonData['CALLTYPE'] ?? [];
            fCallTypeList.value = jsonData['CALLTYPE'] ?? [];
            natureOfCall.value = jsonData['NATUREOFCALL'] ?? [];
            fNatureOfCall.value = jsonData['NATUREOFCALL'] ?? [];
            teamList.value = jsonData['TEAM'] ?? [];
            fTeamList.value = jsonData['TEAM'] ?? [];

            supTypeList.value = jsonData['SUPTYPE'] ?? [];
            fSupTypeList.value = jsonData['SUPTYPE'] ?? [];
            addressList.value =
                jsonData.containsKey("ADDRESS") ? jsonData['ADDRESS'] : [];
            fAddressList.value =
                jsonData.containsKey("ADDRESS") ? jsonData['ADDRESS'] : [];
            tallySrNo.value =
                jsonData.containsKey("TALLYSRNO") ? jsonData['TALLYSRNO'] : [];
            fTallySrNo.value =
                jsonData.containsKey("TALLYSRNO") ? jsonData['TALLYSRNO'] : [];
            contactList.value =
                jsonData.containsKey("CONTACT") ? jsonData['CONTACT'] : [];
            fContactList.value =
                jsonData.containsKey("CONTACT") ? jsonData['CONTACT'] : [];
            allocationManagerList.value =
                jsonData.containsKey("TEAM") ? jsonData['TEAM'] : [];

            selectSupType.value =
                supTypeList.isNotEmpty ? supTypeList[1]['NAME'] : 'Select';
            selectAddress.value =
                addressList.isNotEmpty ? addressList.first['NAME'] : 'Select';
            selectAddress.value =
                addressList.isNotEmpty ? addressList.first['NAME'] : "";
            addressDetails.value =
                addressList.isNotEmpty ? addressList.first['ADD'] : "";
            selectPhone.value =
                addressList.isNotEmpty ? addressList.first['PHONE'] : "";
            selectRegion.value =
                addressList.isNotEmpty ? addressList.first['CITY'] : "";
            // selectTallySrNo.value =
            // tallySrNo.isNotEmpty ? tallySrNo.first['NAME'] : "Select";
          }
        } else {
          Get.snackbar(
              "Error", "Failed to load call entry data. Please try again.");
        }
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "An error occurred while loading data: $e");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar("Error", "Network error: $error");
    });
  }

  void getUserData() async {
    Api().fetchApi(action: "L1USER").then((value) {
      try {
        if (value != null && value.success) {
          var jsonData = value.data;
          if (jsonData != null) {
            lUsersList.value = jsonData;
            flUsersList.value = jsonData;
          }
        } else {
          Get.snackbar("Error", "Failed to load user data. Please try again.");
        }
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "An error occurred while loading user data: $e");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar("Error", "Network error: $error");
    });
  }

  searchUser(int type) {
    if (type == 1) {
      fNatureOfCall.value = natureOfCall
          .where((element) => element['NAME']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.trim().toLowerCase()))
          .toList();
    } else {
      flUsersList.value = flUsersList
          .where((element) => element['NAME']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.trim().toLowerCase()))
          .toList();
    }
    update();
  }

  updateData() {
    searchController.text = "";
    search.value = "";
    fNatureOfCall.value = natureOfCall;
    flUsersList.value = lUsersList;
    update();
  }

  checkStep1() {
    String? status;
    if (selectCallType.value == "") {
      status = "Type of Call";
      CustomWidgets.snackBar(title: "Please select $status");
    } else if (selectNoc.value == "") {
      status = "Nature of Call";
      CustomWidgets.snackBar(title: "Please select $status");
    } else if (selectManager.value == "") {
      status = "Allocation Manager";
      CustomWidgets.snackBar(title: "Please select $status");
    } else {
      step1.value = true;
      pageController.nextPage(
          duration: const Duration(milliseconds: 800), curve: Curves.easeIn);
    }
  }

  checkStep2() {
    String? status;
    if (selectCallType.value == "") {
      status = "Type of Call";
    } else if (selectNoc.value == "") {
      status = "Nature of Call";
    } else if (selectManager.value == "") {
      status = "";
    } else if (selectManager.value == "Sales" && selectUser.value == "") {
      status = "User";
    }
    // else if (selectTallySrNo.value == "") {
    //   status = "Tally Serial Number";
    //
    // }

    else {
      step2.value = true;
      pageController.nextPage(
          duration: const Duration(milliseconds: 800), curve: Curves.easeIn);
      // pageController.jumpToPage(pageIndex);
    }
    if (Utilities.checkString(status.toString())) {
      CustomWidgets.snackBar(title: "Please select $status");
    }
  }

  checkData() {
    String? status;
    if (selectCallType.value == "") {
      status = "Type of Call";
    } else if (selectNoc.value == "") {
      status = "Nature of Call";
    } else if (selectManager.value == "") {
      status = "Allocation Manager";
    } else if (selectManager.value == "Sales" && selectUser.value == "") {
      status = "User";
    } else if (selectContact.value == "") {
      status = "Contact Person";
    }
    // else if(step1.value == false ||  step2.value == false){
    //   status = "fields";
    //
    // }
    else {
      // Get.dialog(
      //   Center(
      //     child: Card(
      //       color: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(20.0),
      //       ),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const Icon(
      //             Icons.check,
      //             color: Colors.lightGreen,
      //             size: 50,
      //           ),
      //           20.heightBox,
      //           TextWidget(
      //             "Well Done!",
      //             fontSize: 18,
      //             color: Colors.black,
      //           ),
      //           15.heightBox,
      //           TextWidget(
      //             "You call has been Successfully Booked.",
      //             fontSize: 16,
      //             color: Colors.grey[500],
      //           ),
      //           20.heightBox,
      //           CustomButton(
      //             text: "Ok",
      //             onPressed: () {
      //               // Get.offAll(() => DataPointInfo(), arguments: data);
      //               Get.back();
      //             },
      //           ),
      //           10.heightBox,
      //         ],
      //       ).p24(),
      //     ),
      //   ),
      //   barrierDismissible: false,
      // ).then((value) {
      //   Get.back();
      //   //Get.offAll(() => DataPointInfo(), arguments: data);
      // });
      sendData();
    }
    // else if(selectCheckCollection.value == 2)
    //   {
    //     status = "Cheque Collection";
    //   }
    // else if(remarkController.text.trim().isEmpty)
    //   {
    //     CustomWidgets.snackBar(title: "Please enter remark for customer");
    //     return false;
    //   }
    if (Utilities.checkString(status.toString())) {
      CustomWidgets.snackBar(title: "Please select $status");
    }
  }

  clickStep1() {
    String? status;
    if (selectCallType.value == "") {
      status = "Type of Call";
      CustomWidgets.snackBar(title: "Please select $status");
    } else if (selectNoc.value == "") {
      status = "Nature of Call";
      CustomWidgets.snackBar(title: "Please select $status");
    } else if (selectManager.value == "") {
      status = "Allocation Manager";
      CustomWidgets.snackBar(title: "Please select $status");
    } else {
      step1.value = true;

      pageController.jumpToPage(1);
    }
    if (Utilities.checkString(status.toString())) {
      CustomWidgets.snackBar(title: "Please select $status");
    }
  }

  clickStep2() {
    String? status;
    if (selectCallType.value == "") {
      status = "Type of Call";
      CustomWidgets.snackBar(title: "Please select $status");
    } else if (selectNoc.value == "") {
      status = "Nature of Call";
      CustomWidgets.snackBar(title: "Please select $status");
    } else if (selectManager.value == "") {
      status = "Allocation Manager";
      CustomWidgets.snackBar(title: "Please select $status");
    } else {
      step1.value = true;
      step2.value = true;
      pageController.jumpToPage(2);
    }

    if (Utilities.checkString(status.toString())) {
      CustomWidgets.snackBar(title: "Please select $status");
    }
  }

  sendData() async {
    /*
    https://gateway.tallyhelp.com/crm/UpdateData.aspx?DATA="Abc solution india|Andheri-E|vinod1@antraweb.co.in|
    chandresh||Abc solution india|Shanti Estate M.G. Road Andheri 400093 Andheri-E Maharashtra|000000009 (MUM)|0221234567980|
    9172691115||2||20-04-2023 12:15 PM|2||High|
    vinod|31999|2|43930|I|Mr.|Andheri-E|Yes"&ACTION=CALLENTRY&ENCKEY=a9301158-4764-45ee-a6ec-9a8120c2a153&SRC=KARMA
     */
    /*
    https://gateway.tallyhelp.com/crm/UpdateData.aspx?DATA=Abc%20solution%20india||vinod1%40antraweb.co.in|
    chandresh|Onsite|Shanti%20Estate%20M.G.%20Road%20Andheri%20400093%20Andheri-E%20Maharashtra||0221234567980|
    9172691115|2|2|2023-04-20%2012:18%20pm|
    29||High||vinod|31999|2|39|III|Mr.|No&ACTION=CALLENTRY&ENCKEY=a989f07d-d9ce-4419-8b2c-148decc3183b&SRC=KARMA

     */

    isLoading.value = true;
    callBookingData = data['DPNAME'];
    callBookingData += "|";
    callBookingData += "|${selectContactEmail.value}";
    callBookingData += "|${selectContact.value}";
    callBookingData += "|${selectAddress.value}";
    callBookingData += "|${addressDetails.value}";
    callBookingData += "|${selectTallySrNo.value.trim()}";
    callBookingData += "|${selectPhone.value}";
    callBookingData += "|${selectContactMobile.value.trim()}";
    callBookingData += "|${selectSupTypeId.value}";
    callBookingData += "|${selectManagerId.value}";
    callBookingData +=
        "|${DateFormat('yyyy-MM-dd').format(DateTime.parse(selectDate.value.toString()))} ${selectTime.value}";
    callBookingData += "|${selectNocId.value}";
    callBookingData += "|${remarkController.text.trim()}";
    callBookingData += "|High";
    callBookingData += "|${remarkController1.text.trim()}";
    callBookingData += "|${DataInfo.username.value}";
    callBookingData += "|${data['DPID'].toString()}";
    callBookingData += "|${selectCallTypeId.value}";
    callBookingData += "|${selectUserId.value}";
    callBookingData += "|I";

    callBookingData += "|Mr.";

    callBookingData += "|${selectCheckCollection.value == 1 ? "Yes" : "No"}";
    // print(callBookingData.toString());
    // CALLENTRY
    Api()
        .fetchApi(
            data: DataInfo.desCat.value == "L1"
                ? Uri.encodeComponent(callBookingData)
                : callBookingData,
            action: "CALLENTRY")
        .then((value) {
      try {
        if (value != null && value.success) {
          if (value.data == "YES") {
            final controller = Get.find<DashboardController>();
            controller.getData();
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
                        "Your Call Has Been Successfully Booked.",
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      20.heightBox,
                      CustomButton(
                        text: "Ok",
                        onPressed: () {
                          // Get.offAll(() => DataPointInfo(), arguments: data);
                          Get.back();
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
              //Get.offAll(() => DataPointInfo(), arguments: data);
            });
          } else {
            Get.snackbar("Error", "Booking failed. Please try again.");
          }
        } else {
          Get.snackbar("Error", "Failed to book call. Please check your data.");
        }
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "An error occurred during booking: $e");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar("Error", "Network error: $error");
    });
  }

  getChatGptData() async {
    try {
      Loader();
      var apiResponse =
          await Apis.chatGptApi(message: remarkController.text.trim());

      if (apiResponse != null) {
        message.value = remarkController.text.trim();
        message1.value = apiResponse['MSG'];
        remarkController.text = apiResponse['MSG'];
        update();
        Loader().hide();
      } else {
        Loader().hide();
        Get.snackbar("Error", "Failed to enhance remark. Please try again.");
      }
    } catch (e) {
      Loader().hide();
      Get.snackbar("Error", "An error occurred while enhancing remark: $e");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  getChatGptData1() async {
    try {
      Loader();
      var apiResponse =
          await Apis.chatGptApi(message: remarkController1.text.trim());

      if (apiResponse != null) {
        remarkMessage.value = remarkController1.text.trim();
        remarkMessage1.value = apiResponse['MSG'];
        remarkController1.text = apiResponse['MSG'];
        update();
        Loader().hide();
      } else {
        Loader().hide();
        Get.snackbar("Error", "Failed to enhance remark. Please try again.");
      }
    } catch (e) {
      Loader().hide();
      Get.snackbar("Error", "An error occurred while enhancing remark: $e");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  selectData() {
    remarkController.text = message.value;
    update();
  }

  updateData1(value) {
    message.value = value;
    update();
  }

  selectData2() {
    remarkController1.text = remarkMessage.value;
    update();
  }

  updateData2(value) {
    remarkMessage.value = value;
    update();
  }
}
