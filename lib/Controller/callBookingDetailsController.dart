// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

/// Controller for managing call booking details.
class CallBookingDetailsController extends GetxController {
  /// Observable map holding call booking data.
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  /// List of available options for call booking actions.
  static const String optionIdCreateLead = "1";
  static const String optionIdTicketHistory = "2";
  static const String optionIdSupportVisitHistory = "3";
  static const String optionIdConveyanceEntry = "4";
  static const String optionIdProductServices = "5";

  final List<Map<String, String>> optionList1 = [
    {"ID": optionIdCreateLead, "NAME": "Create Lead"},
    {"ID": optionIdTicketHistory, "NAME": "Ticket History"},
    {"ID": optionIdSupportVisitHistory, "NAME": "Support/Visit History"},
    {"ID": optionIdConveyanceEntry, "NAME": "Conveyance Entry"},
    {"ID": optionIdProductServices, "NAME": "Product & Services"},
  ];

  /// Observable for loading state.
  final RxBool isLoading = false.obs;

  /// Observable for workshop applicability.
  final RxBool isWorkShop = false.obs;

  /// Observable for workshop date.
  final RxString workShopDate = "".obs;

  /// Observable for workshop status.
  final RxBool workShopStatus = false.obs;

  @override
  void onInit() {
    data.value = Get.arguments;

    // Remove "Create Lead" option if TALLYSRLNO is not valid
    if (!Utilities.checkString(data['TALLYSRLNO']?.toString() ?? "")) {
      optionList1.removeWhere((element) => element['ID'] == optionIdCreateLead);
      update();
    }

    DataInfo.dpId.value = data['COMPANYID']?.toString() ?? "";
    super.onInit();
  }

  /// Updates the check-in/out status for a call booking.
  Future<void> updateStatus(
    Map<String, dynamic> bookingData,
    String latitude,
    String longitude,
    String address,
  ) async {
    isLoading.value = true;
    final String sendData =
        "${bookingData['ID']}|${bookingData['COMPANYID']}|${DateTime.now()}|$latitude,$longitude||$latitude|$longitude|${bookingData['UID']}|${DataInfo.userId.value}||${workShopStatus.value ? 1 : 0}";

    Api().fetchApi(data: sendData.trim(), action: "CHKINOUTDATA").then((value) {
      try {
        if (value != null && value.success) {
          final response = value.data;
          if (response == "YES") {
            getData();
            Get.dialog(
              Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        "Check In/Out",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ).p8(),
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      10.heightBox,
                      TextWidget(
                        address,
                        fontSize: 16,
                        maxLines: 10,
                        textAlign: TextAlign.center,
                      ),
                      10.heightBox,
                      CustomButton(
                        text: "OK",
                        onPressed: () {
                          Get.back();
                        },
                        width: 120,
                        height: 40,
                      )
                    ],
                  ).p8(),
                ).p8(),
              ),
            ).then((_) => Get.back(canPop: false));
          } else {
            CustomWidgets.snackBar(title: value.data);
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        if (kDebugMode) {
          print("error: $e");
        }
      }
    });
  }

  /// Fetches the latest call booking data.
  void getData() async {
    Api()
        .fetchApi(data: DataInfo.userId.value, action: "CALLBOOK")
        .then((value) {
      try {
        if (value != null && value.success) {
          final response = value.data!;
          final List<dynamic> jsonData = response['ROOT'][0]['DETAILS'];
          final List<dynamic> list = jsonData
              .where((element) =>
                  element['ID'].toString() == data['ID'].toString())
              .toList();
          if (list.isNotEmpty) {
            data.value = list.first;
          }
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        if (kDebugMode) {
          print("getData error: $e");
        }
      }
    });
  }

  /// Changes the workshop status and updates the UI.
  void changeWorkShopStatus(statusValue) {
    workShopStatus.value = statusValue;
    update();
  }

  /// Checks if the workshop is applicable for the given company and call ID.
  Future<bool> checkStatus(String companyId, String id) async {
    try {
      isLoading.value = true;
      isWorkShop.value = false;
      update();
      ApiResponse? apiResponse = await Api().fetchApi(
        data: json.encode({"DPID": companyId, "CALLID": id}),
        action: "ISWORKSHOP",
      );
      if (apiResponse != null && apiResponse.success) {
        isWorkShop.value =
            apiResponse.data['Table'][0]['ispplicable'] == 'Yes';
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
      if (kDebugMode) {
        print("checkStatus error: $e");
      }
      return false;
    }
  }
}
