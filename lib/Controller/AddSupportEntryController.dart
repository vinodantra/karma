// ignore_for_file: depend_on_referenced_packages, file_names
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';

/// Controller for managing support entry logic and state.
final class AddSupportEntryController extends GetxController {
  /// API action constants and keys.
  static const String updateCallAction = 'UPDATECALL';
  static const String categoryTypeAction = 'CATEGORYTYPE';
  static const String nameKey = 'NAME';
  static const String idKey = 'ID';

  /// Reactive data map.
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  /// Controllers for text fields.
  final TextEditingController tallySerialController = TextEditingController();
  final TextEditingController tallyNumberController = TextEditingController();
  final TextEditingController tallyNoController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController ccEmail = TextEditingController();
  final TextEditingController remark = TextEditingController();
  final TextEditingController observation = TextEditingController();
  final TextEditingController requirement = TextEditingController();

  /// Reactive state variables.
  final RxString selectTallyDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()).obs;
  final RxString tallyDate = DateFormat('ddMMMyyyy').format(DateTime.now()).obs;
  final RxString selectDate = "".obs;
  final RxString selectTicketType = "Select".obs;
  final RxString selectTicketTypeId = "".obs;
  final RxString selectTypeOfCall = "Select".obs;
  final RxString selectTypeOfCallId = "".obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> categoryList =
      <Map<String, dynamic>>[].obs;
  final RxString selectCategory = "Select".obs;
  final RxString selectCategoryId = "".obs;
  final RxBool experienceTicket = false.obs;
  final RxString message = "".obs;
  final RxString message1 = "".obs;
  final RxString observationMessage = "".obs;
  final RxString observationMessage1 = "".obs;
  final RxList<PlatformFile> selectFile = <PlatformFile>[].obs;
  final RxList<String> selectFilePath = <String>[].obs;
  final RxString requirementMessage = "".obs;
  final RxString requirementMessage1 = "".obs;
  final RxBool isShowObservation = false.obs;
  final RxBool isShowRequirement = false.obs;
  final RxList<String> ccEmailList = <String>[].obs;
  final RxList<Map<String, dynamic>> typeOfCallList = <Map<String, dynamic>>[
    {
      "ID": "95",
      "NAME": "Onsite Demo",
    },
    {
      "ID": "87",
      "NAME": "Onsite Visit",
    },
    {
      "ID": "82",
      "NAME": "Product Support Calls",
    },
    {
      "ID": "91",
      "NAME": "Requirement Discussions",
    },
    {
      "ID": "88",
      "NAME": "Training",
    },
  ].obs;
  final RxList<Map<String, dynamic>> typeOfCallList1 =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> ticketTypeList = <Map<String, dynamic>>[
    {
      "ID": "1",
      "NAME": "TLY",
    },
    {
      "ID": "2",
      "NAME": "AWT",
    }
  ].obs;
  final RxList<Map<String, dynamic>> levelList = <Map<String, dynamic>>[
    {"ID": "1", "NAME": "Critical"},
    {"ID": "2", "NAME": "Major"},
    {"ID": "3", "NAME": "Minor"},
    {"ID": "4", "NAME": "Requirement"},
  ].obs;
  final RxString selectLevel = "Select".obs;
  final RxString selectLevelId = "".obs;
  final RxList<Map<String, dynamic>> statusList = <Map<String, dynamic>>[
    {"ID": "1", "NAME": "Pending"},
    {"ID": "2", "NAME": "Resolved"},
  ].obs;
  final RxString selectStatus = "Select".obs;
  final RxString selectStatusId = "".obs;
  final RxBool isCCEmail = false.obs;

  /// Initializes the controller and loads initial data.
  @override
  void onInit() {
    if (Get.arguments != null) {
      data.value = Map<String, dynamic>.from(Get.arguments as Map);
      name.text = data['CONPER'];
      email.text = data['ALTEREMAILID'];
      tallySerialController.text = data['TALLYSRLNO'];
      tallyNumberController.text =
          Utilities.checkString(data['TCKNUMBER']) ? data['TCKNUMBER'] : "";
      isCCEmail.value = false;
      if (data['TEAMID'].toString() == "1") {
        getCategoryData();
      }
    }

    super.onInit();
  }

  @override
  void onClose() {
    tallySerialController.dispose();
    tallyNumberController.dispose();
    tallyNoController.dispose();
    name.dispose();
    email.dispose();
    ccEmail.dispose();
    remark.dispose();
    observation.dispose();
    requirement.dispose();
    super.onClose();
  }

  /// Updates the support entry status after validation and API call.
  Future<void> updateStatus() async {
    // if(tallyNumberController.text.trim().isEmpty)
    //   {
    //     CustomWidgets.snackBar(title: "Please enter Ticket number");
    //   }
    Loader();
    await Future.delayed(const Duration(seconds: 2));
    try {
      if (selectTypeOfCallId.isEmpty) {
        CustomWidgets.snackBar(title: "Please select type of call");
        Loader().hide();
      } else if (selectLevelId.isEmpty && data['TEAMID'] == "1") {
        CustomWidgets.snackBar(title: "Please select level of call");
        Loader().hide();
      } else if (selectCategoryId.isEmpty && data['TEAMID'] == "1") {
        CustomWidgets.snackBar(title: "Please select category");
        Loader().hide();
      } else if (selectStatusId.isEmpty && data['TEAMID'] == "1") {
        CustomWidgets.snackBar(title: "Please select status");
        Loader().hide();
      } else if (name.text.isEmpty) {
        CustomWidgets.snackBar(title: "Please enter attend person");
        Loader().hide();
      } else if (email.text.isEmpty) {
        CustomWidgets.snackBar(title: "Please enter attend person email");
        Loader().hide();
      } else if (remark.text.isEmpty) {
        CustomWidgets.snackBar(title: "Please enter remark");
        Loader().hide();
      }

      // else if (isCCEmail.value && ccEmailList.isEmpty) {
      //   CustomWidgets.snackBar(title: "Please enter send email.");
      //   Loader().hide();
      // }
      else {
        //308770|96|16:02|21:09||Critical|34|Resolved|test|Hassan|hassan%40antraweb.com|pranali t|ASC|1|731065725|||||YES

        List<dynamic> attachmentData = [];
        if (selectFile.isNotEmpty) {
          for (int i = 0; i < selectFile.length; i++) {
            attachmentData.add({
              "imgstr": await convertFileToBase64(file: selectFile[i]),
              "Name": selectFile[i].name.toString()
            });
          }
        }
        String attachmentData1 = json.encode(attachmentData);

        String content = "";

        content = "&ATTACH=$attachmentData1";
        if (data['ALTEREMAILID'].toString().trim() != email.text.trim() &&
            isCCEmail.value == true) {
          ccEmailList.add(data['ALTEREMAILID'].toString());
        }
        content = "$content&CCEMAIL=${ccEmailList.join(",")}";

        String apiData =
            "${data['ID']}|${selectTypeOfCallId.value}|${data['CHKIN']}|${data['CHKOUT'] != "00" ? data['CHKOUT'] : "${TimeOfDay.now().hour.toString()}:${TimeOfDay.now().minute.toString()}"}|${tallyNumberController.text}|${data['TEAMID'] == "1" ? selectLevel.value : ""}|${data['TEAMID'] == "1" ? selectCategoryId.value : "18"}|${data['TEAMID'] == "1" ? selectStatus.value : ""}|${remark.text}|${name.text}|${email.text}|${DataInfo.username.value}|${data['CALLTYPID']}|${data['TEAMID']}|${tallySerialController.text}|||||${data['TEAMID'] == "1" ? experienceTicket.value ? "YES" : "NO" : "NO"}|${requirement.text.trim()}|${observation.text.trim()}$content&ISEMAIL=${isCCEmail.value == true ? "YES" : "NO"}";

        Api().postApi(data: apiData, action: updateCallAction).then((value) {
          if (value != null && value.success) {
            Loader().hide();
            if (value.data == "YES") {
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
                            // Get.back();
                            Get.back(result: true);

                            //Get.to(()=>  const SupportList(),arguments: data);
                          },
                        ),
                        10.heightBox,
                      ],
                    ).p24(),
                  ),
                ),
                barrierDismissible: false,
              ).then((value) {
                Get.back(result: true);
                // Get.offAll(()=>  const SupportList(),arguments: data);
              });
            }

            isLoading.value = false;
          } else {
            Loader().hide();
            isLoading.value = false;
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
      Loader().hide();
    }
  }

  /// Fetches category data from the API.
  void getCategoryData() async {
    try {
      Api()
          .fetchApi(data: DataInfo.username.value, action: categoryTypeAction)
          .then((value) {
        if (value != null && value.success) {
          typeOfCallList1.value = (value.data['ROOT'][0]['CATEGORY'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          categoryList.value = (value.data['ROOT'][0]['SUPCATEGORY'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          

          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Enhances the remark text using GPT API.
  Future<void> chatGptApi() async {
    try {
      Loader();
      var apiResponse = await Apis.chatGptApi(message: remark.text.trim());

      if (apiResponse != null) {
        message.value = remark.text.trim();
        message1.value = apiResponse['MSG'];
        remark.text = apiResponse['MSG'];
        update();
        Loader().hide();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }
  }

  /// Toggles CC email status and clears list if disabled.
  void checkEmailStatus(bool value) {
    isCCEmail.value = value;
    if (isCCEmail.value == false) {
      ccEmailList.clear();
      ccEmail.clear();
    }
    update();
  }

  /// Updates the enhanced remark message.
  void updateData(String value) {
    message.value = value;
    update();
  }

  /// Selects the enhanced remark message.
  void selectData() {
    remark.text = message.value;
    update();
  }

  /// Toggle observation field visibility.
  void changeStatus1(bool value) {
    isShowObservation.value = !value;
    update();
  }

  /// Toggle requirement field visibility.
  void changeStatus2(bool value) {
    isShowRequirement.value = !value;
    update();
  }

  /// Enhances the observation text using GPT API.
  Future<void> chatGptApi1() async {
    try {
      Loader();
      var apiResponse = await Apis.chatGptApi(message: observation.text.trim());

      if (apiResponse != null) {
        observationMessage.value = observation.text.trim();
        observationMessage1.value = apiResponse['MSG'];
        observation.text = apiResponse['MSG'];
        update();
        Loader().hide();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }
  }

  /// Picks multiple files and updates the file lists.
  Future<void> pickMultipleFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Enable multiple file selection
    );

    if (result != null) {
      selectFile.addAll(result.files);
      List<String> filePaths = result.files.map((file) => file.path!).toList();
      selectFilePath.addAll(filePaths);
      update();
      // print("Selected files: $filePaths");
    }
  }

  /// Enhances the requirement text using GPT API.
  Future<void> chatGptApi2() async {
    try {
      Loader();
      var apiResponse = await Apis.chatGptApi(message: requirement.text.trim());

      if (apiResponse != null) {
        requirementMessage.value = requirement.text.trim();
        requirementMessage1.value = apiResponse['MSG'];
        requirement.text = apiResponse['MSG'];
        update();
        Loader().hide();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }
  }

  /// Updates the enhanced observation message.
  void updateData1(String value) {
    observationMessage.value = value;
    update();
  }

  /// Selects the enhanced observation message.
  void selectData1() {
    observation.text = observationMessage.value;
    update();
  }

  /// Updates the enhanced requirement message.
  void updateData2(String value) {
    requirementMessage.value = value;
    update();
  }

  /// Selects the enhanced requirement message.
  void selectData2() {
    requirement.text = requirementMessage.value;
    update();
  }

  /// Adds a CC email to the list after validation.
  void addCCEmail() {
    if (ccEmail.text.trim().isEmpty) {
      CustomWidgets.snackBar(title: "Please enter email.");
    } else if (ccEmail.text.trim().isEmail == false) {
      CustomWidgets.snackBar(title: "Please enter valid email.");
    } else {
      ccEmailList.add(ccEmail.text.trim());
      ccEmail.clear();
      update();
    }
  }

  /// Removes a CC email from the list.
  void removeCCEmail(int index) {
    ccEmailList.removeAt(index);
    update();
  }

  /// Returns the file icon path based on file extension.
  String getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return "assets/icons/ig.svg";
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return "assets/icons/video-icon.svg";
      case 'pdf':
        return "assets/icons/pdf-icon.svg";
      case 'doc':
      case 'docx':
      case 'txt':
        return "assets/icons/document-icon.svg";
      default:
        return "assets/icons/document-icon.svg";
    }
  }

  /// Removes a file from the selected files list.
  void removeFile(int index) {
    selectFile.removeAt(index);
    selectFilePath.removeAt(index);
    update();
  }

  /// Converts a file to a base64 string for API submission.
  Future<String?> convertFileToBase64({required PlatformFile file}) async {
    try {
      File selectFile = File(file.path!);

      List<int> fileBytes = await selectFile.readAsBytes();
      String base64String = base64Encode(fileBytes);
      return base64String;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
