// ignore_for_file: file_names

import 'package:karma/Application/data_scope/data_scope.dart';
import 'package:karma/Application/epicenter/epicenter_screen.dart';
import 'package:karma/Constants/Library.dart';

class DataPointInfo extends GetView<DataPointInfoController> {
  const DataPointInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DataPointInfoController());
    return PopScope(
      canPop: true,
      // onPopInvokedWithResult: (didPop, result) {
      //   Get.back();
      // },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Obx(
              () => AppBarWidget(
                title: controller.isLoading.value == false
                    ? Utilities.checkString(
                            controller.data['DPNAME'].toString())
                        ? controller.data['DPNAME'].toString()
                        : controller.info['NAME'].toString()
                    : "",
                onBackPress: () {
                  Get.back();
                  // Get.off(()=> const DataPoints());
                },
              ),
            )),
        body: SizedBox(
            width: context.screenWidth,
            height: context.screenHeight,
            child: Obx(() => Stack(
                  children: [
                    !controller.isLoading.value
                        ? ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              checkData1()
                                  ? Container(
                                      width: context.screenWidth,
                                      decoration: decoration(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              10.widthBox,
                                              Utilities.checkString(controller
                                                      .info['CONTNAME1']
                                                      .toString())
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextWidget(
                                                          controller
                                                              .info['CONTNAME1']
                                                              .toString(),
                                                          color: titleColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        TextWidget(
                                                          controller
                                                              .info['CONTDESG1']
                                                              .toString(),
                                                          color: const Color(
                                                              0xFF667084),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          10.heightBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Utilities.checkString(controller
                                                      .info['CONTMOB1']
                                                      .toString())
                                                  ? Expanded(
                                                      child: Container(
                                                        decoration: decoration2(
                                                                context)
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                        child: Row(
                                                          //mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomWidgets
                                                                .showImage(
                                                              path: callIcon1,
                                                              color: Provider.of<
                                                                          AppThemeController>(
                                                                      Get.context!)
                                                                  .appColor,
                                                            ),
                                                            5.widthBox,
                                                            GradientTextWidget(
                                                              "Call",
                                                              fontSize: 12,
                                                            ),
                                                          ],
                                                        ).pSymmetric(
                                                            h: 15.0, v: 8.0),
                                                      ).onTap(() {
                                                        Utilities.onClickMobile(
                                                            controller.info[
                                                                'CONTMOB1']);
                                                      }),
                                                    )
                                                  : const SizedBox(),
                                              10.widthBox,
                                              Utilities.checkString(controller
                                                      .info['CONTEMAIL1']
                                                      .toString())
                                                  ? Expanded(
                                                      child: Container(
                                                        decoration: decoration2(
                                                                context)
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomWidgets
                                                                .showImage(
                                                              path: emailIcon,
                                                              color: Provider.of<
                                                                          AppThemeController>(
                                                                      context)
                                                                  .appColor,
                                                            ),
                                                            5.widthBox,
                                                            GradientTextWidget(
                                                              "Email",
                                                              fontSize: 12,
                                                            ),
                                                          ],
                                                        ).pSymmetric(
                                                            h: 15.0, v: 8.0),
                                                      ).onTap(() {
                                                        Utilities.onClickEmail(
                                                            controller.info[
                                                                'CONTEMAIL1']);
                                                      }),
                                                    )
                                                  : const SizedBox(),
                                              10.widthBox,
                                              Utilities.checkString(controller
                                                      .info['WEBSITE']
                                                      .toString())
                                                  ? Expanded(
                                                      child: Container(
                                                        decoration: decoration2(
                                                                context)
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomWidgets
                                                                .showImage(
                                                              path: websiteIcon,
                                                              color: Provider.of<
                                                                          AppThemeController>(
                                                                      Get.context!)
                                                                  .appColor,
                                                            ),
                                                            5.widthBox,
                                                            GradientTextWidget(
                                                              "Website",
                                                              fontSize: 12,
                                                            ),
                                                          ],
                                                        ).pSymmetric(
                                                            h: 10.0, v: 8.0),
                                                      ).onTap(() {
                                                        Utilities.onClickLink(
                                                            controller
                                                                .info['WEBSITE']
                                                                .toString()
                                                                .trim());
                                                      }),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ).p16(),
                                    )
                                  : const SizedBox(),
                              10.heightBox,
                              ColoredBox(
                                color: Colors.white,
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    contentWidget(
                                        text: "Address Details",
                                        context: context,
                                        image: address,
                                        onPressed: () {
                                          customBottomSheet(
                                              title: "Address Details",
                                              widget: Container(
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        context.screenHeight /
                                                            1.5),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: controller
                                                        .addressList.length,
                                                    itemBuilder:
                                                        (context, int index) {
                                                      return Container(
                                                        width:
                                                            context.screenWidth,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 0.50,
                                                                color: Color(
                                                                    0xFFDFDFDF)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          shadows: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0x14919191),
                                                              blurRadius: 12,
                                                              offset:
                                                                  Offset(0, 2),
                                                              spreadRadius: 0,
                                                            )
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            //controller.info.toString().text.make(),
                                                            TextWidget(
                                                              controller
                                                                  .addressList[
                                                                      index]
                                                                      ['NAME']
                                                                  .toString(),
                                                              color: const Color(
                                                                  0xFF282828),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              maxLines: 20,
                                                            ),
                                                            10.heightBox,
                                                            TextWidget(
                                                              'Phone Number',
                                                              color: const Color(
                                                                  0xFF7D8493),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            5.heightBox,
                                                            TextWidget(
                                                              "${controller.addressList[index]['PHONE']}",
                                                              fontSize: 14,
                                                              color: const Color(
                                                                  0xFF282828),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            10.heightBox,
                                                            TextWidget(
                                                              'Location',
                                                              color: const Color(
                                                                  0xFF7D8493),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            5.heightBox,
                                                            SizedBox(
                                                              width: context
                                                                  .screenWidth,
                                                              child: TextWidget(
                                                                controller
                                                                    .addressList[
                                                                        index]
                                                                        ['ADD']
                                                                    .toString()
                                                                    .trim(),
                                                                fontSize: 14,
                                                                color: const Color(
                                                                    0xFF282828),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                maxLines: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        ).p16(),
                                                      ).pSymmetric(v: 5.0);
                                                    }),
                                              ));
                                          // Get.to(()=> const AddressDetails(),arguments: controller.info);
                                        }),
                                    contentWidget(
                                        text: "Call Booking",
                                        context: context,
                                        image: callBooking1,
                                        onPressed: () {
                                          Get.to(() => const CallBookingPage(),
                                                  arguments: controller.data)!
                                              .then((value) =>
                                                  controller.onInit());
                                        }),
                                    contentWidget(
                                        text: "Contact Details",
                                        context: context,
                                        image: contactDetails,
                                        onPressed: () {
                                          Get.to(() => const ContactDetails(),
                                              arguments: controller.data);
                                        }),
                                    contentWidget(
                                        text: "Data Scope",
                                        context: context,
                                        image: dataPoint1,
                                        onPressed: () {
                                          Get.to(
                                            () => const DataScope(),
                                          );
                                        }),
                                    contentWidget(
                                        text: "Epicenter",
                                        context: context,
                                        image: epicenter1,
                                        onPressed: () {
                                          Get.to(
                                            () => const EpicenterScreen(),
                                          );
                                        }),
                                    contentWidget(
                                        text: "FT History",
                                        context: context,
                                        image: visitHistory,
                                        onPressed: () {
                                          Get.to(() => const VisitHistory(),
                                              arguments: controller.data);
                                        }),
                                    contentWidget(
                                        text: "Live Products",
                                        context: context,
                                        image: product,
                                        onPressed: () {
                                          Get.to(
                                              () => const ProductAndServices(),
                                              arguments: controller.data);
                                        }),
                                    contentWidget(
                                        text: "MainBrochure",
                                        context: context,
                                        image: mailBrochure,
                                        onPressed: () {
                                          customBottomSheet(
                                              title: "MainBrochure",
                                              widget: Obx(() => Container(
                                                  width: context.screenWidth,
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 500),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          controller
                                                                  .showBrochure
                                                                  .value =
                                                              !controller
                                                                  .showBrochure
                                                                  .value;
                                                          controller.showEmail
                                                              .value = false;
                                                        },
                                                        child: Container(
                                                          width: context
                                                              .screenWidth,
                                                          height: 50,
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                  width: 0.50,
                                                                  color: Color(
                                                                      0xFFDFDFDF)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            shadows: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x14919191),
                                                                blurRadius: 12,
                                                                offset: Offset(
                                                                    0, 2),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              TextWidget(
                                                                Utilities.checkString(
                                                                        controller
                                                                            .selectBrochure
                                                                            .value)
                                                                    ? controller
                                                                        .selectBrochure
                                                                        .value
                                                                    : 'Brochure',
                                                                color: const Color(
                                                                    0xFF282828),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              Icon(
                                                                controller
                                                                        .showBrochure
                                                                        .value
                                                                    ? Icons
                                                                        .keyboard_arrow_up_outlined
                                                                    : Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                color: const Color(
                                                                    0xFF4A4A4A),
                                                              ),
                                                            ],
                                                          ).pSymmetric(h: 10.0),
                                                        ),
                                                      ),
                                                      5.heightBox,
                                                      controller.showBrochure
                                                              .value
                                                          ? Expanded(
                                                              child: Container(
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: const BorderSide(
                                                                          width:
                                                                              0.50,
                                                                          color:
                                                                              dividerColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    shadows: const [
                                                                      BoxShadow(
                                                                        color: Color(
                                                                            0x14919191),
                                                                        blurRadius:
                                                                            12,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                        spreadRadius:
                                                                            0,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Scrollbar(
                                                                    child: ListView.separated(
                                                                            itemBuilder: (context, int index) {
                                                                              return ListTile(
                                                                                onTap: () {
                                                                                  controller.showBrochure.value = false;
                                                                                  controller.selectBrochure.value = controller.brochureList[index]['NAME'];
                                                                                  controller.selectBrochureId.value = controller.brochureList[index]['ID'].toString();
                                                                                },
                                                                                minLeadingWidth: 1.0,
                                                                                title: TextWidget(
                                                                                  controller.brochureList[index]['NAME'],
                                                                                  color: blackColor,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              );
                                                                            },
                                                                            separatorBuilder: (context, int index) {
                                                                              return CustomWidgets.divider();
                                                                            },
                                                                            itemCount: controller.brochureList.length)
                                                                        .p16(),
                                                                  )),
                                                            )
                                                          : const SizedBox(),
                                                      10.heightBox,
                                                      InkWell(
                                                        onTap: () {
                                                          controller
                                                              .showBrochure
                                                              .value = false;
                                                          controller.showEmail
                                                                  .value =
                                                              !controller
                                                                  .showEmail
                                                                  .value;
                                                        },
                                                        child: Container(
                                                          width: context
                                                              .screenWidth,
                                                          height: 50,
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                  width: 0.50,
                                                                  color: Color(
                                                                      0xFFDFDFDF)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            shadows: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x14919191),
                                                                blurRadius: 12,
                                                                offset: Offset(
                                                                    0, 2),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              TextWidget(
                                                                Utilities.checkString(
                                                                        controller
                                                                            .selectEmail
                                                                            .value)
                                                                    ? controller
                                                                        .selectEmail
                                                                        .value
                                                                    : 'Email',
                                                                color: const Color(
                                                                    0xFF282828),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              Icon(
                                                                controller
                                                                        .showEmail
                                                                        .value
                                                                    ? Icons
                                                                        .keyboard_arrow_up_outlined
                                                                    : Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                color: const Color(
                                                                    0xFF4A4A4A),
                                                              ),
                                                            ],
                                                          ).pSymmetric(h: 10.0),
                                                        ),
                                                      ),
                                                      5.heightBox,
                                                      controller.showEmail.value
                                                          ? Expanded(
                                                              child: Container(
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: const BorderSide(
                                                                          width:
                                                                              0.50,
                                                                          color:
                                                                              dividerColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    shadows: const [
                                                                      BoxShadow(
                                                                        color: Color(
                                                                            0x14919191),
                                                                        blurRadius:
                                                                            12,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                        spreadRadius:
                                                                            0,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Scrollbar(
                                                                    child: ListView.separated(
                                                                            itemBuilder: (context, int index) {
                                                                              return ListTile(
                                                                                onTap: () {
                                                                                  controller.showEmail.value = false;
                                                                                  controller.selectEmail.value = controller.emailList[index]['Name'];
                                                                                  controller.selectCntName.value = controller.emailList[index]['CNTNAME'];
                                                                                },
                                                                                minLeadingWidth: 1.0,
                                                                                title: TextWidget(
                                                                                  controller.emailList[index]['Name'],
                                                                                  color: blackColor,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              );
                                                                            },
                                                                            separatorBuilder: (context, int index) {
                                                                              return CustomWidgets.divider();
                                                                            },
                                                                            itemCount: controller.emailList.length)
                                                                        .p16(),
                                                                  )),
                                                            )
                                                          : const SizedBox(),
                                                      10.heightBox,
                                                      CustomButton(
                                                        text: "Send",
                                                        width:
                                                            context.screenWidth,
                                                        onPressed: () {
                                                          if (controller
                                                                  .selectBrochure
                                                                  .value
                                                                  .isEmpty ||
                                                              controller
                                                                      .selectBrochure
                                                                      .value ==
                                                                  "Select") {
                                                            VxToast.show(
                                                                context,
                                                                bgColor: Colors
                                                                    .black,
                                                                msg:
                                                                    "Please select Brochure",
                                                                textColor:
                                                                    Colors
                                                                        .white);
                                                            //CustomWidgets.snackBar(title: "Please select Brochure");
                                                          } else if (controller
                                                                  .selectEmail
                                                                  .value
                                                                  .isEmpty ||
                                                              controller
                                                                      .selectEmail
                                                                      .value ==
                                                                  "Select") {
                                                            VxToast.show(
                                                                context,
                                                                bgColor: Colors
                                                                    .black,
                                                                msg:
                                                                    "Please select Email",
                                                                textColor:
                                                                    Colors
                                                                        .white);
                                                            // CustomWidgets.snackBar(title: "Please select Email");
                                                          } else {
                                                            controller
                                                                .sendData();
                                                            Get.back();
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ))));
                                        }),
                                    contentWidget(
                                        text: "Opportunity",
                                        context: context,
                                        image: opportunity1,
                                        onPressed: () {
                                          Get.to(
                                              () => const OpportunityDetails(),
                                              arguments: controller.data);
                                        }),
                                    contentWidget(
                                        text: "Recent Activity",
                                        context: context,
                                        image: recentActivity,
                                        onPressed: () {
                                          Get.to(() => const RecentActivity(),
                                              arguments: controller.data);
                                        }),
                                    contentWidget(
                                        text: "Tally Serial Number",
                                        context: context,
                                        image: tallySerialNumber,
                                        onPressed: () {
                                          Get.to(() => const TallySerial(),
                                              arguments: controller.data);
                                        }),
                                    contentWidget(
                                        text: "Tickets",
                                        context: context,
                                        image: tickets1,
                                        onPressed: () {
                                          DataInfo.dpId.value = controller
                                              .data['DPID']
                                              .toString();
                                          DataInfo.dpName.value = controller
                                              .data['DPNAME']
                                              .toString();
                                          Get.to(() => const Tickets(),
                                              arguments: controller.data);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ).p16().animate().fade(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn)
                        : const SizedBox(),
                    controller.isLoading.value
                        ? const LoadingScreen()
                        : const SizedBox(),
                  ],
                ))),
      ),
    );
  }

  bool checkData1() {
    return Utilities.checkString(controller.info['CONTNAME1'].toString()) ||
            Utilities.checkString(controller.info['CONTDESG1'].toString())
        ? true
        : false;
  }

  Widget contentWidget(
      {required String text,
      required BuildContext context,
      String? image = "datapoint",
      Function()? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: context.screenWidth / 2.3,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x3F919191),
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: CustomWidgets.showAssetImage(
                path: image!,
                width: 25,
                height: 25,
              ),
            ),
            10.heightBox,
            FittedBox(
              child: TextWidget(
                text,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ).pSymmetric(h: 10.0),
      ).pSymmetric(v: 5.0),
    );
  }
}
