// ignore_for_file: depend_on_referenced_packages, file_names


import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';

class CallBookingControllerL2 extends GetxController {
  RxMap data = {}.obs;
  RxList<dynamic> tallySerialList = [].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> userList = [].obs;
  RxList<dynamic> filterUserList = [].obs;
  RxString selectId = "".obs;
  RxString selectUser = "Select User".obs;

  RxString selectCallStatus = "".obs;
  RxList<dynamic> todayCallList = [].obs;
  RxList<dynamic> fTodayCallList = [].obs;
  RxList<dynamic> previousCallList = [].obs;
  RxList<dynamic> fPreviousCallList = [].obs;
  RxList<dynamic> callList = [].obs;
  RxList<dynamic> fCallList = [].obs;
  RxString id = DataInfo.userId.value.obs;
  RxString selectCheckInTime = "".obs;
  RxString selectCheckOutTime = "".obs;
  @override
  void onInit() {
    getUserData();
    getData();
    super.onInit();
  }

  Future<void> onRefresh() async => getData();

  void getData() async {
    isLoading.value = true;
    hasError.value = false;
    todayCallList.clear();
    previousCallList.clear();
    callList.clear();
    fTodayCallList.clear();
    fPreviousCallList.clear();
    fCallList.clear();

    Api().fetchApi(data: id.value, action: "CALLBOOK").then((value) {
      try {
        if (value != null && value.success) {
          var jsonResponse = value.data;

          var jsonData = jsonResponse['ROOT'][0]['DETAILS'];

          for (int i = 0; i < jsonData.length; i++) {
            if (DateTime.parse(jsonData[i]['NRMLCALLDATE'])
                .isAfter(DateTime.now())) {
              fCallList.add(jsonData[i]);
              fCallList.sort((a, b) => a['CALLDATE'].compareTo(b['CALLDATE']));
            } else if (DateFormat('yyyy-MM-dd')
                    .format(DateTime.now())
                    .toString() ==
                jsonData[i]['NRMLCALLDATE']) {
              fTodayCallList.add(jsonData[i]);
              fTodayCallList
                  .sort((a, b) => a['CALLDATE'].compareTo(b['CALLDATE']));
            } else {
              fPreviousCallList.add(jsonData[i]);
              fPreviousCallList
                  .sort((a, b) => a['CALLDATE'].compareTo(b['CALLDATE']));
            }
          }
          callList.value = fCallList.reversed.toList();
          todayCallList.value = fTodayCallList.reversed.toList();
          previousCallList.value = fPreviousCallList.reversed.toList();
        } else {
          hasError.value = true;
        }
      } catch (e) {
        hasError.value = true;
        if (kDebugMode) {
          print("error:$e");
        }
      } finally {
        isLoading.value = false;
      }
    });
  }

  getUserData() async {
    Api()
        .fetchApi(data: DataInfo.userId.value, action: "TEAMMEMBER")
        .then((value) {
      if (value != null && value.success) {
        var userdata = value.data;

        userList.value = userdata;
        filterUserList.value = userdata;
      }
    });
  }

  void statusUpdate(String callId) async {
    Api()
        .fetchApi(
            data: json.encode({
              "CALLID": callId,
              "APR": selectCallStatus.value == "Approved" ? "YES" : "NO"
            }),
            action: "CALLAPROVE")
        .then((value) {
      try {
        if (value != null && value.success) {
          selectCallStatus.value = "";

          if (value.data == 'Yes') {
            CustomWidgets.snackBar(title: "Status Update Successfully");
            getData();
          }

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

  void visitEntry(String callId) async {
    Api()
        .fetchApi(data: json.encode({"CALLID": callId}), action: "GETCALLEDESC")
        .then((value) {
      try {
        if (value != null && value.success) {
          getData();

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

  Future<void> updateStatus(var data, String type) async {
    String sendData = "";
    if (type == "1") {
      sendData = """${data['ID']}|${data['COMPANYID']}|${data['CALLDATE']}|
        This Check In Entry has been done by vinod|
182.74.156.234|${data['LAT']}|${data['LONG']}|${DataInfo.userId.value}|${data['UNAME']}|${selectCheckInTime.value}""";
    } else {
      sendData = """${data['ID']}|${data['COMPANYID']}|${data['CALLDATE']}|
This Check Out Entry has been done by vinod|
182.74.156.234|${data['LAT']}|${data['LONG']}|${DataInfo.userId.value}|${data['UNAME']}|${selectCheckOutTime.value}""";
    }

    Api().fetchApi(data: sendData.trim(), action: "CHKINOUTDATA").then((value) {
      try {
        if (value != null && value.success) {
          getData();

          isLoading.value = false;
        } else {
          selectCheckInTime.value = "";
          selectCheckOutTime.value = "";
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        selectCheckInTime.value = "";
        selectCheckOutTime.value = "";
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }
}
