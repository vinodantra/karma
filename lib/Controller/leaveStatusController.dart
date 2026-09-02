// ignore_for_file: depend_on_referenced_packages, file_names

import '../Constants/Library.dart';
import 'package:intl/intl.dart';
class LeaveStatusController extends GetxController{
  RxString selectDate = DateFormat('MMM yyyy')
      .format(DateTime.now()).obs;
  RxString selectDate1 = DateFormat('MM yyyy')
      .format(DateTime.now()).obs;
  RxList<dynamic> userList = [].obs;
  RxList<dynamic> filterUserList = [].obs;
  RxString selectUser = DataInfo.username.value.obs;
  RxString selectUserId = DataInfo.enrollId.value.obs;
  RxBool isLoading =  false.obs;
  RxBool hasError = false.obs;
  RxList<dynamic> listData = [].obs;
  DateTime selectDate2  = DateTime.now();


  RxList<dynamic> leaveType = [{"ID":"1","NAME":"PL"},
    {"ID":"2","NAME":"OL"},
    {"ID":"3","NAME":"WPL"},].obs;
  RxString selectType = "Select".obs;
  RxString selectApplyType = "Select".obs;
  RxInt selectLeaveStatusId = (-1).obs;
  RxString selectLeaveStatus = "".obs;
  final commentController = TextEditingController();


  RxList<dynamic> applyList = [{"ID":"1","NAME":"Half Day"},
    {"ID":"2","NAME":"1 Day"},{"ID":"3","NAME":"More than 1 day"},].obs;
  RxList<dynamic> leaveTypeList = [{"ID":"1","NAME":"First Half"},
    {"ID":"2","NAME":"Second Half"}].obs;
  RxString selectLeaveData = "Select".obs;
  RxString selectLeaveId = "Select".obs;

  TextEditingController email =  TextEditingController();
  TextEditingController leaveReason = TextEditingController();
  RxString selectOnDate = DateFormat('dd MMM yyyy')
      .format(DateTime.now()).obs;
  RxString selectFromDate = DateFormat('dd MMM yyyy')
      .format(DateTime.now()).obs;
  RxString selectToDate = DateFormat('dd MMM yyyy')
      .format(DateTime.now()).obs;
  RxString selectOnDate1 = DateTime.now().toString().obs;
  RxString selectFromDate1 = DateTime.now().toString().obs;
  RxString selectToDate1 = DateTime.now().toString().obs;
  RxString selectApplyTypeId = "".obs;
  @override
  onInit(){
    getUserData();
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    commentController.dispose();
    email.dispose();
    leaveReason.dispose();
    super.onClose();
  }

  getUserData() async {
    Api().fetchApi(data: DataInfo.userId.value,action: "TEAMMEMBER").then((value) {
      if(value != null && value.success) {
        var response = value.data!;

        userList.value = response;
        filterUserList.value = response;
        isLoading.value = false;

      }

    });

  }
  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final value = await Api().fetchApi(
          data: json.encode({
            "LMONTH": int.parse(selectDate1.value.split(" ")[0].toString()),
            "LYEAR": int.parse(selectDate1.value.split(" ")[1].toString()),
            "UID": selectUserId.value
          }),
          action: "GETLEAVEDATA");
      if (value != null && value.success) {
        var response = value.data!;
        listData.value = response['records'];
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
  deleteData(int id)async{
    Api().fetchApi(data: json.encode({"LEAVEID":id}),action: "DELETELEAVE").then((value) {
      if(value != null && value.success) {
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
                    "Entry deleted successfully",
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                  20.heightBox,
                  CustomButton(
                    text: "Ok",
                    onPressed: () {
                      Get.back();
                      getData();

                    },
                  ),
                  10.heightBox,
                ],
              ).p24(),
            ),
          ),
          barrierDismissible: false,
        );

