// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

/// Controller for managing conveyance entry operations.
class ConveyanceEntryController extends GetxController {
  /// Observable map holding conveyance data.
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> travelByList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> conveyanceList =
      <Map<String, dynamic>>[].obs;
  final RxString selectTravelByData = "Select".obs;
  final RxString selectTravelById = "".obs;
  final TextEditingController from = TextEditingController();
  final TextEditingController to = TextEditingController();
  final TextEditingController fromLocationController = TextEditingController();
  final TextEditingController toLocationController = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController passAmount = TextEditingController();
  final TextEditingController comment = TextEditingController();
  final TextEditingController distanceController = TextEditingController();

  static const String passTypeBus = "Bus";
  static const String passTypeMetro = "Metro";
  static const String passTypeMonorail = "Monorail";
  static const String passTypeTrain = "Train";

  final RxList<Map<String, String>> passTypeList = <Map<String, String>>[
    {"ID": "1", "NAME": passTypeBus},
    {"ID": "2", "NAME": passTypeMetro},
    {"ID": "3", "NAME": passTypeMonorail},
    {"ID": "4", "NAME": passTypeTrain},
  ].obs;

  final RxString petrolPrice = "".obs;
  final RxString selectPassType = "Select".obs;
  final RxString selectFromDate = "".obs;
  final RxString selectToDate = "".obs;
  final RxString fromLocation = "".obs;
  final RxString toLocation = "".obs;
  final RxMap<String, dynamic> callDetails = <String, dynamic>{}.obs;
  final RxBool showPassData = false.obs;
  final RxBool isShowButton = true.obs;
  final RxBool isLoading = false.obs;

  /// API action names as static constants
  static const String actionGetSource = "GETSOURCE";
  static const String actionGetConveyance = "GETCONVAYANCE";
  static const String actionDeleteConveyance = "DELETECONVAYANCE";
  static const String actionPassConv = "PASSCONV";
  static const String actionCallBook = "CALLBOOK";
  static const String actionPetrolRate = "PETROLRATE";
  static const String actionSetConveyance = "SETCONVAYANCE";

  @override
  void onInit() {
    data.value = Get.arguments;
    getData();
    getTravelByData();
    getConveyanceData(data['ID']?.toString() ?? "");
    super.onInit();
  }

  @override
  void onClose() {
    from.dispose();
    to.dispose();
    fromLocationController.dispose();
    toLocationController.dispose();
    amount.dispose();
    passAmount.dispose();
    comment.dispose();
    distanceController.dispose();
    super.onClose();
  }

  /// Fetches travel by options from API.
  Future<void> getTravelByData() async {
    Api().fetchApi(action: actionGetSource).then((value) {
      try {
        if (value != null && value.success) {
          final jsonResponse = value.data;
          travelByList.value = List<Map<String, dynamic>>.from(
              jsonResponse['ROOT'][0]['DETAILS']);
        }
      } catch (e) {
        if (kDebugMode) {
          print("getTravelByData error: $e");
        }
      }
    });
  }

  /// Fetches conveyance data for a given ID.
  Future<void> getConveyanceData(String id) async {
    Api().fetchApi(data: id, action: actionGetConveyance).then((value) {
      try {
        if (value != null && value.success) {
          final jsonResponse = value.data;
          conveyanceList.value = List<Map<String, dynamic>>.from(
              jsonResponse['ROOT'][0]['DETAILS']);
        }
      } catch (e) {
        if (kDebugMode) {
          print("getConveyanceData error: $e");
        }
      }
    });
  }

  /// Fetches call details data from API.
  Future<void> getData() async {
    Api()
        .fetchApi(data: DataInfo.username.value, action: actionCallBook)
        .then((value) {
      try {
        if (value != null && value.success) {
          final jsonResponse = value.data;
          callDetails.value =
              Map<String, dynamic>.from(jsonResponse['ROOT'][0]['DETAILS'][0]);
        }
      } catch (e) {
        if (kDebugMode) {
          print("getData error: $e");
        }
      }
    });
  }

