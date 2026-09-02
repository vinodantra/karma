// ignore_for_file: file_names
import 'package:karma/Application/CallBooking/PiwForm.dart';
import 'package:karma/Constants/Library.dart';

class CallBooking extends GetView<CallBookingController1> {
  const CallBooking({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CallBookingController1());

    final dashboardController = Get.find<DashboardController>();
    return Scaffold(
      appBar: AppBarWidget(
        title: "Call Booking",
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  controller.isLoading.value == false
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              DataInfo.rollId.value == "1"
                                  ? InkWell(
                                      onTap: () {
                                        CustomWidgets.customBottomSheet(
                                            dashboardController.filterUserList,
                                            "NAME",
                                            true, (data) {
                                          controller.selectCallBookingUser(
                                              data: data);
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
                                                      CustomWidgets.showImage(
                                                          path: userIcon),
                                                      10.widthBox,
                                                      TextWidget(
                                                        controller
                                                            .selectUser.value,
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
                                        ).pSymmetric(h: 15.0, v: 10.0),
                                      ),
                                    )
                                  : const SizedBox(),
                              controller.todayCallList.isNotEmpty ||
                                      controller.callList.isNotEmpty ||
                                      controller.previousCallList.isNotEmpty
                                  ? Expanded(
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          controller.todayCallList.isNotEmpty
                                              ? TextWidget("Today's Call",
                                                      color: const Color(
                                                          0xff2f3237),
                                                      fontSize: 16,
                                                      textAlign:
                                                          TextAlign.start)
                                                  .pSymmetric(h: 10.0)
                                              : const SizedBox(),
                                          Column(
                                            children: List.generate(
                                                controller.todayCallList.length,
                                                (index) => tile(
                                                    controller
                                                        .todayCallList[index],
                                                    index)),
                                          ),
                                          controller.callList.isNotEmpty
                                              ? TextWidget(
                                                  "Call Ahead",
                                                  color:
                                                      darkTextColor,
                                                  fontSize: 16,
                                                  textAlign: TextAlign.start,
                                                ).pSymmetric(h: 10.0)
                                              : const SizedBox(),
                                          Column(
                                            children: List.generate(
                                                controller.callList.length,
                                                (index) => tile(
                                                    controller.callList[index],
                                                    index)),
                                          ),

                                          controller.previousCallList.isNotEmpty
                                              ? TextWidget("Previous Call",
                                                      color: const Color(
                                                          0xff2f3237),
                                                      fontSize: 16,
                                                      textAlign:
                                                          TextAlign.start)
                                                  .pSymmetric(h: 10.0)
                                              : const SizedBox(),
                                          Column(
                                            children: List.generate(
                                                controller
                                                    .previousCallList.length,
                                                (index) => tile(
                                                    controller.previousCallList[
                                                        index],
                                                    index)),
                                          ),
                                          // controller.list.isNotEmpty ?
                                          // ListView.builder(
                                          //     itemCount: controller.list.length,
                                          //     itemBuilder: (context,index ){return tile(controller.list[index],index);}) : controller.isLoading.value == false ?
                                          // Center(child: TextWidget("No data found",fontSize: 20,fontWeight: FontWeight.w500,)) : const SizedBox()
                                        ],
                                      ),
                                    )
                                  : const Expanded(
                                      child: Center(
                                          child: Text(
                                      "No data found.",
                                      style: TextStyle(fontSize: 30),
                                    ))),
                            ],
                          ),
                        )
                      : const SizedBox(),
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
    return GetBuilder<CallBookingController1>(builder: (dashboardController) {
      return InkWell(
        onTap: () {
          Get.to(() => const CallBookingDetails(), arguments: data)!
              .then((value) => controller.onInit());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xffeaecf0),
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.60,
                        child: TextWidget(
                          data['CMP'],
                          color: titleColor,
                          fontSize: 18,
                          maxLines: 2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DataInfo.rollId.value == "1" &&
                              (data['CHKIN'] == "00" || data['CHKOUT'] == "00")
                          ? CustomWidgets.showSvgImage(
                              path: editIcon,
                              onPressed: () async {
                                if (data['CHKIN'] == "00" &&
                                    DataInfo.desCat.value == "L1") {
                                  await controller.checkStatus(
                                      data['COMPANYID'].toString(),
                                      data['ID'].toString());
                                }
                                Get.dialog(Center(
                                  child: Obx(() => Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextWidget(
                                              "Update check In/Out Time",
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.center,
                                            ).p8(),
                                            Container(
                                              width: Get.width,
                                              height: 1.0,
                                              color: Colors.grey,
                                            ),
                                            10.heightBox,
                                            data['CHKIN'] == "00"
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        "Check In - ",
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).p8(),
                                                      TextWidget(
                                                        Utilities.checkString(
                                                                controller
                                                                    .selectCheckInTime
                                                                    .value)
                                                            ? controller
                                                                .selectCheckInTime
                                                                .value
                                                            : "__/__ ",
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).p8(),
                                                      iconWidget(
                                                          iconData: Icons
                                                              .timer_outlined,
                                                          onPressed: () async {
                                                            TimeOfDay?
                                                                selectTime =
                                                                await CustomWidgets
                                                                    .pickTime(Get
                                                                        .context!);
                                                            if (selectTime !=
                                                                null) {
                                                              controller
                                                                      .selectCheckInTime
                                                                      .value =
                                                                  "${selectTime.hour.toString().padLeft(2, '0')}:${selectTime.minute.toString().padLeft(2, '0')}";
                                                            }
                                                          }),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            10.heightBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                  "Check Out - ",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center,
                                                ).p8(),
                                                TextWidget(
                                                  Utilities.checkString(
                                                          controller
                                                              .selectCheckOutTime
                                                              .value)
                                                      ? controller
                                                          .selectCheckOutTime
                                                          .value
                                                      : "__/__ ",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center,
                                                ).p8(),
                                                iconWidget(
                                                    iconData:
                                                        Icons.timer_outlined,
                                                    onPressed: () async {
                                                      TimeOfDay? selectTime =
                                                          await CustomWidgets
                                                              .pickTime(
                                                                  Get.context!);
                                                      if (selectTime != null) {
                                                        controller
                                                                .selectCheckOutTime
                                                                .value =
                                                            "${selectTime.hour.toString().padLeft(2, "0")}:${selectTime.minute.toString().padLeft(2, "0")}";
                                                      }
                                                    }),
                                              ],
                                            ),
                                            Container(
                                              width: Get.width,
                                              height: 1.0,
                                              color: Colors.grey,
                                            ),
                                            //10.heightBox,
                                            data['CHKIN'].toString() == "00" &&
                                                    DataInfo.desCat.value ==
                                                        "L1"
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Checkbox(
                                                              value: controller
                                                                  .workShopStatus
                                                                  .value,
                                                              onChanged: controller
                                                                      .isWorkShop
                                                                      .value
                                                                  ? controller
                                                                      .changeWorkShopStatus
                                                                  : null),
                                                          TextWidget(
                                                            "is PIW",
                                                            color: controller
                                                                    .isWorkShop
                                                                    .value
                                                                ? Colors.black
                                                                : Colors
                                                                    .grey[500],
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ).pOnly(bottom: 10),
                                                      Utilities.checkString(
                                                              controller
                                                                  .workShopDate
                                                                  .value)
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextWidget(
                                                                  "Last Workshop Date : ",
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                5.widthBox,
                                                                TextWidget(
                                                                  controller
                                                                      .workShopDate
                                                                      .value,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ],
                                                            ).pOnly(bottom: 10)
                                                          : const SizedBox(),
                                                      Container(
                                                        width: Get.width,
                                                        height: 1.0,
                                                        color: Colors.grey,
                                                      ),
                                                      10.heightBox,
                                                    ],
                                                  )
                                                : const SizedBox(),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      controller
                                                          .selectCheckInTime
                                                          .value = "";
                                                      controller
                                                          .selectCheckOutTime
                                                          .value = "";
                                                      Get.back();
                                                    },
                                                    child: TextWidget(
                                                      "Cancel",
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                15.widthBox,
                                                CustomButton(
                                                  text: "SAVE",
                                                  onPressed: () async {
                                                    if (Utilities.checkString(
                                                            controller
                                                                .selectCheckInTime
                                                                .value) &&
                                                        Utilities.checkString(
                                                            controller
                                                                .selectCheckOutTime
                                                                .value)) {
                                                      bool status = controller
                                                          .checkTime();
                                                      if (status) {

                                                        await controller
                                                            .updateStatus(
                                                                data, "1");
                                                        await controller
                                                            .updateStatus(
                                                                data, "2");
                                                        controller
                                                            .selectCheckInTime
                                                            .value = "";
                                                        controller
                                                            .selectCheckOutTime
                                                            .value = "";
                                                        Get.back();
                                                      } else {
                                                        CustomWidgets.snackBar(
                                                            title:
                                                                "Check In time must before check out time");
                                                      }
                                                    } else if (Utilities
                                                        .checkString(controller
                                                            .selectCheckInTime
                                                            .value)) {
                                                      await controller
                                                          .updateStatus(
                                                              data, "1");
                                                      controller
                                                          .selectCheckInTime
                                                          .value = "";
                                                      Get.back();
                                                    } else if (Utilities
                                                        .checkString(controller
                                                            .selectCheckOutTime
                                                            .value)) {
                                                      await controller
                                                          .updateStatus(
                                                              data, "2");
                                                      controller
                                                          .selectCheckOutTime
                                                          .value = "";
                                                      Get.back();
                                                    } else {
                                                      if (!Utilities.checkString(controller.selectCheckInTime.value) &&
                                                          !Utilities.checkString(
                                                              controller
                                                                  .selectCheckOutTime
                                                                  .value) &&
                                                          data['CHKIN'] ==
                                                              "00" &&
                                                          data['CHKOUT'] ==
                                                              "00") {
                                                        CustomWidgets.snackBar(
                                                            title:
                                                                "Please select Check In and Check Out time.");
                                                      } else if (Utilities
                                                              .checkString(
                                                                  controller
                                                                      .selectCheckInTime
                                                                      .value) &&
                                                          data['CHKIN'] ==
                                                              "00") {
                                                        CustomWidgets.snackBar(
                                                            title:
                                                                "Please select Check In time.");
                                                      } else {
                                                        CustomWidgets.snackBar(
                                                            title:
                                                                "Please select Check Out time.");
                                                      }
                                                    }
                                                  },
                                                  width: 120,
                                                  height: 35,
                                                )
                                              ],
                                            ),
                                          ],
                                        ).p8(),
                                      ).pSymmetric(h: 20, v: 8)),
                                ));
                              })
                          : const SizedBox(),
                      DataInfo.desCat.value == "L1"
                          ? IconButton(
                              onPressed: () {
                                CustomWidgets.showAlertDialog1(
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 40,
                                    ),
                                    title: "Are you sure",
                                    content: "Do you want to delete?",
                                    text1: "Delete",
                                    onCancel: () {
                                      Get.back();
                                    },
                                    text2: "Cancel",
                                    onClick: () {
                                      Get.back();
                                      controller.deleteCall(data['ID']);
                                    });
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        "${data['CALLDATE']} ${data['SHEDULE']} - ",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        data['CALLTYPID'],
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  5.heightBox,
                  Row(
                    children: [
                      TextWidget(
                        "Contact Person : ",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        data['CNTPERSON'],
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  5.heightBox,
                  DataInfo.desCat.value == "L1" && data['SUPCNT'] == "Yes"
                      ? Column(
                          children: [
                            Row(
                              children: [
                                TextWidget(
                                  "Call approved status : ",
                                  color: descriptionColor,
                                  fontSize: 14,
                                ),
                                5.widthBox,
                                TextWidget(
                                  controller.showStatus(data['APRSTS']),
                                  color: controller
                                      .showStatusColor(data['APRSTS']),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            5.heightBox,
                          ],
                        )
                      : const SizedBox(),
                  5.heightBox,
                  Row(
                    children: [
                      TextWidget(
                        "Payment collection : ",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        data['CHKCOLL'],
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xffebeffd),
                                ),
                                child: TextWidget(
                                  "In",
                                  color: linkBlueColor,
                                  fontSize: 12,
                                ).p8(),
                              ),
                              5.widthBox,
                              TextWidget(data['CHKIN'],
                                  color: linkBlueColor, fontSize: 12)
                            ],
                          ),
                          10.widthBox,
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xffebeffd),
                                ),
                                child: TextWidget(
                                  "Out",
                                  color: linkBlueColor,
                                  fontSize: 12,
                                ).p8(),
                              ),
                              5.widthBox,
                              TextWidget(data['CHKOUT'],
                                  color: linkBlueColor, fontSize: 12)
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xffebeffd),
                                ),
                                child: TextWidget(
                                  "SE",
                                  color: linkBlueColor,
                                  fontSize: 12,
                                ).p8(),
                              ),
                              5.widthBox,
                              TextWidget(data['SUPCNT'],
                                  color: linkBlueColor, fontSize: 12)
                            ],
                          ),
                          10.widthBox,
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xffebeffd),
                                ),
                                child: TextWidget(
                                  "CE",
                                  color: linkBlueColor,
                                  fontSize: 12,
                                ).p8(),
                              ),
                              5.widthBox,
                              TextWidget(data['CONV'],
                                  color: linkBlueColor, fontSize: 12)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  15.heightBox,
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 5.0,
                    children: [
                      tileWidget(
                          name: "Call",
                          icon: callIcon2,
                          onPressed: () {
                            Utilities.onClickMobile(data['MOB']);
                          }),
                      tileWidget(
                          name: "Message",
                          icon: messageIcon,
                          onPressed: () {
                            Utilities.onClickMessage(data['MOB']);
                          }),
                      Utilities.checkString(data['LAT'])
                          ? tileWidget(
                              name: "Address",
                              icon: map,
                              onPressed: () {
                                Utilities.onGoogleMap(
                                    data['LAT'], data['LONG']);
                              })
                          : const SizedBox(),
                      tileWidget(
                          name: "Checkin",
                          icon: locationIcon,
                          onPressed: () {
                            if (data['CHKIN'] != "00") {
                              Get.dialog(Center(
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextWidget(
                                        data['CMP'],
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        textAlign: TextAlign.center,
                                      ).p8(),
                                      10.heightBox,
                                      TextWidget(
                                        "Check In - ${data['CHKIN']}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ).p8(),
                                      TextWidget(
                                        data['LOCTCHKIN'].toString(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.lightGreen,
                                        textAlign: TextAlign.center,
                                        maxLines: 10,
                                      ).p8(),
                                      TextWidget(
                                        "Check Out - ${data['CHKOUT']}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ).p8(),
                                      TextWidget(
                                        data['LOCTCHKOUT'],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        maxLines: 10,
                                        textAlign: TextAlign.center,
                                        color: Colors.orangeAccent,
                                      ).p8(),
                                      10.heightBox,
                                      CustomButton(
                                        text: "OK",
                                        onPressed: () {
                                          Get.back();
                                        },
                                        width: 80,
                                        height: 40,
                                      )
                                    ],
                                  ).p8(),
                                ).p8(),
                              ));
                            }
                          }),
                      (DataInfo.rollId.value == "1" ||
                                  DataInfo.rollId.value == "2") &&
                              DataInfo.desCat.value == "L1" &&
                              DataInfo.tcId.value == "7" &&
                              data['SUPCNT'] == "Yes"
                          ? tileWidget(
                              name: "Visit Entry",
                              icon: data['SUPCNT'] == "Yes"
                                  ? checkStatus1
                                  : checkStatus2,
                              onPressed: () {
                                if (data['SUPCNT'] == 'Yes') {
                                  Get.dialog(Center(
                                    child: Card(
                                      child: Obx(() => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextWidget(
                                                "Call Status",
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
                                              ListTile(
                                                onTap: () {
                                                  controller.selectCallStatus
                                                      .value = "Approved";
                                                },
                                                title: TextWidget(
                                                  "Approved",
                                                  fontSize: 16,
                                                ),
                                                trailing: controller
                                                            .selectCallStatus
                                                            .value ==
                                                        "Approved"
                                                    ? const Icon(Icons.check)
                                                    : const SizedBox(),
                                              ),
                                              ListTile(
                                                  onTap: () {
                                                    controller.selectCallStatus
                                                        .value = "Rejected";
                                                  },
                                                  title: TextWidget(
                                                    "Rejected",
                                                    fontSize: 16,
                                                  ),
                                                  trailing: controller
                                                              .selectCallStatus
                                                              .value ==
                                                          "Rejected"
                                                      ? const Icon(Icons.check)
                                                      : const SizedBox()),
                                              10.heightBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        controller
                                                            .selectCallStatus
                                                            .value = "";
                                                        Get.back();
                                                      },
                                                      child: TextWidget(
                                                        "Cancel",
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  15.widthBox,
                                                  CustomButton(
                                                    text: "OK",
                                                    onPressed: () {
                                                      controller.statusUpdate(
                                                          data['ID']);

                                                      Get.back();
                                                    },
                                                    width: 120,
                                                    height: 40,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ).p8()),
                                    ).p8(),
                                  ));
                                } else {
                                  CustomWidgets.showDialogWidget(
                                      title: "Alert",
                                      content:
                                          "Sorry!! Visit entry is must to be approve call.Please add visit entry!");
                                }
                              })
                          : const SizedBox(),
                      DataInfo.desCat.value == "L1"
                          ? tileWidget(
                              name: "Notes",
                              icon: notesIcon1,
                              onPressed: () {
                                controller.visitEntry(data['ID']);
                                // await Future.delayed(const Duration(seconds: 2));
                              })
                          : const SizedBox(),

                      data['ISPIW'].toString() == "1"
                          ? InkWell(
                              onTap: () {
                                Get.to(() => const PiwForm(),
                                    arguments: {"id": data['ID'].toString()});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  //color: Colors.black,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextWidget(
                                  "PIW",
                                  color: Colors.black,
                                  fontSize: 12,
                                ).pSymmetric(h: 8.0, v: 4.0),
                              ).pOnly(left: 10.0,top: 10.0),
                            )
                          : const SizedBox(),
                    ],
                  )
                ],
              ).pSymmetric(h: 16, v: 10),
            ).p8(),
            // Container(
            //   width:Get.width,
            //
            //
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: const Color(0xffeaecf0), width: 1, ),
            //     color: Colors.white,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           TextWidget(
            //             data['CMP'],
            //
            //             color: appColor,
            //             fontSize: 18,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //           // TextWidget(
            //           //   data['STATUS'],
            //           //
            //           //   color: titleColor,
            //           //   fontSize: 14,
            //           //
            //           //   fontWeight: FontWeight.w500,
            //           //
            //           // ),
            //
            //         ],
            //       ),
            //       5.heightBox,
            //       Container(
            //         width: Get.width,
            //         height: 1.0,
            //         color: Colors.grey[300],
            //       ).pOnly(bottom: 10.0),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           TextWidget(
            //             data['CALLDATE'] +" "+ data['SHEDULE'],
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //           TextWidget(
            //             data['CALLTYPID'],
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //         ],
            //       ),
            //       10.heightBox,
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //
            //
            //         children: [
            //           TextWidget(
            //             "Contact Person",
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //           TextWidget(
            //             data['ACCOWNER'],
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //         ],
            //       ),
            //       10.heightBox,
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           TextWidget(
            //             "Call Approved Status",
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //           TextWidget(
            //             data['APRSTS'] == "NO" ? "Pending" : data['APRSTS'] == "REJECT" ? "Rejected" : "Approved",
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //         ],
            //       ),
            //       10.heightBox,
            //       Row(
            //
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           TextWidget(
            //             "Payment Collection",
            //
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //           TextWidget(
            //             data['CHKCOLL'],
            //             maxLines: 5,
            //             color: titleColor,
            //             fontSize: 14,
            //
            //             fontWeight: FontWeight.w500,
            //
            //           ),
            //         ],
            //       ),
            //       10.heightBox,
            //       Row(
            //
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //          Row(
            //            children: [
            //              Row(
            //                children: [
            //                  TextWidget(
            //                    "In - ",
            //
            //                    color: titleColor,
            //                    fontSize: 14,
            //
            //                    fontWeight: FontWeight.w500,
            //
            //                  ),
            //                  5.widthBox,
            //                  TextWidget(
            //                    data['CHKIN'],
            //                    maxLines: 5,
            //                    color: data['CHKIN'] != "0" ? Colors.green :
            //                    Colors.red,
            //                    fontSize: 14,
            //
            //                    fontWeight: FontWeight.w500,
            //
            //                  ),
            //                ],
            //              ),
            //              10.widthBox,
            //              Row(
            //                children: [
            //                  TextWidget(
            //                    "Out - ",
            //
            //                    color: titleColor,
            //                    fontSize: 14,
            //
            //                    fontWeight: FontWeight.w500,
            //
            //                  ),
            //                  5.widthBox,
            //                  TextWidget(
            //                    data['CHKOUT'],
            //                    maxLines: 5,
            //                    color: data['CHKOUT'] != "0" ? Colors.green :
            //                    Colors.red,
            //                    fontSize: 14,
            //
            //                    fontWeight: FontWeight.w500,
            //
            //                  ),
            //                ],
            //              ),
            //            ],
            //          ),
            //           Row(
            //             children: [
            //               Row(
            //                 children: [
            //                   TextWidget(
            //                     "SE - ",
            //
            //                     color: titleColor,
            //                     fontSize: 14,
            //
            //                     fontWeight: FontWeight.w500,
            //
            //                   ),
            //                   5.widthBox,
            //                   TextWidget(
            //                     data['SUPCNT'],
            //                     maxLines: 5,
            //                     color: data['SUPCNT'] == "Yes" ? Colors.green :
            //                     Colors.red,
            //                     fontSize: 14,
            //
            //                     fontWeight: FontWeight.w500,
            //
            //                   ),
            //                 ],
            //               ),
            //               10.widthBox,
            //               Row(
            //                 children: [
            //                   TextWidget(
            //                     "CE - ",
            //
            //                     color: titleColor,
            //                     fontSize: 14,
            //
            //                     fontWeight: FontWeight.w500,
            //
            //                   ),
            //                   5.widthBox,
            //                   TextWidget(
            //                     data['CONV'],
            //                     maxLines: 5,
            //                     color: data['CONV'] != "0" ? Colors.green :
            //                     Colors.red,
            //                     fontSize: 14,
            //
            //                     fontWeight: FontWeight.w500,
            //
            //                   ),
            //
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //       10.heightBox,
            //       Row(
            //         children: [
            //           iconWidget(iconData:Icons.phone,onPressed:  () {
            //             Utilities.onClickMobile(data['MOB']);
            //           }),
            //           iconWidget(iconData:Icons.message, onPressed: () => Utilities.onClickMessage(data['MOB'])),
            //           iconWidget(iconData:Icons.maps_ugc_outlined, onPressed: () => Utilities.onGoogleMap(data['LAT'],data['LONG'])),
            //           iconWidget(iconData:Icons.location_on_outlined, onPressed: () => data['CHKIN'] != "00" ?
            //           Get.dialog(Center(
            //             child: Card(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   TextWidget(data['CMP'],fontSize: 18,fontWeight: FontWeight.w700,
            //                   textAlign: TextAlign.center,).p8(),
            //                   10.heightBox,
            //                   TextWidget("Check In - ${data['CHKIN']}",fontSize: 16,fontWeight: FontWeight.w500,
            //                   textAlign: TextAlign.center,).p8(),
            //                   TextWidget(data['LOCTCHKIN'].toString(),fontSize: 16,fontWeight: FontWeight.w500,
            //                   color: Colors.lightGreen,
            //                     textAlign: TextAlign.center,
            //                   maxLines: 10,).p8(),
            //                   TextWidget("Check Out - ${data['CHKOUT']}",fontSize: 16,fontWeight: FontWeight.w500,
            //                     textAlign: TextAlign.center,).p8(),
            //                   TextWidget(data['LOCTCHKOUT'],fontSize: 16,fontWeight: FontWeight.w500,maxLines: 10,
            //                     textAlign: TextAlign.center,
            //                   color: Colors.orangeAccent,).p8(),
            //                   10.heightBox,
            //                   CustomButton(text: "OK",onPressed: (){Get.back();},
            //                   width: 80,
            //                   height: 40,)
            //
            //                 ],
            //               ).p8(),
            //             ).p8(),
            //           )) : null),
            //           DataInfo.rollId.value == "1" &&  (data['CHKIN'] == "00" || data['CHKOUT'] == "00")?
            //           iconWidget(iconData:Icons.edit, onPressed: () => Get.dialog(Center(
            //             child: Obx(()=>Card(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   TextWidget("Update check In/Out Time",fontSize: 18,fontWeight: FontWeight.w700,
            //                     textAlign: TextAlign.center,).p8(),
            //                   Container(
            //                     width: Get.width,
            //                     height: 1.0,
            //                     color: Colors.grey,
            //                   ),
            //                   10.heightBox,
            //                   data['CHKIN'] == "00" ?  Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //
            //                       TextWidget("Check In - ",fontSize: 16,fontWeight: FontWeight.w500,
            //                         textAlign: TextAlign.center,).p8(),
            //
            //                       TextWidget(Utilities.checkString(controller.selectCheckInTime.value) ? controller.selectCheckInTime.value : "__/__ ",fontSize: 16,fontWeight: FontWeight.w500,
            //                         textAlign: TextAlign.center,).p8(),
            //                       iconWidget(iconData: Icons.timer_outlined,onPressed: ()async{
            //                         TimeOfDay? selectTime = await  CustomWidgets.pickTime(Get.context!);
            //                         if(selectTime != null) {
            //                           controller.selectCheckInTime.value =  "${selectTime.hour.toString()}:${selectTime.minute.toString()}";
            //
            //                         }
            //                       }),
            //                     ],
            //                   ) : const SizedBox(),
            //                   10.heightBox,
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       TextWidget("Check Out - ",fontSize: 16,fontWeight: FontWeight.w500,
            //                         textAlign: TextAlign.center,).p8(),
            //
            //                       TextWidget(Utilities.checkString(controller.selectCheckOutTime.value) ?  controller.selectCheckOutTime.value : "__/__ ",fontSize: 16,fontWeight: FontWeight.w500,
            //                         textAlign: TextAlign.center,).p8(),
            //                       iconWidget(iconData: Icons.timer_outlined,onPressed: ()async{
            //                         TimeOfDay? selectTime = await  CustomWidgets.pickTime(Get.context!);
            //                         if(selectTime != null) {
            //                           controller.selectCheckOutTime.value =  "${selectTime.hour.toString()}:${selectTime.minute.toString()}";
            //
            //                         }
            //                       }),
            //                     ],
            //                   ),
            //                   10.heightBox,
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.end,
            //                     children: [
            //                       TextButton(onPressed: (){
            //
            //                         Get.back();
            //                       }, child: TextWidget("Cancel",fontSize: 16,
            //                         color:Colors.black,fontWeight: FontWeight.w500,)),
            //                       15.widthBox,
            //                       CustomButton(text: "SAVE",onPressed: ()async{
            //
            //                       if(Utilities.checkString(controller.selectCheckInTime.value) && Utilities.checkString(controller.selectCheckOutTime.value))
            //                         {
            //                           await controller.updateStatus(data, "1");
            //                           await controller.updateStatus(data, "2");
            //                           controller.selectCheckInTime.value = "";
            //                           controller.selectCheckOutTime.value = "";
            //                           Get.back();
            //                         }
            //                       else if(Utilities.checkString(controller.selectCheckInTime.value))
            //                         {
            //                           await controller.updateStatus(data, "1");
            //                           controller.selectCheckInTime.value = "";
            //                           Get.back();
            //                         }
            //                       else if(Utilities.checkString(controller.selectCheckOutTime.value))
            //                         {
            //                           await controller.updateStatus(data, "2");
            //                           controller.selectCheckOutTime.value = "";
            //                           Get.back();
            //                         }
            //                       else
            //                         {
            //                             if(!Utilities.checkString(controller.selectCheckInTime.value) && !Utilities.checkString(controller.selectCheckOutTime.value) && data['CHKIN'] == "00" && data['CHKOUT'] == "00")
            //                                       {
            //                                         CustomWidgets.snackBar(title: "Please select Check In and Check Out time.");
            //                                       }
            //                             else if(Utilities.checkString(controller.selectCheckInTime.value) && data['CHKIN'] == "00")
            //
            //                               {
            //                                 CustomWidgets.snackBar(title: "Please select Check In time.");
            //                               }
            //                             else
            //
            //                             {
            //                               CustomWidgets.snackBar(title: "Please select Check Out time.");
            //                             }
            //
            //                         }
            //
            //                         },
            //                         width: 120,
            //                         height: 35,)
            //                     ],
            //                   ),
            //
            //
            //                 ],
            //               ).p8(),
            //             ).pSymmetric(h: 20,v: 8)),
            //           ))) : const SizedBox(),
            //          DataInfo.rollId.value == "1" && DataInfo.desCat.value == "L1" ?
            //          iconWidget(iconData: Icons.check_circle_outline,
            //                  color: data['SUPCNT'] == "Yes" ? Colors.green :
            //                  Colors.red,
            //                  onPressed: () => data['SUPCNT']  == 'Yes' ?
            //                  Get.dialog(Center(
            //             child: Card(
            //               child: Obx(()=>Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   TextWidget("Call Status",fontSize: 18,fontWeight: FontWeight.w700,
            //                     textAlign: TextAlign.center,).p8(),
            //                   Container(
            //                     width: Get.width,
            //                     height: 1.0,
            //                     color: Colors.grey[400],
            //                   ),
            //                   10.heightBox,
            //                   ListTile(
            //                     onTap: (){
            //                       controller.selectCallStatus.value = "Approved";
            //                     },
            //                     title: TextWidget("Approved",fontSize: 16,
            //                   ),
            //                     trailing: controller.selectCallStatus.value == "Approved" ?
            //                     Icon(Icons.check) : SizedBox(),),
            //                   ListTile(
            //                       onTap: (){
            //                         controller.selectCallStatus.value = "Rejected";
            //                       },
            //                       title: TextWidget("Rejected",fontSize: 16,),trailing: controller.selectCallStatus.value == "Rejected" ?
            //                   Icon(Icons.check) : SizedBox()),
            //                   10.heightBox,
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.end,
            //                     children: [
            //                       TextButton(onPressed: (){
            //                         controller.selectCallStatus.value = "";
            //                         Get.back();
            //                       }, child: TextWidget("Cancel",fontSize: 16,
            //                         color:Colors.black,fontWeight: FontWeight.w500,)),
            //                       15.widthBox,
            //                       CustomButton(text: "OK",onPressed: (){
            //                         controller.statusUpdate(data['ID']);
            //
            //                         Get.back();},
            //                       width: 120,
            //                       height: 40,)
            //                     ],
            //                   ),
            //
            //                 ],
            //               ).p8()),
            //             ).p8(),
            //           )) : CustomWidgets.showDialog(title: "Alert",
            //                  content: "Sorry!! Visit entry is must to be approve call.Please add visit entry!")) : const SizedBox(),
            //           DataInfo.desCat.value == "L1" ?
            //           iconWidget(iconData:Icons.insert_drive_file_outlined, onPressed: () {
            //             controller.visitEntry(data['ID']);
            //             Get.dialog(Center(
            //               child: Card(
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     TextWidget("Visit Entry Description",fontSize: 18,fontWeight: FontWeight.w700,
            //                       textAlign: TextAlign.center,).p8(),
            //                     Container(
            //                       width: Get.width,
            //                       height: 1.0,
            //                       color: Colors.grey[400],
            //                     ),
            //                     10.heightBox,
            //                     TextWidget(data['SPNOTE'].toString(),fontSize: 16,maxLines: 10,),
            //                     10.heightBox,
            //                     CustomButton(text: "OK",onPressed: (){
            //
            //
            //                       Get.back();},  width: 120,
            //                       height: 40,)
            //
            //                   ],
            //                 ).p8(),
            //               ).p8(),
            //             ));
            //           }) : const SizedBox(),
            //           //iconWidget(iconData:Icons.description, onPressed: () => null),
            //
            //         ],
            //       ),
            //
            //
            //
            //     ],
            //   ).p16(),
            // ).p8(),
          ],
        ),
      );
    });
  }
}

Widget tileWidget({String? name, String? icon, Function()? onPressed}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: CustomWidgets.showImage(path: icon!),
    ).pSymmetric(v: 4.0),
    // Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(4),
    //     border: Border.all(color: const Color(0xffd0d5dd), width: 1, ),
    //   ),
    //   padding: const EdgeInsets.all(8),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children:[
    //       CustomWidgets.showImage(path: icon!),
    //       5.widthBox,
    //       TextWidget(
    //         name,
    //         color: const Color(0xff191d23),
    //         fontSize: 15,
    //       ),
    //     ],
    //   ),
    // ).pSymmetric(v: 4.0),
  );
}

Widget iconWidget(
    {final iconData, Function()? onPressed, Color color = Colors.black}) {
  return SizedBox(
      width: 40,
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 18,
            color: color,
          )));
}
