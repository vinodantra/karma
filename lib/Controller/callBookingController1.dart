// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:async';
import 'dart:developer';

import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';

/// Controller for managing call booking logic and state.
final class CallBookingController1 extends GetxController {
  /// API action constants and keys.
  static const String callBookAction = 'CALLBOOK';
  static const String teamMemberAction = 'TEAMMEMBER';
  static const String deleteCallBookAction = 'DELETECALLBOOK';
  static const String callApproveAction = 'CALLAPROVE';
  static const String isWorkshopAction = 'ISWORKSHOP';
  static const String getCallDescAction = 'GETCALLEDESC';
  static const String chkinoutDataAction = 'CHKINOUTDATA';
  static const String nameKey = 'NAME';
  static const String idKey = 'ID';

  /// Reactive data map.
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  /// Reactive lists and state variables.
  final RxList<Map<String, dynamic>> tallySerialList =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxList<Map<String, dynamic>> userList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filterUserList =
      <Map<String, dynamic>>[].obs;
  final RxString selectId = "".obs;
  final RxString selectUser = "Select User".obs;
  final RxString description = "".obs;
  final RxString selectCallStatus = "".obs;
  final RxList<Map<String, dynamic>> todayCallList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> fTodayCallList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> previousCallList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> fPreviousCallList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> callList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> fCallList = <Map<String, dynamic>>[].obs;
  final RxString id = DataInfo.userId.value.obs;
  final RxString selectCheckInTime = "".obs;
  final RxString selectCheckOutTime = "".obs;
  final RxBool isWorkShop = false.obs;
  final RxString workShopDate = "".obs;
  final RxBool workShopStatus = false.obs;

  /// Initializes the controller and loads initial data.
  @override
  void onInit() {
    if (Utilities.checkString(DataInfo.username.value)) {
      selectUser.value = DataInfo.username.value;
    }
    if (DataInfo.box.hasData("selectCallBookingUser")) {
      final userData = DataInfo.box.read("selectCallBookingUser");
      selectId.value = userData[idKey].toString();
      selectUser.value = userData[nameKey];
      id.value = userData[idKey].toString();
    } else {
      id.value = DataInfo.userId.value;
      selectUser.value = DataInfo.username.value;
      selectId.value = DataInfo.userId.value;
    }
    getUserData();
    fetchData();
    super.onInit();
  }

