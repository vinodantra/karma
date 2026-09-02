// ignore_for_file: file_names

import '../Constants/Library.dart';

class CreateDataPointController extends GetxController {
  // -------------------------------
  // Rx Variables
  // -------------------------------
  RxBool isLoading = false.obs;

  RxInt selectTallyUser = 0.obs;

  RxString selectLead = "".obs;
  RxString selectLeadId = "".obs;
  RxString selectEpicenter = "".obs;
  RxString selectEpicenterId = "".obs;
  RxString selectSalutationData = "".obs;
  RxString selectProduct = "".obs;
  RxString selectUrt = "".obs;

  RxList<dynamic> lead = [].obs;
  RxList<dynamic> epicenter = [].obs;

  RxList<dynamic> salutationList = [
    {"id": "1", "name": "Mr."},
    {"id": "2", "name": "Mrs."},
    {"id": "3", "name": "Miss."},
    {"id": "4", "name": "Smt."},
    {"id": "5", "name": "Shri."},
  ].obs;

  RxList<dynamic> productList = [
    {"id": "1", "name": "Gold"},
    {"id": "2", "name": "Silver"},
    {"id": "3", "name": "Server9"},
  ].obs;

  RxList<dynamic> urtList = [
    {"id": "1", "name": "Yes"},
    {"id": "2", "name": "No"},
  ].obs;

  // -------------------------------
  // TextEditingControllers
  // -------------------------------
  final companyName = TextEditingController();
  final companyWebsite = TextEditingController();
  final contactName = TextEditingController();
  final designation = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final landlineNumber = TextEditingController();
  final tallySerialNumber = TextEditingController();
  final location = TextEditingController();

  // -------------------------------
  // Lifecycle
  // -------------------------------
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    companyName.dispose();
    companyWebsite.dispose();
    contactName.dispose();
    designation.dispose();
    mobile.dispose();
    email.dispose();
    landlineNumber.dispose();
    tallySerialNumber.dispose();
    location.dispose();
    super.onClose();
  }

  // -------------------------------
  // Load All Data
  // -------------------------------
  Future<void> getData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        getLeadSource(),
        getEpicData(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------
  // API: Lead Source
  // -------------------------------
  Future<void> getLeadSource() async {
    try {
      final response = await Api().fetchApi(action: "LEADSRC");

      if (response != null && response.success) {
        lead.value = response.data['ROOT'][0]['LEDSRC'];
      }
    } catch (e) {
      if (kDebugMode) print("Lead Source Error: $e");
    }
  }

  // -------------------------------
  // API: Epicenter
  // -------------------------------
  Future<void> getEpicData() async {
    try {
      final response = await Api().fetchApi(
        data: json.encode({"UID": DataInfo.userId.value}),
        action: "EPICMAST",
      );

      if (response != null && response.success) {
        epicenter.value = response.data['records'];
      }
    } catch (e) {
      if (kDebugMode) print("Epic Error: $e");
    }
  }

  // -------------------------------
  // Validation Logic
  // -------------------------------
  String? validate() {
    if (!Utilities.checkString(selectLeadId.value)) {
      return "Please select lead";
    }
    if (!Utilities.checkString(companyName.text)) {
      return "Please enter company name";
    }
    if (!Utilities.checkString(selectSalutationData.value)) {
      return "Please select salutation";
    }
    if (!Utilities.checkString(contactName.text)) {
      return "Please enter contact name";
    }
    if (!Utilities.checkString(mobile.text)) {
      return "Please enter mobile number";
    }
    if (!RegExp(r'^\d{10,15}$').hasMatch(mobile.text)) {
      return "Please enter valid mobile number (10-15 digits)";
    }
    if (!Utilities.checkString(email.text)) {
      return "Please enter email";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email.text)) {
      return "Please enter valid email";
    }
    if (!Utilities.checkString(landlineNumber.text)) {
      return "Please enter landline number";
    }
    if (!RegExp(r'^\d{1,15}$').hasMatch(landlineNumber.text)) {
      return "Please enter valid landline number (up to 15 digits)";
    }

    if (selectTallyUser.value != 1 && selectTallyUser.value != 2) {
      return "Please select tally user";
    }
    if (selectTallyUser.value == 1 &&
        !Utilities.checkString(tallySerialNumber.text)) {
      return "Please enter tally serial number";
    }
    if (selectTallyUser.value == 1 &&
        Utilities.checkString(tallySerialNumber.text) &&
        !validateTallySerial(tallySerialNumber.text)) {
      return "Please enter valid tally serial number";
    }

    if (selectTallyUser.value == 1 && !Utilities.checkString(selectUrt.value)) {
      return "Please select URT";
    }

    if (selectTallyUser.value == 1 &&
        !Utilities.checkString(selectProduct.value)) {
      return "Please select product";
    }

    return null;
  }

  // -------------------------------
  // Check & Submit
  // -------------------------------
  void checkData() {
    String? message = validate();

    if (message != null) {
      CustomWidgets.snackBar(title: message);
      return;
    }

    createDataPoint();
  }

  // Check Valid Tally Serial Number

  bool validateTallySerial(String input) {
    // Check 1: Must be exactly 9 digits
    if (input.length != 9) return false;

    // Check 2: Must be numeric only
    if (!RegExp(r'^\d+$').hasMatch(input)) return false;

    int number = int.parse(input);

    if (number % 9 != 0) return false;

    return true;
  }

  // -------------------------------
  // API: Create Data Point
  // -------------------------------
  Future<void> createDataPoint() async {
    isLoading.value = true;
    update();

    String website = companyWebsite.text.trim();
    if (website.isNotEmpty && !website.startsWith('http')) {
      website = 'https://$website';
    }

    Map<String, dynamic> body = {
      "UID": DataInfo.userId.value,
      "CMPNAME": companyName.text.trim(),
      "DPID": "0",
      "PHONE": landlineNumber.text.trim(),
      "SALUTATION": selectSalutationData.value,
      "CNTNAME": contactName.text.trim(),
      "DESG": Utilities.checkString(designation.text.trim())
          ? designation.text.trim()
          : "undefine",
      "MOBILE": mobile.text.trim(),
      "EMAIL": email.text.trim(),
      "TALLYUSE": selectTallyUser.value == 1 ? "Yes" : "No",
      "URT": selectUrt.value,
      "WEBSITE": website,
      "TALLYSRNO": tallySerialNumber.text.trim(),
      "LOCATION": location.text.trim(),
      "PRODUCT": selectProduct.value,
      "EPICID": Utilities.checkString(selectEpicenterId.value)
          ? selectEpicenterId.value
          : "0",
      "LDSRC": selectLeadId.value,
    };
    debugPrint("body: ${json.encode(body)}");

    try {
      final response = await Api().fetchApi(
        data: Uri.encodeComponent(json.encode(body)),
        action: "NEWDATAPOINT",
      );

      if (response?.success == true) {
        CustomWidgets.snackBar(title: "Data point created successfully");
        Get.back();
      }
    } catch (e) {
      debugPrint("Create Data Error: $e");
      CustomWidgets.snackBar(title: "Something went wrong");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
