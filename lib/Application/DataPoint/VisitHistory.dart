// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class VisitHistory extends GetView<VisitHistoryController> {
  const VisitHistory({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VisitHistoryController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "FT History",
      ),
      body: Obx(()=>Stack(
        children: [
          SizedBox(
              width: Get.width,
              height: Get.height,
              child: controller.list.isNotEmpty ?
              ListView.builder(
                  itemCount: controller.list.length,
                  itemBuilder: (context,index ){return tile(controller.list[index],index);}) : controller.isLoading.value == false ?
              Center(child: TextWidget("No data found",fontSize: 20,fontWeight: FontWeight.w500,)) : const SizedBox()
          ),
          controller.isLoading.value ? const LoadingScreen() : const SizedBox(),
        ],
      )),
    );
  }

  Widget tile(var data,int i,){
    return GetBuilder<VisitHistoryController>(builder: (dashboardController){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CustomWidgets.showAssetImage(path: visitHistory),
              CustomWidgets.divider(width: 1.0,height: 120.0)

            ],
          ),
          10.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

               Utilities.checkString(data['uname']) ?  Container(
                  decoration: BoxDecoration(
                    gradient: bGradient,
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                  child: GradientTextWidget(data['uname'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ).pSymmetric(h: 15.0,v: 4.0),
                ) : const SizedBox(),
               10.heightBox,

               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       TextWidget(
                         "Data Problem",

                         color: blackColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                       TextWidget(
                         data['Supporttype'],
                         color: greyColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                     ],
                   ),
                   10.heightBox,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,


                     children: [
                       TextWidget(
                         "Call Date",
                         color: blackColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                       TextWidget(
                         data['CallDate'],
                         color: greyColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                     ],
                   ),
                   10.heightBox,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       TextWidget(
                         "Date Created",
                         color: blackColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                       TextWidget(
                         data['DateCreated'],
                         color: greyColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                     ],
                   ),
                   10.heightBox,
                   Row(

                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       TextWidget(
                         "Remark",
                         color: blackColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w400,

                       ),
                       SizedBox(
                         width: Get.width / 2,
                         child: TextWidget(
                           data['remark'].trim(),
                           maxLines: 5,
                           textAlign: TextAlign.right,
                           color: greyColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w400,


                         ),
                       ),
                     ],
                   ),
                   10.heightBox,
                 ],
               ),
              ],
            ),
          ),
        ],
      ).p16();
});
  }
}