  /// Deletes a conveyance entry by ID.
  Future<void> deleteConveyanceData(String id) async {
    Api().fetchApi(data: id, action: actionDeleteConveyance).then((value) {
      try {
        if (value?.success == true) {
          if (value?.data == "Yes") {
            Get.find<ConveyanceEntryController>().onInit();
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("deleteConveyanceData error: $e");
        }
      }
    });
  }

  /// Creates a new pass entry.
  Future<void> createPass() async {
    Api()
        .fetchApi(
      data: json.encode({
        "PASSTYPE": selectPassType.value,
        "FROMDATE": selectFromDate.value,
        "TODATE": selectToDate.value,
        "FROMLOC": fromLocationController.text,
        "TOLOC": toLocationController.text,
        "PASSAMT": passAmount.text.trim(),
        "UNAME": DataInfo.username.value,
      }),
      action: actionPassConv,
    )
        .then((value) {
      try {
        if (value?.success == true) {
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
                      "You pass successfully created.",
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    20.heightBox,
                    CustomButton(
                      text: "Ok",
                      onPressed: () {
                        Get.offAll(() => const ConveyanceEntry(),
                            arguments: data);
                      },
                    ),
                    10.heightBox,
                  ],
                ).p24(),
              ),
            ),
            barrierDismissible: false,
          ).then((_) {
            Get.offAll(() => const ConveyanceEntry(), arguments: data);
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print("createPass error: $e");
        }
      }
    });
  }

  /// Fetches petrol price for the call date.
  Future<void> getPrice() async {
    Api()
        .fetchApi(
      data: json.encode({"CALLDATE": callDetails['CALLDATE']}),
      action: actionPetrolRate,
    )
        .then((value) {
      try {
        if (value != null && value.success) {
          final jsonResponse = value.data;
          petrolPrice.value = jsonResponse['records'][0]['RATE'].toString();
          showPassData.value = true;
        }
      } catch (e) {
        if (kDebugMode) {
          print("getPrice error: $e");
        }
      }
    });
  }

  /// Adds a new conveyance entry.
  Future<void> addConveyanceEntry() async {
    isShowButton.value = false;
    isLoading.value = true;
    update();
    Api()
        .fetchApi(
      data: Uri.encodeComponent(
        "${data['ID']}|${data['CALLDATE']}|${data['CMP']}|${DataInfo.username.value}|${from.text.trim()}|${to.text.trim()}|${selectTravelByData.value}|${amount.text.trim()}|${comment.text.trim()}|",
      ),
      action: actionSetConveyance,
    )
        .then((value) {
      try {
        from.clear();
        to.clear();
        fromLocationController.clear();
        toLocationController.clear();
        comment.clear();
        amount.clear();
        passAmount.clear();
        distanceController.clear();
        selectTravelByData.value = "Select";
        selectTravelById.value = "";
        if (value?.success == true) {
          if (value?.data == 'YES') {
            Get.dialog(
              Center(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Your Conveyance Entry Added Successfully.",
                        fontSize: 16,
                        color: Colors.grey[500],
                        textAlign: TextAlign.center,
                      ),
                      20.heightBox,
                      CustomButton(
                        text: "Ok",
                        onPressed: () {
                          getData();
                          getConveyanceData(data['ID']?.toString() ?? "");
                          Get.back();
                        },
                      ),
                      10.heightBox,
                    ],
                  ).p24(),
                ),
              ),
              barrierDismissible: false,
            ).then((_) {
              isShowButton.value = true;
              isLoading.value = false;
              update();
            });
          }
        }
      } catch (e) {
        isShowButton.value = true;
        isLoading.value = false;
        update();
        if (kDebugMode) {
          print("addConveyanceEntry error: $e");
        }
      } finally {
        isShowButton.value = true;
        isLoading.value = false;
        update();
      }
    });
  }

  /// Validates form data and triggers conveyance entry addition.
  void checkData() {
    if (from.text.trim().isEmpty) {
      CustomWidgets.snackBar(title: "Please enter from location.");
    } else if (to.text.trim().isEmpty) {
      CustomWidgets.snackBar(title: "Please enter to location.");
    } else if (selectTravelByData.value == "Select") {
      CustomWidgets.snackBar(title: "Please select travel by");
    } else if (amount.text.trim().isEmpty) {
      CustomWidgets.snackBar(title: "Please enter amount.");
    } else {
      addConveyanceEntry();
    }
  }
}