        getData();

      }

    });
  }

  void applyLeave(int id){
    Map<String, Object> sendData;
    if(selectApplyTypeId.value == "1")
    {
      sendData = {"ENROLLID":DataInfo.enrollId.value,
        "LEAVEID":id,
        "UID":DataInfo.userId.value,"UNAME":DataInfo.username.value,"LEAVETYPE":"H",
        "LEAVECATEGORY":selectType.value,"LEAVEDESC":leaveReason.text.trim(),
        "ONDATE":selectOnDate.value.contains("/") ? DateFormat('dd MMM yyyy').format(DateFormat('dd/MMM/yyyy').parse(selectOnDate.value)) : selectOnDate.value,
        "TODATE":"",
        "HALF":selectLeaveId.value == "1" ? "FH":"SH","NUMOFDAYS":0.5,
        "FROMEMAIL":DataInfo.email.value,
        "TOEMAIL":email.text.trim()};
    }
    else if(selectApplyTypeId.value == "2")
    {
      sendData = {"ENROLLID":DataInfo.enrollId.value,
        "LEAVEID":id,
        "UID":DataInfo.userId.value,"UNAME":DataInfo.username.value,"LEAVETYPE":"F",
        "LEAVECATEGORY":selectType.value,"LEAVEDESC":leaveReason.text.trim(),
        "ONDATE":selectOnDate.value.contains("/") ? DateFormat('dd MMM yyyy').format(DateFormat('dd/MMM/yyyy').parse(selectOnDate.value)) : selectOnDate.value,"TODATE":"",
        "NUMOFDAYS":1,
        "FROMEMAIL":DataInfo.email.value,
        "TOEMAIL":email.text.trim()};
    }
    else
    {
      sendData = {"ENROLLID":DataInfo.enrollId.value,
        "LEAVEID":id,
        "UID":DataInfo.userId.value,"UNAME":DataInfo.username.value,
        "LEAVETYPE":"F",
        "LEAVECATEGORY":selectType.value,"LEAVEDESC":leaveReason.text.trim(),
        "ONDATE":selectFromDate.value.contains("/") ? DateFormat('dd MMM yyyy').format(DateFormat('dd/MM/yyyy').parse(selectFromDate.value)) : selectFromDate.value,
        "TODATE":selectToDate.value.contains("/") ? DateFormat('dd MMM yyyy').format(DateFormat('dd/MM/yyyy').parse(selectToDate.value)) : selectToDate.value,
        "NUMOFDAYS":DateTime.parse(selectToDate1.value).difference(DateTime.parse(selectFromDate1.value)).inDays,
        "FROMEMAIL":DataInfo.email.value.trim(),
        "TOEMAIL":email.text.trim()};
    }
    isLoading.value = true;

    Api().fetchApi(
        data: Uri.encodeComponent(json.encode(sendData)),
        action: "UPDATELEAVE").then((value) {
      if(value != null && value.success) {
        selectType.value = "Select";
        email.clear();
        leaveReason.clear();
        selectFromDate.value = DateFormat('dd MMM yyyy')
            .format(DateTime.now());
        selectToDate.value = DateFormat('dd MMM yyyy')
            .format(DateTime.now());
        isLoading.value = false;
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
                      isLoading.value = false;
                      getData();
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
      }
      else{
        isLoading.value = false;
      }

    });



    // isLoading.value = false;
  }

  updateStatus(var data){
    Api().fetchApi(data: json.encode({"LEAVEID":data['LEAVEID'],"UID":DataInfo.userId.value,"UNAME":DataInfo.username.value,"STATUS":selectLeaveStatus.value,"REASON":commentController.text.trim()}),action: "APPROVELEAVE").then((value) {
      if(value != null && value.success) {
        commentController.clear();
        selectLeaveStatusId.value = -1;
        selectLeaveStatus.value = "";
        Get.back();
        getData();
        // var response = value.data!;
        //
        // userList.value = response;
        // filterUserList.value = response;
        // isLoading.value = false;

      }

    });
  }
}