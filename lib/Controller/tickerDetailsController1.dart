// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class TicketDetailsController1 extends GetxController {
  RxString ticketNumber = "".obs;
  RxBool isLoading = false.obs;
  RxList<dynamic> interactionList = [].obs;
  RxMap ticketData = {}.obs;
  @override
  void onInit() {
    ticketNumber.value = Get.arguments;
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading.value = true;

    try {
      var response = await Apis.sendData5("TICKETDETAILS|$ticketNumber|");
      if (response != null) {
        var responseData = json.decode(response.body);

        ticketData.value = responseData['ROOT']['ticket_details'];
        interactionList.value =
            responseData['ROOT']['ticket_details']['interaction'];
        //interactionList.value = interactionList;
        Map<String, dynamic> data = interactionList.first;

        if (interactionList.first['int_no'].contains('Customer')) {
          interactionList.removeAt(0);
          interactionList.add(data);
        }

        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error:${e.toString()}");
      }
      isLoading.value = false;
    }
  }

  bool isHtml(String input) {
    final htmlTagPattern =
        RegExp(r'<[^>]+>'); // Matches anything in angle brackets
    return htmlTagPattern.hasMatch(input);
  }
}
