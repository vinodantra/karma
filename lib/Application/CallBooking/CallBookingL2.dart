// ignore_for_file: file_names


import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';




class CallBookingL2 extends GetView<CallBookingControllerL2> {
  const CallBookingL2({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CallBookingController1());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Call Booking",
      ),
      body: Obx(() {
        final isEmpty = controller.todayCallList.isEmpty &&
            controller.callList.isEmpty &&
            controller.previousCallList.isEmpty;
        return Column(
          children: [
            DataInfo.rollId.value == "1"
                ? InkWell(
                    onTap: () {
                      CustomWidgets.customBottomSheet(
                          controller.filterUserList, "NAME", true, (data) {
                        controller.selectId.value = data['ID'].toString();
                        controller.selectUser.value = data['NAME'];
                        controller.id.value = data['ID'].toString();
                        Get.find<CallBookingController1>().onInit();
                        Get.back();
                      });
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CustomWidgets.showImage(path: userIcon),
                                    10.widthBox,
                                    TextWidget(
                                      controller.selectUser.value,
                                      color: greyColor,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: iconColor,
                              )
                            ],
                          ),
                          const Divider(
                            color: iconColor,
                          )
                        ],
                      ).pSymmetric(h: 15.0, v: 10.0),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.onRefresh,
                child: AsyncStateView(
                  isLoading: controller.isLoading.value,
                  hasError: controller.hasError.value,
                  isEmpty: isEmpty,
                  onRetry: controller.getData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      controller.todayCallList.isNotEmpty
                          ? TextWidget(
                              "Today's Call",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.todayCallList.length,
                        itemBuilder: (context, index) =>
                            tile(controller.todayCallList[index], index),
                      ),
                      controller.callList.isNotEmpty
                          ? TextWidget(
                              "Call Ahead",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.callList.length,
                        itemBuilder: (context, index) =>
                            tile(controller.callList[index], index),
                      ),
                      controller.previousCallList.isNotEmpty
                          ? TextWidget(
                              "Previous Call",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.previousCallList.length,
                        itemBuilder: (context, index) =>
                            tile(controller.previousCallList[index], index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
  Widget tile(var data,int i,){
    return GetBuilder<CallBookingController1>(builder: (dashboardController){
      return InkWell(
        onTap:(){
          Get.to(()=> const CallBookingDetails(),arguments: data);
        },
        child: Container(
          width:Get.width,


          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffeaecf0), width: 1, ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    data['CMP'],

                    color: appColor.value,
                    fontSize: 18,

                    fontWeight: FontWeight.w500,

                  ),
                  // TextWidget(
                  //   data['STATUS'],
                  //
                  //   color: titleColor,
                  //   fontSize: 14,
                  //
                  //   fontWeight: FontWeight.w500,
                  //
                  // ),

                ],
              ),
              5.heightBox,
              Container(
                width: Get.width,
                height: 1.0,
                color: Colors.grey[300],
              ).pOnly(bottom: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "${data['CALLDATE']} ${data['SHEDULE']}",

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                  TextWidget(
                    data['CALLTYPID'],

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                ],
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,


                children: [
                  TextWidget(
                    "Contact Person",

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                  TextWidget(
                    data['ACCOWNER'],

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                ],
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "Call Approved Status",

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                  TextWidget(
                    data['APRSTS'] == "NO" ? "Pending" : data['APRSTS'] == "REJECT" ? "Rejected" : "Approved",

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                ],
              ),
              10.heightBox,
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    "Payment Collection",

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                  TextWidget(
                    data['CHKCOLL'],
                    maxLines: 5,
                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                ],
              ),
              10.heightBox,
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            "In - ",

                            color:  titleColor,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                          5.widthBox,
                          TextWidget(
                            data['CHKIN'],
                            maxLines: 5,
                            color: data['CHKIN'] != "0" ? Colors.green :
                            Colors.red,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                        ],
                      ),
                      10.widthBox,
                      Row(
                        children: [
                          TextWidget(
                            "Out - ",

                            color:  titleColor,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                          5.widthBox,
                          TextWidget(
                            data['CHKOUT'],
                            maxLines: 5,
                            color: data['CHKOUT'] != "0" ? Colors.green :
                            Colors.red,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            "SE - ",

                            color:  titleColor,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                          5.widthBox,
                          TextWidget(
                            data['SUPCNT'],
                            maxLines: 5,
                            color: data['SUPCNT'] == "Yes" ? Colors.green :
                            Colors.red,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                        ],
                      ),
                      10.widthBox,
                      Row(
                        children: [
                          TextWidget(
                            "CE - ",

                            color:  titleColor,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),
                          5.widthBox,
                          TextWidget(
                            data['CONV'],
                            maxLines: 5,
                            color: data['CONV'] != "0" ? Colors.green :
                            Colors.red,
                            fontSize: 14,

                            fontWeight: FontWeight.w500,

                          ),

                        ],
                      ),
                    ],
                  ),
                ],
              ),
              10.heightBox,
              Row(
                children: [
                  iconWidget(iconData:Icons.phone,onPressed:  () {
                    Utilities.onClickMobile(data['MOB']);
                  }),
                  iconWidget(iconData:Icons.message, onPressed: () => Utilities.onClickMessage(data['MOB'])),
                  iconWidget(iconData:Icons.maps_ugc_outlined, onPressed: () => Utilities.onGoogleMap(data['LAT'],data['LONG'])),
                  iconWidget(iconData:Icons.location_on_outlined, onPressed: () => data['CHKIN'] != "00" ?
                  Get.dialog(Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(data['CMP'],fontSize: 18,fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,).p8(),
                          10.heightBox,
                          TextWidget("Check In - ${data['CHKIN']}",fontSize: 16,fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,).p8(),
                          TextWidget(data['LOCTCHKIN'].toString(),fontSize: 16,fontWeight: FontWeight.w500,
                            color: Colors.lightGreen,
                            textAlign: TextAlign.center,
                            maxLines: 10,).p8(),
                          TextWidget("Check Out - ${data['CHKOUT']}",fontSize: 16,fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,).p8(),
                          TextWidget(data['LOCTCHKOUT'],fontSize: 16,fontWeight: FontWeight.w500,maxLines: 10,
                            textAlign: TextAlign.center,
                            color: Colors.orangeAccent,).p8(),
                          10.heightBox,
                          CustomButton(text: "OK",onPressed: (){Get.back();},
                            width: 80,
                            height: 40,)

                        ],
                      ).p8(),
                    ).p8(),
                  )) : null),
                  DataInfo.rollId.value == "1" &&  (data['CHKIN'] == "00" || data['CHKOUT'] == "00")?
                  iconWidget(iconData:Icons.edit, onPressed: () => Get.dialog(Center(
                    child: Obx(()=>Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget("Update check In/Out Time",fontSize: 18,fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,).p8(),
                          Container(
                            width: Get.width,
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget("Check In - ",fontSize: 16,fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,).p8(),

                              TextWidget(Utilities.checkString(controller.selectCheckInTime.value) ? controller.selectCheckInTime.value : "__/__ ",fontSize: 16,fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,).p8(),
                              iconWidget(iconData: Icons.timer_outlined,onPressed: ()async{
                                TimeOfDay? selectTime = await  CustomWidgets.pickTime(Get.context!);
                                if(selectTime != null) {
                                  controller.selectCheckInTime.value =  "${selectTime.hour.toString()}:${selectTime.minute.toString()}";

                                }
                              }),
                            ],
                          ),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget("Check Out - ",fontSize: 16,fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,).p8(),

                              TextWidget(Utilities.checkString(controller.selectCheckOutTime.value) ?  controller.selectCheckOutTime.value : "__/__ ",fontSize: 16,fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,).p8(),
                              iconWidget(iconData: Icons.timer_outlined,onPressed: ()async{
                                TimeOfDay? selectTime = await  CustomWidgets.pickTime(Get.context!);
                                if(selectTime != null) {
                                  controller.selectCheckOutTime.value =  "${selectTime.hour.toString()}:${selectTime.minute.toString()}";

                                }
                              }),
                            ],
                          ),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(onPressed: (){

                                Get.back();
                              }, child: TextWidget("Cancel",fontSize: 16,
                                color:Colors.black,fontWeight: FontWeight.w500,)),
                              15.widthBox,
                              CustomButton(text: "SAVE",onPressed: ()async{

                                if(Utilities.checkString(controller.selectCheckInTime.value) && Utilities.checkString(controller.selectCheckOutTime.value))
                                {
                                  await controller.updateStatus(data, "1");
                                  await controller.updateStatus(data, "2");
                                  controller.selectCheckInTime.value = "";
                                  controller.selectCheckOutTime.value = "";
                                }
                                else if(Utilities.checkString(controller.selectCheckInTime.value))
                                {
                                  await controller.updateStatus(data, "1");
                                  controller.selectCheckInTime.value = "";
                                }
                                else if(Utilities.checkString(controller.selectCheckOutTime.value))
                                {
                                  await controller.updateStatus(data, "2");
                                  controller.selectCheckOutTime.value = "";
                                }
                                else
                                {
                                  CustomWidgets.snackBar(title: "Please select Check In and Check Out time.");
                                }

                                Get.back();},
                                width: 120,
                                height: 35,)
                            ],
                          ),


                        ],
                      ).p8(),
                    ).pSymmetric(h: 20,v: 8)),
                  ))) : const SizedBox(),
                  DataInfo.rollId.value == "1" && DataInfo.desCat.value == "L1" ?
                  iconWidget(iconData: Icons.check_circle_outline,
                      color: data['SUPCNT'] == "Yes" ? Colors.green :
                      Colors.red,
                      onPressed: () => data['SUPCNT']  == 'Yes' ?
                      Get.dialog(Center(
                        child: Card(
                          child: Obx(()=>Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget("Call Status",fontSize: 18,fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,).p8(),
                              Container(
                                width: Get.width,
                                height: 1.0,
                                color: Colors.grey[400],
                              ),
                              10.heightBox,
                              ListTile(
                                onTap: (){
                                  controller.selectCallStatus.value = "Approved";
                                },
                                title: TextWidget("Approved",fontSize: 16,
                                ),
                                trailing: controller.selectCallStatus.value == "Approved" ?
                                const Icon(Icons.check) : const SizedBox(),),
                              ListTile(
                                  onTap: (){
                                    controller.selectCallStatus.value = "Rejected";
                                  },
                                  title: TextWidget("Rejected",fontSize: 16,),trailing: controller.selectCallStatus.value == "Rejected" ?
                              const Icon(Icons.check) : const SizedBox()),
                              10.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(onPressed: (){
                                    controller.selectCallStatus.value = "";
                                    Get.back();
                                  }, child: TextWidget("Cancel",fontSize: 16,
                                    color:Colors.black,fontWeight: FontWeight.w500,)),
                                  15.widthBox,
                                  CustomButton(text: "OK",onPressed: (){
                                    controller.statusUpdate(data['ID']);

                                    Get.back();},
                                    width: 120,
                                    height: 40,)
                                ],
                              ),

                            ],
                          ).p8()),
                        ).p8(),
                      )) : CustomWidgets.showDialogWidget(title: "Alert",
                          content: "Sorry!! Visit entry is must to be approve call.Please add visit entry!")) : const SizedBox(),
                  DataInfo.desCat.value == "L1" ?
                  iconWidget(iconData:Icons.insert_drive_file_outlined, onPressed: () {
                    controller.visitEntry(data['ID']);
                    Get.dialog(Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget("Visit Entry Description",fontSize: 18,fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,).p8(),
                            Container(
                              width: Get.width,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            10.heightBox,
                            TextWidget(data['SPNOTE'].toString(),fontSize: 16,maxLines: 10,),
                            10.heightBox,
                            CustomButton(text: "OK",onPressed: (){


                              Get.back();},  width: 120,
                              height: 40,)

                          ],
                        ).p8(),
                      ).p8(),
                    ));
                  }) : const SizedBox(),
                  //iconWidget(iconData:Icons.description, onPressed: () => null),

                ],
              ),



            ],
          ).p16(),
        ).p8(),
      );
    });
  }
}
Widget iconWidget({final iconData,Function()? onPressed,Color color =  Colors.black}){
  return SizedBox(
      width: 40,
      child: IconButton(onPressed: onPressed, icon: Icon(iconData,size: 18,color: color,)));
}
