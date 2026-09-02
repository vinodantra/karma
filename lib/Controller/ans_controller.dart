import '../Constants/Library.dart';

/// Controller for managing answer and user data.
final class AnsController extends GetxController {
  /// Indicates if data is loading.
  final RxBool isLoading = true.obs;

  /// Indicates if last fetch failed.
  final RxBool hasError = false.obs;

  /// List of filtered answer data.
  final RxList<Map<String, dynamic>> ansData = <Map<String, dynamic>>[].obs;

  /// List of all answer data.
  final RxList<Map<String, dynamic>> list = <Map<String, dynamic>>[].obs;

  /// List of users.
  final RxList<Map<String, dynamic>> usersList = <Map<String, dynamic>>[].obs;

  /// Currently selected user name.
  final RxString userName = 'Select User'.obs;
  // Remove unused id if not needed.
  // final RxString id = ''.obs;

  /// API action constants.
  static const String getAnsAction = 'GETANS';
  static const String ansUserAction = 'ANSUSER';

  @override
  void onInit() {
    super.onInit();
    // getUserList();
    getAnsData();
  }

  /// Filters answer data by selected user name.
  void changeData() {
    ansData.value = list
        .where((element) => element['PersonName'] == userName.value)
        .toList();
    update();
  }

  /// Pull-to-refresh entry point.
  Future<void> onRefresh() async => getAnsData();

  /// Fetches answer data from the API and populates lists.
  Future<void> getAnsData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
      hasError.value = false;
      update();
    });

    try {
      final value = await Api().fetchApi(
        data: json.encode({"login_id": DataInfo.userId.value}),
        action: getAnsAction,
      );

      if (value != null && value.success) {
        final jsonResponse = value.data;
        final List<dynamic> decodedData = json.decode(jsonResponse['data']);
        ansData.value = List<Map<String, dynamic>>.from(decodedData);
        list.value = List<Map<String, dynamic>>.from(decodedData);
        for (final item in list) {
          if (list.isNotEmpty) {
            if (!usersList
                .any((element) => element['NAME'] == item['PersonName'])) {
              usersList.add({"ID": "1", "NAME": item['PersonName']});
            }
          } else {
            usersList.add({"ID": "1", "NAME": item['PersonName']});
          }
        }
        update();
      } else {
        ansData.value = <Map<String, dynamic>>[];
        hasError.value = true;
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred: $e");
      }
      hasError.value = true;
      update();
    } finally {
      isLoading.value = false;
      update();
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Loader().hide();
      // });
    }
  }

  /// Fetches user list from the API.
  Future<void> getUserList() async {
    isLoading.value = true;
    try {
      final value = await Api().fetchApi(
        data: json.encode({"login_id": DataInfo.userId.value}),
        action: ansUserAction,
      );
      if (value != null && value.success) {
        final jsonResponse = value.data;
        final List<dynamic> decodedUsers = json.decode(jsonResponse['data']);
        usersList.value = List<Map<String, dynamic>>.from(decodedUsers);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
