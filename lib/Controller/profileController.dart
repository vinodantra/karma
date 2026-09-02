// ignore_for_file: file_names

import '../Constants/Library.dart';
class ProfileController extends GetxController{
 final fullName =  TextEditingController();
 final designation = TextEditingController();
 RxBool isLoading = false.obs;

 @override
  void onInit() {
    fullName.text =  DataInfo.fullName.value.trim();
    designation.text  = DataInfo.designation.value.trim();
    super.onInit();
  }

  @override
  void onClose() {
    fullName.dispose();
    designation.dispose();
    super.onClose();
  }

  updateData() async{
   isLoading.value = true;
   Api().fetchApi(data:"${fullName.text.trim()}|${designation.text.trim()}|${DataInfo.mobile.value}|${DataInfo.email.value}|${DataInfo.username.value}",action: "UPDATEUSERDETAILS").then((value) {
     try{

       if(value != null && value.success)
       {
         getUserData();
          Get.back();

         isLoading.value = false;

       }
       else
       {
         isLoading.value = false;
         return null;
       }
     }catch(e){
       isLoading.value = false;
       if (kDebugMode) {
         print("error:$e");
       }
       return null;
     }
   });

 }

 getUserData() async {
   var responseData = await Apis.sendData(
       DataInfo.username.value, "GETUSERDITAILS&ENCKEY=${DataInfo.encKey.value}&SRC=KARMA");
   var de = json.decode(responseData.body);
   var data = de[0];
   DataInfo.box.write("userInfo", data);
   DataInfo.fullName.value = data['FULLNAME'].toString().trim();
   DataInfo.name.value = data['NAME'].toString().trim();
   DataInfo.designation.value = data['DESIGNATION'].toString().trim();
   DataInfo.mobile.value = data['MOBILE'].toString().trim();
   DataInfo.email.value = data['USEREMAIL'].toString().trim();
   DataInfo.aboutMe.value =  data['ABOUTME'].toString().trim();


 }

}