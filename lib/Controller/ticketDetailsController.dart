// ignore_for_file: file_names

import '../Constants/Library.dart';
class TicketDetailsController extends GetxController{
  RxMap args = {}.obs;
  RxBool isLoading =  false.obs;
  RxMap ticketData = {}.obs;
  RxList<dynamic> interactionList = [].obs;
  @override
  void onInit() {
    args.value = Get.arguments;

    getData();
    super.onInit();
  }
  void getData() async{
    isLoading.value = true;



    try{

      var response =  await Apis.sendData5("TICKETDETAILS|${args['TICKET']}|");
      if(response != null){
        var responseData = json.decode(response.body);

        ticketData.value = responseData['ROOT']['ticket_details'];
        interactionList.value = responseData['ROOT']['ticket_details']['interaction'];
        Map<String,dynamic> data = interactionList.first;

        if(interactionList.first['int_no'].contains('Customer')){
          interactionList.removeAt(0);
          interactionList.add(data);
        }


        isLoading.value = false;

      }
      else{
        isLoading.value = false;
      }
    }catch(e){
      isLoading.value = false;
    }


    

  }
  bool isHtml(String input) {
    final htmlTagPattern = RegExp(r'<[^>]+>'); // Matches anything in angle brackets
    return htmlTagPattern.hasMatch(input);
  }
}