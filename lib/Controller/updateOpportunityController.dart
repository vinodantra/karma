
// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class UpdateOpportunityController extends GetxController{
  RxString selectLeadSource = "".obs;
  RxString selectLeasSourceId = "".obs;
  RxList<dynamic> leadSourceList = [].obs;

  RxString selectBusinessLine = "".obs;
  RxString selectBusinessLineId = "".obs;
  RxList<dynamic> businessLineList = [].obs;

  RxString selectPriceLevel = "".obs;
  RxString selectPriceLevelId = "".obs;
  RxList<dynamic> priceLevelList = [].obs;

  RxString selectTallyLedger = "".obs;
  RxString selectTallyLedgerId = "".obs;
  RxList<dynamic> tallyLedgerList = [].obs;

  RxString selectLocation = "".obs;
  RxString selectAddress = "".obs;
  RxList<dynamic> locationList  = [].obs;

  RxString selectContactPerson = "".obs;
  RxString selectContactPersonId = "".obs;
  RxList<dynamic> contactPersonList = [].obs;

  RxString selectTallySerial = "".obs;
  RxString selectTallySerialId = "".obs;
  RxList<dynamic> tallySerialList = [].obs;


  RxBool  isLoading = false.obs;
  RxMap data  = {}.obs;
  final remarkController = TextEditingController();
  final termController =  TextEditingController();


  @override
  void onInit() {
    data.value = Get.arguments;
    fetchApi();
    super.onInit();
  }

  @override
  void onClose() {
    remarkController.dispose();
    termController.dispose();
    super.onClose();
  }

  void fetchApi() async{
   // isLoading.value = true;

   await Future.wait([getLeadSource(),getData()]);
   isLoading.value = false;

  }

  Future<void> getLeadSource()async{
    Api().fetchApi(data: json.encode({"DPID":data['DPID'].toString()}), action: "PROPOSALSOURCE").then((value){
      try{
        if(value != null && value.success) {
          var data = value.data;

          var leadData = data['ROOT'][0]['LEDSRC'];

          var businessData = data['ROOT'][0]['BUSSSRC'];
          var priceData = data['ROOT'][0]['PRICELEVEL'];

          var tallyLedgerData = data['ROOT'][0]['TALLYLEDGER'];
          leadSourceList.value = leadData;
          businessLineList.value  = businessData;
          priceLevelList.value = priceData;
          tallyLedgerList.value = tallyLedgerData;




        }
        else{
          isLoading.value = false;
        }

      }catch(e){
        isLoading.value =  false;
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }


  Future<void> getData()async{
    Api().fetchApi(data: data['DPID'].toString(), action: "GETCALLENTRYDATA").then((value){
      try{
        if(value != null && value.success) {
          var data = value.data;

          var responseData = data['ROOT'][0];
          locationList.value = responseData['ADDRESS'];
          contactPersonList.value = responseData['CONTACT'];
          tallySerialList.value = responseData['TALLYSRNO'];


        }
        else{
          isLoading.value = false;
        }

      }catch(e){
        isLoading.value =  false;
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

}