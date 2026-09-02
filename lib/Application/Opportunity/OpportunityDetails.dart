// ignore_for_file: file_names

import 'package:karma/Application/Opportunity/Status.dart';
import 'package:karma/Constants/Library.dart';

class OpportunityDetails extends GetView<OpportunityController> {
  const OpportunityDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OpportunityController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Opportunity",
      ),
      body: Obx(() => Stack(
            children: [
              SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchWidget(
                              controller: controller.searchController,
                              hintText: "Search",
                              onChanged: (value) {
                                controller.search.value = value!;
                                controller.type.value = "All";
                                controller.filterDataList();
                              },
                              onClose: () {
                                controller.searchController.clear();
                                controller.search.value = "";
                                controller.type.value = "All";
                                controller.onInit();
                              },
                            ),
                          ),
                          Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.50, color: dividerColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x14919191),
                                    blurRadius: 12,
                                    offset: Offset(0, 2),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomWidgets.showAssetImage1(
                                  path: filter,

                                ),
                              )).onInkTap(() {
                            CustomWidgets.customBottomSheet(
                                controller.filterOption, "NAME", false,
                                (value) {

                              controller.search.value = "";
                              controller.type.value = value['NAME'];
                              controller.filterDataList();
                              Get.back();
                            });
                          }).pOnly(right: 10.0),
                          // IconButton(
                          //   onPressed: (){
                          //     CustomWidgets.customBottomSheet(controller.filterOption,
                          //         "NAME", false, (value) {
                          //
                          //       controller.search.value = "";
                          //       controller.type.value = value['NAME'];
                          //       controller.filterDataList();
                          //       Get.back();
                          //         });
                          //   },
                          //   icon: const Icon(Icons.filter_alt_outlined),
                          // ),
                        ],
                      ),
                      Expanded(
                        child: controller.opportunityList.isNotEmpty
                            ? Scrollbar(
                            thickness: 5.0,

                              child: ListView.builder(
                                  itemCount: controller.opportunityList.length,
                                  itemBuilder: (context, index) {
                                    return tile(
                                        controller.opportunityList[index], index);
                                  }),
                            )
                            : controller.isLoading.value == false
                                ? Center(
                                    child: TextWidget(
                                    "No data found",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ))
                                : const SizedBox(),
                      ),
                    ],
                  )).p8(),
              controller.isLoading.value
                  ? const LoadingScreen()
                  : const SizedBox(),
            ],
          )),
    );
  }

  Widget tile(
    var data,
    int i,
  ) {
    return GetBuilder<OpportunityController>(builder: (dashboardController) {
      return InkWell(
        onTap: () {
          Get.to(() => const OpportunityData(), arguments: data);
        },
        child: Container(
          width: Get.width,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.50, color: dividerColor),
                borderRadius: BorderRadius.circular(8.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: bGradient,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 247,

                      child: TextWidget(
                        data['DPNAME'],
                        color: appColor.value,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        maxLines: 5,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(()=>const Status(),arguments: data)!.then((value) => controller.getData());
                        // CustomWidgets.customBottomSheet(
                        //     data['STATUS'] == "Open"
                        //         ? controller.optionList
                        //         : controller.optionList1,
                        //     "NAME",
                        //     false,
                        //     (data1) {
                        //
                        //       if(data1['ID'] == "1"){
                        //
                        //         Get.back();
                        //         Get.to(()=>const Status(),arguments: data)!.then((value) => controller.getData());
                        //
                        //       }
                        //       else{
                        //         Get.back();
                        //         Get.to(()=> const UpdateOpportunity(),arguments: data);
                        //       }
                        //
                        //     });
                      },
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        color: iconColor,
                      ),
                    ),
                  ],
                ).pOnly(left: 16.0),
              ),
              Container(
                width: Get.width,
                height: 1.0,
                color: Colors.grey[300],
              ).pOnly(bottom: 10.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width / 2.3,
                        child: TextWidget(
                          "${data['BUSLINENAME']}-(Ref-ID ${data['ID']})",
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          maxLines: 5,
                        ),
                      ),
                      TextWidget(
                        data['STATUS'],
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
                      TextWidget(data['CRTDATE'],
                          color: blackColor, fontSize: 14),
                      TextWidget(data['USERNAME'],
                          color: greyColor, fontSize: 14),
                    ],
                  ),
                  data['STATUS'].toString() != "Open"
                      ? Column(
                          children: [
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget("Sales Order No",
                                    color: blackColor,
                                    fontSize: 14),
                                TextWidget(data['SONO'],
                                    color: greyColor,
                                    fontSize: 14),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(data['NETVALUE'],
                          color: blackColor, fontSize: 14),
                      TextWidget(data['NETVALUE'],
                          color: greyColor, fontSize: 14),
                    ],
                  ),
                  10.heightBox,
                  InkWell(
                    onTap:(){
                      dashboardController.showProduct(i);
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  dashboardController.showProduct(i);
                                },
                                child: GradientTextWidget(
                                  "D",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              5.widthBox,
                              GradientTextWidget("|"),
                              5.widthBox,
                              InkWell(
                                onTap: () {
                                  dashboardController.showProduct(i);
                                },
                                child: GradientTextWidget(
                                  "T",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              5.widthBox,
                              GradientTextWidget("|"),
                              5.widthBox,
                              InkWell(
                                onTap: () {
                                  dashboardController.showProduct(i);
                                },
                                child: GradientTextWidget(
                                  "P",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              5.widthBox,
                              GradientTextWidget("|"),
                              5.widthBox,
                              InkWell(
                                onTap: () {
                                  dashboardController.showProduct(i);
                                },
                                child: GradientTextWidget(
                                  "M",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              dashboardController.showProduct(i);
                            },
                            child: CustomWidgets.showAssetImage(
                                path: dashboardController
                                            .selectPrdId.value.isNotEmpty &&
                                        dashboardController.selectPrdId.value ==
                                            data['ID']
                                    ? arrowUp
                                    : arrowDown,
                                color:
                                    Provider.of<AppThemeController>(Get.context!)
                                        .appColor),
                          ),
                        ],
                      ).pSymmetric(h: 10.0, v: 10.0),
                    ),
                  ),
                  10.heightBox,
                  dashboardController.selectPrdId.value.isNotEmpty &&
                          dashboardController.selectPrdId.value == data['ID']
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width / 4,
                                  child: TextWidget(
                                    "NAME",
                                    color: greyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width / 5,
                                  child: TextWidget(
                                    "QTY",
                                    textAlign: TextAlign.start,
                                    color: greyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextWidget(
                                  "AMT",
                                  color: greyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ).pSymmetric(h: 5.0),
                            10.heightBox,
                          ],
                        )
                      : const SizedBox(),
                  dashboardController.selectPrdId.value.isNotEmpty &&
                          controller.selectPrdId.value == data['ID']
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              data['PRODUCT'].length,
                              (index) => SizedBox(
                                    width: Get.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: Get.width / 3,
                                          child: TextWidget(
                                            "${data['PRODUCT'][index]['NAME']}",
                                            color: blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Get.width / 5,
                                          child: TextWidget(
                                            "${data['PRODUCT'][index]['QTY']}",
                                            textAlign: TextAlign.start,
                                            color: blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextWidget(
                                          "${data['PRODUCT'][index]['AMT']}",
                                          color: blackColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ).pSymmetric(h: 5.0),
                                  )),
                        )
                      : const SizedBox(),
                ],
              ).p16()
            ],
          ),
        ).p8(),
      );
    });
  }
}
