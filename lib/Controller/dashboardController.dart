// ignore_for_file: file_names, unused_import, unused_local_variable, depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/notificationService.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

import '../Services/db_helper.dart';
import 'NotificationListController.dart';
import 'NotificationListProvider.dart';

class DashboardController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<dynamic> targetList = [].obs;
  RxInt selectTab = 0.obs;
  List<ChartData> chartData = [];
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1.0);
  RxMap<String, dynamic> dataPoint = <String, dynamic>{}.obs;
  RxMap<String, dynamic> epicData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> zoneData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> outstandingData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> callBookingData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> businessData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> leadData = <String, dynamic>{}.obs;
  RxList<dynamic> opportunityList = [].obs;
  RxBool selectCategory1 = true.obs;
  RxString selectL2Category1 = "1".obs;
  RxList<dynamic> userList = [].obs;
  RxList<dynamic> filterUserList = [].obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchController1 = TextEditingController();
  RxList<dynamic> listData = [].obs;
  RxString search = "".obs;
  RxString selectPrdId = "".obs;
  RxMap selectData = {}.obs;
  RxMap monthlyL2Data = {}.obs;
  RxMap quarterlyL2Data = {}.obs;
  RxMap allL2Data = {}.obs;
  RxString avgRating = "".obs;
  RxString overAllRating = "0".obs;
  RxMap mapDataL2 = {}.obs;
  RxString status = "0.0L/(0.0L)".obs;
  RxString selectUser = "User".obs;
  RxString callBooking = "".obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var themeController;
  RxBool showData = false.obs;
  RxInt selectTabL2 = 0.obs;
  RxString selectTallyDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()).obs;
  RxString selectTicketType = "Select".obs;
  RxString selectTicketTypeId = "".obs;
  RxString tallyDate = DateFormat('ddMMMyyyy').format(DateTime.now()).obs;
  RxString selectDate = "".obs;
  TextEditingController tallyNoController = TextEditingController();
  TextEditingController content = TextEditingController();
  RxString ticketNumber = "".obs;

  RxString remindMeDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).obs;
  RxString selectRemindMeDate = "".obs;
  RxString selectTime = "".obs;
  TextEditingController content1 = TextEditingController();
  RxList<dynamic> remindMeList = [].obs;
  int badgesCount = 0;
  List<dynamic> list = [];
  RxString netValue = "".obs;
  RxString faceTime = "".obs;
  RxMap<String, dynamic> targetMap = <String, dynamic>{}.obs;
  RxDouble topValue = 0.0.obs;
  RxDouble nextTopValue = 0.0.obs;
  RxDouble thirdTopValue = 0.0.obs;
  RxList<dynamic> ticketTypeList = [
    {
      "ID": "1",
      "NAME": "TLY",
    },
    {
      "ID": "2",
      "NAME": "AWT",
    }
  ].obs;
  @override
  void onInit() {
    mapDataL2.value = {
      "pprc": "0",
      "ticket": "0",
      "onsitevisits": "0",
      "lead": "0"
    };

    getNotificationData();
    getNotificationListData();

    if (DataInfo.box.hasData("filterUserList")) {
      filterUserList.value = DataInfo.box.read("filterUserList");
      userList.value = DataInfo.box.read("filterUserList");
    }

    if (DataInfo.box.hasData("selectedDashboardUser")) {
      final selected = DataInfo.box.read("selectedDashboardUser");
      selectUser.value = selected['NAME'] ?? "User";
      DataInfo.username.value = selected['NAME'] ?? "";
      DataInfo.userId.value = selected['ID']?.toString() ?? "";
      DataInfo.pid.value = selected['PID']?.toString() ?? "";
      DataInfo.enrollId.value = selected['ENROLLID']?.toString() ?? "";
      DataInfo.desCat.value = selected['DESCAT']?.toString() ?? "";
      DataInfo.isSelectUser.value = false;
    }

    getData();

    if (DataInfo.box.hasData("remindMe")) {
      remindMeList.value = DataInfo.box.read("remindMe");
    }

    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchController1.dispose();
    content.dispose();
    content1.dispose();
    tallyNoController.dispose();
    super.onClose();
  }

  void getData() async {
    isLoading.value = true;
    targetList.clear();
    status.value = "0.0L/(0.0)L";
    if (DataInfo.desCat.value == "L1") {
      await Api()
          .fetchApi(
              data: json.encode(
                {
                  "UID": DataInfo.userId.value,
                  "PID": DataInfo.pid.value,
                  "UNAME": DataInfo.username.value
                },
              ),
              action: "ACHIVEDTARGET")
          .then((value) async {
        if (value != null && value.success) {
          if (value.data.toString().contains("Please Update Your App") ==
              false) {
            var data = value.data;
            var targetData = data['ROOT'][0]['DETAILS'][0];
            targetMap.value = targetData;

            var data1 = {
              "type": "Today",
              "meTarget": CustomWidgets.showNumber(
                  (int.parse(targetData['DAILYUSER']['USERACHIVD']) /
                          int.parse(targetData['DAILYUSER']['USERTGT'])) *
                      100),
              "teamTarget": CustomWidgets.showNumber(
                  (int.parse(targetData['DAILYTEAM']['TEAMACHIVD']) /
                          int.parse(targetData['DAILYTEAM']['TEAMTGT'])) *
                      100),
              "floorTarget": CustomWidgets.showNumber(
                  (int.parse(targetData['DAILYFLOAR']['FLOARACHIVD']) /
                          int.parse(targetData['DAILYFLOAR']['FLOARTGT'])) *
                      100),
              "USERACHIVD": targetData['DAILYUSER']['USERACHIVD'],
              "USERTGT": targetData['DAILYUSER']['USERTGT'],
              "TEAMACHIVD": targetData['DAILYTEAM']['TEAMACHIVD'],
              "TEAMTGT": targetData['DAILYTEAM']['TEAMTGT'],
              "FLOARACHIVD": targetData['DAILYFLOAR']['FLOARACHIVD'],
              "FLOARTGT": targetData['DAILYFLOAR']['FLOARTGT'],
              "percentage": status.value,
            };
            targetList.add(data1);

            chartData = [
              ChartData("Me", double.parse(data1['meTarget']),
                  const Color(0xff16BFD6)),
              ChartData("Team", double.parse(data1['teamTarget']),
                  const Color(0xffF7BD65)),
              ChartData("Floor", double.parse(data1['floorTarget']),
                  const Color(0xffA155B9)),
            ];

            netValue.value = targetData['DAILYUSER']['USERACHIVD'];
            faceTime.value = targetData['FACETIME']['TODAY'];

            var data2 = {
              "type": DateFormat.MMMM().format(DateTime.now()),
              "meTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['MONTHUSER']['USERACHIVD']) /
                              int.parse(targetData['MONTHUSER']['USERTGT'])) *
                          100)
                  .toString(),
              "teamTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['MONTHTEAM']['TEAMACHIVD']) /
                              int.parse(targetData['MONTHTEAM']['TEAMTGT'])) *
                          100)
                  .toString(),
              "floorTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['MONTHFLOAR']['FLOARACHIVD']) /
                              int.parse(targetData['MONTHFLOAR']['FLOARTGT'])) *
                          100)
                  .toString(),
              "USERACHIVD": targetData['MONTHUSER']['USERACHIVD'],
              "USERTGT": targetData['MONTHUSER']['USERTGT'],
              "TEAMACHIVD": targetData['MONTHTEAM']['TEAMACHIVD'],
              "TEAMTGT": targetData['MONTHTEAM']['TEAMTGT'],
              "FLOARACHIVD": targetData['MONTHFLOAR']['FLOARACHIVD'],
              "FLOARTGT": targetData['MONTHFLOAR']['FLOARTGT'],
              "percentage": status.value,
            };
            targetList.add(data2);
            var data3 = {
              "type": "Cumulative",
              "meTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['QRTUSER']['USERACHIVD']) /
                              int.parse(targetData['QRTUSER']['USERTGT'])) *
                          100)
                  .toString(),
              "teamTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['QRTTEAM']['TEAMACHIVD']) /
                              int.parse(targetData['QRTTEAM']['TEAMTGT'])) *
                          100)
                  .toString(),
              "floorTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['QRTFLOAR']['FLOARACHIVD']) /
                              int.parse(targetData['QRTFLOAR']['FLOARTGT'])) *
                          100)
                  .toString(),
              "USERACHIVD": targetData['QRTUSER']['USERACHIVD'],
              "USERTGT": targetData['QRTUSER']['USERTGT'],
              "TEAMACHIVD": targetData['QRTTEAM']['TEAMACHIVD'],
              "TEAMTGT": targetData['QRTTEAM']['TEAMTGT'],
              "FLOARACHIVD": targetData['QRTFLOAR']['FLOARACHIVD'],
              "FLOARTGT": targetData['QRTFLOAR']['FLOARTGT'],
              "percentage": status.value,
            };
            targetList.add(data3);

            dataPoint.value = targetData['DATAPOINT'];
            epicData.value = targetData['EPICENTRE'];
            zoneData.value = targetData['ZONEMIS'];
            outstandingData.value = targetData['OUTSTANDING'];
            callBookingData.value = targetData['CALLBOOK'];

            businessData.value = targetData['RPTBUSINESS'];
            await getOpportunity();
            await getLeadData();
            if (DataInfo.isSelectUser.value) {
              await getUserData();
            }

            await getDataL2();
            await getTopCustomerData();
            isLoading.value = false;
          } else {
            isLoading.value = false;
            CustomWidgets.snackBar(title: value.data.toString());
          }
        }
      });
    } else {
      await Api()
          .fetchApi(
              data: json.encode(
                {
                  "UID": DataInfo.userId.value,
                  "PID": DataInfo.pid.value,
                  "UNAME": DataInfo.username.value
                },
              ),
              action: "ACHIVEDTARGET")
          .then((value) {
        if (value != null && value.success) {
          if (value.data.toString().contains("Please Update Your App") ==
              false) {
            var data = value.data;
            var targetData = data['ROOT'][0]['DETAILS'][0];

            var data1 = {
              "type": "Today",
              "meTarget": CustomWidgets.showNumber(
                  (int.parse(targetData['DAILYUSER']['USERACHIVD']) /
                          int.parse(targetData['DAILYUSER']['USERTGT'])) *
                      100),
              "teamTarget": CustomWidgets.showNumber(
                  (int.parse(targetData['DAILYTEAM']['TEAMACHIVD']) /
                          int.parse(targetData['DAILYTEAM']['TEAMTGT'])) *
                      100),
              "floorTarget": CustomWidgets.showNumber(
                  (int.parse(targetData['DAILYFLOAR']['FLOARACHIVD']) /
                          int.parse(targetData['DAILYFLOAR']['FLOARTGT'])) *
                      100),
              "USERACHIVD": targetData['DAILYUSER']['USERACHIVD'],
              "USERTGT": targetData['DAILYUSER']['USERTGT'],
              "TEAMACHIVD": targetData['DAILYTEAM']['TEAMACHIVD'],
              "TEAMTGT": targetData['DAILYTEAM']['TEAMTGT'],
              "FLOARACHIVD": targetData['DAILYFLOAR']['FLOARACHIVD'],
              "FLOARTGT": targetData['DAILYFLOAR']['FLOARTGT'],
              "percentage": status.value,
            };
            targetList.add(data1);
            chartData = [
              ChartData("Me", double.parse(data1['meTarget']),
                  const Color(0xff16BFD6)),
              ChartData("Team", double.parse(data1['teamTarget']),
                  const Color(0xffF7BD65)),
              ChartData("Floor", double.parse(data1['floorTarget']),
                  const Color(0xffA155B9)),
            ];
            var data2 = {
              "type": "Monthly",
              "meTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['MONTHUSER']['USERACHIVD']) /
                              int.parse(targetData['MONTHUSER']['USERTGT'])) *
                          100)
                  .toString(),
              "teamTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['MONTHTEAM']['TEAMACHIVD']) /
                              int.parse(targetData['MONTHTEAM']['TEAMTGT'])) *
                          100)
                  .toString(),
              "floorTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['MONTHFLOAR']['FLOARACHIVD']) /
                              int.parse(targetData['MONTHFLOAR']['FLOARTGT'])) *
                          100)
                  .toString(),
              "USERACHIVD": targetData['MONTHUSER']['USERACHIVD'],
              "USERTGT": targetData['MONTHUSER']['USERTGT'],
              "TEAMACHIVD": targetData['MONTHTEAM']['TEAMACHIVD'],
              "TEAMTGT": targetData['MONTHTEAM']['TEAMTGT'],
              "FLOARACHIVD": targetData['MONTHFLOAR']['FLOARACHIVD'],
              "FLOARTGT": targetData['MONTHFLOAR']['FLOARTGT'],
              "percentage": status.value,
            };
            targetList.add(data2);
            var data3 = {
              "type": "Cumulative",
              "meTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['QRTUSER']['USERACHIVD']) /
                              int.parse(targetData['QRTUSER']['USERTGT'])) *
                          100)
                  .toString(),
              "teamTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['QRTTEAM']['TEAMACHIVD']) /
                              int.parse(targetData['QRTTEAM']['TEAMTGT'])) *
                          100)
                  .toString(),
              "floorTarget": CustomWidgets.showNumber(
                      (int.parse(targetData['QRTFLOAR']['FLOARACHIVD']) /
                              int.parse(targetData['QRTFLOAR']['FLOARTGT'])) *
                          100)
                  .toString(),
              "USERACHIVD": targetData['QRTUSER']['USERACHIVD'],
              "USERTGT": targetData['QRTUSER']['USERTGT'],
              "TEAMACHIVD": targetData['QRTTEAM']['TEAMACHIVD'],
              "TEAMTGT": targetData['QRTTEAM']['TEAMTGT'],
              "FLOARACHIVD": targetData['QRTFLOAR']['FLOARACHIVD'],
              "FLOARTGT": targetData['QRTFLOAR']['FLOARTGT'],
              "percentage": status.value,
            };
            targetList.add(data3);
          } else {
            isLoading.value = false;
            CustomWidgets.snackBar(title: value.data.toString());
          }
        }
      });

      await Api()
          .fetchApi(
              data: json.encode(
                {
                  "UID": DataInfo.userId.value,
                  "PID": DataInfo.pid.value,
                  "UNAME": DataInfo.username.value,
                  "ENROLLID": DataInfo.enrollId.value,
                  "REQTYPE": "MONTH"
                },
              ),
              action: "SUPDASHBOARD")
          .then((value) async {
        if (value != null && value.success) {
          if (value.data.toString().contains("Please Update Your App") ==
              false) {
            var responseDataL2 = value.data;
            var dataL2 = responseDataL2['ROOT'][0]['DETAILS'][0];
            mapDataL2['pprc'] = dataL2['TCKDTLS']['PPRC'];
            mapDataL2['ticket'] = dataL2['TCKDTLS']['RESTCK'];

            selectData.value = {
              "caseCreated": dataL2['CASEDTLS']['USERCREATECASE'],
              "caseResolved": dataL2['CASEDTLS']['USERAPRCASE'],
              "tallyTips": dataL2['TALLYTIPS']['USERTIPS'],
              "testmoinels": dataL2['TESTIMONIAL']['USERTESTIMONIAL'],
              "feedbacks": dataL2['FEEDBACK']['USERMONTHFEEDBACK'],
              "ratings": dataL2['RATING']['USER'],
            };
            monthlyL2Data.value = {
              "caseCreated": dataL2['CASEDTLS']['USERCREATECASE'],
              "caseResolved": dataL2['CASEDTLS']['USERAPRCASE'],
              "tallyTips": dataL2['TALLYTIPS']['USERTIPS'],
              "testmoinels": dataL2['TESTIMONIAL']['USERTESTIMONIAL'],
              "feedbacks": dataL2['FEEDBACK']['USERMONTHFEEDBACK'],
              "ratings": dataL2['RATING']['USER'],
            };
            quarterlyL2Data.value = {
              "caseCreated": dataL2['CASEDTLS']['QRTUSERCREATECASE'],
              "caseResolved": dataL2['CASEDTLS']['QRTAPRCASE'],
              "tallyTips": dataL2['TALLYTIPS']['QRTTIPS'],
              "testmoinels": dataL2['TESTIMONIAL']['QRTTESTIMONIAL'],
              "feedbacks": dataL2['FEEDBACK']['QRTFEEDBACK'],
              "ratings": dataL2['RATING']['QRT'],
            };
            allL2Data.value = {
              "caseCreated": dataL2['CASEDTLS']['ALLUSERCREATECASE'],
              "caseResolved": dataL2['CASEDTLS']['ALLRAPRCASE'],
              "tallyTips": dataL2['TALLYTIPS']['ALLTIPS'],
              "testmoinels": dataL2['TESTIMONIAL']['ALLTESTIMONIAL'],
              "feedbacks": dataL2['FEEDBACK']['ALLFEEDBACK'],
              "ratings": dataL2['RATING']['ALL'],
            };
            avgRating.value = dataL2['RATINGAVG']['ALLRATING'];
            await getRating();
            await getDataL2();
            isLoading.value = false;
          } else {
            isLoading.value = false;
            CustomWidgets.snackBar(title: value.data.toString());
          }
        }
      });
      await Api()
          .fetchApi(
              data: json.encode(
                {"UID": DataInfo.userId.value, "LEADTYPE": "GIVEN"},
              ),
              action: "LEADDASHBOARD")
          .then((value) {
        if (value != null && value.success) {
          if (value.data.toString().contains("Please Update Your App") ==
              false) {
            var responseDataL2 = value.data;

            var data = responseDataL2['ROOT'][0]['DETAILS'][0];
            mapDataL2['lead'] = data['ACCEPTED'];
          } else {
            isLoading.value = false;
            CustomWidgets.snackBar(title: value.data.toString());
          }
        }
      });
      if (DataInfo.isSelectUser.value) {
        getUserData();
      }
    }
    if (DataInfo.box.hasData("status")) {
      if (DataInfo.box.read("status") == 1) {
        //  await Future.delayed(const Duration(seconds: 2));
        CustomWidgets.showProfileDialog();
        DataInfo.box.write("status", 2);
      }
    }
  }

  updateStatus(int index, String type) {
    String p1, p2, p3;

    if (index == 0) {
      if (type == "M") {
        p1 = "DAILYUSER";
        p2 = "USERACHIVD";
        p3 = "USERTGT";

        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      } else if (type == "T") {
        p1 = "DAILYTEAM";
        p2 = "TEAMACHIVD";
        p3 = "TEAMTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      } else {
        p1 = "DAILYFLOAR";
        p2 = "FLOARACHIVD";
        p3 = "FLOARTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      }
    } else if (index == 1) {
      if (type == "M") {
        p1 = "MONTHUSER";
        p2 = "USERACHIVD";
        p3 = "USERTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      } else if (type == "T") {
        p1 = "MONTHTEAM";
        p2 = "TEAMACHIVD";
        p3 = "TEAMTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      } else {
        p1 = "MONTHFLOAR";
        p2 = "FLOARACHIVD";
        p3 = "FLOARTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      }
    } else {
      if (type == "M") {
        p1 = "QRTUSER";
        p2 = "USERACHIVD";
        p3 = "USERTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;
        update();
        targetList[index]['percentage'] = status.value;

        update();
      } else if (type == "T") {
        p1 = "QRTTEAM";
        p2 = "TEAMACHIVD";
        p3 = "TEAMTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      } else {
        p1 = "QRTFLOAR";
        p2 = "FLOARACHIVD";
        p3 = "FLOARTGT";
        status.value =
            "${(int.parse(targetList[index][p2].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L / (${(int.parse(targetList[index][p3].toString()) / 100000).toDoubleStringAsFixed(digit: 2)}L)";
        targetList[index]['percentage'] = status.value;

        update();
      }
    }
  }

  updateChartData(int index) {
    if (DataInfo.desCat.value == "L1") {
      if (index == 0) {
        netValue.value = targetMap['DAILYUSER']['USERACHIVD'];
        faceTime.value = targetMap['FACETIME']['TODAY'];
      } else if (index == 1) {
        netValue.value = targetMap['MONTHUSER']['USERACHIVD'];
        faceTime.value = targetMap['FACETIME']['MONTHLY'];
      } else {
        netValue.value = targetMap['QRTUSER']['USERACHIVD'];
        faceTime.value = targetMap['FACETIME']['QURTER'];
      }
    }
    chartData = [
      ChartData("Me", double.parse(targetList[index]['meTarget']),
          const Color(0xff16BFD6)),
      ChartData("Team", double.parse(targetList[index]['teamTarget']),
          const Color(0xffF7BD65)),
      ChartData("Floor", double.parse(targetList[index]['floorTarget']),
          const Color(0xffA155B9)),
    ];

    update();
  }

  getOpportunity() async {
    Api()
        .fetchApi(
            data: json.encode(
              {
                "UID": DataInfo.userId.value,
                "DPID": "",
              },
            ),
            action: "GETOPP")
        .then((value) {
      try {
        if (value != null && value.success) {
          var data = value.data;
          if (data != null &&
              data['ROOT'] != null &&
              data['ROOT'][0] != null &&
              data['ROOT'][0].containsKey("OPPORTUNITY")) {
            opportunityList.value = data['ROOT'][0]['OPPORTUNITY'];
          }
        }
      } catch (e) {
        Get.snackbar(
            "Error", "Failed to load opportunities. Please try again.");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  getTopCustomerData() async {
    
    Api()
        .fetchApi(
            data: json.encode(
              {
                "UID": DataInfo.userId.value,
              },
            ),
            action: "GETTOPCUSTOMER")
        .then((value) {
      try {
        if (value != null && value.success) {
          var data = value.data;
          if (data != null &&
              data['records'] != null &&
              data['records'].isNotEmpty) {
            Map<String, dynamic> progressData = data['records'].first;

            topValue.value =
                Utilities.checkString(progressData['top30'].toString())
                    ? double.parse(progressData['top30'].toString())
                    : 0.0;

            nextTopValue.value =
                Utilities.checkString(progressData['nextTOP30'].toString())
                    ? double.parse(progressData['nextTOP30'].toString())
                    : 0.0;

            thirdTopValue.value =
                Utilities.checkString(progressData['OtherTOP30'].toString())
                    ? double.parse(progressData['OtherTOP30'].toString())
                    : 0.0;
          }
        }
      } catch (e) {
        Get.snackbar(
            "Error", "Failed to load top customer data. Please try again.");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  getLeadData() async {
    Api()
        .fetchApi(
            data: json.encode(
              {
                "UID": DataInfo.userId.value,
                'LEADTYPE': 'RECEIVED',
              },
            ),
            action: "LEADDASHBOARD")
        .then((value) {
      if (value != null && value.success) {
        var data = value.data;
        var targetData = data['ROOT'][0]['DETAILS'][0];
        leadData.value = targetData;
      }
    });
  }

  getUserData() async {
    Api()
        .fetchApi(data: DataInfo.userId.value, action: "TEAMMEMBER")
        .then((value) {
      try {
        if (value != null && value.success) {
          var userdata = value.data;
          userList.value = userdata;
          filterUserList.value = userdata;
          DataInfo.box.write("filterUserList", userdata);
        }
      } catch (e) {
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });
  }

  getRating() async {
    Api()
        .fetchApi(
            data: json
                .encode({"UNAME": DataInfo.username.value, "REQTYPE": "MONTH"}),
            action: "GETSUPRANK")
        .then((value) {
      if (value != null && value.success) {
        if (value.data.toString().contains("Please Update Your App") == false) {
          var responseDataL2 = value.data;

          for (int i = 0; i < responseDataL2.length; i++) {
            if (responseDataL2[i]['TYPE'] == "Floor") {
              overAllRating.value = responseDataL2[i]['RANK'];
            }
          }
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: value.data.toString());
        }
      }
    });
  }

  getDataL2() async {
    Api()
        .fetchApi(data: DataInfo.username.value.trim(), action: "CALLBOOK")
        .then((value) {
      if (value != null && value.success) {
        if (value.data.toString().contains("Please Update Your App") == false) {
          var responseDataL2 = value.data;

          if (responseDataL2['ROOT'][0].containsKey("DETAILS")) {
            var data = responseDataL2['ROOT'][0]['DETAILS'];

            mapDataL2['onsitevisits'] = data.length.toString();
            callBooking.value = data
                .where((element) =>
                    int.parse(element['DTFLT'].toString()) == 0 ||
                    int.parse(element['DTFLT'].toString()) == 1)
                .toList()
                .length
                .toString();
          } else {
            callBooking.value = "";
          }
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: value.data.toString());
        }
      }
    });

    await Api()
        .fetchApi(
            data: json.encode(
              {"UID": DataInfo.userId.value, "LEADTYPE": "GIVEN"},
            ),
            action: "LEADDASHBOARD")
        .then((value) {
      if (value != null && value.success) {
        if (value.data.toString().contains("Please Update Your App") == false) {
          var responseDataL2 = value.data;

          var data = responseDataL2['ROOT'][0]['DETAILS'][0];
          mapDataL2['lead'] = data['ACCEPTED'];
        } else {
          isLoading.value = false;
          CustomWidgets.snackBar(title: value.data.toString());
        }
      }
    });
  }

  searchUser() {
    filterUserList.value = userList
        .where((element) => element['NAME']
            .toString()
            .trim()
            .toLowerCase()
            .contains(search.trim().toLowerCase()))
        .toList();
    update();
  }

  updateData() {
    searchController.text = "";
    search.value = "";
    filterUserList.value = userList;
    update();
  }

  showProduct(int index) {
    if (selectPrdId.value != opportunityList[index]['ID']) {
      selectPrdId.value = opportunityList[index]['ID'];
    } else {
      selectPrdId.value = "";
    }
    update();
  }

  dataPointSearch(String? value) async {
    if (value!.trim().isNotEmpty) {
      var responseData = await Apis.sendData(
          json.encode(
            {
              "TALLYSRNO": "",
              "SRCHWORD": value,
              "UID": DataInfo.userId.value,
            },
          ),
          "SEARCHDATAPOINT&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");

      if (responseData != null) {
        var data = json.decode(responseData.body);
        listData.value = data;
        update();
      }
    } else {
      listData.value = [];
    }
    update();
  }

  void onRefresh() async {
    // monitor network fetch
    getData();
    //getDashboardData();
    // await Future.delayed(const Duration(milliseconds: 1000));

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    // await Future.delayed(const Duration(milliseconds: 1000));

    refreshController.loadComplete();
  }

  uploadData() async {
    try {
      // Loader();
      // DatabaseReference ref = FirebaseDatabase.instance.ref("tipOffBox/");
      //
      // await ref.push().set({
      //   "USERID": DataInfo.userId.value,
      //   "USERNAME": DataInfo.username.value,
      //   "USERTEAM": DataInfo.fullName.value,
      //   "DESIGNATION": DataInfo.designation.value,
      //   "DATE": DateFormat('EEE MMM dd yyyy').format(DateTime.now()),
      //   "TIME": "${TimeOfDay.now().hour} : ${TimeOfDay.now().minute}",
      //   "DESCRIPTION": content.text.trim(),
      // });
      //
      // Loader().hide();
      content.clear();
      CustomWidgets.showDialogWidget(
          title: "Thanks for being awesome!",
          content:
              "We’re thrilled to hear from you.Your ideas and suggestions are very important to us and we read every message that we receive.");
    } catch (e) {
      Loader().hide();
    }
  }

  updateRemindMeData() {
    remindMeList.add({
      "ID": remindMeList.length + 1,
      "DATE": selectRemindMeDate.value,
      "TIME": selectTime.value,
      "DESC": content1.text.trim()
    });

    selectTime.value = "";
    content1.clear();

    DataInfo.box.write("remindMe", remindMeList);
    Get.back();
  }

  getHistory() {
    Get.dialog(Center(
        child: Obx(
      () => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              "History",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ).centered().p8(),
            Container(
              width: Get.width,
              height: 1.0,
              color: Colors.grey[400],
            ),
            10.heightBox,
            SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: remindMeList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            remindMeList[index]['DESC'].toString(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          5.heightBox,
                          Row(
                            children: [
                              TextWidget(
                                remindMeList[index]['DATE'],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              5.widthBox,
                              TextWidget(
                                remindMeList[index]['TIME'],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ).p8(),
                    );
                  }),
            ),
            CustomButton(
              text: "OK",
              onPressed: () {
                Get.back();
              },
              width: 120,
              height: 40,
            ).centered()
          ],
        ).p8(),
      ).pSymmetric(h: 20.0, v: 8.0),
    )));
  }

  updateTheme(int index) {
    final themeController =
        Provider.of<AppThemeController>(Get.context!, listen: false);
    DataInfo.box.write("theme", index + 1);
    DataInfo.selectTheme.value = index + 1;
    appGradientColor.value = appTheme[index];
    appColor.value = appColorList[index];
    var theme = Get.put(AppTheme());
    theme.appGradientColor.value = appTheme[index];
    theme.appColor.value = appColorList[index];
    theme.changeTheme(appTheme[index]);
    themeController.changeTheme(appTheme[index]);
    update();
    Get.back();
  }

  void getNotificationData() async {
    String? data = await SharedPrefHelper.getString(DataInfo.notificationKey);

    if (data != null) {
      list = json.decode(data);
      bool status =
          await SharedPrefHelper.getBool('isReadNotification') ?? false;

      DataInfo.isReadNotification.value = status;
      if (DataInfo.isReadNotification.value == false) {
        badgesCount = list.length;
      }

      update();
    }
  }

  getNotificationListData() async {
    int unreadCount = await DBHelper().getUnreadCount();

    // int count = PrefsService().getNotificationCount();

    List<dynamic> list = PrefsService().getNotificationData();

    Get.context!
        .read<NotificationListProvider>()
        .updateNotificationData(list: list, count: unreadCount);
  }
}
