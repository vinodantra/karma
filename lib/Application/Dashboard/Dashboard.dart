// ignore_for_file: file_names, invalid_use_of_protected_member
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:karma/Constants/Library.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBarWidget(
        title: "Dashboard",
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(
          () => controller.isLoading.value == false &&
                  controller.targetList.isNotEmpty
              ? SmartRefresher(
                  enablePullDown: true,
                 // enablePullUp: false,
                  header: const ClassicHeader(),
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DataInfo.rollId.value == "1" ?
                        InkWell(
                          onTap: () {
                            CustomWidgets.customBottomSheet(
                                controller.filterUserList, "NAME", true,
                                (data) {
                              controller.selectUser.value = data['NAME'];
                              DataInfo.userId.value = data['ID'].toString();
                              DataInfo.pid.value = data['PID'].toString();
                              DataInfo.rollId.value = data['ROLLID'].toString();
                              DataInfo.enrollId.value =
                                  data['ENROLLID'].toString();
                              DataInfo.desCat.value = data['DESCAT'].toString();
                              Get.find<DashboardController>().onInit();
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
                                            controller.selectUser.value,
                                            color: greyColor,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: iconColor,
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: iconColor,
                                )
                              ],
                            ).pSymmetric(h: 15.0, v: 15.0),
                          ),
                        ) : const SizedBox(),
                        SizedBox(
                          width: Get.width,
                          height: 200,
                          child: PageView.builder(
                              itemCount: controller.targetList.length,
                              itemBuilder: (_, index) {
                                return targetWidget(
                                    controller.targetList[index], index);
                              },
                              onPageChanged: (int i) {
                                controller.targetList[i]['percentage'] =
                                    "0L/(0L)";
                              }),
                          // ListView(
                          //     scrollDirection: Axis.horizontal,
                          //     //shrinkWrap: true,
                          //     children: List.generate(
                          //         controller.targetList.length,
                          //         (index) =>
                          //             targetWidget(controller.targetList[index],index))),
                        ).pOnly(left: 10.0),
                        30.heightBox,
                        DataInfo.desCat.value == "L1"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.selectCategory1.value =
                                                  true;
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomWidgets.showImage(
                                                        path: starIcon1,
                                                        width: 23,
                                                        height: 23),
                                                    15.widthBox,
                                                    GradientText(
                                                      "Category1",
                                                      gradient: LinearGradient(
                                                        colors: controller
                                                                .selectCategory1
                                                                .value
                                                            ? appGradientColor.value
                                                            : const [
                                                                Color(
                                                                    0xff7d8493),
                                                                Color(
                                                                    0xff7d8493),
                                                              ],
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                15.heightBox,
                                                controller.selectCategory1.value
                                                    ? Container(
                                                        width: Get.width / 2.5,
                                                        height: 2.5,
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                              Color(0xffe0659b),
                                                              Color(0xff8b4de6)
                                                            ],
                                                          ),
                                                        ))
                                                    : SizedBox(
                                                        width: Get.width / 2.5,
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              width: 1.0,
                                              height: 30.0,
                                              color: cardBorderColor),
                                          InkWell(
                                            onTap: () {
                                              controller.selectCategory1.value =
                                                  false;
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomWidgets.showImage(
                                                        path: starIcon1,
                                                        width: 23,
                                                        height: 23),
                                                    15.widthBox,
                                                    GradientText(
                                                      "Category2",
                                                      gradient: LinearGradient(
                                                        colors: !controller
                                                                .selectCategory1
                                                                .value
                                                            ? appGradientColor.value
                                                            : const [
                                                                Color(
                                                                    0xff7d8493),
                                                                Color(
                                                                    0xff7d8493),
                                                              ],
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  ],
                                                ).pOnly(left: 20.0),
                                                15.heightBox,
                                                !controller
                                                        .selectCategory1.value
                                                    ? Container(
                                                        width: Get.width / 2.5,
                                                        height: 2.5,
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                              Color(0xffe0659b),
                                                              Color(0xff8b4de6)
                                                            ],
                                                          ),
                                                        ))
                                                    : SizedBox(
                                                        width: Get.width / 2.5,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          width: Get.width,
                                          height: 1.0,
                                          color: cardBorderColor),
                                    ],
                                  ),
                                  controller.selectCategory1.value
                                      ? SizedBox(
                                          width: Get.width,
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(
                                                      () =>  DataPoints());
                                                },
                                                child: Container(
                                                  width: Get.width / 2.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xffe5e6ef),
                                                      width: 2,
                                                    ),
                                                    color:
                                                        const Color(0xffF3FFF1),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomWidgets
                                                              .showImage(
                                                                  path:
                                                                      menuIcon),
                                                          10.widthBox,
                                                          TextWidget(
                                                            "Datapoint",
                                                            color: const Color(
                                                                0xff555b69),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      ).p8(),
                                                      5.heightBox,
                                                      Container(
                                                          width: Get.width / 3,
                                                          height: 1.0,
                                                          color: const Color(
                                                              0xffE5E7EF)),
                                                      20.heightBox,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffe6f7e4),
                                                            ),
                                                            child: TextWidget(
                                                              "ASC",
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ).p8(),
                                                          ),
                                                          TextWidget(
                                                            controller
                                                                    .dataPoint[
                                                                'ASCCNT'],
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 16,
                                                          )
                                                        ],
                                                      ).pSymmetric(v: 5.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffe6f7e4),
                                                            ),
                                                            child: TextWidget(
                                                              "Billed",
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ).p8(),
                                                          ),
                                                          TextWidget(
                                                            controller
                                                                    .dataPoint[
                                                                'BILLED'],
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 16,
                                                          )
                                                        ],
                                                      ).pSymmetric(v: 5.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffe6f7e4),
                                                            ),
                                                            child: TextWidget(
                                                              "Total",
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ).p8(),
                                                          ),
                                                          TextWidget(
                                                            controller
                                                                    .dataPoint[
                                                                'OUTBILLED'],
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 16,
                                                          )
                                                        ],
                                                      ).pSymmetric(v: 5.0),
                                                    ],
                                                  ).p8(),
                                                ).p16(),
                                              ),
                                              Container(
                                                width: Get.width / 2.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        cardBorderColor,
                                                    width: 2,
                                                  ),
                                                  color:
                                                      const Color(0xffFFF8E7),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomWidgets.showImage(
                                                            path: menuIcon),
                                                        10.widthBox,
                                                        TextWidget(
                                                          "Epicenter",
                                                          color: const Color(
                                                              0xff555b69),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ],
                                                    ).p8(),
                                                    5.heightBox,
                                                    Container(
                                                        width: Get.width / 3,
                                                        height: 1.0,
                                                        color: const Color(
                                                            0xffE5E7EF)),
                                                    20.heightBox,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffffefc6),
                                                          ),
                                                          child: TextWidget(
                                                            "Aquire",
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ).p8(),
                                                        ),
                                                        TextWidget(
                                                          controller.epicData[
                                                              'ACQUIRE'],
                                                          color: const Color(
                                                              0xff6891ff),
                                                          fontSize: 16,
                                                        )
                                                      ],
                                                    ).pSymmetric(v: 5.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffffefc6),
                                                          ),
                                                          child: TextWidget(
                                                            "Sustain",
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ).p8(),
                                                        ),
                                                        TextWidget(
                                                          controller.epicData[
                                                              'SUSTAIN'],
                                                          color: const Color(
                                                              0xff6891ff),
                                                          fontSize: 16,
                                                        )
                                                      ],
                                                    ).pSymmetric(v: 5.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffffefc6),
                                                          ),
                                                          child: TextWidget(
                                                            "Bootstrap",
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ).p8(),
                                                        ),
                                                        TextWidget(
                                                          controller.epicData[
                                                              'BOOSTRAP'],
                                                          color: const Color(
                                                              0xff6891ff),
                                                          fontSize: 16,
                                                        )
                                                      ],
                                                    ).pSymmetric(v: 5.0),
                                                  ],
                                                ).p8(),
                                              ).p16(),
                                              Container(
                                                width: Get.width / 2.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        cardBorderColor,
                                                    width: 2,
                                                  ),
                                                  color:
                                                      const Color(0xffFFF7F6),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomWidgets.showImage(
                                                            path: menuIcon),
                                                        10.widthBox,
                                                        TextWidget(
                                                          "Zone",
                                                          color: const Color(
                                                              0xff555b69),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ],
                                                    ).p8(),
                                                    5.heightBox,
                                                    Container(
                                                        width: Get.width / 3,
                                                        height: 1.0,
                                                        color: const Color(
                                                            0xffE5E7EF)),
                                                    20.heightBox,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffffe6e4),
                                                          ),
                                                          child: TextWidget(
                                                            "Zone",
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ).p8(),
                                                        ),
                                                        TextWidget(
                                                          controller
                                                              .zoneData['ZONE'],
                                                          color: const Color(
                                                              0xff6891ff),
                                                          fontSize: 16,
                                                        )
                                                      ],
                                                    ).pSymmetric(v: 5.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffffe6e4),
                                                          ),
                                                          child: TextWidget(
                                                            "Non Zone",
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ).p8(),
                                                        ),
                                                        TextWidget(
                                                          controller.zoneData[
                                                              'NONZONE'],
                                                          color: const Color(
                                                              0xff6891ff),
                                                          fontSize: 16,
                                                        )
                                                      ],
                                                    ).pSymmetric(v: 5.0),
                                                  ],
                                                ).p8(),
                                              ).p16(),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      const Outstanding());
                                                },
                                                child: Container(
                                                  width: Get.width / 2.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xffe5e6ef),
                                                      width: 2,
                                                    ),
                                                    color:
                                                        surfaceColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomWidgets
                                                              .showImage(
                                                                  path:
                                                                      menuIcon),
                                                          10.widthBox,
                                                          TextWidget(
                                                            "Outstanding",
                                                            color: const Color(
                                                                0xff555b69),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      ).p8(),
                                                      5.heightBox,
                                                      Container(
                                                          width: Get.width / 3,
                                                          height: 1.0,
                                                          color: const Color(
                                                              0xffE5E7EF)),
                                                      20.heightBox,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffe5e6ef),
                                                            ),
                                                            child: TextWidget(
                                                              "User",
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ).p8(),
                                                          ),
                                                          TextWidget(
                                                            controller
                                                                    .outstandingData[
                                                                'USER'],
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 16,
                                                          )
                                                        ],
                                                      ).pSymmetric(v: 5.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffe5e6ef),
                                                            ),
                                                            child: TextWidget(
                                                              "Team",
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ).p8(),
                                                          ),
                                                          TextWidget(
                                                            controller
                                                                    .outstandingData[
                                                                'TEAM'],
                                                            color: const Color(
                                                                0xff6891ff),
                                                            fontSize: 16,
                                                          )
                                                        ],
                                                      ).pSymmetric(v: 5.0),
                                                    ],
                                                  ).p8(),
                                                ).p16(),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          width: Get.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                          () => const CallBooking());
                                                    },
                                                    child: Container(
                                                      width: Get.width / 2.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xffe5e6ef),
                                                          width: 2,
                                                        ),
                                                        color: const Color(
                                                            0xffF3FFF1),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CustomWidgets
                                                                  .showImage(
                                                                      path:
                                                                          menuIcon),
                                                              10.widthBox,
                                                              TextWidget(
                                                                "Call Booking",
                                                                color: const Color(
                                                                    0xff555b69),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ],
                                                          ).p8(),
                                                          5.heightBox,
                                                          Container(
                                                              width:
                                                                  Get.width / 3,
                                                              height: 1.0,
                                                              color: const Color(
                                                                  0xffE5E7EF)),
                                                          20.heightBox,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  color: const Color(
                                                                      0xffe6f7e4),
                                                                ),
                                                                child:
                                                                    TextWidget(
                                                                  "Total",
                                                                  color: const Color(
                                                                      0xff6891ff),
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ).p8(),
                                                              ),
                                                              TextWidget(
                                                                controller
                                                                        .callBooking.value,
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 16,
                                                              )
                                                            ],
                                                          ).pSymmetric(
                                                              h: 5.0, v: 5.0),
                                                        ],
                                                      ).p8(),
                                                    ).p16(),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          const OpportunityDetails());
                                                    },
                                                    child: Container(
                                                      width: Get.width / 2.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xffe5e6ef),
                                                          width: 2,
                                                        ),
                                                        color: const Color(
                                                            0xffFFF8E7),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CustomWidgets
                                                                  .showImage(
                                                                      path:
                                                                          menuIcon),
                                                              10.widthBox,
                                                              TextWidget(
                                                                "Opportunity",
                                                                color: const Color(
                                                                    0xff555b69),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ],
                                                          ).p8(),
                                                          5.heightBox,
                                                          Container(
                                                              width:
                                                                  Get.width / 3,
                                                              height: 1.0,
                                                              color: const Color(
                                                                  0xffE5E7EF)),
                                                          20.heightBox,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  color: const Color(
                                                                      0xffffefc6),
                                                                ),
                                                                child:
                                                                    TextWidget(
                                                                  "Total",
                                                                  color: const Color(
                                                                      0xff6891ff),
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ).p8(),
                                                              ),
                                                              TextWidget(
                                                                controller
                                                                    .opportunityList
                                                                    .where((element) =>
                                                                        element[
                                                                            'STATUS'] ==
                                                                        "Open")
                                                                    .toList()
                                                                    .length
                                                                    .toString(),
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 16,
                                                              )
                                                            ],
                                                          ).pSymmetric(
                                                              h: 5.0, v: 5.0),
                                                        ],
                                                      ).p8(),
                                                    ).p16(),
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap:(){

                                                },

                                                child: Container(
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color:
                                                          cardBorderColor,
                                                      width: 2,
                                                    ),
                                                    color:
                                                        surfaceColor,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomWidgets.showImage(
                                                              path: menuIcon),
                                                          10.widthBox,
                                                          TextWidget(
                                                            "Lead",
                                                            color: const Color(
                                                                0xff555b69),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      ).p8(),
                                                      5.heightBox,
                                                      Container(
                                                          width: Get.width,
                                                          height: 1.0,
                                                          color: const Color(
                                                              0xffE5E7EF)),
                                                      10.heightBox,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: Get.width / 4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                6),
                                                                    color: const Color(
                                                                        0xffe6f7e4),
                                                                  ),
                                                                  child:
                                                                      TextWidget(
                                                                    "Accepted",
                                                                    color: const Color(
                                                                        0xff6891ff),
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ).p8(),
                                                                ),
                                                                TextWidget(
                                                                  controller
                                                                          .leadData[
                                                                      'ACCEPTED'],
                                                                  color: const Color(
                                                                      0xff6891ff),
                                                                  fontSize: 16,
                                                                )
                                                              ],
                                                            ).pSymmetric(
                                                                h: 5.0, v: 5.0),
                                                          ),
                                                          SizedBox(
                                                            width: Get.width / 4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                6),
                                                                    color: const Color(
                                                                        0xffe6f7e4),
                                                                  ),
                                                                  child:
                                                                      TextWidget(
                                                                    "Inprocess",
                                                                    color: const Color(
                                                                        0xff6891ff),
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ).p8(),
                                                                ),
                                                                TextWidget(
                                                                  controller
                                                                          .leadData[
                                                                      'INPROCESS'],
                                                                  color: const Color(
                                                                      0xff6891ff),
                                                                  fontSize: 16,
                                                                )
                                                              ],
                                                            ).pSymmetric(
                                                                h: 5.0, v: 5.0),
                                                          ),
                                                          SizedBox(
                                                            width: Get.width / 4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                6),
                                                                    color: const Color(
                                                                        0xffe6f7e4),
                                                                  ),
                                                                  child:
                                                                      TextWidget(
                                                                    "Untouch",
                                                                    color: const Color(
                                                                        0xff6891ff),
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ).p8(),
                                                                ),
                                                                TextWidget(
                                                                  controller
                                                                          .leadData[
                                                                      'UNTOUCHED'],
                                                                  color: const Color(
                                                                      0xff6891ff),
                                                                  fontSize: 16,
                                                                )
                                                              ],
                                                            ).pSymmetric(
                                                                h: 5.0, v: 5.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ).p8(),
                                                ).pSymmetric(h: 24.0),
                                              ),
                                              15.heightBox,
                                              Container(
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        cardBorderColor,
                                                    width: 2,
                                                  ),
                                                  color:
                                                      surfaceColor,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomWidgets.showImage(
                                                            path: menuIcon),
                                                        10.widthBox,
                                                        TextWidget(
                                                          "Renewable Business",
                                                          color: const Color(
                                                              0xff555b69),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ],
                                                    ).p8(),
                                                    5.heightBox,
                                                    Container(
                                                        width: Get.width,
                                                        height: 1.0,
                                                        color: const Color(
                                                            0xffE5E7EF)),
                                                    10.heightBox,
                                                    Wrap(
                                                      spacing: 5.0,
                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffe6f7e4),
                                                              ),
                                                              child: TextWidget(
                                                                "ASC",
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ).p8(),
                                                            ),
                                                            10.widthBox,
                                                            TextWidget(
                                                              controller
                                                                      .businessData[
                                                                  'AMC'],
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 16,
                                                            )
                                                          ],
                                                        ).pSymmetric(
                                                            h: 5.0, v: 5.0),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffe6f7e4),
                                                              ),
                                                              child: TextWidget(
                                                                "SMS",
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ).p8(),
                                                            ),
                                                            10.widthBox,
                                                            TextWidget(
                                                              controller
                                                                      .businessData[
                                                                  'SMS'],
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 16,
                                                            )
                                                          ],
                                                        ).pSymmetric(
                                                            h: 5.0, v: 5.0),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffe6f7e4),
                                                              ),
                                                              child: TextWidget(
                                                                "CLD",
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ).p8(),
                                                            ),
                                                            10.widthBox,
                                                            TextWidget(
                                                              controller
                                                                      .businessData[
                                                                  'CLD'],
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 16,
                                                            )
                                                          ],
                                                        ).pSymmetric(
                                                            h: 5.0, v: 5.0),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffe6f7e4),
                                                              ),
                                                              child: TextWidget(
                                                                "TSS",
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ).p8(),
                                                            ),
                                                            10.widthBox,
                                                            TextWidget(
                                                              controller
                                                                      .businessData[
                                                                  'TSS'],
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 16,
                                                            )
                                                          ],
                                                        ).pSymmetric(
                                                            h: 5.0, v: 5.0),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffe6f7e4),
                                                              ),
                                                              child: TextWidget(
                                                                "DS",
                                                                color: const Color(
                                                                    0xff6891ff),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ).p8(),
                                                            ),
                                                            10.widthBox,
                                                            TextWidget(
                                                              controller
                                                                      .businessData[
                                                                  'DIG'],
                                                              color: const Color(
                                                                  0xff6891ff),
                                                              fontSize: 16,
                                                            )
                                                          ],
                                                        ).pSymmetric(
                                                            h: 5.0, v: 5.0),
                                                      ],
                                                    ),
                                                  ],
                                                ).p8(),
                                              ).pSymmetric(h: 24.0),
                                            ],
                                          ),
                                        ),
                                  20.heightBox,
                                  tileWidget(
                                    onTap: () {
                                      Get.bottomSheet(
                                        GetBuilder<DashboardController>(
                                            builder: (dashboardController) {
                                          return Container(
                                            width: 375,
                                            height: 448,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(36.0),
                                                  topRight:
                                                      Radius.circular(36.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x3f929292),
                                                  blurRadius: 27,
                                                  offset: Offset(0, -4),
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                        width: Get.width * 0.7,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: const Color(
                                                              0xfff4f5f7),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16,
                                                          vertical: 2,
                                                        ),
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            if (value
                                                                    .trim()
                                                                    .length >
                                                                2) {
                                                              dashboardController
                                                                  .dataPointSearch(
                                                                      value);
                                                            }
                                                          },
                                                          controller:
                                                              dashboardController
                                                                  .searchController1,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Search",
                                                                  hintStyle:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0xff555b69),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  suffixIcon: dashboardController
                                                                          .searchController1
                                                                          .text
                                                                          .trim()
                                                                          .isNotEmpty
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            dashboardController.searchController1.clear();

                                                                            dashboardController.dataPointSearch("");
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.close))
                                                                      : const SizedBox()),
                                                        ))
                                                    .pOnly(
                                                        top: 20.0,
                                                        bottom: 10.0),
                                                Expanded(
                                                    child: dashboardController
                                                            .listData.isNotEmpty
                                                        ? ListView.builder(
                                                            itemCount:
                                                                dashboardController
                                                                    .listData
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Container(
                                                                width:
                                                                    Get.width,
                                                                height: 60,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                      color: Color(
                                                                          0x3fb0b0b0),
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                    ),
                                                                  ],
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    TextWidget(
                                                                      "${controller.listData[index]['CITY']}",
                                                                      color: const Color(
                                                                          0xff2f3237),
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios_outlined,
                                                                      color: Color(
                                                                          0xffBDC0CE),
                                                                    ),
                                                                  ],
                                                                ).pSymmetric(
                                                                    h: 25.0),
                                                              );
                                                            })
                                                        : Center(
                                                            child: TextWidget(
                                                              "No data found.",
                                                              fontSize: 25,
                                                            ),
                                                          ))
                                              ],
                                            ),
                                          );
                                        }),
                                        backgroundColor: Colors.transparent,
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 400),
                                      ).then((value) => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus());
                                    },
                                    title: "Datapoint search",
                                    icon: Icons.search,
                                  ),
                                  tileWidget(
                                    title: "Nearby Customers",
                                    icon: Icons.near_me_outlined,
                                  ),
                                  tileWidget(
                                    onTap:() async{
                                      final location = await Utilities.getLocation();
                                      if (location == null) {
                                        CustomWidgets.snackBar(
                                            title:
                                                "Location permission required for Cold Calling.");
                                        return;
                                      }
                                      Get.to(()=>  ColdCalling(locationData: location,));
                                    },
                                    title: "Cold Calling",
                                    icon: Icons.call,

                                  ),
                                  tileWidget(
                                    onTap:(){
                                      Get.to(() =>
                                      const Outstanding());
                                    },
                                    title: "Outstanding Reports",
                                    icon: Icons.report_outlined,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.selectL2Category1.value =
                                              "1";
                                          controller.selectData =
                                              controller.monthlyL2Data;
                                        },
                                        child: ColoredBox(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              GradientText(
                                                "Monthly",
                                                gradient: LinearGradient(
                                                  colors: controller
                                                              .selectL2Category1
                                                              .value ==
                                                          "1"
                                                      ? appGradientColor.value
                                                      : const [
                                                          greyColor,
                                                          greyColor,
                                                        ],
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              10.heightBox,
                                              controller.selectL2Category1
                                                          .value ==
                                                      "1"
                                                  ? Container(
                                                      width: Get.width / 3.5,
                                                      height: 2.0,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: controller
                                                                      .selectL2Category1
                                                                      .value ==
                                                                  "1"
                                                              ? appGradientColor
                                                              : const [
                                                                  Color(
                                                                      0xff7d8493),
                                                                  Color(
                                                                      0xff7d8493),
                                                                ],
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      width: Get.width / 3.5,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectL2Category1.value =
                                              "2";
                                          controller.selectData =
                                              controller.quarterlyL2Data;
                                        },
                                        child: ColoredBox(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              GradientText(
                                                "Quarterly",
                                                gradient: LinearGradient(
                                                  colors: controller
                                                              .selectL2Category1
                                                              .value ==
                                                          "2"
                                                      ? appGradientColor.value
                                                      : const [
                                                          greyColor,
                                                          greyColor,
                                                        ],
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              10.heightBox,
                                              controller.selectL2Category1
                                                          .value ==
                                                      "2"
                                                  ? Container(
                                                      width: Get.width / 3.5,
                                                      height: 2.0,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: controller
                                                                      .selectL2Category1
                                                                      .value ==
                                                                  "2"
                                                              ? appGradientColor.value
                                                              : const [
                                                                  Color(
                                                                      0xff7d8493),
                                                                  Color(
                                                                      0xff7d8493),
                                                                ],
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      width: Get.width / 3.5,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectL2Category1.value =
                                              "3";
                                          controller.selectData =
                                              controller.allL2Data;
                                        },
                                        child: ColoredBox(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              GradientText(
                                                "All Time",
                                                gradient: LinearGradient(
                                                  colors: controller
                                                              .selectL2Category1
                                                              .value ==
                                                          "3"
                                                      ? appGradientColor.value
                                                      : const [
                                                          greyColor,
                                                          greyColor,
                                                        ],
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              10.heightBox,
                                              controller.selectL2Category1
                                                          .value ==
                                                      "3"
                                                  ? Container(
                                                      width: Get.width / 3.5,
                                                      height: 2.0,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: controller
                                                                      .selectL2Category1
                                                                      .value ==
                                                                  "3"
                                                              ? appGradientColor.value
                                                              : const [
                                                                  Color(
                                                                      0xff7d8493),
                                                                  Color(
                                                                      0xff7d8493),
                                                                ],
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      width: Get.width / 3.5,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).pSymmetric(h: 16.0),
                                  Container(
                                    width: Get.width,
                                    height: 1.5,
                                    color: Colors.grey[200],
                                  ),
                                  10.heightBox,
                                  userL2Data(controller.selectData),
                                  10.heightBox,
                                   GradientText(
                                    "Rating",
                                    gradient: LinearGradient(
                                      colors: appGradientColor.value,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ).pSymmetric(h: 15.0),
                                  10.heightBox,
                                  ratingL2Data(),
                                  10.heightBox,
                                  userL2DataWidget(controller.mapDataL2),
                                  tileWidget(
                                    onTap: () {
                                      Get.to(
                                              () =>  DataPoints());
                                    },
                                    title: "Datapoints",
                                    icon: Icons.add_circle_outline_outlined,
                                  ),
                                  tileWidget(
                                    onTap: () {

                                    },
                                    title: "Internal Trainings",
                                    icon: Icons.add_circle_outline_outlined,
                                  ),
                                  tileWidget(
                                    onTap: () {

                                    },
                                    title: "Enrich Training Program",
                                    icon: Icons.add_circle_outline_outlined,
                                  ),
                                ],
                              ),
                      ],
                    ),
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
    );
  }

  Widget tileWidget({String? title, IconData? icon, Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      minLeadingWidth: 1.0,
      title: TextWidget(title!),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }

  Widget userL2Data(var data) {
    return Column(

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cardBorderColor,
                    width: 2,
                  ),
                  color: surfaceColor,
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: infoSoftBgColor,
                        ),
                        child: TextWidget(
                          data['caseCreated'],
                          color: linkBlueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ).p8()),
                    15.heightBox,
                    Container(
                        width: Get.width / 3,
                        height: 1.0,
                        color: cardBorderColor),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomWidgets.showImage(path: caseCreatedIcon),
                        10.widthBox,
                        TextWidget(
                          "Case Created",
                          color: subtleTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ).p8(),
                  ],
                ).p8(),
              ).pSymmetric(h: 8.0, v: 4.0),
            ),
            Expanded(
              flex: 1,
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cardBorderColor,
                    width: 2,
                  ),
                  color: surfaceColor,
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: infoSoftBgColor,
                        ),
                        child: TextWidget(
                          data['caseResolved'],
                          color: linkBlueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ).p8()),
                    15.heightBox,
                    Container(
                        width: Get.width / 3,
                        height: 1.0,
                        color: cardBorderColor),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomWidgets.showImage(path: resolvedIcon),
                        10.widthBox,
                        TextWidget(
                          "Case Resolved",
                          color: subtleTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ).p8(),
                  ],
                ).p8(),
              ).pSymmetric(h: 8.0, v: 4.0),
            ),
          ],
        ),

       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Expanded(
             flex: 1,
             child: Container(

               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(
                   color: cardBorderColor,
                   width: 2,
                 ),
                 color: surfaceColor,
               ),
               child: Column(
                 children: [
                   Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(6),
                         color: infoSoftBgColor,
                       ),
                       child: TextWidget(
                         data['tallyTips'],
                         color: linkBlueColor,
                         fontSize: 13,
                         fontWeight: FontWeight.w500,
                       ).p8()),
                   15.heightBox,
                   Container(
                       width: Get.width / 3,
                       height: 1.0,
                       color: cardBorderColor),
                   5.heightBox,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       CustomWidgets.showImage(path: tipsIcon),
                       10.widthBox,
                       TextWidget(
                         "Tally Tips",
                         color: subtleTextColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w500,
                       ),
                     ],
                   ).p8(),
                 ],
               ).p8(),
             ).pSymmetric(h: 8.0, v: 4.0),
           ),
           Expanded(
             flex: 1,
             child: Container(

               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(
                   color: cardBorderColor,
                   width: 2,
                 ),
                 color: surfaceColor,
               ),
               child: Column(
                 children: [
                   Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(6),
                         color: infoSoftBgColor,
                       ),
                       child: TextWidget(
                         data['testmoinels'],
                         color: linkBlueColor,
                         fontSize: 13,
                         fontWeight: FontWeight.w500,
                       ).p8()),
                   15.heightBox,
                   Container(
                       width: Get.width / 3,
                       height: 1.0,
                       color: cardBorderColor),
                   5.heightBox,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       CustomWidgets.showImage(path: testmonielsIcon),
                       10.widthBox,
                       TextWidget(
                         "Testimonial",
                         color: subtleTextColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w500,
                       ),
                     ],
                   ).p8(),
                 ],
               ).p8(),
             ).pSymmetric(h: 8.0, v: 4.0),
           ),
         ],
       ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: cardBorderColor,
                  width: 2,
                ),
                color: surfaceColor,
              ),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: infoSoftBgColor,
                      ),
                      child: TextWidget(
                        data['feedbacks'],
                        color: linkBlueColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ).p8()),
                  15.heightBox,
                  Container(
                      width: Get.width / 3,
                      height: 1.0,
                      color: cardBorderColor),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomWidgets.showImage(path: feedbackIcon),
                      10.widthBox,
                      TextWidget(
                        "Feedbacks",
                        color: subtleTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ).p8(),
                ],
              ).p8(),
          ).pSymmetric(h: 8.0, v: 4.0),
            ),
            Expanded(
              flex: 1,
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cardBorderColor,
                    width: 2,
                  ),
                  color: surfaceColor,
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: infoSoftBgColor,
                        ),
                        child: TextWidget(
                          data['ratings'],
                          color: linkBlueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ).p8()),
                    15.heightBox,
                    Container(
                        width: Get.width / 3,
                        height: 1.0,
                        color: cardBorderColor),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomWidgets.showImage(path: ratingIcon),
                        10.widthBox,
                        TextWidget(
                          "Ratings",
                          color: subtleTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ).p8(),
                  ],
                ).p8(),
              ).pSymmetric(h: 8.0, v: 4.0),
            ),

          ],
        ),
      ],
    ).pSymmetric(h: 5.0);
  }

  Widget ratingL2Data() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cardBorderColor,
                width: 2,
              ),
              color: surfaceColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomWidgets.showImage(path: menuIcon),
                    10.widthBox,
                    TextWidget(
                      "Average",
                      color: subtleTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: infoSoftBgColor,
                    ),
                    child: TextWidget(
                      controller.avgRating.value,
                      color: linkBlueColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ).p8()),
              ],
            ).p8(),
          ).pSymmetric(h: 8.0, v: 4.0),
        ),
        Expanded(
          flex: 1,
          child: Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cardBorderColor,
                width: 2,
              ),
              color: surfaceColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomWidgets.showImage(path: menuIcon),
                    10.widthBox,
                    TextWidget(
                      "Overall",
                      color: subtleTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: infoSoftBgColor,
                    ),
                    child: TextWidget(
                      controller.overAllRating.value,
                      color: linkBlueColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ).p8()),
              ],
            ).p8(),
          ).pSymmetric(h: 8.0, v: 4.0),
        ),
      ],
    ).pSymmetric(h: 5.0);
  }

  Widget userL2DataWidget(var data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cardBorderColor,
                    width: 2,
                  ),
                  color: surfaceColor,
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: infoSoftBgColor,
                        ),
                        child: TextWidget(
                          data['pprc'].toString(),
                          color: linkBlueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ).p8()),
                    15.heightBox,
                    Container(
                        width: Get.width / 3,
                        height: 1.0,
                        color: cardBorderColor),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomWidgets.showImage(path: pprcIcon),
                        10.widthBox,
                        TextWidget(
                          "PPRC",
                          color: subtleTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ).p8(),
                  ],
                ).p8(),
              ).pSymmetric(h: 8.0, v: 4.0),
            ),
            Expanded(
              flex: 1,
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cardBorderColor,
                    width: 2,
                  ),
                  color: surfaceColor,
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: infoSoftBgColor,
                        ),
                        child: TextWidget(
                          data['ticket'].toString(),
                          color: linkBlueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ).p8()),
                    15.heightBox,
                    Container(
                        width: Get.width / 3,
                        height: 1.0,
                        color: cardBorderColor),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomWidgets.showImage(path: menuIcon),
                        10.widthBox,
                        TextWidget(
                          "Tickets(R)",
                          color: subtleTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ).p8(),
                  ],
                ).p8(),
              ).pSymmetric(h: 8.0, v: 4.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: (){
                  Get.to(
                          () => const CallBooking());
                },
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cardBorderColor,
                      width: 2,
                    ),
                    color: surfaceColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: infoSoftBgColor,
                          ),
                          child: TextWidget(
                            controller
                                .callBooking.value,
                            color: linkBlueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ).p8()),
                      15.heightBox,
                      Container(
                          width: Get.width / 3,
                          height: 1.0,
                          color: cardBorderColor),
                      5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomWidgets.showImage(path: onsiteIcon),
                          10.widthBox,
                          TextWidget(
                            "Onsite Visits",
                            color: subtleTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ).p8(),
                    ],
                  ).p8(),
                ).pSymmetric(h: 8.0, v: 4.0),
              ),
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: (){
                  Get.to(()=> const  Lead());
                },
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cardBorderColor,
                      width: 2,
                    ),
                    color: surfaceColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: infoSoftBgColor,
                          ),
                          child: TextWidget(
                            data['lead'].toString(),
                            color: linkBlueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ).p8()),
                      15.heightBox,
                      Container(
                          width: Get.width / 3,
                          height: 1.0,
                          color: cardBorderColor),
                      5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomWidgets.showImage(path: leadIcon),
                          10.widthBox,
                          TextWidget(
                            "Lead",
                            color: subtleTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ).p8(),
                    ],
                  ).p8(),
                ).pSymmetric(h: 8.0, v: 4.0),
              ),
            ),
          ],
        ),
      ],
    ).pSymmetric(h: 5.0);
  }

  Widget targetWidget(var targetData, int index) {
    return GetBuilder<DashboardController>(
        builder: (dashboard) => Container(
              width: Get.width * 0.85,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: cardBorderColor,
                  width: 2,
                ),
                color: const Color(0xffebeffd),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(()=>Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xffffe6e4),
                        ),
                        child: TextWidget(
                          dashboard.targetList[index]['type'],
                          color: subtleTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ).pSymmetric(h: 7.0, v: 5.0),
                      ),),
                      5.widthBox,
                      TextWidget(
                        dashboard.targetList[index]['percentage'].toString(),
                        color: subtleTextColor,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 18,
                                  height: ((double.tryParse((targetData['meTarget'] ?? '').toString()) ?? 0) /
                                              120 *
                                              100) >
                                          2
                                      ? ((double.tryParse((targetData['meTarget'] ?? '').toString()) ?? 0) /
                                          120 *
                                          100)
                                      : 2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    color: Color(0xffbaedbd),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.widthBox,
                          SizedBox(
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 18,
                                  height: ((double.tryParse((targetData['teamTarget'] ?? '').toString()) ?? 0) /
                                              120 *
                                              100) >
                                          2
                                      ? ((double.tryParse((targetData['teamTarget'] ?? '').toString()) ?? 0) /
                                          120 *
                                          100)
                                      : 2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    color: Color(0xffc6c7f8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.widthBox,
                          SizedBox(
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 18,
                                  height: ((double.tryParse((targetData['floorTarget'] ?? '').toString()) ?? 0) /
                                              120 *
                                              100) >
                                          2
                                      ? ((double.tryParse((targetData['floorTarget'] ?? '').toString()) ?? 0) /
                                          120 *
                                          100)
                                      : 2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    color: Color(0xffb1e3ff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.widthBox,
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.updateStatus(index, "M");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0xffbaedbd),
                                  ),
                                  child: TextWidget(
                                    "Me",
                                    color: subtleTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ).pSymmetric(h: 7.0, v: 5.0),
                                ),
                                20.widthBox,
                                TextWidget(
                                  "${targetData['meTarget'].toString()}%",
                                  color: subtleTextColor,
                                  fontSize: 16,
                                ),
                              ],
                            ).pSymmetric(h: 10.0, v: 5.0),
                          ),
                          InkWell(
                            onTap: () {
                              controller.updateStatus(index, "T");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0xffA155B9),
                                  ),
                                  child: TextWidget(
                                    "Team",
                                    color: subtleTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ).pSymmetric(h: 7.0, v: 5.0),
                                ),
                                20.widthBox,
                                TextWidget(
                                  "${targetData['teamTarget'].toString()}%",
                                  color: subtleTextColor,
                                  fontSize: 16,
                                ),
                              ],
                            ).pSymmetric(h: 10.0, v: 5.0),
                          ),
                          InkWell(
                            onTap: () {
                              controller.updateStatus(index, "F");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0xffb1e3ff),
                                  ),
                                  child: TextWidget(
                                    "Floor",
                                    color: subtleTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ).pSymmetric(h: 7.0, v: 5.0),
                                ),
                                20.widthBox,
                                TextWidget(
                                  "${targetData['floorTarget'].toString()}%",
                                  color: subtleTextColor,
                                  fontSize: 16,
                                ),
                              ],
                            ).pSymmetric(h: 10.0, v: 5.0),
                          ),
                        ],
                      )
                    ],
                  ).pSymmetric(h: 10.0),
                ],
              ).p8(),
            ).pSymmetric(h: 10.0));
  }
}
