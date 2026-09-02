// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';

class RecentActivity extends GetView<RecentActivityController> {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RecentActivityController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Recent Activity",
      ),
      body: Obx(() => Stack(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.height,
                child: ListView(
                  children: List.generate(controller.activityList.length,
                      (index) => tile(controller.activityList[index], index)),
                ).p8(),
              ),
              controller.isLoading.value
                  ? const LoadingScreen()
                  : const SizedBox(),
            ],
          )),
    );
  }

  tile(data, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: TextWidget(
                controller.checkDate(data['id'].toString()) == "0"
                    ? "Today"
                    : controller.checkDate(data['id'].toString()) == "-1"
                        ? "Yesterday"
                        : DateFormat('MMM dd,yyyy').format(DateTime.parse(DateFormat('dd-MMM-yy').parse(data['id'].toString()).toString())).toString(),
                color: Colors.black.withValues(alpha:  0.8700000047683716),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ).pSymmetric(h: 10.0, v: 8.0),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomWidgets.divider(width: 1, height: 30.0).pOnly(left: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(data['value'].length, (i) => IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CustomWidgets.divider(width: 1, height: double.infinity).pOnly(left: 10.0,top: 20.0),
                        CustomWidgets.showAssetImage(path: visitHistory),
                      ],
                    ),

                    20.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: bGradient,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: GradientTextWidget(
                            data['value'][i]['HSTTYPE'].toString(),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ).pSymmetric(h: 15.0, v: 5.0),
                        ),
                        10.heightBox,
                        SizedBox(
                          width: Get.width * 0.8,
                          child: TextWidget(data['value'][i]['REGARDING'].toString(),
                            color: blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        10.heightBox,
                        SizedBox(
                          width: Get.width * 0.8,
                          child: TextWidget(data['value'][i]['DETAILS'].toString(),
                            color: greyColor,
                            fontSize: 14,

                            fontWeight: FontWeight.w400,
                            maxLines: 20,
                          ),
                        ),
                        10.heightBox,
                      ],
                    ),


                  ],
                ),
              ))
            ),
          ],
        ).pOnly(left: 20.0),
      ],
    );
  }
}
/*
Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(controller.activityList1[index]['HSTTYPE'].toString(),
                    fontSize: 16,
                    color: appColor.value,
                    fontWeight: FontWeight.w500,),

                  10.heightBox,
                  TextWidget("Follwup Date",fontSize: 16,
                    color: Colors.black,fontWeight: FontWeight.w500,),
                  5.heightBox,
                  TextWidget(controller.activityList1[index]['FLWDATE'].toString(),
                    fontSize: 16,
                    color: Colors.black,),
                  10.heightBox,
                  TextWidget("Regarding",fontSize: 16,
                    color: Colors.black,fontWeight: FontWeight.w500,),
                  5.heightBox,
                  TextWidget(controller.activityList1[index]['REGARDING'].toString(),
                    fontSize: 16,
                    color: Colors.black,),
                  10.heightBox,
                  TextWidget("Details",fontSize: 16,
                    color: Colors.black,fontWeight: FontWeight.w500,),
                  5.heightBox,
                  SizedBox(
                    width: Get.width,
                    child: TextWidget(controller.activityList1[index]['DETAILS'].toString(),
                      fontSize: 16,
                      color: Colors.black,
                    maxLines: 20,),
                  ),
                  10.heightBox,
                  Container(
                    width: Get.width,
                    height: 1.0,
                    color: Colors.grey[400],
                  ),

                ],
              ).p8()

*/
