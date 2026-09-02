// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
class UpdateLeadController extends GetxController{
  RxMap args = <String,dynamic>{}.obs;
  RxBool isLoading = false.obs;
  RxMap leadData = <String,dynamic>{}.obs;
  RxBool showData = false.obs;
  RxList<dynamic>  status = [{"ID":"1","NAME":"Accepted"},
    {"ID":"2","NAME":"InProcess"},
    {"ID":"3","NAME":"Untouched"},
    {"ID":"4","NAME":"Released"},
    {"ID":"5","NAME":"Rejected"},
  ].obs;
  RxString selectStatus = "Select".obs;
  RxString selectStatusId = "".obs;

  final comment = TextEditingController();
  @override
  void onInit() {

    args.value =  Get.arguments['leadData'];
    showData.value = Get.arguments['showData'];
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    comment.dispose();
    super.onClose();
  }

  void getData() async{
    isLoading.value = true;
    try{
      Api().fetchApi(data: args['ID'],action: "GIVENLEAD").then((value) {
        if(value != null && value.success) {
          var response = value.data!;
          if(response['ROOT'][0].containsKey("DETAILS"))
          {
            var data = response['ROOT'][0]['DETAILS'][0];
            leadData.value = data;
            selectStatus.value = Utilities.checkString(data['STATUS']) ? data['STATUS'] : "Select";
            isLoading.value = false;
          }
          else{
            isLoading.value = false;
          }
        }

        else{

          isLoading.value = false;
        }
      });
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      isLoading.value = false;
    }
  }

  updateData(){
    if(selectStatusId.isEmpty){
      CustomWidgets.snackBar(title: "Please select status.");
    }
    else if(comment.text.trim().isEmpty){
      CustomWidgets.snackBar(title: "Please enter comment.");
    }
    else{
      isLoading.value = true;
      try{

        Api().fetchApi(data: "${args['ID']}~$selectStatus~${comment.text.trim()}~${DataInfo.userId.value}~${args['DPID']}",action: "UPDATELEAD").then((value) {
          if(value != null && value.success) {
            Get.dialog(
              Center(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.lightGreen,
                        size: 50,
                      ),
                      20.heightBox,
                      TextWidget(
                        "Well Done!",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      15.heightBox,
                      TextWidget(
                        "Your Lead has been Successfully Updated.",
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      20.heightBox,
                      CustomButton(
                        text: "Ok",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      10.heightBox,
                    ],
                  ).p24(),
                ),
              ),
              barrierDismissible: false,
            ).then((value) {
              Get.back();
              //Get.offAll(() => Lead(),);
            });
          }

          else{

            isLoading.value = false;
          }
        });
      }catch(e){
        isLoading.value = false;
      }
    }
  }
}