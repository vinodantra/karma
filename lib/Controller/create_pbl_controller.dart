import 'package:karma/Constants/Library.dart';
import 'package:karma/Application/PblReport/PblReport.dart';
class CreatePblController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectTime = "".obs;



  RxList usersList = [].obs;
  RxString currentTime = "".obs;
  RxString currentTime1 = "".obs;
  RxString currentDate = ''.obs;
  RxString selectDate = DateTime.now().toString().obs;
  RxString type = "".obs;
  RxString userName = ''.obs;
  RxString id = ''.obs;
  final desc = TextEditingController();
  final observation = TextEditingController();
  final requirement = TextEditingController();
  RxString message = "".obs;
  RxString message1 = "".obs;

  RxString observationMessage = "".obs;
  RxString observationMessage1 = "".obs;

  RxString requirementMessage = "".obs;
  RxString requirementMessage1 = "".obs;
  RxBool isShowObservation = false.obs;
  RxBool isShowRequirement = false.obs;
  @override
  void onInit() {
    super.onInit();
    final ctx = Get.context;
    final now = TimeOfDay.now();
    final formatted = ctx != null ? now.format(ctx) : _fallbackTime(now);
    currentTime.value = formatted;
    currentTime1.value = formatted;
    getUserList();
  }

  @override
  void onClose() {
    desc.dispose();
    observation.dispose();
    requirement.dispose();
    super.onClose();
  }

  String _fallbackTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  changeStatue1(value){
    isShowObservation.value = !value;
    update();
  }

  changeStatue2(value){
    isShowRequirement.value = !value;
    update();
  }

  getUserList() async {

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 100));
    Loader();
    try {
      var value = await Api().fetchApi(
        data: json.encode({"login_id": DataInfo.userId.value}),
        action: "ANSUSER",
      );

      if (value != null && value.success) {

        var jsonResponse = value.data;
        usersList.value = json.decode(jsonResponse['data']);
        update();
      }
    } catch (e) {
      Loader().hide();
      if (kDebugMode) {
        print("Error occurred: $e");
      }
    } finally {
      Loader().hide();
      isLoading.value = false;
    }
  }

  createAns() async {


    try {
      if(id.value.isEmpty){
        CustomWidgets.snackBar(title: "Please select username");
      }else if(type.value.isEmpty){
        CustomWidgets.snackBar(title: "Please select ans type");
      }
      else if(currentDate.value.isEmpty){
        CustomWidgets.snackBar(title: "Please select ans date");
      }
      else if(currentTime.value.isEmpty){
        CustomWidgets.snackBar(title: "Please select time");
      }
      else if(currentTime1.value.isEmpty){
        CustomWidgets.snackBar(title: "Please select time");
      }
      else if(observation.text.trim().isEmpty){
        CustomWidgets.snackBar(title: "Please enter topic");
      }
      // else if(desc.text.trim().isEmpty){
      //   CustomWidgets.snackBar(title: "Please enter description");
      // }
      else{
        Loader();
        var response = await Api().fetchApi(
            data: json.encode({
              "fromdate": "${currentDate.value} ${currentTime.value}",
              "todate": "${currentDate.value} ${currentTime1.value}",
              "login_id": DataInfo.userId.value,
              "person_id": id.value,
              "type": type.value,
              "descr": desc.text,
              "recommandation":observation.text.trim(),
              "requirment":requirement.text.trim(),
              "ispbl":"YES"

            }),
            action: "ANS");

        if (response!.success == true) {
          Loader().hide();
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
                      "Entry Successfully Created.",
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    20.heightBox,
                    CustomButton(
                      text: "Ok",
                      onPressed: () {
                        Get.offAll(() => const PblReport());
                      },
                    ),
                    10.heightBox,
                  ],
                ).p24(),
              ),
            ),
            barrierDismissible: false,
          ).then((value) {
            // Get.offAll(()=>  const Lead(),arguments: data);
          });
        }
        else{
          isLoading.value = false;
          update();
        }
      }







    } catch (e) {
      isLoading.value = false;
      update();
      if (kDebugMode) {
        print("Error occurred: $e");
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
  void chatGptApi()async{


    try{
      Loader();
      var apiResponse = await Apis.chatGptApi(message: desc.text.trim());


      if(apiResponse != null){

        message.value = desc.text.trim();
        message1.value = apiResponse['MSG'];
        desc.text =  apiResponse['MSG'];
        update();
        Loader().hide();
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }




  }

  void chatGptApi1()async{


    try{
      Loader();
      var apiResponse = await Apis.chatGptApi(message: observation.text.trim());


      if(apiResponse != null){

        observationMessage.value = observation.text.trim();
        observationMessage1.value = apiResponse['MSG'];
        observation.text =  apiResponse['MSG'];
        update();
        Loader().hide();
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }




  }
  void chatGptApi2()async{


    try{
      Loader();
      var apiResponse = await Apis.chatGptApi(message: requirement.text.trim());


      if(apiResponse != null){

        requirementMessage.value = requirement.text.trim();
        requirementMessage1.value = apiResponse['MSG'];
        requirement.text =  apiResponse['MSG'];
        update();
        Loader().hide();
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }




  }
  updateData(value){
    message.value = value;
    update();
  }

  selectData(){
    desc.text = message.value;
    update();
  }

  updateData1(value){
    observationMessage.value = value;
    update();
  }

  selectData1(){
    observation.text = observationMessage.value;
    update();
  }

  updateData2(value){
    requirementMessage.value = value;
    update();
  }

  selectData2(){
    requirement.text = requirementMessage.value;
    update();
  }
}

