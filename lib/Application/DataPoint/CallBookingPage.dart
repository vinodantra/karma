// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:karma/Constants/Library.dart';

import 'package:intl/intl.dart';

class CallBookingPage extends GetView<CallBookingController> {
  const CallBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CallBookingController());
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        appBar: AppBarWidget(
          title: controller.data['DPNAME'],

          /* onSubmit: (){
          controller.checkData();
        },*/
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white,
            child: Obx(() => Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.pageController.jumpToPage(0);
                              },
                              child: ColoredBox(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    controller.step1.value
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                  colors: Provider.of<
                                                              AppThemeController>(
                                                          context)
                                                      .appGradientColor),
                                            ),
                                            child: const Center(
                                                child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )),
                                          )
                                        : Container(
                                            width: 24,
                                            height: 24,
                                            decoration:
                                                controller.currentPage.value ==
                                                        0
                                                    ? BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                            colors: Provider.of<
                                                                        AppThemeController>(
                                                                    context)
                                                                .appGradientColor),
                                                      )
                                                    : BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: greyColor)),
                                            child: Center(
                                                child: controller.currentPage
                                                            .value ==
                                                        0
                                                    ? TextWidget(
                                                        "1",
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )
                                                    : TextWidget(
                                                        "1",
                                                        color: greyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                          ),
                                    5.heightBox,
                                    controller.currentPage.value == 0
                                        ? GradientTextWidget(
                                            "Step 1",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : TextWidget(
                                            "Step 1",
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )
                                  ],
                                ),
                              ),
                            ),
                            GradientTextWidget("-----"),
                            InkWell(
                              onTap: () {
                                controller.clickStep1();
                              },
                              child: ColoredBox(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    controller.step2.value
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                  colors: Provider.of<
                                                              AppThemeController>(
                                                          context)
                                                      .appGradientColor),
                                            ),
                                            child: const Center(
                                                child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )),
                                          )
                                        : Container(
                                            width: 24,
                                            height: 24,
                                            decoration:
                                                controller.currentPage.value ==
                                                        1
                                                    ? BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                            colors: Provider.of<
                                                                        AppThemeController>(
                                                                    context)
                                                                .appGradientColor),
                                                      )
                                                    : BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: greyColor)),
                                            child: Center(
                                                child: controller.currentPage
                                                            .value ==
                                                        1
                                                    ? TextWidget(
                                                        "2",
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )
                                                    : TextWidget(
                                                        "2",
                                                        color: greyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                          ),
                                    5.heightBox,
                                    controller.currentPage.value == 1
                                        ? GradientTextWidget(
                                            "Step 2",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : TextWidget(
                                            "Step 2",
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )
                                  ],
                                ),
                              ),
                            ),
                            GradientTextWidget("-----"),
                            InkWell(
                              onTap: () {
                                controller.clickStep2();
                              },
                              child: ColoredBox(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration:
                                          controller.currentPage.value == 2
                                              ? BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                      colors: Provider.of<
                                                                  AppThemeController>(
                                                              context)
                                                          .appGradientColor),
                                                )
                                              : BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: greyColor)),
                                      child: Center(
                                          child: controller.currentPage.value ==
                                                  2
                                              ? TextWidget(
                                                  "3",
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                )
                                              : TextWidget(
                                                  "3",
                                                  color: greyColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                    ),
                                    5.heightBox,
                                    controller.currentPage.value == 2
                                        ? GradientTextWidget(
                                            "Step 3",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : TextWidget(
                                            "Step 3",
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ).pSymmetric(h: 10.0, v: 20.0),
                        10.heightBox,
                        const ShowPage(),
                      ],
                    ).p16(),
                    controller.isLoading.value
                        ? const LoadingScreen()
                        : const SizedBox()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class ShowPage extends GetView<CallBookingController> {
  const ShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallBookingController>(
        builder: (controller1) => Expanded(
              child: PageView.builder(
                itemCount: 3,
                controller: controller.pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, int index) {
                  return Obx(() => SizedBox(
                        width: Get.width,
                        height: Get.height,
                        child: index == 0
                            ? ListView(
                                children: [
                                  selectItem(
                                    title: Utilities.checkString(
                                            controller.currentDate.value)
                                        ? controller.currentDate.value
                                        : "",
                                    label: "Call Date",
                                    icon: CustomWidgets.showAssetImage1(
                                        path: calendar),
                                    onPressed: () async {
                                      var de =
                                          await CustomWidgets.pickDate(context);
                                      if (de != null) {
                                        controller.selectDate.value =
                                            de.toString();

                                        controller.currentDate.value =
                                            DateFormat('dd-MM-yyyy').format(de);
                                      }
                                    },
                                  ),
                                  10.heightBox,
                                  selectItem(
                                      title: controller.currentTime.value,
                                      label: "Call Time",
                                      icon: CustomWidgets.showAssetImage1(
                                          path: calendar),
                                      onPressed: () async {
                                        TimeOfDay? selectTime =
                                            await CustomWidgets.pickTime(
                                                context);
                                        if (selectTime != null) {
                                          controller.selectTime.value =
                                              selectTime
                                                  .format(context)
                                                  .toString();
                                          controller.currentTime.value =
                                              selectTime
                                                  .format(context)
                                                  .toString();
                                        }
                                      }),
                                  10.heightBox,
                                  selectItem(
                                      title: Utilities.checkString(
                                              controller.selectCallType.value)
                                          ? controller.selectCallType.value
                                          : "",
                                      label: "Type of Call",
                                      onPressed: () {
                                        CustomWidgets.customBottomSheet(
                                            controller.callTypeList,
                                            "NAME",
                                            false, (data) {
                                          controller.selectCallType.value =
                                              data['NAME'];
                                          controller.selectCallTypeId.value =
                                              data['ID'];
                                          Get.back();
                                        });
                                      }),
                                  10.heightBox,
                                  selectItem(
                                      title: Utilities.checkString(
                                              controller.selectNoc.value)
                                          ? controller.selectNoc.value
                                          : "",
                                      label: "Nature of Call",
                                      onPressed: () {
                                        CustomWidgets.customBottomSheet(
                                            controller.fNatureOfCall,
                                            "NAME",
                                            true, (data) {
                                          controller.selectNoc.value =
                                              data['NAME'];
                                          controller.selectNocId.value =
                                              data['ID'];
                                          Get.back();
                                        });
                                      }),
                                  10.heightBox,
                                  selectItem(
                                      title: Utilities.checkString(
                                              controller.selectManager.value)
                                          ? controller.selectManager.value
                                          : "",
                                      label: "Allocation Manager",
                                      onPressed: () {
                                        CustomWidgets.customBottomSheet(
                                            controller.allocationManagerList,
                                            "NAME",
                                            false, (data) {
                                          controller.selectManager.value =
                                              data['NAME'];
                                          controller.selectManagerId.value =
                                              data['ID'].toString();
                                          if (controller
                                                  .selectManagerId.value ==
                                              "1") {
                                            if (controller
                                                .remarkController1.text
                                                .trim()
                                                .isNotEmpty) {
                                              controller
                                                  .remarkController1.text = "";
                                            }
                                          }

                                          // controller.selectUser.value = "Select";
                                          Get.back();
                                        });
                                      }),
                                  10.heightBox,
                                  button(),
                                ],
                              )
                            : index == 1
                                ? ListView(
                                    children: [
                                      controller.selectManager.value == "Sales"
                                          ? selectItem(
                                              title: Utilities.checkString(
                                                      controller
                                                          .selectUser.value)
                                                  ? controller.selectUser.value
                                                  : "",
                                              label: "User",
                                              onPressed: () {
                                                CustomWidgets.customBottomSheet(
                                                    controller.flUsersList,
                                                    "NAME",
                                                    true, (data) {
                                                  controller.selectUser.value =
                                                      data['NAME'];
                                                  controller
                                                          .selectUserId.value =
                                                      data['ID'].toString();
                                                  Get.back();
                                                });
                                              })
                                          : const SizedBox(),
                                      10.heightBox,
                                      selectItem(
                                          title: Utilities.checkString(
                                                  controller
                                                      .selectSupType.value)
                                              ? controller.selectSupType.value
                                              : "",
                                          label: "Support Type",
                                          onPressed: () {
                                            CustomWidgets.customBottomSheet(
                                                controller.supTypeList,
                                                "NAME",
                                                true, (data) {
                                              controller.selectSupType.value =
                                                  data['NAME'];
                                              controller.selectSupTypeId.value =
                                                  data['ID'];
                                              Get.back();
                                            });
                                          }),
                                      10.heightBox,
                                      selectItem(
                                          title: controller.selectAddress.value,
                                          label: "Location",
                                          onPressed: () {
                                            CustomWidgets.customBottomSheet(
                                                controller.addressList,
                                                "NAME",
                                                true, (data) {
                                              
                                              controller.selectAddress.value =
                                                  data['NAME'];
                                              controller.addressDetails.value =
                                                  data['ADD'];
                                              controller.selectPhone.value =
                                                  data['PHONE'];
                                              controller.selectRegion.value =
                                                  data['CITY'];
                                              Get.back();
                                            });
                                          }),
                                      10.heightBox,
                                      controller.selectPhone.value.isNotEmpty
                                          ? Column(
                                              children: [
                                                selectItem(
                                                    title: controller
                                                        .selectPhone.value,
                                                    label: "Phone",
                                                    onPressed: () {},
                                                    icon: const SizedBox()),
                                                10.heightBox,
                                              ],
                                            )
                                          : const SizedBox(),
                                      controller.addressDetails.value.isNotEmpty
                                          ? Column(
                                              children: [
                                                selectItem(
                                                    title: controller
                                                        .addressDetails.value,
                                                    label: "Address",
                                                    onPressed: () {},
                                                    icon: const SizedBox()),
                                                10.heightBox,
                                              ],
                                            )
                                          : const SizedBox(),
                                      controller.selectRegion.value.isNotEmpty
                                          ? Column(
                                              children: [
                                                selectItem(
                                                    title: controller
                                                        .selectRegion.value,
                                                    label: "Region",
                                                    onPressed: () {},
                                                    icon: const SizedBox()),
                                                10.heightBox,
                                              ],
                                            )
                                          : const SizedBox(),
                                      selectItem(
                                          title:
                                              controller.selectTallySrNo.value,
                                          label: "Tally Serial",
                                          onPressed: () {
                                            CustomWidgets.customBottomSheet(
                                                controller.tallySrNo,
                                                "NAME",
                                                true, (data) {
                                              controller.selectTallySrNo.value =
                                                  data['NAME'];
                                              Get.back();
                                            });
                                          }),
                                      10.heightBox,
                                      button(),
                                    ],
                                  )
                                : ListView(
                                    children: [
                                      selectItem(
                                          title: Utilities.checkString(
                                                  controller1
                                                      .selectContact.value)
                                              ? controller1.selectContact.value
                                              : "",
                                          label: "Contact Person",
                                          onPressed: () {
                                            CustomWidgets.customBottomSheet(
                                                controller1.contactList,
                                                "CNTNAME",
                                                true, (data) {
                                              controller1.selectContact.value =
                                                  data['CNTNAME'];
                                              controller1.selectContactEmail
                                                  .value = data['EMAIL'];
                                              controller1.selectContactMobile
                                                  .value = data['MOBILE'];
                                              controller1.selectContactId
                                                  .value = data['CNTID'];
                                              Get.back();
                                            });
                                          }),
                                      10.heightBox,
                                      controller1.selectContactEmail.value
                                              .isNotEmpty
                                          ? Column(
                                              children: [
                                                selectItem(
                                                    title: controller
                                                        .selectContactEmail
                                                        .value,
                                                    label: "E-mail",
                                                    onPressed: () {},
                                                    icon: const SizedBox()),
                                                10.heightBox,
                                              ],
                                            )
                                          : const SizedBox(),
                                      controller.selectContactMobile.value
                                              .isNotEmpty
                                          ? Column(
                                              children: [
                                                selectItem(
                                                    title: controller
                                                        .selectContactMobile
                                                        .value,
                                                    label: "Mobile No",
                                                    onPressed: () {},
                                                    icon: const SizedBox()),
                                                10.heightBox,
                                              ],
                                            )
                                          : const SizedBox(),
                                      InkWell(
                                        onTap: () {
                                          if (controller.selectCheckCollection
                                                  .value ==
                                              2) {
                                            controller.selectCheckCollection
                                                .value = 1;
                                          } else {
                                            controller.selectCheckCollection
                                                .value = 2;
                                          }
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            border: controller
                                                        .selectCheckCollection
                                                        .value ==
                                                    1
                                                ? GradientBoxBorder(
                                                    gradient: LinearGradient(
                                                        colors: Provider.of<
                                                                    AppThemeController>(
                                                                context)
                                                            .appGradientColor),
                                                    width: 1.0,
                                                  )
                                                : Border.all(
                                                    width: 0.50,
                                                    color: const Color(
                                                        0xFFDFDFDF)),
                                            // border: Border.all(width: 0.50, color: dividerColor),
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                "Cheque Collection",
                                                color: darkTextColor,
                                                fontSize: 16,
                                              ),
                                              controller.selectCheckCollection
                                                          .value ==
                                                      1
                                                  ? CustomWidgets
                                                      .showAssetImage(
                                                          path: select)
                                                  : const SizedBox(),
                                            ],
                                          ).pSymmetric(h: 25.0),
                                        ),
                                      ),
                                      10.heightBox,
                                      commentField(
                                          controller:
                                              controller1.remarkController,
                                          onChanged: controller.updateData1,
                                          hintText: "Remark for customer"),
                                      controller.remarkController.text
                                                  .isNotEmpty &&
                                              controller.remarkController.text
                                                      .trim()
                                                      .length >=
                                                  15
                                          ? SizedBox(
                                              width: context.screenWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  controller.message1.value
                                                          .isNotEmpty
                                                      ? CustomButton(
                                                          text:
                                                              "Previous Remark",
                                                          onPressed: () {
                                                            controller
                                                                .selectData();
                                                          },
                                                          width: 175,
                                                          height: 35,
                                                        )
                                                      : const SizedBox(),
                                                  CustomButton(
                                                    text: "Enhance Text ",
                                                    onPressed: () {
                                                      controller
                                                          .getChatGptData();
                                                    },
                                                    width: 175,
                                                    height: 35,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      10.heightBox,
                                      controller1.selectManagerId.value == "1"
                                          ? commentField(
                                              controller:
                                                  controller1.remarkController1,
                                              onChanged: controller.updateData2,
                                              hintText:
                                                  "Remark for Support Executive",
                                              focusNode: controller1.focusNode)
                                          : const SizedBox(),
                                      controller.remarkController1.text
                                                  .isNotEmpty &&
                                              controller.remarkController1.text
                                                      .trim()
                                                      .length >=
                                                  15
                                          ? SizedBox(
                                              width: context.screenWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  controller.remarkMessage1
                                                          .value.isNotEmpty
                                                      ? CustomButton(
                                                          text:
                                                              "Previous Remark",
                                                          onPressed: () {
                                                            controller
                                                                .selectData2();
                                                          },
                                                          width: 175,
                                                          height: 35,
                                                        )
                                                      : const SizedBox(),
                                                  CustomButton(
                                                    text: "Enhance Text ",
                                                    onPressed: () {
                                                      controller
                                                          .getChatGptData1();
                                                    },
                                                    width: 175,
                                                    height: 35,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      10.heightBox,
                                      button(),
                                    ],
                                  ),
                      ));
                },
                onPageChanged: (value) {
                  controller.currentPage.value = value;
                },
              ).h(context.screenHeight * 0.65),
            ));
  }

  Widget button() {
    return CustomButton(
      text: controller.currentPage.value == 0
          ? "Proceed to Step 2"
          : controller.currentPage.value == 1
              ? "Proceed to last step"
              : "Done",
      width: Get.width,
      onPressed: () {
        if (controller.currentPage.value == 0) {
          controller.checkStep1();
        } else if (controller.currentPage.value == 1) {
          controller.checkStep2();
        } else {
          controller.checkData();
        }
      },
    );
  }
}
