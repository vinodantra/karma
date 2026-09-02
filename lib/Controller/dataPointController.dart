// ignore_for_file: file_names

import 'dart:async';

import 'package:karma/Constants/Library.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DataPointController extends GetxController {
  RxList<dynamic> dataPointList = [].obs;
  RxList<dynamic> listData = [].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString search = "".obs;
  RxString qualifiedFilter = "All".obs; // All | Qualified | Non Qualified
  TextEditingController searchController = TextEditingController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Timer? _debounce;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    await getData();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));

    refreshController.loadComplete();
  }

  Future<void> getData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final value = await Api()
          .fetchApi(data: DataInfo.username.value, action: "GETDATAPOINT");
      if (value != null && value.success) {
        var jsonResponse = value.data;

        var data = jsonResponse['ROOT'][0]['DETAILS'];
        // Sort data in ascending order by DPNAME (or change key as needed)
        data.sort((a, b) => (a['DPNAME']?.toString() ?? '')
            .toLowerCase()
            .compareTo((b['DPNAME']?.toString() ?? '').toLowerCase()));
        dataPointList.value = data;
        listData.value = data;
      } else {
        hasError.value = true;
        CustomWidgets.snackBar(title: "Failed to load data points");
      }
    } catch (e) {
      hasError.value = true;
      CustomWidgets.snackBar(title: "Something went wrong");
      if (kDebugMode) {
        print("error:$e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  searchUser() {
    final query = search.trim().toLowerCase();
    final filter = qualifiedFilter.value;

    dataPointList.value = listData.where((element) {
      final matchesSearch = element['DPNAME']
          .toString()
          .trim()
          .toLowerCase()
          .contains(query);

      final isQualified =
          (element['Qualified'] ?? '').toString().trim().toLowerCase() == 'yes';

      final matchesFilter = filter == 'Qualified'
          ? isQualified
          : filter == 'Non Qualified'
              ? !isQualified
              : true;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void onFilterChanged(String value) {
    qualifiedFilter.value = value;
    searchUser();
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () {
      search.value = value;
      searchUser();
    });
  }
}
