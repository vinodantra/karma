// ignore_for_file: depend_on_referenced_packages, file_names



import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';

class LeaveReportController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> listData = [].obs;
  RxString selectDate = DateFormat('MMM yyyy').format(DateTime.now()).obs;
  RxMap<String, dynamic> leaveData = <String, dynamic>{}.obs;
  RxList<dynamic> holidaysList = [].obs;
  RxList<dynamic> attendanceList = [].obs;
  RxList<dynamic> leaveType = [
    {"ID": "1", "NAME": "PL"},
    {"ID": "2", "NAME": "OL"},
    {"ID": "3", "NAME": "WPL"},
  ].obs;
  RxString selectType = "Select".obs;
  RxString selectApplyType = "Select".obs;
  DateTime selectDate1 = DateTime.now();

  RxList<dynamic> applyList = [
    {"ID": "1", "NAME": "Half Day"},
    {"ID": "2", "NAME": "1 Day"},
    {"ID": "3", "NAME": "More than 1 day"},
  ].obs;
  RxList<dynamic> leaveTypeList = [
    {"ID": "1", "NAME": "First Half"},
    {"ID": "2", "NAME": "Second Half"}
  ].obs;
  RxString selectLeaveData = "Select".obs;
  RxString selectLeaveId = "Select".obs;

  TextEditingController email = TextEditingController();
  TextEditingController leaveReason = TextEditingController();
  RxString selectOnDate = DateFormat('dd MMM yyyy').format(DateTime.now()).obs;
  RxString selectFromDate =
      DateFormat('dd MMM yyyy').format(DateTime.now()).obs;
  RxString selectToDate = DateFormat('dd MMM yyyy').format(DateTime.now().add(const Duration(days: 1))).obs;
  RxString selectOnDate1 = DateTime.now().toString().obs;
  RxString selectFromDate1 = DateTime.now().toString().obs;
  RxString selectToDate1 = DateTime.now().toString().obs;
  RxString selectApplyTypeId = "".obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    email.dispose();
    leaveReason.dispose();
    super.onClose();
  }

  getApiData() async {
    await getData();
    await getHolidaysList();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final value = await Api().fetchApi(
          data: "${DataInfo.enrollId.value}|${selectDate.value}",
          action: "ATTENDANCE");
      if (value != null && value.success) {
        var response = value.data!;

        //   listData.value = response;
        leaveData.value = response['ROOT'][0]['LEAVELIST'][0];
        attendanceList.value =
            response['ROOT'][0]['ATTENDANCELIST'][0]['ATTENDANCE'];
        await getHolidaysList();
      } else {
        selectDate.value = DateFormat('MMM yyyy').format(DateTime.now());
        selectDate1 = DateTime.now();
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getHolidaysList() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final value = await Api().fetchApi(action: "ANTRAHOLIDAY");
      if (value != null && value.success) {
        var response = value.data!;
        holidaysList.value = response['records'];
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void applyLeave() {
    Map<String, Object> sendData;
    if (selectApplyTypeId.value == "1") {
      sendData = {
        "ENROLLID": DataInfo.enrollId.value,
        "UID": DataInfo.userId.value,
        "UNAME": DataInfo.username.value,
        "LEAVETYPE": "H",
        "LEAVECATEGORY": selectType.value,
        "LEAVEDESC": leaveReason.text.trim(),
        "ONDATE": selectOnDate.value.contains("/")
            ? DateFormat('dd MMM yyyy')
                .format(DateFormat('dd/MMM/yyyy').parse(selectOnDate.value))
            : selectOnDate.value,
        "TODATE": "",
        "HALF": selectLeaveId.value == "1" ? "FH" : "SH",
        "NUMOFDAYS": 0.5,
        "FROMEMAIL": DataInfo.email.value,
        "TOEMAIL": email.text.trim()
      };
    } else if (selectApplyTypeId.value == "2") {
      sendData = {
        "ENROLLID": DataInfo.enrollId.value,
        "UID": DataInfo.userId.value,
        "UNAME": DataInfo.username.value,
        "LEAVETYPE": "F",
        "LEAVECATEGORY": selectType.value,
        "LEAVEDESC": leaveReason.text.trim(),
        "ONDATE": selectOnDate.value.contains("/")
            ? DateFormat('dd MMM yyyy')
                .format(DateFormat('dd/MMM/yyyy').parse(selectOnDate.value))
            : selectOnDate.value,
        "TODATE": "",
        "NUMOFDAYS": 1,
        "FROMEMAIL": DataInfo.email.value,
        "TOEMAIL": email.text.trim()
      };
    } else {
      sendData = {
        "ENROLLID": DataInfo.enrollId.value,
        "UID": DataInfo.userId.value,
        "UNAME": DataInfo.username.value,
        "LEAVETYPE": "F",
        "LEAVECATEGORY": selectType.value,
        "LEAVEDESC": leaveReason.text.trim(),
        "ONDATE": selectFromDate.value.contains("/")
            ? DateFormat('dd MMM yyyy')
                .format(DateFormat('dd/MMM/yyyy').parse(selectFromDate.value))
            : selectFromDate.value,
        "TODATE": selectToDate.value.contains("/")
            ? DateFormat('dd MMM yyyy')
                .format(DateFormat('dd/MMM/yyyy').parse(selectToDate.value))
            : selectToDate.value,
        "NUMOFDAYS": DateTime.parse(selectToDate1.value)
            .difference(DateTime.parse(selectFromDate1.value))
            .inDays,
        "FROMEMAIL": DataInfo.email.value.trim(),
        "TOEMAIL": email.text.trim()
      };
    }
    isLoading.value = true;


    Api()
        .fetchApi(data: json.encode(sendData), action: "CREATELEAVE")
        .then((value) {
      if (value != null && value.success) {
        selectType.value = "Select";
        email.clear();
        leaveReason.clear();
        selectFromDate.value = DateFormat('dd MMM yyyy').format(DateTime.now());
        selectToDate.value = DateFormat('dd MMM yyyy').format(DateTime.now());
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
                    "Success",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  15.heightBox,
                  TextWidget(
                    "Leave Successfully updated.",
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                  20.heightBox,
                  CustomButton(
                    text: "Ok",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  10.heightBox,
                ],
              ).p24(),
            ),
          ),
          barrierDismissible: false,
        );

        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    });

    // isLoading.value = false;
  }
}
