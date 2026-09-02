// ignore_for_file: file_names

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Constants/Library.dart';

class TicketStatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<dynamic> ticketList = [].obs;
  RxList<dynamic> list = [].obs;

  RxList<dynamic> ticketStatus = [
    {"ID": "0", "NAME": "Normal"},
    {"ID": "2", "NAME": "Emergency"},
    {"ID": "3", "NAME": "Experience"}
  ].obs;
  RxString selectTicketStatus = "".obs;
  RxString selectTicketStatusId = "".obs;
  RxString search = "".obs;
  final searchController = TextEditingController();
  RxInt selectIndex = (-1).obs;

  /// Team members for the "user selection" dropdown — shared with the
  /// dashboard (persisted under GetStorage key "filterUserList").
  RxList<dynamic> userList = [].obs;
  RxList<dynamic> filterUserList = [].obs;

  /// Currently selected user for filtering tickets. Defaults to the logged-in
  /// user; the API sends [selectUserId] (current user's id by default, or the
  /// selected user's id).
  RxString selectUser = "User".obs;
  RxString selectUserId = "".obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void onInit() {
    selectUserId.value = DataInfo.userId.value;
    selectUser.value = DataInfo.username.value.trim().isNotEmpty
        ? DataInfo.username.value
        : "User";
    if (DataInfo.box.hasData("filterUserList")) {
      userList.value = DataInfo.box.read("filterUserList");
      filterUserList.value = DataInfo.box.read("filterUserList");
    }
    getData();
    super.onInit();
  }

  /// Sets the selected user (name + id) and reloads the ticket list.
  void onSelectUser(dynamic user) {
    selectUser.value = (user['NAME'] ?? '').toString();
    selectUserId.value = (user['ID'] ?? '').toString();
    getData();
  }

  @override
  void onClose() {
    searchController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  void getData() async {
    isLoading.value = true;
    Api()
        .fetchApi(
            data: "30|${selectUserId.value}", action: "GETSUPPALLPENDTICKET")
        .then((value) {
      try {
        if (value != null && value.success) {
          var jsonData = value.data;

          list.value = jsonData['records'];
          ticketList.value = jsonData['records'];

          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
      }
    });
  }

  void updateStatus(String ticket, String id) async {
    Api().fetchApi(data: "$ticket|$id", action: "ACTTCKUPDATE").then((value) {
      try {
        if (value != null && value.success) {
          getData();
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
      }
    });
  }

  getTicketStatus(String id) {
    return ticketStatus.firstWhere((element) => element['ID'] == id,
        orElse: () => {"NAME": ""});
  }

  Future<void> onRefresh() async {
    getData();

    // await Future.delayed(const Duration(milliseconds: 1000));
    //
    // refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));

    refreshController.loadComplete();
  }

  Color checkColor(String value) {
    if (value == "Normal") {
      return Colors.green;
    } else if (value == "Experience") {
      return Colors.orange;
    } else if (value == "Emergency") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  searchUser() {
    ticketList.value = list
        .where((element) =>
            element['NAME']
                .toString()
                .trim()
                .toLowerCase()
                .contains(search.trim().toLowerCase()) ||
            element['TICKET']
                .toString()
                .trim()
                .toLowerCase()
                .contains(search.trim().toLowerCase()))
        .toList();
    update();
  }

  String checkDate(date) {
    try {
      String result = date.replaceFirst(RegExp(r':(?!.*:)'), '');
      return result;
    } catch (e) {
      return date;
    }
  }

  selectTicket(int index) {
    if (selectIndex.value != index) {
      selectIndex.value = index;
    } else {
      selectIndex.value = -1;
    }
  }
}
