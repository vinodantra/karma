
// ignore_for_file: invalid_use_of_protected_member, file_names, depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

import 'package:intl/intl.dart';
class LeaveReport extends GetView<LeaveReportController> {
  const LeaveReport({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveReportController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(title: "Leave Report",onPressAdd: (){
        Get.dialog(
            Obx(()=>SingleChildScrollView(
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Get.width,
                        height: 50,
                        decoration:  BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            gradient: LinearGradient(
                                colors: appGradientColor.value
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: (){
                              Get.back();
                            }, child: TextWidget("Close",color: Colors.white,fontSize: 18)),
                            TextWidget("Leave",fontSize: 18,color: Colors.white,),
                            TextButton(onPressed: (){
                              if(controller.selectType.value == "Select")
                                {
                                  CustomWidgets.snackBar(title: "Please select field type");
                                }
                              else if(controller.selectApplyType.value == "Select")
                                {
                                  CustomWidgets.snackBar(title: "Please select applying for");
                                }
                              else if(controller.email.text.trim().isEmpty)
                                {
                                  CustomWidgets.snackBar(title: "Please enter email id");
                                }
                              else if(controller.email.text.trim().isEmail == false){
                                CustomWidgets.snackBar(title: "Please enter valid email id");
                              }
                              else if(controller.leaveReason.text.trim().isEmpty)
                                {
                                  CustomWidgets.snackBar(title: "Please enter leave reason");
                                }
                              else
                                {
                                  controller.applyLeave();
                                }
                              Get.back();
                            }, child: TextWidget("Apply",color: Colors.white,fontSize: 18))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("Type",fontSize: 16,color: Colors.black,),
                          InkWell(
                            onTap: (){
                              CustomWidgets.customBottomSheet(
                                  controller.leaveType, "NAME", false,
                                      (data) {
                                    controller.selectType.value = data['NAME'];

                                    controller.getData();
                                    Get.back();
                                  });
                            },
                            child: Row(
                              children: [

                                TextWidget(
                                  controller.selectType.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0,v: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("Applying for",fontSize: 16,color: Colors.black,),
                          InkWell(
                            onTap: (){
                              CustomWidgets.customBottomSheet(
                                  controller.applyList, "NAME", false,
                                      (data) {



                                    controller.selectApplyType.value = data['NAME'];
                                    controller.selectApplyTypeId.value = data['ID'];

                                    controller.getData();
                                    Get.back();
                                  });
                            },
                            child: Row(
                              children: [

                                TextWidget(
                                  controller.selectApplyType.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0,v: 10.0),

                      controller.selectApplyTypeId.value != "3" ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("On Date",fontSize: 16,color: Colors.black,),
                          InkWell(
                            onTap: ()async{
                              var selectOnDate =  await CustomWidgets.pickDate(context,selectPreviousDate: true,selectFromDate: DateTime.now().subtract(const Duration(days: 3)));
                              if(selectOnDate != null) {

                                controller.selectOnDate.value = DateFormat('dd/MMM/yyyy')
                                    .format(selectOnDate);

                                controller.selectOnDate1.value = selectOnDate.toString();



                              }

                            },
                            child: Row(
                              children: [

                                TextWidget(
                                  controller.selectOnDate.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                5.widthBox,
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0,v: 10.0) : const SizedBox(),

                      controller.selectApplyTypeId.value == "3" ?  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("From Date",fontSize: 16,color: Colors.black,),
                          InkWell(
                            onTap: ()async{
                              var selectFromDate =  await CustomWidgets.pickDateRange1(context, DateTime.now().subtract(const Duration(days: 3)),);
                              if(selectFromDate != null) {

                                controller.selectFromDate.value = DateFormat('dd/MMM/yyyy')
                                    .format(selectFromDate);

                                controller.selectFromDate1.value = selectFromDate.toString();



                              }
                            },
                            child: Row(
                              children: [

                                TextWidget(
                                  controller.selectFromDate.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                5.widthBox,
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0,v: 10.0) : const SizedBox(),
                      controller.selectApplyTypeId.value == "3" ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("To Date",fontSize: 16,color: Colors.black,),
                          InkWell(
                            onTap: ()async{
                              var selectToDate =  await CustomWidgets.pickDateRange1(context,DateTime.parse(controller.selectFromDate1.value));
                              if(selectToDate != null) {

                                controller.selectToDate.value = DateFormat('dd/MMM/yyyy')
                                    .format(selectToDate);

                                controller.selectToDate1.value = selectToDate.toString();



                              }

                            },
                            child: Row(
                              children: [

                                TextWidget(
                                  controller.selectToDate.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                5.widthBox,
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0,v: 10.0) : const SizedBox(),

                      controller.selectApplyTypeId.value == "1" ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("Half",fontSize: 16,color: Colors.black,),
                          InkWell(
                            onTap: (){
                              CustomWidgets.customBottomSheet(
                                  controller.leaveTypeList, "NAME", false,
                                      (data) {
                                    controller.selectLeaveData.value = data['NAME'];
                                    controller.selectLeaveId.value = data['ID'];

                                   // controller.getData();
                                    Get.back();
                                  });
                            },
                            child: Row(
                              children: [

                                TextWidget(
                                  controller.selectLeaveData.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0,v: 10.0) : const SizedBox(),
                      TextField(
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                        hintText: "To Email id",

                      ),).pSymmetric(h: 15.0,v: 4.0),
                      TextField(
                        controller: controller.leaveReason,
                        minLines: 5,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          hintText: "Leave Reason",


                        ),).pSymmetric(h: 15.0,v: 10.0),
                    ],
                  ).scrollVertical(),
                ),
              ).p24(),
            )),
        
        );
      },),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: AsyncStateView(
              isLoading: controller.isLoading.value,
              hasError: controller.hasError.value,
              isEmpty: false,
              onRetry: controller.getData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                controller.leaveData.isNotEmpty  ?  Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget("Yearly Report",fontSize: 18,color: appColor.value,).pSymmetric(h: 15,v: 10),
                      10.heightBox,

                      Column(
                        children: [
                          CustomWidgets.divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Year",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget("${DateTime.now().year}",fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15),
                              ),
                              CustomWidgets.divider(width: 0.8,height: 60.0),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Total Leaves",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,

                                   TextWidget("${((double.tryParse((controller.leaveData['YEARLYPL'] ?? '').toString()) ?? 0) + (double.tryParse((controller.leaveData['YEARLYOL'] ?? '').toString()) ?? 0))}",fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15,),
                              ),
                            ],
                          ),
                          CustomWidgets.divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Paid Leaves",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget(controller.leaveData['YEARLYPL'].toString(),fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15),
                              ),
                              CustomWidgets.divider(width: 0.8,height: 60.0),
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Optional Leaves",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget(controller.leaveData['YEARLYOL'],fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15,),
                              ),
                            ],
                          ),
                          CustomWidgets.divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Taken PL",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget(controller.leaveData['TAKENPL'],fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15),
                              ),
                              CustomWidgets.divider(width: 0.8,height: 60.0),
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Taken OL",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget(controller.leaveData['TAKENOL'],fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15,),
                              ),
                            ],
                          ),
                          CustomWidgets.divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Available PL",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget("${((double.tryParse((controller.leaveData['YEARLYPL'] ?? '').toString()) ?? 0) - (double.tryParse((controller.leaveData['TAKENPL'] ?? '').toString()) ?? 0))}",fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15),
                              ),
                              CustomWidgets.divider(width: 0.8,height: 60.0),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Available OL",fontSize: 16,color: Colors.grey[500],),
                                    10.heightBox,
                                    TextWidget("${((double.tryParse((controller.leaveData['YEARLYOL'] ?? '').toString()) ?? 0) - (double.tryParse((controller.leaveData['TAKENOL'] ?? '').toString()) ?? 0))}",fontSize: 18,color: Colors.black54,),
                                  ],
                                ).pSymmetric(h: 15,),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                ).p8() : const SizedBox(),
                InkWell(
                  onTap: (){
                    Get.to(()=> const HolidaysList());
                  },
                  child: Card(
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: "${WebApis.rootUrl}/CRM/Karma/www/img/datap.png",
                          width: 30,
                          memCacheWidth: 60,
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                          placeholder: (context, url) => const SizedBox.shrink(),
                        ),
                        10.widthBox,
                        TextWidget("List of Holidays",fontSize: 18,color: Colors.black,),
                      ],
                    ).pSymmetric(h: 15.0,v: 8.0),
                  ).p8(),
                ),
                InkWell(
                  onTap: (){
                    Get.to(()=> const LeaveStatus());
                  },
                  child: Card(
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: "${WebApis.rootUrl}/CRM/Karma/www/img/datap.png",
                          width: 30,
                          memCacheWidth: 60,
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                          placeholder: (context, url) => const SizedBox.shrink(),
                        ),
                        10.widthBox,
                        TextWidget("Leave Status",fontSize: 18,color: Colors.black,),
                      ],
                    ).pSymmetric(h: 15.0,v: 8.0),
                  ).p8(),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget("Monthly Report",fontSize: 18,color: appColor.value,).pSymmetric(h: 15,v: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("Select Month",fontSize: 16,color: Colors.grey[700],fontWeight: FontWeight.w500,),
                          InkWell(
                            onTap: ()async{
                              var de = await  CustomWidgets.pickMonth(context,selectDate: controller.selectDate1);

                              if(de != null) {


                                controller.selectDate.value = DateFormat('MMM yyyy')
                                    .format(de);
                                controller.selectDate1 = de;

                                controller.getData();

                              }
                            },
                            child: ColoredBox(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  TextWidget(controller.selectDate.value,fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500,),
                                  10.widthBox,
                                  const Icon(Icons.calendar_today_outlined)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0),
                      5.heightBox,

                    ],
                  ),
                ).p8(),
                controller.leaveData.isNotEmpty ?  InkWell(
                  onTap: (){
                    Get.to(()=>MonthlyReport(data: controller.attendanceList,));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        CustomWidgets.divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex:1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("Working Days",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['PRESDAY'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15),
                            ),
                            CustomWidgets.divider(width: 0.8,height: 60.0),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("Same Time",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['SAMETIME'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15,),
                            ),
                          ],
                        ),
                        CustomWidgets.divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex:1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("Latemark",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['LATEMARK'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15),
                            ),
                            CustomWidgets.divider(width: 0.8,height: 60.0),
                            Expanded(
                              flex:1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("Earlywent",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['EARLYWENT'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15,),
                            ),
                          ],
                        ),
                        CustomWidgets.divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex:1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("PL",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['MNTHPL'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15),
                            ),
                            CustomWidgets.divider(width: 0.8,height: 60.0),
                            Expanded(
                              flex:1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("OL",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['MNTHOL'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15,),
                            ),
                          ],
                        ),
                        CustomWidgets.divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex:1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("WPL",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['MNTHWPL'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15),
                            ),
                            CustomWidgets.divider(width: 0.8,height: 60.0),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("COL",fontSize: 16,color: Colors.grey[500],),
                                  10.heightBox,
                                  TextWidget(controller.leaveData['MNTHCOL'],fontSize: 18,color: Colors.black54,),
                                ],
                              ).pSymmetric(h: 15,),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ).p8(),
                ) : const SizedBox(),
              ],
            ),
            ),
          )),
    );
  }
}