  /// Fetches call booking data and categorizes by date.
  void fetchData() async {
    isLoading.value = true;
    hasError.value = false;
    todayCallList.clear();
    previousCallList.clear();
    callList.clear();
    fTodayCallList.clear();
    fPreviousCallList.clear();
    fCallList.clear();
    Api().fetchApi(data: id.value, action: callBookAction).then((value) {
      try {
        if (value != null && value.success) {
          final response = value.data!;
          final jsonData = response['ROOT'][0]['DETAILS'];
          for (final item in jsonData) {
            if (DateTime.parse(item['NRMLCALLDATE']).isAfter(DateTime.now())) {
              fCallList.add(item);
              fCallList.sort((a, b) =>
                  DateTime.parse(b['NRMLCALLDATE'].toString())
                      .compareTo(DateTime.parse(a['NRMLCALLDATE'].toString())));
            } else if (DateFormat('yyyy-MM-dd')
                    .format(DateTime.now())
                    .toString() ==
                item['NRMLCALLDATE']) {
              fTodayCallList.add(item);
              fTodayCallList.sort((a, b) =>
                  DateTime.parse(b['NRMLCALLDATE'].toString())
                      .compareTo(DateTime.parse(a['NRMLCALLDATE'].toString())));
            } else {
              fPreviousCallList.add(item);
              fPreviousCallList.sort((a, b) =>
                  DateTime.parse(a['NRMLCALLDATE'].toString())
                      .compareTo(DateTime.parse(b['NRMLCALLDATE'].toString())));
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
      } finally {
        isLoading.value = false;
      }
    });
  }

  /// Refreshes the call booking data.
  Future<void> onRefresh() async {
    fetchData();
  }

  /// Checks the workshop status for a given company and call ID.
  Future<bool> checkStatus(String companyId, String id) async {
    try {
      isLoading.value = true;

      isWorkShop.value = false;
      update();

      ApiResponse? apiResponse = await Api().fetchApi(
          data: json.encode({"DPID": companyId, "CALLID": id}),
          action: isWorkshopAction);
      if (apiResponse!.success) {
        isWorkShop.value =
            apiResponse.data['Table'][0]['ispplicable'] == 'Yes' ? true : false;
        workShopDate.value =
            apiResponse.data['Table'][0]['lastWorkshopDate'].toString();
        isLoading.value = false;
        update();
        return isWorkShop.value;
      } else {
        isWorkShop.value = false;
        workShopDate.value = "";

        isLoading.value = false;
        update();

        return false;
      }
    } catch (e) {
      isLoading.value = false;
      update();
      return false;
    }
  }

  /// Fetches user data for call booking.
  Future<void> getUserData() async {
    Api()
        .fetchApi(data: DataInfo.userId.value, action: teamMemberAction)
        .then((value) {
      if (value != null && value.success) {
        final response = value.data!;
        userList.value = response as List<Map<String, dynamic>>;
        filterUserList.value = response;
      } else {
        isLoading.value = false;
      }
    });
  }

  /// Deletes a call booking entry by call ID.
  void deleteCall(String callId) {
    isLoading.value = true;
    Api()
        .fetchApi(
            data: json.encode({"CALLID": callId}), action: deleteCallBookAction)
        .then((value) {
      try {
        if (value != null && value.success) {
          final response = value.data!;
          if (response == "Yes") {
            fetchData();
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
      }
    });
  }

  /// Updates the approval status of a call booking.
  void statusUpdate(String callId) async {
    Api()
        .fetchApi(
            data: json.encode({
              "CALLID": callId,
              "APR": selectCallStatus.value == "Approved" ? "YES" : "REJECT"
            }),
            action: callApproveAction)
        .then((value) {
      try {
        if (value != null && value.success) {
          selectCallStatus.value = "";
          if (value.data == 'Yes') {
            CustomWidgets.snackBar(title: "Status Update Successfully");
            fetchData();
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

  /// Fetches and displays visit entry details for a call.
  FutureOr<void> visitEntry(String callId) async {
    Api()
        .fetchApi(
            data: json.encode({"CALLID": callId}), action: getCallDescAction)
        .then((value) {
      try {
        if (value != null && value.success) {
          if (value.data['records'].isNotEmpty) {
            description.value =
                value.data['records'][0]['ACTIVITYDESC'].toString();
            showVisitEntryDialog();
          } else {
            description.value = "";
            showVisitEntryDialog();
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        description.value = "";
        isLoading.value = false;
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  /// Updates the check-in or check-out status for a call.
  FutureOr<void> updateStatus(Map<String, dynamic> data, String type) async {
    String sendData = "";
    if (type == "1") {
      sendData =
          """${data['ID']}|${data['COMPANYID']}|${data['CALLDATE']}|\n        This Check In Entry has been done by ${DataInfo.username.value}|\n182.74.156.234|${data['LAT']}|${data['LONG']}|${data['UID']}|${DataInfo.userId.value}|${selectCheckInTime.value}|${workShopStatus.value ? 1 : 0}""";
    } else {
      sendData =
          """${data['ID']}|${data['COMPANYID']}|${data['CALLDATE']}|\nThis Check Out Entry has been done by ${DataInfo.username.value}|\n182.74.156.234|${data['LAT']}|${data['LONG']}|${data['UID']}|${DataInfo.userId.value}|${selectCheckOutTime.value}|""";
    }
    if (kDebugMode) log("send data:$sendData");
    Api()
        .fetchApi(data: sendData.trim(), action: chkinoutDataAction)
        .then((value) {
      try {
        if (value != null && value.success) {
          if (value.data.toString().toUpperCase() != "YES") {
            CustomWidgets.snackBar(title: value.data.toString());
          }
          fetchData();
          isLoading.value = false;
        } else {
          selectCheckInTime.value = "";
          selectCheckOutTime.value = "";
          isLoading.value = false;
        }
        isWorkShop.value = false;
        workShopStatus.value = false;
        workShopDate.value = "";
      } catch (e) {
        isLoading.value = false;
        selectCheckInTime.value = "";
        selectCheckOutTime.value = "";
        isWorkShop.value = false;
        workShopStatus.value = false;
        workShopDate.value = "";
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  /// Shows a dialog with the visit entry description.
  void showVisitEntryDialog() {
    Get.dialog(Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget("Visit Entry Description",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center)
                .p8(),
            Container(
              width: Get.width,
              height: 1.0,
              color: Colors.grey[400],
            ),
            10.heightBox,
            TextWidget(description.value, fontSize: 16, maxLines: 10),
            10.heightBox,
            CustomButton(
              text: "OK",
              onPressed: () {
                Get.back();
              },
              width: 120,
              height: 40,
            ),
          ],
        ).p8(),
      ).p8(),
    ));
  }

  /// Changes the workshop status and updates the UI.
  void changeWorkShopStatus(value) {
    workShopStatus.value = value;
    update();
  }

  /// Selects a user for call booking and refreshes data.
  void selectCallBookingUser({required Map<String, dynamic> data}) {
    DataInfo.box.write("selectCallBookingUser", data);
    selectId.value = data[idKey].toString();
    selectUser.value = data[nameKey];
    id.value = data[idKey].toString();
    getUserData();
    fetchData();
  }

  /// Returns the display status string for a given approval status value.
  String showStatus(String value) {
    if (value == "YES") {
      return "Approved";
    } else if (value == "NO") {
      return "Pending";
    } else if (value == "REJECT") {
      return "Rejected";
    } else {
      return "Pending";
    }
  }

  /// Returns the color for a given approval status value.
  Color showStatusColor(String value) {
    if (value == "YES") {
      return Colors.green;
    } else if (value == "NO") {
      return Colors.orangeAccent;
    } else if (value == "REJECT") {
      return Colors.red;
    } else {
      return Colors.orangeAccent;
    }
  }

  /// Checks if the check-in time is before the check-out time.
  bool checkTime() {
    DateTime d1 = _parseTime(selectCheckInTime.value);
    DateTime d2 = _parseTime(selectCheckOutTime.value);
    return d1.isBefore(d2);
  }

  /// Parses a time string (HH:mm) into a DateTime object for today.
  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(":");
    return DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }
}
