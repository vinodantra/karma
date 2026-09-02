// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';

import 'package:intl/intl.dart';

/// Screen for adding and viewing conveyance entries.
class ConveyanceEntry extends GetView<ConveyanceEntryController> {
  /// Constructor for ConveyanceEntry.
  const ConveyanceEntry({super.key});

  // Static constants for repeated strings
  static const String addConveyanceTitle = "Add Conveyance";
  static const String companyName = "Company Name";
  static const String date = "Date";
  static const String travelBy = "Travel By";
  static const String from = "From";
  static const String to = "To";
  static const String distance = "Distance(Rs. 3/Km.)";
  static const String amount = "Amount";
  static const String comment = "Comment";
  static const String addPass = "Add Pass";
  static const String conveyanceList = "Conveyance List";
  static const String passDetails = "Pass Details";
  static const String passType = "Pass Type";
  static const String fromDate = "From Date";
  static const String toDate = "To Date";
  static const String fromLocation = "From Location";
  static const String toLocation = "To Location";
  static const String passAmount = "Pass Amount";
  static const String cancel = "Cancel";
  static const String ok = "OK";
  static const String confirm = "Confirm";
  static const String areYouSureDelete = "Are you sure to delete?";

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ConveyanceEntryController>()) {
      Get.put(ConveyanceEntryController());
    }
    return GetBuilder<ConveyanceEntryController>(builder: (controller) {
      return Scaffold(
        appBar: AppBarWidget(
          title: addConveyanceTitle,
          onSubmit: controller.isShowButton.value
              ? () {
                  controller.checkData();
                }
              : null,
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(
            () => controller.isLoading.value == false
                ? ListView(
                    children: [
                      tile(
                          title: companyName,
                          data: controller.data['CMP']?.toString()),
                      tile(
                          title: date,
                          data: controller.data['CALLDATE']?.toString()),
                      tile(
                        title: travelBy,
                        selectData: controller.selectTravelByData.value,
                        list: controller.travelByList,
                        type: "3",
                        pa: "SOURCE",
                        updateData: (data) {
                          controller.selectTravelByData.value = data['SOURCE'];
                          if (controller.selectTravelByData.value == "Bike") {
                            controller.getPrice();
                          }
                        },
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                from,
                                color: titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                width: Get.width / 2,
                                height: 50,
                                child: TextField(
                                  controller: controller.from,
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ).pSymmetric(h: 15.0, v: 5.0),
                          5.heightBox,
                          Container(
                            width: Get.width,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                to,
                                color: titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                width: Get.width / 2,
                                height: 50,
                                child: TextField(
                                  controller: controller.to,
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ).pSymmetric(h: 15.0, v: 5.0),
                          5.heightBox,
                          Container(
                            width: Get.width,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      controller.showPassData.value
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      distance,
                                      color: titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      width: Get.width / 2,
                                      height: 50,
                                      child: TextField(
                                        onChanged: (value) {
                                          controller.amount.text =
                                              (double.parse(controller
                                                          .petrolPrice.value) *
                                                      double.parse(value))
                                                  .toString();
                                        },
                                        controller:
                                            controller.distanceController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ).pSymmetric(h: 15.0, v: 5.0),
                                5.heightBox,
                                Container(
                                  width: Get.width,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                amount,
                                color: titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                width: Get.width / 2,
                                height: 50,
                                child: TextField(
                                  controller: controller.amount,
                                  readOnly:
                                      controller.selectTravelByData.value ==
                                          "Bike",
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ).pSymmetric(h: 15.0, v: 5.0),
                          5.heightBox,
                          Container(
                            width: Get.width,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      TextField(
                        controller: controller.comment,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(hintText: comment),
                        minLines: 10,
                        maxLines: 10,
                      ).pSymmetric(h: 15.0, v: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomButton(
                            text: addPass,
                            onPressed: () {
                              Get.dialog(
                                Center(
                                  child: Obx(
                                    () => Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextWidget(
                                            passDetails,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          10.heightBox,
                                          Container(
                                            height: 1.0,
                                            width: Get.width,
                                            color: Colors.grey[400],
                                          ),
                                          10.heightBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                passType,
                                                fontSize: 16,
                                                color: appColor.value,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  CustomWidgets
                                                      .customBottomSheet(
                                                    controller.passTypeList,
                                                    "NAME",
                                                    false,
                                                    (data) {
                                                      controller.selectPassType
                                                          .value = data['NAME'];
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                      controller
                                                          .selectPassType.value,
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xff2f3237),
                                                    ),
                                                    5.widthBox,
                                                    const Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      color: iconColor,
                                                    ),
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
                                                fromDate,
                                                fontSize: 16,
                                                color: appColor.value,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  final de = await CustomWidgets
                                                      .pickDate(context);
                                                  if (de != null) {
                                                    controller.selectFromDate
                                                        .value = DateFormat(
                                                            'dd-MMM-yyyy')
                                                        .format(de);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                      controller
                                                          .selectFromDate.value,
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xff2f3237),
                                                    ),
                                                    5.widthBox,
                                                    const Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      color: iconColor,
                                                    ),
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
                                                toDate,
                                                fontSize: 16,
                                                color: appColor.value,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  final de = await CustomWidgets
                                                      .pickDate(context);
                                                  if (de != null) {
                                                    controller.selectToDate
                                                        .value = DateFormat(
                                                            'dd-MMM-yyyy')
                                                        .format(de);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                      controller
                                                          .selectToDate.value,
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xff2f3237),
                                                    ),
                                                    5.widthBox,
                                                    const Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      color: iconColor,
                                                    ),
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
                                                fromLocation,
                                                color: appColor.value,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              SizedBox(
                                                width: Get.width / 3,
                                                height: 50,
                                                child: TextField(
                                                  controller: controller
                                                      .fromLocationController,
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
                                                toLocation,
                                                color: appColor.value,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              SizedBox(
                                                width: Get.width / 3,
                                                height: 50,
                                                child: TextField(
                                                  controller: controller
                                                      .toLocationController,
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
                                                passAmount,
                                                color: appColor.value,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              SizedBox(
                                                width: Get.width / 3,
                                                height: 50,
                                                child: TextField(
                                                  controller:
                                                      controller.passAmount,
                                                ),
                                              ),
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
                                                  cancel,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              CustomButton(
                                                text: ok,
                                                onPressed: () {
                                                  if (controller.selectPassType
                                                          .value ==
                                                      "Select") {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please select pass type");
                                                  } else if (controller
                                                      .selectFromDate
                                                      .value
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please select from date");
                                                  } else if (controller
                                                      .selectToDate
                                                      .value
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please select to date");
                                                  } else if (controller
                                                      .fromLocationController
                                                      .value
                                                      .text
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please enter from location");
                                                  } else if (controller
                                                      .toLocationController
                                                      .text
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please enter to location");
                                                  } else if (controller
                                                      .passAmount
                                                      .text
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please enter pass amount");
                                                  } else {
                                                    controller.createPass();
                                                    Get.back();
                                                  }
                                                },
                                                width: 120,
                                                height: 40,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ).p24(),
                                    ),
                                  ),
                                ),
                                barrierDismissible: false,
                              ).then((_) {});
                            },
                            width: 100,
                            height: 50,
                          ),
                        ],
                      ).p8(),
                      TextWidget(
                        conveyanceList,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ).p8(),
                      Column(
                        children: List.generate(
                          controller.conveyanceList.length,
                          (index) => ListTile(
                            title: TextWidget(
                              "${controller.conveyanceList[index]['FROM'].toString()} To ${controller.conveyanceList[index]['TO'].toString()} By ${controller.conveyanceList[index]['SOURCE'].toString()}",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                    "Amount ${controller.conveyanceList[index]['AMOUNT'].toString()}"),
                                TextWidget(
                                    "Remark ${controller.conveyanceList[index]['REMARK'].toString()}"),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                CustomWidgets.showAlertDialog(
                                  title: confirm,
                                  content: areYouSureDelete,
                                  onCancel: () {
                                    Get.back();
                                  },
                                  onClick: () {
                                    controller.deleteConveyanceData(
                                        controller.conveyanceList[index]['ID']);
                                    Get.back();
                                  },
                                );
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ),
                      ),
                      20.heightBox,
                    ],
                  )
                : const LoadingScreen(),
          ),
        ),
      );
    });
  }

  /// Widget for displaying a single detail row or dropdown.
  Widget tile({
    String? title,
    String? data,
    String type = "1",
    List<dynamic>? list,
    String pa = "",
    String selectData = "",
    ValueChanged<Map<String, dynamic>>? updateData,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title ?? '',
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            type == "1"
                ? SizedBox(
                    width: Get.width / 2,
                    child: TextWidget(
                      data ?? '',
                      color: descriptionColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.right,
                      maxLines: 10,
                    ),
                  )
                : type == "2"
                    ? InkWell(
                        onTap: () {
                          if (data != null) {
                            Utilities.onClickMobile(data);
                          }
                        },
                        child: TextWidget(
                          data ?? '',
                          color: Colors.lightBlueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textDecoration: TextDecoration.underline,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          CustomWidgets.customBottomSheet(
                            list,
                            pa,
                            false,
                            (data) {
                              if (updateData != null) {
                                updateData(data);
                              }
                              Get.back();
                            },
                          );
                        },
                        child: Row(
                          children: [
                            TextWidget(
                              selectData,
                              fontSize: 14,
                              color: darkTextColor,
                            ),
                            5.widthBox,
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: iconColor,
                            ),
                          ],
                        ),
                      ),
          ],
        ).pSymmetric(h: 15.0, v: 10.0),
        5.heightBox,
        Container(
          width: Get.width,
          height: 1.0,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}
