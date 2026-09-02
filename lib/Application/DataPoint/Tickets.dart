// ignore_for_file: file_names

import 'package:karma/Application/TicketStatus/TickerDetails.dart';
import 'package:karma/Constants/Library.dart';

class Tickets extends GetView<TicketController> {
  const Tickets({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TicketController());
    return Scaffold(
      appBar: AppBarWidget(
        onBackPress: () {
          Get.back();
        },
        title: "Tickets",
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.getActivityData,
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.white,
              child: Stack(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Column(
                      children: [
                        SearchWidget(
                          controller: controller.searchController,
                          hintText: "Search",
                          onChanged: (value) {
                            controller.search.value = value!;

                            controller.filterDataList();
                          },
                          onClose: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            controller.searchController.clear();
                            controller.search.value = "";

                            controller.onInit();
                          },
                        ),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: controller.selectData.value == "All"
                                  ? decoration(context,
                                      borderRadius: BorderRadius.circular(100))
                                  : shapeDecoration(
                                      borderRadius: BorderRadius.circular(100)),
                              child: controller.selectData.value == "All"
                                  ? GradientTextWidget(
                                      "All",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )
                                      .centered()
                                      .w(Get.width / 4)
                                      .pSymmetric(v: 10.0)
                                  : TextWidget(
                                      "All",
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    )
                                      .centered()
                                      .w(Get.width / 4)
                                      .pSymmetric(v: 10.0),
                            ).onInkTap(() {
                              controller.selectData.value = "All";
                              controller.filterDataList();
                            }),
                            Container(
                              decoration: controller.selectData.value ==
                                      "Pending"
                                  ? decoration(context,
                                      borderRadius: BorderRadius.circular(100))
                                  : shapeDecoration(
                                      borderRadius: BorderRadius.circular(100)),
                              child: controller.selectData.value == "Pending"
                                  ? GradientTextWidget(
                                      "Pending",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )
                                      .centered()
                                      .w(Get.width / 4)
                                      .pSymmetric(v: 10.0)
                                  : TextWidget(
                                      "Pending",
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    )
                                      .centered()
                                      .w(Get.width / 4)
                                      .pSymmetric(v: 10.0),
                            ).onInkTap(() {
                              controller.selectData.value = "Pending";
                              controller.filterDataList();
                            }),
                            Container(
                              decoration: controller.selectData.value ==
                                      "Resolved"
                                  ? decoration(context,
                                      borderRadius: BorderRadius.circular(100))
                                  : shapeDecoration(
                                      borderRadius: BorderRadius.circular(100)),
                              child: controller.selectData.value == "Resolved"
                                  ? GradientTextWidget(
                                      "Resolved",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )
                                      .centered()
                                      .w(Get.width / 4)
                                      .pSymmetric(v: 10.0)
                                  : TextWidget(
                                      "Resolved",
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    )
                                      .centered()
                                      .w(Get.width / 4)
                                      .pSymmetric(v: 10.0),
                            ).onInkTap(() {
                              controller.selectData.value = "Resolved";
                              controller.filterDataList();
                            }),
                          ],
                        ),
                        controller.list.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                    itemCount: controller.list.length,
                                    itemBuilder: (context, index) {
                                      return tile(
                                          controller.list[index], index);
                                    }).p8(),
                              )
                            : controller.isLoading.value == false
                                ? Center(
                                    child: TextWidget(
                                    "No data found",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ))
                                : const SizedBox()
                      ],
                    ),
                  ),
                  controller.isLoading.value
                      ? const LoadingScreen()
                      : const SizedBox(),
                ],
              ),
            ),
          )),
    );
  }

  Widget tile(
    var data,
    int i,
  ) {
    return GetBuilder<TicketController>(builder: (dashboardController) {
      return InkWell(
        onTap: () {
          
          Get.to(() => const TicketDetails(),
              arguments: controller.list[i]['TICKET']);
        },
        child: Container(
            width: Get.width,
            decoration: shapeDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: bGradient,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            data['TICKET'],
                            style: TextStyle(
                              color: appColor.value,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      Container(
                        decoration: ShapeDecoration(
                          color: data['STATUS'] == "Resolved"
                              ? successGreenColor
                              : warnAmberColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(56),
                          ),
                        ),
                        child: TextWidget(
                          data['STATUS'],
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ).pSymmetric(h: 15.0, v: 8.0),
                      ),
                    ],
                  ).pSymmetric(h: 16.0, v: 10.0),
                ),
                Container(
                  width: Get.width,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "Date",
                          color: blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          data['DATE'],
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
                          "Contact Person",
                          color: blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          data['CNTPER'],
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
                          "Category",
                          color: blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          data['CAT'],
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
                          "Supported By",
                          color: blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          data['CREATEDBY'],
                          maxLines: 5,
                          color: greyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    data['STATUS'] == 'Pending'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.heightBox,
                              Utilities.checkString(data['LASTSCHD'].toString())
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          "Support Schedule",
                                          color: blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          width: Get.width / 2.5,
                                          child: TextWidget(
                                            controller.checkDate(
                                                data['LASTSCHD'].toString()),
                                            textAlign: TextAlign.right,
                                            maxLines: 2,
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ).pOnly(bottom: 10.0)
                                  : const SizedBox(),
                              Utilities.checkString(data['CUSTSCHD'].toString())
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          "Customer Schedule",
                                          color: blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          width: Get.width / 2.5,
                                          child: TextWidget(
                                            controller.checkDate(
                                                data['CUSTSCHD'].toString()),
                                            textAlign: TextAlign.right,
                                            maxLines: 2,
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ).pOnly(bottom: 10.0)
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox()
                  ],
                ).p16(),
                10.heightBox,
              ],
            )).p8(),
      );
    });
  }
}
