// ignore_for_file: unnecessary_null_comparison, file_names, depend_on_referenced_packages, deprecated_member_use

import 'dart:io';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:karma/Application/CallBooking/NearByCustomer.dart';
import 'package:karma/Application/Dashboard/top_list.dart';
import 'package:karma/Application/TicketStatus/TickerDetails.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Constants/Library.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class DashboardNew extends GetView<DashboardController> {
  const DashboardNew({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await showExitPopup(context);
          }
        },
        child: GetBuilder<DashboardController>(
            builder: (controller) => Scaffold(
                  appBar: AppBarWidget(
                    title: "Dashboard",
                    onClick: () {
                      Get.bottomSheet(Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () {
                                Get.back();
                                Get.dialog(Center(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextWidget(
                                          "Tip-Off Box",
                                          color: appColor.value,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                        ).p8(),
                                        Container(
                                          width: Get.width,
                                          height: 1.0,
                                          color: Colors.grey[400],
                                        ),
                                        10.heightBox,
                                        TextWidget(
                                          "Has anything in your mind? Now share your Ideas,Requirements and Suggestions with us in one click.Our goal is to improve our service any way we can. ",
                                          maxLines: 5,
                                          fontSize: 16,
                                        ),
                                        10.heightBox,
                                        TextField(
                                          controller: controller.content,
                                          minLines: 4,
                                          maxLines: 10,
                                          decoration: const InputDecoration(
                                              hintText: "Write here...."),
                                        ),
                                        10.heightBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: TextWidget(
                                                  "Cancel",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                )),
                                            CustomButton(
                                              text: "OK",
                                              onPressed: () {
                                                if (controller.content.text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  Get.back();
                                                  controller.uploadData();
                                                } else {
                                                  CustomWidgets.snackBar(
                                                      title:
                                                          "Please enter description");
                                                }
                                              },
                                              width: 120,
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).p8(),
                                  ).pSymmetric(h: 20.0, v: 8.0),
                                ));
                              },
                              leading: const Icon(
                                Icons.tips_and_updates,
                                color: Colors.black,
                              ),
                              title: TextWidget(
                                "Tip-Off Box",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Get.back();
                                Get.dialog(Center(
                                    child: Obx(
                                  () => Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextWidget(
                                          "TLY-ddmmmyyyy-TicketNo",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                        ).p8(),
                                        Container(
                                          width: Get.width,
                                          height: 1.0,
                                          color: Colors.grey[400],
                                        ),
                                        10.heightBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              "Ticket Type",
                                              fontSize: 16,
                                              color: appColor.value,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                CustomWidgets.customBottomSheet(
                                                    controller.ticketTypeList,
                                                    "NAME",
                                                    false, (data) {
                                                  controller.selectTicketType
                                                      .value = data['NAME'];
                                                  controller.selectTicketTypeId
                                                      .value = data['ID'];
                                                  Get.back();
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                    controller
                                                        .selectTicketType.value,
                                                    fontSize: 14,
                                                    color: darkTextColor,
                                                  ),
                                                  5.widthBox,
                                                  const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: iconColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).pSymmetric(h: 10.0, v: 15.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              "Ticket Date",
                                              fontSize: 16,
                                              color: appColor.value,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                var de = await CustomWidgets
                                                    .pickDate(context,
                                                        selectPreviousDate:
                                                            true);

                                                if (de != null) {
                                                  controller.selectDate.value =
                                                      de.toString();

                                                  controller.selectTallyDate
                                                          .value =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(de);
                                                  controller.tallyDate.value =
                                                      DateFormat('ddMMMyyyy')
                                                          .format(de);
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                    controller
                                                        .selectTallyDate.value,
                                                    fontSize: 14,
                                                    color: darkTextColor,
                                                  ),
                                                  5.widthBox,
                                                  const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: iconColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).pSymmetric(h: 10.0, v: 5.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                              "Ticket No",
                                              color: appColor.value,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SizedBox(
                                                width: Get.width / 3,
                                                height: 50,
                                                child: TextField(
                                                  textAlign: TextAlign.right,
                                                  controller: controller
                                                      .tallyNoController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                )),
                                          ],
                                        ).pSymmetric(h: 10.0, v: 5.0),
                                        10.heightBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: TextWidget(
                                                  "Cancel",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                )),
                                            CustomButton(
                                              text: "OK",
                                              onPressed: () {
                                                if (controller
                                                            .selectTicketTypeId
                                                            .value !=
                                                        "" &&
                                                    controller.tallyNoController
                                                            .text !=
                                                        "") {
                                                  controller
                                                          .ticketNumber.value =
                                                      "${controller.selectTicketType.value}-${controller.tallyDate.value.toUpperCase()}-${controller.tallyNoController.text}";
                                                  Get.back();
                                                  Get.to(
                                                      () =>
                                                          const TicketDetails(),
                                                      arguments: controller
                                                          .ticketNumber.value);
                                                } else {
                                                  CustomWidgets.snackBar(
                                                      title:
                                                          "Please enter all fields.");
                                                }
                                              },
                                              width: 120,
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).p8(),
                                  ).pSymmetric(h: 20.0, v: 8.0),
                                )));
                              },
                              leading: const Icon(
                                Icons.sticky_note_2_outlined,
                                color: Colors.black,
                              ),
                              title: TextWidget(
                                "Search Ticket",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Get.back();
                                Get.dialog(Center(
                                    child: Obx(
                                  () => Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          "Remind Me",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                        ).centered().p8(),
                                        Container(
                                          width: Get.width,
                                          height: 1.0,
                                          color: Colors.grey[400],
                                        ),
                                        10.heightBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              "Date",
                                              fontSize: 16,
                                              color: appColor.value,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                var de = await CustomWidgets
                                                    .pickDate(context,
                                                        selectPreviousDate:
                                                            true);

                                                if (de != null) {
                                                  // controller.selectRemindMeDate.value = de.toString();

                                                  controller.selectRemindMeDate
                                                          .value =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(de);
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                    controller
                                                            .selectRemindMeDate
                                                            .value
                                                            .isNotEmpty
                                                        ? controller
                                                            .selectRemindMeDate
                                                            .value
                                                        : "dd/mmm/yyyy",
                                                    fontSize: 14,
                                                    color: darkTextColor,
                                                  ),
                                                  5.widthBox,
                                                  const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: iconColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).pSymmetric(h: 10.0, v: 5.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              "Time",
                                              fontSize: 16,
                                              color: appColor.value,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                TimeOfDay de =
                                                    await CustomWidgets
                                                        .pickTime(context);

                                                controller.selectTime.value =
                                                    "${de.hour.toString()}:${de.minute.toString()}";
                                              },
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                    controller.selectTime.value
                                                            .isNotEmpty
                                                        ? controller
                                                            .selectTime.value
                                                        : "--/--",
                                                    fontSize: 14,
                                                    color: darkTextColor,
                                                  ),
                                                  5.widthBox,
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: iconColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).pSymmetric(h: 10.0, v: 5.0),
                                        TextField(
                                          controller: controller.content1,
                                          minLines: 4,
                                          maxLines: 10,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  "Message/Notes that you want to remind in future.Write here...."),
                                        ).pSymmetric(h: 10.0, v: 5.0),
                                        TextButton(
                                            onPressed: () {
                                              Get.back();

                                              if (controller
                                                  .remindMeList.isNotEmpty) {
                                                controller.getHistory();
                                              }
                                            },
                                            child: TextWidget(
                                              "Click here to view History",
                                              color: appColor.value,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        10.heightBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: TextWidget(
                                                  "Cancel",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                )),
                                            CustomButton(
                                              text: "Set",
                                              onPressed: () {
                                                if (controller.remindMeDate
                                                    .value.isEmpty) {
                                                  CustomWidgets.snackBar(
                                                      title:
                                                          "Please select date.");
                                                } else if (controller
                                                    .selectTime.isEmpty) {
                                                  CustomWidgets.snackBar(
                                                      title:
                                                          "Please select time");
                                                } else if (controller
                                                    .content1.text
                                                    .trim()
                                                    .isEmpty) {
                                                  CustomWidgets.snackBar(
                                                      title:
                                                          "Please enter description.");
                                                } else {
                                                  controller
                                                      .updateRemindMeData();
                                                }
                                              },
                                              width: 120,
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).p8(),
                                  ).pSymmetric(h: 20.0, v: 8.0),
                                )));
                              },
                              leading: const Icon(
                                Icons.notifications_active_outlined,
                                color: Colors.black,
                              ),
                              title: TextWidget(
                                "Remind Me",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.color_lens_rounded,
                                color: Colors.black,
                              ),
                              title: TextWidget(
                                "Theme - ${themeName[DataInfo.selectTheme.value - 1]}",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitle: Row(
                                  children: List.generate(
                                appTheme.length,
                                (index) => IconButton(
                                    onPressed: () {
                                      controller.updateTheme(index);
                                    },
                                    icon: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                              colors: appTheme[index])),
                                    )),
                              )),
                            ),
                          ],
                        ),
                      ));
                    },
                    isShowNotification: true,
                  ),
                  drawer: const DrawerWidget(),
                  body: SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    child: Obx(
                      () => controller.isLoading.value == false &&
                              controller.targetList.isNotEmpty
                          ? SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: false,
                              header: const ClassicHeader(),
                              controller: controller.refreshController,
                              onRefresh: controller.onRefresh,
                              onLoading: controller.onLoading,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    controller.filterUserList.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              CustomWidgets.customBottomSheet(
                                                  controller.filterUserList,
                                                  "NAME",
                                                  true, (data) {
                                                controller.selectUser.value =
                                                    data['NAME'];
                                                DataInfo.username.value =
                                                    data['NAME'];
                                                DataInfo.userId.value =
                                                    data['ID'].toString();
                                                DataInfo.pid.value =
                                                    data['PID'].toString();
                                                // DataInfo.rollId.value =
                                                //     data['ROLLID'].toString();
                                                DataInfo.enrollId.value =
                                                    data['ENROLLID'].toString();
                                                DataInfo.desCat.value =
                                                    data['DESCAT'].toString();
                                                DataInfo.isSelectUser.value =
                                                    false;
                                                DataInfo.box.write(
                                                    "selectedDashboardUser",
                                                    data);
                                                Get.find<DashboardController>()
                                                    .onInit();
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
                                                            CustomWidgets
                                                                .showImage(
                                                                    path:
                                                                        userIcon),
                                                            10.widthBox,
                                                            TextWidget(
                                                              controller
                                                                  .selectUser
                                                                  .value,
                                                              color: greyColor,
                                                              fontSize: 14,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: iconColor,
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: iconColor,
                                                  )
                                                ],
                                              ).pSymmetric(v: 15.0),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.selectTab.value = 0;
                                            if (DataInfo.desCat.value != "L1") {
                                              controller.pageController
                                                  .jumpToPage(0);
                                            }

                                            controller.updateChartData(0);
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            decoration: controller
                                                        .selectTab.value ==
                                                    0
                                                ? BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: Provider.of<
                                                                    AppThemeController>(
                                                                context)
                                                            .appGradientColor),
                                                  )
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors: Provider.of<
                                                                      AppThemeController>(
                                                                  context)
                                                              .appGradientColor),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                controller.selectTab.value == 0
                                                    ? TextWidget(
                                                        "${controller.targetList[0]['type']}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        //fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )
                                                    : GradientText(
                                                        "${controller.targetList[0]['type']}",
                                                        gradient: LinearGradient(
                                                            colors: Provider.of<
                                                                        AppThemeController>(
                                                                    context)
                                                                .appGradientColor),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        10.widthBox,
                                        InkWell(
                                          onTap: () {
                                            controller.selectTab.value = 1;
                                            if (DataInfo.desCat.value != "L1") {
                                              controller.pageController
                                                  .jumpToPage(1);
                                            }
                                            controller.updateChartData(1);
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            decoration: controller
                                                        .selectTab.value ==
                                                    1
                                                ? BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: Provider.of<
                                                                    AppThemeController>(
                                                                context)
                                                            .appGradientColor),
                                                  )
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors: Provider.of<
                                                                      AppThemeController>(
                                                                  context)
                                                              .appGradientColor),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                controller.selectTab.value == 1
                                                    ? TextWidget(
                                                        "${controller.targetList[1]['type']}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        //fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )
                                                    : GradientText(
                                                        "${controller.targetList[1]['type']}",
                                                        gradient: LinearGradient(
                                                            colors: Provider.of<
                                                                        AppThemeController>(
                                                                    context)
                                                                .appGradientColor),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        10.widthBox,
                                        InkWell(
                                          onTap: () {
                                            controller.selectTab.value = 2;
                                            if (DataInfo.desCat.value != "L1") {
                                              controller.pageController
                                                  .jumpToPage(2);
                                            }

                                            controller.updateChartData(2);
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            decoration: controller
                                                        .selectTab.value ==
                                                    2
                                                ? BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: Provider.of<
                                                                    AppThemeController>(
                                                                context)
                                                            .appGradientColor),
                                                  )
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors: Provider.of<
                                                                      AppThemeController>(
                                                                  context)
                                                              .appGradientColor),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                controller.selectTab.value == 2
                                                    ? TextWidget(
                                                        "${controller.targetList[2]['type']}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        //fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )
                                                    : GradientText(
                                                        "${controller.targetList[2]['type']}",
                                                        gradient: LinearGradient(
                                                            colors: Provider.of<
                                                                        AppThemeController>(
                                                                    context)
                                                                .appGradientColor),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).pOnly(bottom: 10.0),
                                    DataInfo.desCat.value != "L1"
                                        ? SizedBox(
                                            height: context.screenHeight / 4,
                                            child: chartWidget(context),
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                width: context.screenWidth,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xfff5f6f9),
                                                    width: 1,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: cardShadowColor,
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SvgPicture.asset(
                                                            meetingIcon,
                                                            color: Provider.of<
                                                                        AppThemeController>(
                                                                    context)
                                                                .appColor,
                                                            width: 30,
                                                            height: 30),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        TextWidget(
                                                          "Face Time",
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        TextWidget(
                                                          controller
                                                              .faceTime.value,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                    50.widthBox,
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 60,
                                                          height: 40,
                                                          child: CustomWidgets
                                                              .showAssetImage(
                                                                  path:
                                                                      outstanding,
                                                                  width: 60,
                                                                  height: 60),
                                                        ),
                                                        TextWidget(
                                                          "Net Value",
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        TextWidget(
                                                          controller
                                                              .netValue.value,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              10.heightBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  _PendingItem(
                                                    onTap: () {
                                                      Get.to(
                                                          () => const TopList(),
                                                          arguments: "Top 30");
                                                    },
                                                    title: 'Top 30',
                                                    value: controller
                                                        .topValue.value,
                                                    max: 30,
                                                    color: Colors.green,
                                                  ),
                                                  _PendingItem(
                                                    onTap: () {
                                                      Get.to(
                                                          () => const TopList(),
                                                          arguments: "Next 30");
                                                    },
                                                    title: 'Next 30',
                                                    value: controller
                                                        .nextTopValue.value,
                                                    max: 30,
                                                    color: Colors.orange,
                                                  ),
                                                  _PendingItem(
                                                    onTap: () {
                                                      Get.to(
                                                          () => const TopList(),
                                                          arguments: "Others");
                                                    },
                                                    title: 'Others',
                                                    value: controller
                                                        .thirdTopValue.value,
                                                    max: 30,
                                                    color: Colors.red,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                    10.heightBox,
                                    if (DataInfo.desCat.value == "L1")
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => DataPoints());
                                            },
                                            child: Container(
                                              width: context.screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: cardShadowColor,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomWidgets
                                                          .showAssetImage(
                                                              path: dataPoint,
                                                              width: 60,
                                                              height: 60),
                                                      10.widthBox,
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextWidget(
                                                            "Datapoint",
                                                            color: const Color(
                                                                0xff3d3d3d),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          5.heightBox,
                                                          Row(
                                                            children: [
                                                              TextWidget(
                                                                "ASC-${controller.dataPoint['ASCCNT']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                "Billed-${controller.dataPoint['BILLED']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                "Non Live-${controller.dataPoint['OUTBILLED']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  CustomWidgets.showAssetImage(
                                                      path: arrowRight),
                                                ],
                                              ).p8(),
                                            ).pOnly(bottom: 5.0),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              DataInfo.box.write(
                                                  "selectCallBookingUser", {
                                                "ID": DataInfo.userId.value,
                                                "NAME": DataInfo.username.value
                                              });

                                              Get.to(() => const CallBooking());
                                            },
                                            child: Container(
                                              width: context.screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: cardShadowColor,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomWidgets
                                                          .showAssetImage(
                                                              path: callBooking,
                                                              width: 60,
                                                              height: 60),
                                                      10.widthBox,
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextWidget(
                                                            "Call Booking",
                                                            color: const Color(
                                                                0xff3d3d3d),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          5.heightBox,
                                                          Row(
                                                            children: [
                                                              TextWidget(
                                                                "Total-${controller.callBooking.value}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  CustomWidgets.showAssetImage(
                                                      path: arrowRight),
                                                ],
                                              ).p8(),
                                            ).pOnly(bottom: 5.0),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => const Lead());
                                            },
                                            child: Container(
                                              width: context.screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: cardShadowColor,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomWidgets
                                                          .showAssetImage(
                                                              path: lead1,
                                                              width: 60,
                                                              height: 60),
                                                      10.widthBox,
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextWidget(
                                                            "Lead",
                                                            color: const Color(
                                                                0xff3d3d3d),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          5.heightBox,
                                                          Row(
                                                            children: [
                                                              TextWidget(
                                                                "Accepted-${controller.leadData['ACCEPTED']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                "Inprocess-${controller.leadData['INPROCESS']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                "Untouch-${controller.leadData['UNTOUCHED']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  CustomWidgets.showAssetImage(
                                                      path: arrowRight),
                                                ],
                                              ).p8(),
                                            ).pOnly(bottom: 5.0),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                () =>
                                                    const OpportunityDetails(),
                                              );
                                            },
                                            child: Container(
                                              width: context.screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: cardShadowColor,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomWidgets
                                                          .showAssetImage(
                                                              path: opportunity,
                                                              width: 60,
                                                              height: 60),
                                                      10.widthBox,
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextWidget(
                                                            "Opportunity",
                                                            color: const Color(
                                                                0xff3d3d3d),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          5.heightBox,
                                                          Row(
                                                            children: [
                                                              TextWidget(
                                                                "Total-${controller.opportunityList.where((element) => element['STATUS'] == "Open").toList().length.toString()}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                "Billed-00",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                "Total-00",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                color: const Color(
                                                                    0xff787878),
                                                                fontSize: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  CustomWidgets.showAssetImage(
                                                      path: arrowRight),
                                                ],
                                              ).p8(),
                                            ).pOnly(bottom: 5.0),
                                          ),
                                          controller.showData.value
                                              ? Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          context.screenWidth,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CustomWidgets
                                                                  .showAssetImage(
                                                                      path:
                                                                          renewableBusiness,
                                                                      width: 60,
                                                                      height:
                                                                          60),
                                                              10.widthBox,
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextWidget(
                                                                    "Renewable Business",
                                                                    color: const Color(
                                                                        0xff3d3d3d),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  5.heightBox,
                                                                  Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        "ASC-${controller.businessData['AMC']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "SMS-${controller.businessData['SMS']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "CLD-${controller.businessData['CLD']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "TSS-${controller.businessData['TSS']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "DS-${controller.businessData['DIG']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          // CustomWidgets.showAssetImage(
                                                          //     path: arrowRight),
                                                        ],
                                                      ).p8(),
                                                    ).pOnly(bottom: 5.0),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            const Outstanding());
                                                      },
                                                      child: Container(
                                                        width:
                                                            context.screenWidth,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0x3f919191),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                        path:
                                                                            outstanding,
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60),
                                                                10.widthBox,
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    TextWidget(
                                                                      "Outstanding",
                                                                      color: const Color(
                                                                          0xff3d3d3d),
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    5.heightBox,
                                                                    Row(
                                                                      children: [
                                                                        TextWidget(
                                                                          "User-${controller.outstandingData['USER']}",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          color:
                                                                              mediumGreyColor,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                        5.widthBox,
                                                                        TextWidget(
                                                                          "Team-${controller.outstandingData['TEAM']}",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          color:
                                                                              mediumGreyColor,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            CustomWidgets
                                                                .showAssetImage(
                                                                    path:
                                                                        arrowRight),
                                                          ],
                                                        ).p8(),
                                                      ).pOnly(bottom: 5.0),
                                                    ),
                                                    Container(
                                                      width:
                                                          context.screenWidth,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CustomWidgets
                                                                  .showAssetImage(
                                                                      path:
                                                                          epicenter,
                                                                      width: 60,
                                                                      height:
                                                                          60),
                                                              10.widthBox,
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextWidget(
                                                                    "Epicenter",
                                                                    color: const Color(
                                                                        0xff3d3d3d),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  5.heightBox,
                                                                  Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        "Aquire-${controller.epicData['ACQUIRE']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "Sustain-${controller.epicData['SUSTAIN']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "Bootstrap-${controller.epicData['BOOSTRAP']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          // CustomWidgets.showAssetImage(
                                                          //     path: arrowRight),
                                                        ],
                                                      ).p8(),
                                                    ).pOnly(bottom: 5.0),
                                                    Container(
                                                      width:
                                                          context.screenWidth,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CustomWidgets
                                                                  .showAssetImage(
                                                                      path:
                                                                          location,
                                                                      width: 60,
                                                                      height:
                                                                          60),
                                                              10.widthBox,
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextWidget(
                                                                    "Zone",
                                                                    color: const Color(
                                                                        0xff3d3d3d),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  5.heightBox,
                                                                  Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        "Zone-${controller.zoneData['ZONE']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        "Non Zone-${controller.zoneData['NONZONE']}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        color: const Color(
                                                                            0xff787878),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          // CustomWidgets.showAssetImage(
                                                          //     path: arrowRight),
                                                        ],
                                                      ).p8(),
                                                    ).pOnly(bottom: 5.0),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          10.heightBox,
                                          InkWell(
                                            onTap: () {
                                              controller.showData.value =
                                                  !controller.showData.value;
                                            },
                                            child: GradientText(
                                              controller.showData.value == false
                                                  ? "View more"
                                                  : "View Less",
                                              gradient: LinearGradient(
                                                  colors: Provider.of<
                                                              AppThemeController>(
                                                          context)
                                                      .appGradientColor),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          10.heightBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                  overlayColor:
                                                      WidgetStateProperty
                                                          .resolveWith(
                                                    (states) {
                                                      return states.contains(
                                                              WidgetState
                                                                  .pressed)
                                                          ? Colors.grey[200]
                                                          : null;
                                                    },
                                                  ),
                                                  splashColor: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  splashFactory:
                                                      InkRipple.splashFactory,
                                                  onTap: () async {
                                                    // await Future.delayed(const Duration(milliseconds: 500))
                                                    Get.bottomSheet(
                                                      GetBuilder<
                                                              DashboardController>(
                                                          builder:
                                                              (dashboardController) {
                                                        return Container(
                                                          width: Get.width,
                                                          height: 448,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        36.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        36.0)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x3f929292),
                                                                blurRadius: 27,
                                                                offset: Offset(
                                                                    0, -4),
                                                              ),
                                                            ],
                                                            color: Colors.white,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  width: context
                                                                          .screenWidth *
                                                                      0.9,
                                                                  // height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: const Color(
                                                                        0xfff4f5f7),
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    onChanged:
                                                                        (value) {
                                                                      if (value
                                                                              .trim()
                                                                              .length >
                                                                          2) {
                                                                        dashboardController
                                                                            .dataPointSearch(value);
                                                                      }
                                                                    },
                                                                    controller:
                                                                        dashboardController
                                                                            .searchController1,
                                                                    decoration: InputDecoration(
                                                                        hintText: "Sr No or 1st 4 letter of datapoint",
                                                                        hintStyle: const TextStyle(
                                                                          color:
                                                                              subtleTextColor,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                        border: InputBorder.none,
                                                                        prefixIcon: const Icon(Icons.search),
                                                                        suffixIcon: dashboardController.searchController1.text.trim().isNotEmpty
                                                                            ? IconButton(
                                                                                onPressed: () {
                                                                                  dashboardController.searchController1.clear();

                                                                                  dashboardController.dataPointSearch("");
                                                                                },
                                                                                icon: const Icon(Icons.close))
                                                                            : const SizedBox()),
                                                                  )).pOnly(top: 20.0, bottom: 10.0),
                                                              Expanded(
                                                                  child: dashboardController
                                                                          .listData
                                                                          .isNotEmpty
                                                                      ? ListView.builder(
                                                                          itemCount: dashboardController.listData.length,
                                                                          itemBuilder: (context, index) {
                                                                            return InkWell(
                                                                              onTap: () {
                                                                                Get.back();
                                                                                Get.to(() => const DataPointInfo(), arguments: dashboardController.listData[index]);
                                                                              },
                                                                              child: Container(
                                                                                width: Get.width,
                                                                                height: 60,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  boxShadow: const [
                                                                                    BoxShadow(
                                                                                      color: Color(0x3fb0b0b0),
                                                                                      blurRadius: 4,
                                                                                      offset: Offset(0, 2),
                                                                                    ),
                                                                                  ],
                                                                                  color: Colors.white,
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    TextWidget(
                                                                                      "${controller.listData[index]['CITY']}",
                                                                                      color: darkTextColor,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.arrow_forward_ios_outlined,
                                                                                      color: Color(0xffBDC0CE),
                                                                                    ),
                                                                                  ],
                                                                                ).pSymmetric(h: 25.0),
                                                                              ),
                                                                            );
                                                                          })
                                                                      : Center(
                                                                          child:
                                                                              TextWidget(
                                                                            "Search Datapoint..",
                                                                            fontSize:
                                                                                25,
                                                                          ),
                                                                        ))
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enterBottomSheetDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                    ).then((value) =>
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus());
                                                  },
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              cardShadowColor,
                                                          blurRadius: 8,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                                path:
                                                                    dataPointSearch),
                                                        10.heightBox,
                                                        TextWidget(
                                                          "Datapoint Search",
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ],
                                                    ).p16(),
                                                  )),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      const NearByCustomer());
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: cardShadowColor,
                                                        blurRadius: 8,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      CustomWidgets
                                                          .showAssetImage(
                                                              path:
                                                                  nearByCustomer),
                                                      10.heightBox,
                                                      TextWidget(
                                                        "Nearby Customer",
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ).pSymmetric(h: 8.0, v: 16.0),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  // LocationData location =
                                                  //     await Utilities.getLocation();

                                                  Get.to(() => ColdCalling());
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: cardShadowColor,
                                                        blurRadius: 8,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      CustomWidgets
                                                          .showAssetImage(
                                                              path:
                                                                  coldCalling),
                                                      10.heightBox,
                                                      TextWidget(
                                                        "Cold Calling",
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ).p16(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: [
                                          Container(
                                            width: context.screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x3F919191),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        controller.selectTabL2
                                                            .value = 0;
                                                        controller
                                                            .selectL2Category1
                                                            .value = "1";
                                                        controller.selectData =
                                                            controller
                                                                .monthlyL2Data;
                                                      },
                                                      child: Container(
                                                        width: 80,
                                                        height: 35,
                                                        decoration: controller
                                                                    .selectTabL2
                                                                    .value ==
                                                                0
                                                            ? BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                gradient: LinearGradient(
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                    colors: Provider.of<AppThemeController>(
                                                                            context)
                                                                        .appGradientColor),
                                                              )
                                                            : BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                border:
                                                                    GradientBoxBorder(
                                                                  gradient: LinearGradient(
                                                                      colors: Provider.of<AppThemeController>(
                                                                              context)
                                                                          .appGradientColor),
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GradientText(
                                                              "Monthly",
                                                              gradient: LinearGradient(
                                                                  colors: controller
                                                                              .selectTabL2
                                                                              .value !=
                                                                          0
                                                                      ? Provider.of<AppThemeController>(
                                                                              context)
                                                                          .appGradientColor
                                                                      : [
                                                                          Colors
                                                                              .white,
                                                                          Colors
                                                                              .white
                                                                        ]),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    10.widthBox,
                                                    InkWell(
                                                      onTap: () {
                                                        controller.selectTabL2
                                                            .value = 1;
                                                        controller
                                                            .selectL2Category1
                                                            .value = "2";
                                                        controller.selectData =
                                                            controller
                                                                .quarterlyL2Data;
                                                      },
                                                      child: Container(
                                                        width: 80,
                                                        height: 35,
                                                        decoration: controller
                                                                    .selectTabL2
                                                                    .value ==
                                                                1
                                                            ? BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                gradient: LinearGradient(
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                    colors: Provider.of<AppThemeController>(
                                                                            context)
                                                                        .appGradientColor),
                                                              )
                                                            : BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                border:
                                                                    GradientBoxBorder(
                                                                  gradient: LinearGradient(
                                                                      colors: Provider.of<AppThemeController>(
                                                                              context)
                                                                          .appGradientColor),
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GradientText(
                                                              "Quarterly",
                                                              gradient: LinearGradient(
                                                                  colors: controller
                                                                              .selectTabL2
                                                                              .value !=
                                                                          1
                                                                      ? Provider.of<AppThemeController>(
                                                                              context)
                                                                          .appGradientColor
                                                                      : [
                                                                          Colors
                                                                              .white,
                                                                          Colors
                                                                              .white
                                                                        ]),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    10.widthBox,
                                                    InkWell(
                                                      onTap: () {
                                                        controller.selectTabL2
                                                            .value = 2;
                                                        controller
                                                            .selectL2Category1
                                                            .value = "3";
                                                        controller.selectData =
                                                            controller
                                                                .allL2Data;
                                                      },
                                                      child: Container(
                                                        width: 80,
                                                        height: 35,
                                                        decoration: controller
                                                                    .selectTabL2
                                                                    .value ==
                                                                2
                                                            ? BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                gradient: LinearGradient(
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                    colors: Provider.of<AppThemeController>(
                                                                            context)
                                                                        .appGradientColor),
                                                              )
                                                            : BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                border:
                                                                    GradientBoxBorder(
                                                                  gradient: LinearGradient(
                                                                      colors: Provider.of<AppThemeController>(
                                                                              context)
                                                                          .appGradientColor),
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GradientText(
                                                              "All Time",
                                                              gradient: LinearGradient(
                                                                  colors: controller
                                                                              .selectTabL2
                                                                              .value !=
                                                                          2
                                                                      ? Provider.of<AppThemeController>(
                                                                              context)
                                                                          .appGradientColor
                                                                      : [
                                                                          Colors
                                                                              .white,
                                                                          Colors
                                                                              .white
                                                                        ]),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ).pSymmetric(v: 10.0),
                                                5.heightBox,
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                  path:
                                                                      caseCreated,
                                                                ),
                                                                10.heightBox,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        'Case Created',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        '${controller.selectData['caseCreated']}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                  path:
                                                                      caseResolved,
                                                                ),
                                                                10.heightBox,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        'Case Resolved',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        '${controller.selectData['caseResolved']}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    10.heightBox,
                                                    CustomWidgets.divider(),
                                                  ],
                                                ).pSymmetric(v: 10.0),
                                                10.heightBox,
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                  path:
                                                                      tallyTips,
                                                                ),
                                                                10.heightBox,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        'Tally Tips',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        '${controller.selectData['tallyTips']}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                  path:
                                                                      testimonials,
                                                                ),
                                                                10.heightBox,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        'Testimonials',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        '${controller.selectData['testmoinels']}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    10.heightBox,
                                                    CustomWidgets.divider(),
                                                  ],
                                                ).pSymmetric(v: 10.0),
                                                10.heightBox,
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                  path:
                                                                      feedback,
                                                                ),
                                                                10.heightBox,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        'Feedbacks',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        '${controller.selectData['feedbacks']}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                CustomWidgets
                                                                    .showAssetImage(
                                                                  path: ratings,
                                                                ),
                                                                10.heightBox,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      TextWidget(
                                                                        'Ratings',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      5.widthBox,
                                                                      TextWidget(
                                                                        '${controller.selectData['ratings']}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                10.heightBox,
                                              ],
                                            ).pSymmetric(v: 16.0),
                                          ),
                                          10.heightBox,
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                          path: ratings,
                                                        ),
                                                        10.heightBox,
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Row(
                                                            children: [
                                                              TextWidget(
                                                                'Average Ratings',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                controller
                                                                    .avgRating
                                                                    .value,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]).p16(),
                                                    ),
                                                  ),
                                                  20.widthBox,
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                          path: overallRanking,
                                                        ),
                                                        10.heightBox,
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Row(
                                                            children: [
                                                              TextWidget(
                                                                'Overall Rankings',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                controller
                                                                    .overAllRating
                                                                    .value,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]).p16(),
                                                    ),
                                                  ),
                                                ],
                                              ).pSymmetric(v: 5.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                          path: pprc,
                                                        ),
                                                        10.heightBox,
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Row(
                                                            children: [
                                                              TextWidget(
                                                                'PPRC',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                controller
                                                                    .mapDataL2[
                                                                        'pprc']
                                                                    .toString(),
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]).p16(),
                                                    ),
                                                  ),
                                                  20.widthBox,
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                          path: ticket,
                                                        ),
                                                        10.heightBox,
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Row(
                                                            children: [
                                                              TextWidget(
                                                                'Tickets',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                controller
                                                                    .mapDataL2[
                                                                        'ticket']
                                                                    .toString(),
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]).p16(),
                                                    ),
                                                  ),
                                                ],
                                              ).pSymmetric(v: 5.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          const CallBooking());
                                                    },
                                                    child: Container(
                                                      width:
                                                          context.screenWidth /
                                                              2.3,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                          path: onsiteVisits,
                                                        ),
                                                        10.heightBox,
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Row(
                                                            children: [
                                                              TextWidget(
                                                                'Onsite Visits',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                controller
                                                                    .callBooking
                                                                    .value,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]).p16(),
                                                    ),
                                                  ),
                                                  20.widthBox,
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                          () => const Lead());
                                                    },
                                                    child: Container(
                                                      width:
                                                          context.screenWidth /
                                                              2.32,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f919191),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(children: [
                                                        CustomWidgets
                                                            .showAssetImage(
                                                          path: lead,
                                                        ),
                                                        10.heightBox,
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Row(
                                                            children: [
                                                              TextWidget(
                                                                'Lead',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              5.widthBox,
                                                              TextWidget(
                                                                '${controller.mapDataL2['lead']}',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]).p16(),
                                                    ),
                                                  ),
                                                ],
                                              ).pSymmetric(v: 5.0),
                                            ],
                                          ),
                                        ],
                                      ),

                                    // ElevatedButton(onPressed: (){
                                    //   Utilities.getCurrentLocation();
                                    // },child: const Text("Location"),),
                                  ],
                                ).p16(),
                              ),
                            )
                          : controller.isLoading.value == true
                              ? const LoadingScreen()
                              : Center(
                                  child: TextWidget(
                                    "Server error",
                                    fontSize: 20,
                                  ),
                                ),
                    ),
                  ),
                )));
  }

  showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Do you want to exit?",
                    textScaler: TextScaler.linear(1.2),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: const Text(
                            "Yes",
                            textScaler: TextScaler.linear(1.2),
                            style: TextStyle(color: Colors.blue),
                          )),
                      const SizedBox(width: 15),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            textScaler: TextScaler.linear(1.2),
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

