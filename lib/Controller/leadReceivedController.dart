// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class LeadReceivedController extends GetxController {
  RxString lead = "".obs;
  RxString leadType = "".obs;
  RxList<dynamic> list = [].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  final description = TextEditingController();
  RxList<dynamic> ticketTypeList = [].obs;
  RxString selectTicket = "Ticket Type".obs;
  RxString selectTicketId = "".obs;
  @override
  void onInit() {
    final args = Get.arguments ?? {};
    lead.value = (args['lead'] ?? '').toString();
    leadType.value = (args['leadtype'] ?? '').toString();

    getData();
    getTickerData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final resp = await Api().fetchApi(
          data: json.encode({
            "USERID": DataInfo.userId.value,
            "LEADTYPE": leadType.value,
          }),
          action: lead.value == "Given" ? "LEADLIST" : "RCVLEADLIST");
      if (resp?.success == true) {
        final response = resp?.data;
        if (response is Map &&
            response['ROOT'] is List &&
            (response['ROOT'] as List).isNotEmpty) {
          final root1 = (response['ROOT'] as List)[0];
          if (root1 is Map &&
              root1.containsKey('DETAILS') &&
              root1['DETAILS'] is List) {
            list.value = List<dynamic>.from(root1['DETAILS']);
          } else {
            list.value = [];
          }
        } else {
          list.value = [];
        }
      } else {
        list.value = [];
        hasError.value = true;
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('getData error: $e');
        print(st);
      }
      list.value = [];
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTickerData() async {
    try {
      final resp = await Api().fetchApi(action: "TCKLEADSTYPE");
      if (resp?.success == true) {
        final response = resp?.data;
        if (response is Map && response['records'] is List) {
          ticketTypeList.value = List<dynamic>.from(response['records']);
        }
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('getTickerData error: $e');
        print(st);
      }
    }
  }

  Future<bool> createTicket(String id) async {
    if (selectTicketId.isEmpty) {
      CustomWidgets.snackBar(title: "Please select Ticket Type");
      return false;
    }
    Loader();
    try {
      final resp = await Api().fetchApi(
          data: json.encode({
            "LEADID": id,
            "LEADTYPE": selectTicketId.value,
            "DESCR": description.text.trim()
          }),
          action: "LEADTICKET");
      final success = resp?.success == true;

      if (success) {

        selectTicket.value = "";
        selectTicketId.value = "";
        description.clear();
        Loader().hide();

        CustomWidgets.showDialogWidget(title: "Alert", content: resp!.message);
        await getData();
      } else {
        Loader().hide();
        CustomWidgets.showDialogWidget(
            title: "Alert",
            content: resp?.message ?? 'Failed to create ticket');
      }
      return success;
    } catch (e, st) {
      if (kDebugMode) {
        print('createTicket error: $e');
        print(st);
        Loader().hide();
      }
      return false;
    }
  }

  @override
  void onClose() {
    description.dispose();
    super.onClose();
  }
}
