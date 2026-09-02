// ignore_for_file: file_names

import '../Constants/Library.dart';

/// Controller backing the Escalation forms.
///
/// Fetches the customer master used by the "Customer Name" picker via the
/// `ESCALATIONMST` action. The API returns:
/// `{"records": {"Table": [{"ID": 126105, "NAME": "13 threads"}, ...]}}`
class EscalationController extends GetxController {
  RxBool isLoading = false.obs;

  /// Full customer master as returned by the API.
  RxList<dynamic> customerList = <dynamic>[].obs;

  /// Filtered view driven by the search box in the picker.
  RxList<dynamic> filteredCustomers = <dynamic>[].obs;

  /// Category master used by the "Category" dropdown. The Ticket tab uses
  /// `Table1`; the Internal tab uses `Table3` ([internalCategoryList]).
  RxList<dynamic> categoryList = <dynamic>[].obs;
  RxList<dynamic> internalCategoryList = <dynamic>[].obs;
  RxString selectedCategoryId = "".obs;
  RxString selectedCategoryName = "".obs;

  /// Improvement Area master (`Table2`) used by the "Improvement Area" dropdown.
  RxList<dynamic> improvementAreaList = <dynamic>[].obs;
  RxString selectedImprovementAreaId = "".obs;
  RxString selectedImprovementAreaName = "".obs;

  /// Subcategory master (`Table4`) used by the Internal form's "Subcategory"
  /// dropdown. Each row carries an `internal_category` that ties it to a
  /// category.
  RxList<dynamic> subcategoryList = <dynamic>[].obs;
  RxString selectedSubcategoryId = "".obs;
  RxString selectedSubcategoryName = "".obs;

  /// User master (`Table5`) used by the Internal form's "User Name" dropdown.
  /// Each row carries an `internal_category` that ties it to a category.
  RxList<dynamic> userList = <dynamic>[].obs;
  RxString selectedUserId = "".obs;
  RxString selectedUserName = "".obs;

  /// Currently selected customer.
  RxString selectedCustomerId = "".obs;
  RxString selectedCustomerName = "".obs;

  /// Ticket info fetched for the selected customer via `DPTICKETINFO`.
  RxBool isTicketLoading = false.obs;
  RxList<dynamic> ticketList = <dynamic>[].obs;
  RxString selectedTicketNo = "".obs;
  RxString ticketUid = "".obs;
  RxString escalateToDevId = "".obs;

  /// True while a `SAVEESCALATION` submit is in flight.
  RxBool isSaving = false.obs;

  @override
  void onInit() {
    getCustomers();
    super.onInit();
  }

  void getCustomers() async {
    isLoading.value = true;
    Api()
        .fetchApi(
      data: '{"uid":"${DataInfo.userId.value}"}',
      action: "ESCALATIONMST",
    )
        .then((value) {
      try {
        if (value != null && value.success) {
          final records = value.data['records'];
          final table = records is Map ? records['Table'] : records;
          customerList.value = (table as List?) ?? [];
          filteredCustomers.value = customerList;

          if (records is Map) {
            categoryList.value = (records['Table1'] as List?) ?? [];
            improvementAreaList.value = (records['Table2'] as List?) ?? [];
            internalCategoryList.value = (records['Table3'] as List?) ?? [];
            subcategoryList.value = (records['Table4'] as List?) ?? [];
            userList.value = (records['Table5'] as List?) ?? [];
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("getCustomers error: ${e.toString()}");
        }
      } finally {
        isLoading.value = false;
      }
    });
  }

  void searchCustomer(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredCustomers.value = customerList;
    } else {
      filteredCustomers.value = customerList
          .where((e) =>
              (e['NAME'] ?? '').toString().trim().toLowerCase().contains(q))
          .toList();
    }
  }

  void selectCustomer(dynamic customer) {
    selectedCustomerId.value = (customer['ID'] ?? '').toString();
    selectedCustomerName.value = (customer['NAME'] ?? '').toString().trim();
    getTicketInfo(selectedCustomerId.value);
  }

  void selectCategory(dynamic category) {
    // Ticket categories (Table1) use ID/NAME; Internal categories (Table3) use
    // id/internal_category.
    selectedCategoryId.value =
        (category['ID'] ?? category['id'] ?? '').toString();
    selectedCategoryName.value =
        (category['NAME'] ?? category['internal_category'] ?? '')
            .toString()
            .trim();
    // Subcategory and user lists are category-scoped, so a category change
    // invalidates the previously selected subcategory/user.
    selectedSubcategoryId.value = "";
    selectedSubcategoryName.value = "";
    selectedUserId.value = "";
    selectedUserName.value = "";
  }

  /// Rows from [source] whose `internal_category` matches the selected category
  /// (compared against both the category id and name to be safe). Returns the
  /// full list when no category is selected yet.
  List<dynamic> _forSelectedCategory(List<dynamic> source) {
    final catId = selectedCategoryId.value.trim().toLowerCase();
    final catName = selectedCategoryName.value.trim().toLowerCase();
    if (catId.isEmpty && catName.isEmpty) return source;
    return source.where((e) {
      final ic = (e['internal_category'] ?? '').toString().trim().toLowerCase();
      return ic == catId || ic == catName;
    }).toList();
  }

  List<dynamic> subcategoriesForSelectedCategory() =>
      _forSelectedCategory(subcategoryList);

  List<dynamic> usersForSelectedCategory() => _forSelectedCategory(userList);

  void selectSubcategory(dynamic sub) {
    // Table4 rows follow the internal_* convention (id + internal_subcategory,
    // tied to a category via internal_category).
    selectedSubcategoryId.value = (sub['ID'] ?? sub['id'] ?? '').toString();
    selectedSubcategoryName.value =
        (sub['internal_SubCategory'] ?? sub['NAME'] ?? '').toString().trim();
  }

