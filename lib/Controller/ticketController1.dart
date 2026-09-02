// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';



class TicketListController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxString search = "".obs;
  RxList<dynamic> ticketList = [].obs;
  RxList<dynamic> list1 = [].obs;

  RxList<dynamic> pendingList = [].obs;
  RxList<dynamic> resolvedList = [].obs;
  RxList<dynamic> pendingList1 = [].obs;
  RxList<dynamic> resolvedList1 = [].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  late PageController pageController;
  RxString fromDate = DateFormat('yyyyMMdd')
      .format(DateTime.now().subtract(const Duration(days: 7)))
      .toString()
      .obs;
  RxString toDate =
      DateFormat('yyyyMMdd').format(DateTime.now()).toString().obs;

  DateTime? selectFromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime? selectToDate = DateTime.now();
  RxString selectData = "Pending".obs;
  @override
  void onInit() {
    pageController = PageController();
    getList();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    pageController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async => getList();

  void getList() async {
    isLoading.value = true;
    hasError.value = false;
    search.value = "";
    searchController.clear();
    update();

    try {
      Api()
          .fetchApi(
              data: json.encode({
                "fromdate": fromDate.value,
                "todate": toDate.value,
                "uid": DataInfo.userId.value
              }),
              action: "GETANTRATICKET")
          .then((value) {
        if (value != null && value.success) {
          var jsonData = value.data;
          if (jsonData['statuscode'] == 1) {
            //  ticketList.value  = json.decode(jsonData['data']);
            list1.value = json.decode(jsonData['data']);


            pendingList.value =
                list1.where((element) => element['STATUS'] != "Resolved").toList();
            pendingList1.value =
                list1.where((element) => element['STATUS'] != "Resolved").toList();
            resolvedList.value = list1.where((element) => element['STATUS'].trim() == "Resolved").toList();
            resolvedList1.value = list1.where((element) => element['STATUS'].trim() == "Resolved").toList();





          //  filterDataList();
            update();
          }

          isLoading.value = false;
          update();
        } else {
          hasError.value = true;
          isLoading.value = false;
          update();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("error:$e");
      }
      hasError.value = true;
      isLoading.value = false;
      update();
    }
  }

  selectDate(DateTimeRange dateTimeRange) {
    selectFromDate = dateTimeRange.start;
    selectToDate = dateTimeRange.end;

    fromDate.value = DateFormat('yyyyMMdd').format(selectFromDate!).toString();
    toDate.value = DateFormat('yyyyMMdd').format(selectToDate!).toString();
    update();

    getList();
  }

  filterDataList() {
    if (search.value.trim().isNotEmpty) {

      pendingList.value = pendingList1
          .where((element) =>
              (element['Ticket']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase()) ||
                  element['Subject']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase()) ||
                  element['AllocatedUser']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase()) ||
                  element['AllocatedTeam']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase()) ||
                  element['Team']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase()) ||
                  element['Created_Date']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase())) ||
              element['Priority']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .contains(search.value.trim().toLowerCase()))
          .toList();

      resolvedList.value = resolvedList1
          .where((element) =>
      (element['Ticket']
          .toString()
          .trim()
          .toLowerCase()
          .contains(search.value.trim().toLowerCase()) ||
          element['Subject']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.value.trim().toLowerCase()) ||
          element['AllocatedUser']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.value.trim().toLowerCase()) ||
          element['AllocatedTeam']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.value.trim().toLowerCase()) ||
          element['Team']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.value.trim().toLowerCase()) ||
          element['Created_Date']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.value.trim().toLowerCase())) ||
          element['Priority']
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.value.trim().toLowerCase()))
          .toList();


    }
    else{
      pendingList.value =
          list1.where((element) => element['STATUS'] != "Resolved").toList();
      pendingList1.value =
          list1.where((element) => element['STATUS'] != "Resolved").toList();
      resolvedList.value = list1.where((element) => element['STATUS'].trim() == "Resolved").toList();
      resolvedList1.value = list1.where((element) => element['STATUS'].trim() == "Resolved").toList();
      update();
    }


    update();
  }

  pageChange(int value){
    if(value == 0){
      selectData.value = "Pending";
    }
    else{
      selectData.value = "Resolved";
    }
    update();

  }
}
