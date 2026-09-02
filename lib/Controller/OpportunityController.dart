// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class OpportunityController extends GetxController{
  RxList<dynamic> opportunityList = [].obs;
  RxList<dynamic> list = [].obs;
  RxString selectPrdId = "".obs;
  RxBool isLoading = false.obs;
  TextEditingController searchController =  TextEditingController();
  RxString search = "".obs;
  RxString type = "All".obs;

  RxMap data  = {}.obs;

  /*
  {"ID":"1",
    "NAME":"Change Status"},{"ID":"2",
    "NAME":"Create Proposal"},
    {"ID":"3",
      "NAME":"Create Sales Order"},
    {"ID":"4",
      "NAME":"Create Sales Invoice"},
    {"ID":"5",
      "NAME":"Delivery Request"},
    {"ID":"6",
      "NAME":"Edit/Update"},
  */
  List<dynamic> optionList = [{"ID":"1",
    "NAME":"Change Status"},
    {"ID":"2",
      "NAME":"Edit/Update"},];

  List<dynamic> optionList1 = [{"ID":"1",
    "NAME":"Change Status"},{"ID":"2",
    "NAME":"Create Proposal"},

    {"ID":"3",
      "NAME":"Create Sales Invoice"},
    {"ID":"4",
      "NAME":"Delivery Request"},
    {"ID":"5",
      "NAME":"Add Attachment"},];

  List<dynamic> filterOption = [{"ID":"1",
    "NAME":"All"},{"ID":"2",
    "NAME":"Open"},

    {"ID":"3",
      "NAME":"Close Won"},
    ];
  @override
  void onInit() {


    if(Get.arguments != null){
      data.value = Get.arguments;
    }


    getData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  getData() async {
    isLoading.value = true;

    Api().fetchApi(data:json.encode(
      {
        "UID": Get.arguments == null ?  DataInfo.userId.value :"",
        "DPID": Get.arguments != null ?  data['DPID'].toString() : "",
      },
    ), action: "GETOPP").then((value){
      try{
        if(value != null && value.success){
          var data = value.data;
          opportunityList.value = data['ROOT'][0]['OPPORTUNITY'];
          list.value = data['ROOT'][0]['OPPORTUNITY'];
          opportunityList.value  = list.where((element) => element['STATUS'] ==  "Open").toList();
          isLoading.value =  false;
        }

      }catch(e){
        isLoading.value =  false;
      }
    });

  }
  showProduct(int index)
  {
    if(selectPrdId.value != opportunityList[index]['ID'])
    {
      selectPrdId.value = opportunityList[index]['ID'];
    }
    else
    {
      selectPrdId.value = "";
    }
    update();


  }
  filterDataList(){

    if(type.value == "All" && search.trim().isEmpty)
      {
        opportunityList.value = list;
      }
    else if(type.value == "All" && search.trim().isNotEmpty)
      {
        opportunityList.value  = list.where((element) => element['DPNAME'].toString().trim().toLowerCase().contains(search.value.trim().toLowerCase())).toList();
      }
    else
      {

        opportunityList.value  = list.where((element) => element['STATUS'] ==  type.value).toList();


      }
    update();


  }
}