chartWidget(BuildContext context) {
  return GetBuilder<DashboardController>(builder: (dashboard) {
    return SizedBox(
      height: context.screenHeight / 4,
      child: PageView.builder(
        controller: dashboard.pageController,
        itemCount: 3,
        itemBuilder: (context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              width: context.screenWidth,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xfff5f6f9),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: cardShadowColor,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    dashboard.targetList[index]['percentage'].toString(),
                    color: subtleTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ).p8(),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                            width: context.screenWidth / 2.8,
                            child: SfCircularChart(series: <CircularSeries>[
                              RadialBarSeries<ChartData, String>(
                                  dataSource: dashboard.chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  maximumValue: 100.0,
                                  radius: '100%',
                                  gap: "4%",
                                  cornerStyle: CornerStyle.bothCurve,
                                  useSeriesColor: true,
                                  trackOpacity: 0.2,
                                  dataLabelSettings: const DataLabelSettings(
                                      // Renders the data label
                                      isVisible: false))
                            ])),

                        // SfCircularChart(
                        //     legend: Legend(
                        //
                        //       isVisible: false,
                        //
                        //     ),
                        //     series: <CircularSeries>[
                        //       PieSeries<ChartData, String>(
                        //           dataSource: dashboard.chartData,
                        //
                        //           xValueMapper: (ChartData data, _) =>
                        //           data.x,
                        //           yValueMapper: (ChartData data, _) =>
                        //           data.y,
                        //           pointColorMapper: (ChartData data,_)=>data.color,
                        //           // Radius of pie
                        //           radius: '85%')
                        //     ]),
                        //  ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  dashboard.updateStatus(index, "M");
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff16BFD6)),
                                    ),
                                    10.widthBox,
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: TextWidget(
                                            "Me",
                                            color: subtleTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextWidget(
                                          "${dashboard.targetList[index]['meTarget']}%",
                                          color: subtleTextColor,
                                          fontSize: dashboard.targetList[index]
                                                          ['meTarget']
                                                      .toString()
                                                      .length >
                                                  8
                                              ? 14
                                              : 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              8.heightBox,
                              InkWell(
                                onTap: () {
                                  dashboard.updateStatus(index, "T");
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffF7BD65)),
                                    ),
                                    10.widthBox,
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: TextWidget(
                                            "Team",
                                            color: subtleTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextWidget(
                                          "${dashboard.targetList[index]['teamTarget']}%",
                                          color: subtleTextColor,
                                          fontSize: dashboard.targetList[index]
                                                          ['teamTarget']
                                                      .toString()
                                                      .length >
                                                  8
                                              ? 14
                                              : 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              8.heightBox,
                              InkWell(
                                onTap: () {
                                  dashboard.updateStatus(index, "F");
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffA155B9)),
                                    ),
                                    10.widthBox,
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: TextWidget(
                                            "Floor",
                                            color: subtleTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextWidget(
                                          "${dashboard.targetList[index]['floorTarget']}%",
                                          color: subtleTextColor,
                                          fontSize: dashboard.targetList[index]
                                                          ['floorTarget']
                                                      .toString()
                                                      .length >
                                                  8
                                              ? 14
                                              : 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onPageChanged: (int value) {
          dashboard.selectTab.value = value;
          // dashboard.updateChartData(value);
        },
      ),
    );
  });
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;

  final Color? color;
}

class _PendingItem extends StatelessWidget {
  final String title;
  final double value;
  final int max;
  final Color color;
  final VoidCallback? onTap;

  const _PendingItem({
    required this.title,
    required this.value,
    required this.max,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.screenWidth * 0.3,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Provider.of<AppThemeController>(context).appColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 46,
                  width: 46,
                  child: CircularProgressIndicator(
                    value: value / max,
                    strokeWidth: 5,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
