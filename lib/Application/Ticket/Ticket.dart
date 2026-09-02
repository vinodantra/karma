// ignore_for_file: file_names




import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Application/Ticket/CreateTicket.dart';
import 'package:karma/Application/Ticket/RemarkList.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/ticketController1.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

class Ticket extends GetView<TicketListController> {
  const Ticket({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TicketListController());
    return Scaffold(
        appBar: AppBarWidget(
          title: "Antra Ticket System",
          onSelectDate: () {
            showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now())
                .then((value) {
              if (value != null) {
                controller.selectDate(value);
              }
            });
          },
          onPressAdd: () {
            Get.to(() => const CreateTicket());
          },
          onBackPress: ()=>Get.offAll(()=>const DashboardNew())
        ),
        body: GetBuilder<TicketListController>(
            builder: (controller) => SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight,
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
                          controller.filterDataList();
                          //  controller.onInit();
                        },
                      ),
                      10.heightBox,
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                                      .w(Get.width / 3)
                                      .pSymmetric(v: 10.0)
                                  : TextWidget(
                                      "Pending",
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    )
                                      .centered()
                                      .w(Get.width / 3)
                                      .pSymmetric(v: 10.0),
                            ).onInkTap(() {
                              controller.selectData.value = "Pending";
                              controller.pageController.jumpToPage(0);
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
                                      .w(Get.width / 3)
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
                              controller.pageController.jumpToPage(1);
                              controller.filterDataList();
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: controller.pageController,
                          children: [
                            pendingTile(),
                            resolvedTile(),
                          ],
                          onPageChanged: (value){
                              controller.pageChange(value);
                          },
                        ),
                      )
                    ],
                  ),
                )));
  }

  tileWidget(var data) {
    return Container(
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
                  TextWidget(
                    data['Ticket'],
                    color: appColor.value,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  TextWidget(
                    data['Priority'],
                    maxLines: 5,
                    color: data['Priority'] == "High" ||
                            data['Priority'] == "Critical"
                        ? Colors.red
                        : greyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utilities.checkString(data['STATUS'].toString())
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            "Status",
                            color: blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              color: data['STATUS'] == "Resolved"
                                  ? successGreenColor
                                  : data['STATUS'] == 'Work in Progress'
                                      ? successGreenColor
                                      : warnAmberColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(56),
                              ),
                            ),
                            child: TextWidget(
                              data['STATUS'],
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ).pSymmetric(h: 15.0, v: 8.0),
                          ),
                        ],
                      ).pOnly(bottom: 10.0)
                    : const SizedBox(),
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
                      data['Created_Date'],
                      color: greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ).pOnly(bottom: 10.0),

                Utilities.checkString(data['Subject'].toString())
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Subject",
                            color: blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            width: Get.width / 1.8,
                            child: TextWidget(
                              data['Subject'],
                              textAlign: TextAlign.end,
                              color: greyColor,
                              maxLines: 15,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).pOnly(bottom: 10.0)
                    : const SizedBox(),
                Check.data(
                  data['AllocatedTeam'],
                )
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Allocated Team",
                            color: blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          TextWidget(
                            data['AllocatedTeam'],
                            maxLines: 5,
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ).paddingOnly(bottom: 10)
                    : const SizedBox(),
                Check.data(
                  data['AllocatedUser'],
                )
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Allocated User",
                            color: blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          TextWidget(
                            data['AllocatedUser'],
                            maxLines: 5,
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ).paddingOnly(bottom: 10)
                    : const SizedBox(),
                data['STATUS'] == "Pending"
                    ? Check.data(
                        data['RemarkDate'],
                      )
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Remark Date",
                                color: blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              TextWidget(
                                data['RemarkDate'],
                                maxLines: 5,
                                color: greyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ).paddingOnly(bottom: 10)
                        : const SizedBox()
                    : Check.data(
                        data['ResolvedDate'],
                      )
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Resolved Date",
                                color: blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              TextWidget(
                                data['ResolvedDate'],
                                maxLines: 5,
                                color: greyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ).paddingOnly(bottom: 10)
                        : const SizedBox(),
                // Check.data(
                //   data['Remark'],
                // )
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           TextWidget(
                //             "Allocator's Remarks:",
                //             color: blackColor,
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //           ),
                //           ReadMoreText(
                //             data['Remark'],
                //             style: const TextStyle(
                //               color: greyColor,
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //             ),
                //             trimMode: TrimMode.Line,
                //             trimLines: 2,
                //             colorClickableText: Colors.pink,
                //             trimCollapsedText: 'Show more',
                //             trimExpandedText: 'Show less',
                //           )
                //         ],
                //       ).paddingOnly(bottom: 10)
                //     : const SizedBox(),
                // TextWidget(
                //
                //   "Show Remark",
                //   color: appColor.value,
                //   fontSize: 12,
                //   fontWeight: FontWeight.w500,
                // ).onTap(() {
                //
                // }),

                Row(
                  children: [
                    IconButton(
                        onPressed: () {

                          CustomWidgets.showDialogWidget(
                              title: "Description", content: data['Descr']);
                        },
                        tooltip: "Description",
                        icon: SvgPicture.asset(descriptionIcon1)
                        ),
                    IconButton(
                        onPressed: () {
                          Get.to(() => const RemarkList(),
                              arguments: data['ID'].toString());
                        },
                        tooltip: "Allocator's Remark",
                        icon: const Icon(
                          Icons.description,
                          size: 20,
                        )).w(40),
                    Check.data(data['MobileNo'])
                        ? const Icon(
                            Icons.call,
                            size: 20,
                          ).onTap(() {
                            Utilities.onClickMobile(data['MobileNo']);
                          }).paddingOnly(right: 10)
                        : const SizedBox(),
                    Check.data(data['MailID'])
                        ? const Icon(
                            Icons.mail,
                            size: 20,
                          ).onTap(() {
                            Utilities.onClickEmail(data['MailID']);
                          })
                        : const SizedBox()
                  ],
                ),
              ],
            ).p16(),
          ],
        )).p8();
  }

  Widget pendingTile() {
    return Obx(() => RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: AsyncStateView(
            isLoading: controller.isLoading.value,
            hasError: controller.hasError.value,
            isEmpty: controller.pendingList.isEmpty,
            onRetry: controller.getList,
            emptyMessage: 'No pending tickets.',
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: controller.pendingList.length,
              itemBuilder: (context, index) =>
                  tileWidget(controller.pendingList[index]),
            ),
          ),
        ));
  }

  Widget resolvedTile() {
    return Obx(() => RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: AsyncStateView(
            isLoading: controller.isLoading.value,
            hasError: controller.hasError.value,
            isEmpty: controller.resolvedList.isEmpty,
            onRetry: controller.getList,
            emptyMessage: 'No resolved tickets.',
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: controller.resolvedList.length,
              itemBuilder: (context, index) =>
                  tileWidget(controller.resolvedList[index]),
            ),
          ),
        ));
  }
}
