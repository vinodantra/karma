// ignore_for_file: file_names

import 'package:karma/Application/Ticket/Ticket.dart';
import 'package:karma/Constants/Library.dart';

class CreateTicketController extends GetxController {
  RxList<dynamic> categoryList = [].obs;
  RxList<dynamic> problemList = [].obs;
  RxList<dynamic> subjectList = [].obs;
  RxBool isLoading = false.obs;
  RxString selectCategory = "".obs;
  RxString selectCategoryId = "".obs;


  RxString selectSubjectData  = "".obs;
  RxString selectSubjectId = "".obs;

  RxString selectIssue = "".obs;

  final description = TextEditingController();
  RxString message = "".obs;
  RxString message1 = "".obs;


  RxList<dynamic> priorityList = [
    {
      "Id": "1",
      "Name": "Low",
    },
    {
      "Id": "2",
      "Name": "Medium",
    },
    {
      "Id": "3",
      "Name": "High",
    },
    {"Id": "4", "Name": "Critical"}
  ].obs;

  RxString selectPriority = "".obs;

  @override
  void onInit() {
    getList();
    super.onInit();
  }

  @override
  void onClose() {
    description.dispose();
    super.onClose();
  }

  getList() async {
    isLoading.value = true;
    update();
    try {
      final value = await Api().fetchApi(action: "GETTCKMAST");
      if (value != null && value.success && value.data is Map) {
        final jsonData = value.data as Map;
        problemList.value = (jsonData['Table'] as List?) ?? [];
        categoryList.value = (jsonData['Table1'] as List?) ?? [];
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  selectCategoryData(data) {
    subjectList.clear();
    selectCategoryId.value = data['ID'].toString();
    selectCategory.value = data['Name'];
    selectSubjectId.value = "";
    selectSubjectData.value = "";

    getSubject();
    update();

  }
  getSubject(){
    subjectList.value = problemList.where((element) => element['MID'] == int.parse(selectCategoryId.value)).toList();
    if(subjectList.isEmpty){
      subjectList.add({"ID":"-1","Category":"Other"});
    }

    update();
  }
  selectProblemData(data) {
    selectIssue.value = data['Category'];
    update();
  }
  selectSubject(data) {
    selectSubjectId.value =  data['ID'].toString();
    selectSubjectData.value  = data['Category'];
    update();



  }

  selectPriorityData(data) {
    selectPriority.value = data['Name'];
    update();
  }

  createTicket() async {
    try {
      if (selectCategoryId.value.trim().isEmpty) {
        CustomWidgets.snackBar(title: "Please select category");
      } else if (selectSubjectId.value.trim().isEmpty) {
        CustomWidgets.snackBar(title: "Please select problem");
      } else if (selectPriority.value.trim().isEmpty) {
        CustomWidgets.snackBar(title: "Please select priority");
      }
      else if(description.text.trim().isEmpty){
        CustomWidgets.snackBar(title: "Please enter description");
      }
      else {
        isLoading.value = true;

      Loader();
        Api()
            .postApi1(
                data: json.encode(
                  {"categoryid":selectSubjectId.value,"descr":description.text.trim(),"uid":DataInfo.userId.value,"priority":selectPriority.value,"duplicate":"0"},
                ), action: "ANTRATICKET")
            .then((value) {
          if (value != null && value.success && value.data is Map) {
            final jsonData = value.data as Map;

            if (jsonData['statuscode'] == 1) {
              Loader().hide();
              Get.dialog(Center(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check,color: Colors.lightGreen,size: 50,),
                      20.heightBox,
                      TextWidget("Well Done!",fontSize: 18,color: Colors.black,),
                      15.heightBox,
                      TextWidget("Ticket Successfully Created.",fontSize: 16,color: Colors.grey[500],),
                      20.heightBox,
                      CustomButton(text: "Ok",onPressed: (){
                        Get.offAll(()=>  const Ticket());
                      },),
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
              Loader().hide();
            }

            isLoading.value = false;
            update();
          } else {
            isLoading.value = false;
            Loader().hide();
            update();
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Loader().hide();
    }
  }
  getChatGptData()async{

    try{
      Loader();
      var apiResponse = await Apis.chatGptApi(message: description.text.trim());


      if(apiResponse != null){

        message.value = description.text.trim();
        message1.value = apiResponse['MSG'];
        description.text =  apiResponse['MSG'];
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

  selectData(){
    description.text = message.value;
    update();
  }
  updateData(value){
    message.value = value;
    update();
  }
}
