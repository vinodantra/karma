

import 'package:karma/Constants/Library.dart';

class TopListController extends GetxController {
  final searchText = ''.obs;
  final selectedFilter = 'All'.obs;

  final filters = ['All', 'Non ASC', 'Non AC', 'Non TSS', 'Non A CX'];
  final isLoading = false.obs;
  final mapDataL2 = {}.obs;

  RxList<dynamic> companyList = <dynamic>[].obs;
  RxList<dynamic> filteredList = <dynamic>[].obs;
  RxString type = 'Top 30'.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      String arg = Get.arguments as String;
      type.value = arg;
    }
    fetchTopCustomerDetails();
    super.onInit();
  }

  void clearSearch() {
    searchText.value = '';
    filterCompanies();
  }

  @override
  void onReady() {
    ever(searchText, (_) => filterCompanies());
    ever(selectedFilter, (_) => filterCompanies());
    super.onReady();
  }

  void filterCompanies() {
    final search = searchText.value.trim().toLowerCase();
    final filter = selectedFilter.value;
    filteredList.value = companyList.where((company) {
      // Search
      final matchesSearch = search.isEmpty ||
          (company['NAME']?.toString().toLowerCase().contains(search) ?? false);

      // Filter
      if (filter == 'All') {
        // Show all data, only apply search
        return matchesSearch;
      } else if (filter == 'Non ASC') {
        return matchesSearch &&
            (double.parse(company['ASC']?.toString() ?? '0') == 0);
      } else if (filter == 'Non AC') {
        return matchesSearch &&
            (double.parse(company['Antracloud']?.toString() ?? '0') == 0);
      } else if (filter == 'Non TSS') {
        return matchesSearch &&
            (double.parse(company['TSS']?.toString() ?? '0') == 0);
      } else if (filter == 'Non A CX') {
        return matchesSearch && (double.parse(company['CX'].toString()) == 0);
      }
      return matchesSearch;
    }).toList();
  }

  Future<void> fetchTopCustomerDetails() async {
    isLoading.value = true;

    try {
      await Api()
          .fetchApi(
        data: json.encode({
          "UID": DataInfo.userId.value
        }),
        action: "GETTOPCUSTOMERDETAILS",
      )
          .then((value) {

        if (value != null && value.success == true) {
          companyList.value = value.data['records']
              .where((company) =>
                  company['CATEGORY']?.toString() == type.value.toUpperCase())
              .toList();
          selectedFilter.value = 'All';
          filterCompanies();
          update();
        }
        isLoading.value = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
    }
  }
}
