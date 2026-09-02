// ignore_for_file: file_names

import '../Constants/Library.dart';

class PiwFormController extends GetxController {
  RxString callId = "".obs;
  RxBool isLoading = true.obs;
  RxList<dynamic> rawData = [].obs;
  RxList<dynamic> piwList = [].obs;
  RxList<dynamic> existingAnswers = [].obs;
  RxString selectPiwId = "".obs;
  RxString selectPiwName = "".obs;
  RxList<dynamic> questionList = [].obs;

  RxList<TextEditingController> answerControllerList =
      <TextEditingController>[].obs;
  RxList<dynamic> answerList = [].obs;
  RxList<dynamic> answeredPiwList = [].obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      callId.value = Get.arguments['id'].toString();
    }

    getPiwData();
    super.onInit();
  }

  @override
  void onClose() {
    for (var controller in answerControllerList) {
      controller.dispose();
    }
    super.onClose();
  }

  void getPiwData() async {
    Api()
        .fetchApi(
            data: json.encode({"CALLID": callId.value}), action: "WORKSHOPMST")
        .then((value) {
      try {
        if (value != null && value.success) {
          final response = value.data!;
          rawData.value = response['Table'];
          existingAnswers.value = response['Table1'];

          for (int i = 0; i < rawData.length; i++) {
            if (piwList.any((element) =>
                    element['ID'].toString() == rawData[i]['ID'].toString()) ==
                false) {
              piwList.add(rawData[i]);
            }
          }

          for (int i = 0; i < existingAnswers.length; i++) {
            if (answeredPiwList.any((element) =>
                    element['ID'].toString() ==
                    existingAnswers[i]['PIWID'].toString()) ==
                false) {
              int index = piwList.indexWhere((element) =>
                  element['ID'].toString() ==
                  existingAnswers[i]['PIWID'].toString());

              if (index >= 0) {
                if (Utilities.checkString(
                    piwList[index]['Question'].toString())) {
                  answeredPiwList.add(piwList[index]);
                }
              }
            }
          }

          // print("js:${answeredPiwList}");
          // print("ajkdks:${answerList}");
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to load data. Please try again.");
        isLoading.value = false;
      } finally {
        isLoading.value = false;
        update();
      }
    });
  }

  selectPiwData(final data) {
    selectPiwId.value = data['ID'].toString();
    selectPiwName.value = data['PIW_Name'].toString();

    selectQuestionData();

    update();
  }

  updatePiwData() async {
    isLoading.value = true;
    update();
    Api()
        .postApi1(
            data: json.encode({"DATA": answerList}), action: "SAVEWORKSHOPREF")
        .then((value) {
      try {
        if (value != null && value.success) {
          selectPiwId.value = "";
          selectPiwName.value = "";
          rawData.value = [];
          questionList.value = [];
          answerList.value = [];
          answerControllerList.value = [];
          existingAnswers.value = [];
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
                      "PIW Answers submit successfully.",
                      fontSize: 16,
                      color: Colors.grey[500],
                      textAlign: TextAlign.center,
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
          ).then((value) {
            // Get.back();
            //Get.offAll(() => const ConveyanceEntry(), arguments: data);
          });
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to submit data. Please try again.");
        isLoading.value = false;
      } finally {
        getPiwData();
        isLoading.value = false;
        update();
      }
    });
  }

  selectQuestionData() {
    try {
      questionList.value = rawData
          .where((element) =>
              element['ID'].toString() == selectPiwId.value &&
              Utilities.checkString(element['Question'].toString()))
          .toList();

      answerControllerList.value = List.generate(
          questionList.length, (index) => TextEditingController());
      for (int i = 0; i < questionList.length; i++) {
        if (existingAnswers.any((element) =>
            element['Q_ID'].toString() == questionList[i]['Q_id'].toString())) {
          var data = existingAnswers
              .where((element) =>
                  element['Q_ID'].toString() ==
                  questionList[i]['Q_id'].toString())
              .toList()
              .first;
          answerControllerList[i].text =
              Utilities.checkString(data['DESCR'].toString())
                  ? data['DESCR'].toString()
                  : "";
          questionList[i]['DESCR'] = data['DESCR'].toString();
        }
      }
      answerList.value = List.generate(
          questionList.length,
          (index) => {
                "DPID": DataInfo.dpId.value,
                "CALLID": callId.value,
                "PIWID": selectPiwId.value,
                "Q_ID": questionList[index]['Q_id'].toString(),
                "DESCR": questionList[index]['DESCR'].toString()
              });

      update();
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
    }
  }

  updateAnswer(int index, String value) {
    answerList[index]['DESCR'] = value;
  }
}
