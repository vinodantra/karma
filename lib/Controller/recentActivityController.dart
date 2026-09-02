
// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:karma/Constants/Library.dart';

import 'package:intl/intl.dart';
class RecentActivityController extends GetxController{
  RxMap data  = {}.obs;
  RxString selectType = "1".obs;
  RxList<dynamic> activityList = [].obs;
  RxList<dynamic> proposalList = [].obs;
  RxString proformaData = "".obs;
  RxBool isLoading  = false.obs;
  RxList<dynamic> activityList1 = [].obs;



  var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void onInit() {
    data.value = Get.arguments;
    getActivityData();
    super.onInit();
  }
  getActivityData()async{
    isLoading.value = true;

    Api().fetchApi(
        data: json.encode({"OPPID":"0","DPID":data['DPID'].toString()}),
        action: "OPPRECENTACTIVITY").then((value) {
      try{

        if(value != null && value.success)
        {
          var jsonResponse =
          value.data;
         // activityList.value = jsonResponse;
         // print(activityList.sort((a,b)=>a['FLWDATE'].toString().compareTo(b['FLWDATE'].toString())).toString());

         // sortList();
          List<dynamic> list = jsonResponse.where((element)=>element['FLWDATE'].toString() != "0").toList();
          var de = sortList(list);

          activityList1.addAll(de);
          activityList.value = activityList1
              .fold({}, (previousValue, element) {
            Map val = previousValue;
            String? date = element['FLWDATE'];
            if (!val.containsKey(date)) {
              val[date] = [];
            }
            // element.remove('release_date');
            val[date]?.add(element);
            return val;
          })
              .entries
              .map((e) => {"id":e.key,
            "value":e.value})
              .toList();


          isLoading.value = false;
        }
        else
        {
          isLoading.value = false;
          CustomWidgets.snackBar(title: "Failed to load activities");
        }

      }catch(e){
        isLoading.value = false;
        CustomWidgets.snackBar(title: "Something went wrong");
        if (kDebugMode) {
          print("error:$e");
        }
      }
    });


  }

  List<dynamic> sortList(List list) {

    return list..sort((a,b)=>DateFormat('dd-MMM-yy').parse(b['FLWDATE'].toString()).compareTo(DateFormat('dd-MMM-yy').parse(a['FLWDATE'].toString())));
  }

  checkDate(String date){
    return DateTime.parse(DateFormat('dd-MMM-yy').parse(date).toString()).difference(DateTime.parse(currentDate.toString())).toString();
  }
}