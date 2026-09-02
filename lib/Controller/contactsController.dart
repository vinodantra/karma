// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class ContactsController extends GetxController {
  RxList<dynamic> contactList = [].obs;
  RxList<dynamic> allContacts = [].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString search = "".obs;
  final searchController = TextEditingController();
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async => getData();

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final value = await Api().fetchApi(action: "ANTRAUSER");
      if (value != null && value.success) {
        var jsonData = value.data;
        if (jsonData != null && jsonData['records'] != null) {
          contactList.value = jsonData['records'];
          allContacts.value = jsonData['records'];
        } else {
          contactList.value = [];
          allContacts.value = [];
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load contacts. Please try again.");
      hasError.value = true;
      if (kDebugMode) {
        print("error:$e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  int _matchPriority(Map<String, dynamic> element, String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) return 0;

    bool matches(dynamic field) =>
        field?.toString().trim().toLowerCase().contains(lowerQuery) ?? false;

    if (matches(element['NAME'])) return 1;
    if (matches(element['teamOwner'])) return 2;
    if (matches(element['DESIGNATION'])) return 3;
    if (matches(element['TEAMNAME'])) return 4;
    return 0;
  }

  searchUser() {
    if (search.value.trim().isEmpty) {
      contactList.value = List<dynamic>.from(allContacts);
    } else {
      final ranked = allContacts
          .map((e) => MapEntry(e, _matchPriority(e, search.value)))
          .where((entry) => entry.value > 0)
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      contactList.value = ranked.map((e) => e.key).toList();
    }
    update();
  }
}