  void selectUser(dynamic user) {
    // Table5 rows use ID + internal_username.
    selectedUserId.value = (user['ID'] ?? user['id'] ?? '').toString();
    selectedUserName.value =
        (user['internal_username'] ?? user['NAME'] ?? '').toString().trim();
  }

  void selectImprovementArea(dynamic area) {
    selectedImprovementAreaId.value = (area['ID'] ?? '').toString();
    selectedImprovementAreaName.value = (area['NAME'] ?? '').toString().trim();
  }

  /// Fetches the ticket number for the selected customer (dpid) via
  /// `DPTICKETINFO`. Response:
  /// `{"records": {"Table": [{"TICKET": "AWT-...", "UID": 2235, "Escalatetodevid": null}]}}`
  /// When [updateTicket] is false the ticket number is not touched (used by the
  /// preset flow from Ticket Details, where the ticket comes from the row) —
  /// only `UID` (exeid) and Escalatetodevid are fetched.
  void getTicketInfo(String dpid, {bool updateTicket = true}) async {
    if (dpid.trim().isEmpty) return;
    if (updateTicket) {
      isTicketLoading.value = true;
      selectedTicketNo.value = "";
    }
    ticketUid.value = "";
    escalateToDevId.value = "";
    ticketList.clear();
    Api()
        .fetchApi(
      data: '{"dpid":"$dpid"}',
      action: "DPTICKETINFO",
    )
        .then((value) {
      try {
        if (value != null && value.success) {
          final records = value.data['records'];
          final table = records is Map ? records['Table'] : records;
          if (table is List && table.isNotEmpty) {
            ticketList.value = table;
            if (updateTicket) {
              // A single ticket auto-selects; multiple tickets let the user
              // pick one from the dropdown.
              if (table.length == 1) {
                selectTicket(table.first);
              }
            } else {
              // Preset flow: keep the row's ticket number, but set exeid from
              // the matching ticket (falls back to the first).
              final match = table.firstWhere(
                (r) =>
                    (r['TICKET'] ?? '').toString().trim() ==
                    selectedTicketNo.value.trim(),
                orElse: () => table.first,
              );
              ticketUid.value = (match['UID'] ?? '').toString();
              escalateToDevId.value =
                  (match['Escalatetodevid'] ?? '').toString();
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("getTicketInfo error: ${e.toString()}");
        }
      } finally {
        if (updateTicket) isTicketLoading.value = false;
      }
    });
  }

  /// Selects one ticket row (from [ticketList]); its `UID` becomes `exeid`.
  void selectTicket(dynamic row) {
    selectedTicketNo.value = (row['TICKET'] ?? '').toString().trim();
    ticketUid.value = (row['UID'] ?? '').toString();
    escalateToDevId.value = (row['Escalatetodevid'] ?? '').toString();
  }

  /// Submits the Ticket-tab escalation via `SAVEESCALATION`. `exeid` is the
  /// `UID` returned by DPTICKETINFO; `touserid` and `subcatid` are sent as "0".
  Future<bool> saveEscalation({
    required String background,
    required String observation,
    required String recommendation,
  }) {
    return _postEscalation({
      "userid": DataInfo.userId.value,
      "dpid": selectedCustomerId.value,
      "exeid": ticketUid.value,
      "catid": selectedCategoryId.value,
      "imprid": selectedImprovementAreaId.value,
      "touserid": "0",
      "subcatid": "0",
      "background": background.trim(),
      "observation": observation.trim(),
      "Recommendation": recommendation.trim(),
      "ticket": selectedTicketNo.value,
    });
  }

  /// Submits the Internal-tab escalation via `SAVEESCALATION`. `touserid` is the
  /// selected User Name id; `subcatid` is only sent when the category is
  /// "Account" (otherwise "0"); dpid/exeid/ticket are unused here and sent "0".
  Future<bool> saveInternalEscalation({
    required String background,
    required String observation,
    required String recommendation,
  }) {
    final cat = selectedCategoryName.value.trim().toLowerCase();
    final isAccount = cat == 'account' || cat == 'accounts';
    return _postEscalation({
      "userid": DataInfo.userId.value,
      "dpid": "0",
      "exeid": "0",
      "catid": selectedCategoryId.value,
      "imprid": selectedImprovementAreaId.value,
      "touserid": selectedUserId.value,
      "subcatid": isAccount ? selectedSubcategoryId.value : "0",
      "background": background.trim(),
      "observation": observation.trim(),
      "Recommendation": recommendation.trim(),
      "ticket": "",
    });
  }

  /// Posts a `SAVEESCALATION` payload and reports success. A JSON body always
  /// decodes to a Map with HTTP 200, so `value.success` is true even for an
  /// error payload like {"status":"Error","statuscode":"0","msg":"..."}; treat
  /// the escalation as saved only when the server reports statuscode 1.
  Future<bool> _postEscalation(Map<String, dynamic> payload) async {
    if (isSaving.value) return false;
    isSaving.value = true;
    try {
      final value = await Api()
          .postApi1(data: json.encode(payload), action: "SAVEESCALATION");
      if (value != null && value.data is Map) {
        final data = value.data as Map;
        final msg = (data['msg'] ?? '').toString().trim();
        if ((data['statuscode'] ?? '').toString() == '1') {
          CustomWidgets.snackBar(
              title: msg.isNotEmpty ? msg : 'Escalation saved successfully.');
          return true;
        }
        CustomWidgets.snackBar(
            title: msg.isNotEmpty ? msg : 'Could not save escalation.');
        return false;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("saveEscalation error: ${e.toString()}");
      }
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
