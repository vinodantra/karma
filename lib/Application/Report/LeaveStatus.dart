// ignore_for_file: depend_on_referenced_packages, invalid_use_of_protected_member, must_be_immutable, file_names, deprecated_member_use

import '../../Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
import 'package:intl/intl.dart';

class LeaveStatus extends GetView<LeaveStatusController> {
  const LeaveStatus({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveStatusController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Leave Status",
      ),
      body: Obx(() => Column(
            children: [
              if (DataInfo.rollId.value == "1")
                InkWell(
                  onTap: () {
                    CustomWidgets.customBottomSheet(
                        controller.filterUserList, "NAME", true, (data) {
                      controller.selectUser.value = data['NAME'];
                      controller.selectUserId.value =
                          data['ENROLLID'].toString();
                      controller.getData();
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
                                  CustomWidgets.showImage(path: userIcon),
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
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "Select Month",
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: () async {
                      var de = await CustomWidgets.pickMonth(context,
                          selectDate: controller.selectDate2);

                      if (de != null) {
                        controller.selectDate.value =
                            DateFormat('MMM yyyy').format(de);
                        controller.selectDate1.value =
                            DateFormat('MM yyyy').format(de);
                        controller.selectDate2 = de;

                        controller.getData();
                      }
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          TextWidget(
                            controller.selectDate.value,
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          10.widthBox,
                          const Icon(Icons.calendar_today_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
              ).pSymmetric(h: 20.0),
              15.heightBox,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.listData.isEmpty,
                    onRetry: controller.getData,
                    emptyMessage: 'No leave records found.',
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.listData.length,
                      itemBuilder: (context, index) =>
                          tile(controller.listData[index]),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  tile(data) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                data['LEAVECATEGORY'].toString(),
                fontSize: 18,
                color: Colors.black,
              ),
              TextWidget(
                data['LEAVESTATUS'] == "A"
                    ? "Approved By ${data['APPROVEDBY']}"
                    : data['LEAVESTATUS'] == "P"
                        ? "Pending"
                        : data['LEAVESTATUS'] == "R"
                            ? "Rejected By ${data['APPROVEDBY']}"
                            : "Hold",
                fontSize: 18,
                color: data['LEAVESTATUS'] == "A"
                    ? Colors.green
                    : data['LEAVESTATUS'] == "P"
                        ? Colors.orangeAccent
                        : data['LEAVESTATUS'] == "R"
                            ? Colors.red
                            : Colors.orangeAccent,
              ),
            ],
          ).pSymmetric(h: 10.0, v: 5.0),
          CustomWidgets.divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Applied on : ${data['CREATEDATE']}",
                fontSize: 18,
                color: Colors.black,
              ),
              TextWidget(
                "${data['NUMOFDAYS']} days",
                fontSize: 18,
                color: Colors.black,
              ),
            ],
          ).pSymmetric(h: 10.0, v: 5.0),
          TextWidget(
            data['NUMOFDAYS'] > 1
                ? "Applied for : ${data['ONDATE']} to ${data['TODATE']}"
                : "Applied for : ${data['ONDATE']}",
            fontSize: 18,
            color: Colors.black,
            maxLines: 2,
          ).pSymmetric(h: 10.0, v: 5.0),
          SizedBox(
              width: Get.width,
              child: TextWidget(
                "Description: ${data['LEAVEDESC'].toString()}",
                fontSize: 18,
                color: Colors.black,
                maxLines: 10,
              ).pSymmetric(h: 10.0, v: 5.0)),
          data['LEAVESTATUS'] == "R"
              ? SizedBox(
                  width: Get.width,
                  child: TextWidget(
                    "Rejected Reason: ${data['REJREASON'].toString()}",
                    fontSize: 18,
                    color: Colors.black,
                    maxLines: 10,
                  ).pSymmetric(h: 10.0, v: 5.0))
              : const SizedBox(),
          Utilities.checkString(data['APPROVEDBY']) == false &&
                  controller.selectUser.value.trim() ==
                      DataInfo.username.value &&
                  data['LEAVESTATUS'] == "P"
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (data['NUMOFDAYS'] == 0.5) {
                            controller.selectApplyType.value = "Half Day";
                            controller.selectApplyTypeId.value = "1";
                            controller.selectLeaveData.value =
                                data['HALF'] == "FH"
                                    ? "First Half"
                                    : "Second Half";
                            controller.selectLeaveId.value =
                                data['HALF'] == "FH" ? "1" : "2";
                            controller.selectOnDate.value = data['ONDATE'];
                          } else if (data['NUMOFDAYS'] == 1) {
                            controller.selectApplyType.value = "1 Day";
                            controller.selectApplyTypeId.value = "2";
                            controller.selectOnDate.value = data['ONDATE'];
                          } else {
                            controller.selectApplyType.value =
                                "More than 1 day";
                            controller.selectApplyTypeId.value = "3";
                            controller.selectFromDate.value = data['ONDATE'];
                            controller.selectToDate.value = data['TODATE'];
                          }
                          controller.selectType.value = data['LEAVECATEGORY'];
                          controller.email.text = data['TOEMAIL'];
                          controller.leaveReason.text = data['LEAVEDESC'];

                          Get.dialog(Obx(() => Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: Get.width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            gradient: LinearGradient(
                                                colors:
                                                    appGradientColor.value)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: TextWidget("Close",
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                            TextWidget(
                                              "Leave",
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  if (controller
                                                          .selectType.value ==
                                                      "Select") {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please select field type");
                                                  } else if (controller
                                                          .selectApplyType
                                                          .value ==
                                                      "Select") {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please select applying for");
                                                  } else if (controller
                                                      .email.text
                                                      .trim()
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please enter email id");
                                                  } else if (controller
                                                          .email.text
                                                          .trim()
                                                          .isEmail ==
                                                      false) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please enter valid email id");
                                                  } else if (controller
                                                      .leaveReason.text
                                                      .trim()
                                                      .isEmpty) {
                                                    CustomWidgets.snackBar(
                                                        title:
                                                            "Please enter leave reason");
                                                  } else {
                                                    controller.applyLeave(
                                                        int.parse(
                                                            data['LEAVEID']
                                                                .toString()));
                                                  }
                                                  Get.back();
                                                },
                                                child: TextWidget("Apply",
                                                    color: Colors.white,
                                                    fontSize: 18))
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            "Type",
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              CustomWidgets.customBottomSheet(
                                                  controller.leaveType,
                                                  "NAME",
                                                  false, (data) {
                                                controller.selectType.value =
                                                    data['NAME'];

                                                controller.getData();
                                                Get.back();
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  controller.selectType.value,
                                                  color: greyColor,
                                                  fontSize: 16,
                                                ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_outlined,
                                                  color: iconColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).pSymmetric(h: 15.0, v: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            "Applying for",
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              CustomWidgets.customBottomSheet(
                                                  controller.applyList,
                                                  "NAME",
                                                  false, (data) {
                                                controller.selectApplyType
                                                    .value = data['NAME'];
                                                controller.selectApplyTypeId
                                                    .value = data['ID'];

                                                controller.getData();
                                                Get.back();
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  controller
                                                      .selectApplyType.value,
                                                  color: greyColor,
                                                  fontSize: 16,
                                                ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_outlined,
                                                  color: iconColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).pSymmetric(h: 15.0, v: 10.0),
                                      controller.selectApplyTypeId.value != "3"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  "On Date",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var selectOnDate =
                                                        await CustomWidgets
                                                            .pickDate(
                                                                Get.context!);
                                                    if (selectOnDate != null) {
                                                      controller.selectOnDate
                                                          .value = DateFormat(
                                                              'dd MMM yyyy')
                                                          .format(selectOnDate);

                                                      controller.selectOnDate1
                                                              .value =
                                                          selectOnDate
                                                              .toString();
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      TextWidget(
                                                        controller
                                                            .selectOnDate.value,
                                                        color: greyColor,
                                                        fontSize: 16,
                                                      ),
                                                      5.widthBox,
                                                      const Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        color:
                                                            iconColor,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ).pSymmetric(h: 15.0, v: 10.0)
                                          : const SizedBox(),
                                      controller.selectApplyTypeId.value == "3"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  "From Date",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var selectFromDate =
                                                        await CustomWidgets
                                                            .pickDateRange(
                                                                Get.context!,
                                                                null);
                                                    if (selectFromDate !=
                                                        null) {
                                                      controller.selectFromDate
                                                          .value = DateFormat(
                                                              'dd MMM yyyy')
                                                          .format(
                                                              selectFromDate);

                                                      controller.selectFromDate1
                                                              .value =
                                                          selectFromDate
                                                              .toString();
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      TextWidget(
                                                        controller
                                                            .selectFromDate
                                                            .value,
                                                        color: greyColor,
                                                        fontSize: 16,
                                                      ),
                                                      5.widthBox,
                                                      const Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        color:
                                                            iconColor,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ).pSymmetric(h: 15.0, v: 10.0)
                                          : const SizedBox(),
                                      controller.selectApplyTypeId.value == "3"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  "To Date",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var selectToDate =
                                                        await CustomWidgets
                                                            .pickDateRange(
                                                                Get.context!,
                                                                DateTime.parse(
                                                                    controller
                                                                        .selectFromDate1
                                                                        .value));
                                                    if (selectToDate != null) {
                                                      controller.selectToDate
                                                          .value = DateFormat(
                                                              'dd MMM yyyy')
                                                          .format(selectToDate);

                                                      controller.selectToDate1
                                                              .value =
                                                          selectToDate
                                                              .toString();
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      TextWidget(
                                                        controller
                                                            .selectToDate.value,
                                                        color: greyColor,
                                                        fontSize: 16,
                                                      ),
                                                      5.widthBox,
                                                      const Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        color:
                                                            iconColor,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ).pSymmetric(h: 15.0, v: 10.0)
                                          : const SizedBox(),
                                      controller.selectApplyTypeId.value == "1"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  "Half",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    CustomWidgets
                                                        .customBottomSheet(
                                                            controller
                                                                .leaveTypeList,
                                                            "NAME",
                                                            false, (data) {
                                                      controller.selectLeaveData
                                                          .value = data['NAME'];
                                                      controller.selectLeaveId
                                                          .value = data['ID'];

                                                      // controller.getData();
                                                      Get.back();
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      TextWidget(
                                                        controller
                                                            .selectLeaveData
                                                            .value,
                                                        color: greyColor,
                                                        fontSize: 16,
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color:
                                                            iconColor,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ).pSymmetric(h: 15.0, v: 10.0)
                                          : const SizedBox(),
                                      TextField(
                                        controller: controller.email,
                                        decoration: const InputDecoration(
                                          hintText: "To Email id",
                                        ),
                                      ).pSymmetric(h: 15.0, v: 4.0),
                                      TextField(
                                        controller: controller.leaveReason,
                                        minLines: 5,
                                        maxLines: 10,
                                        decoration: const InputDecoration(
                                          hintText: "Leave Reason",
                                        ),
                                      ).pSymmetric(h: 15.0, v: 10.0),
                                    ],
                                  ),
                                ),
                              ).p24()));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: appColor.value,
                        )),
                    IconButton(
                        onPressed: () {
                          CustomWidgets.showAlertDialog(
                              title: "delete",
                              content: "Are you sure?",
                              onCancel: () {
                                Get.back();
                              },
                              onClick: () {
                                controller.deleteData(
                                    int.parse(data['LEAVEID'].toString()));
                                Get.back();
                              });
                        },
                        icon: Icon(Icons.delete, color: appColor.value)),
                  ],
                )
              : controller.selectUser.value.trim() != DataInfo.username.value &&
                      data['LEAVESTATUS'] != "A"
                  ? IconButton(
                      onPressed: () {
                        Get.bottomSheet(
                            StatusWidget(
                              data: data,
                            ),
                            isScrollControlled: true);
                      },
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: appColor.value,
                      ),
                    )
                  : const SizedBox()
        ],
      ).p8(),
    ).pSymmetric(h: 8.0, v: 4.0);
  }
}

class StatusWidget extends GetView<LeaveStatusController> {
  Map<String, dynamic> data;
  StatusWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveStatusController>(
        builder: (controller1) => Obx(() => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      "Leave Status",
                      color: appColor.value,
                      fontSize: 20,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Card(
                        child: ListTile(
                      onTap: () {
                        controller1.selectLeaveStatusId.value = 1;
                        controller.selectLeaveStatus.value = "A";
                      },
                      leading: 
                       Radio(
                        onChanged: (value) {
                          controller1.selectLeaveStatusId.value = 1;
                          controller.selectLeaveStatus.value = "A";
                        },
                        value: 1,
                        groupValue: controller1.selectLeaveStatusId.value,
                        activeColor: appColor.value,
                      ),
                      title: TextWidget(
                        "Approve",
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
                    Card(
                        child: ListTile(
                      onTap: () {
                        controller1.selectLeaveStatusId.value = 2;
                        controller.selectLeaveStatus.value = "R";
                      },
                      leading: Radio(
                        onChanged: (value) {
                          controller1.selectLeaveStatusId.value = 2;
                          controller.selectLeaveStatus.value = "R";
                        },
                        value: 2,
                        groupValue: controller1.selectLeaveStatusId.value,
                        activeColor: appColor.value,
                      ),
                      title: TextWidget(
                        "Reject",
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
                    Card(
                        child: ListTile(
                      onTap: () {
                        controller1.selectLeaveStatusId.value = 3;
                        controller.selectLeaveStatus.value = "P";
                      },
                      leading: Radio(
                        onChanged: (value) {
                          controller1.selectLeaveStatusId.value = 3;
                          controller.selectLeaveStatus.value = "P";
                        },
                        value: 3,
                        groupValue: controller1.selectLeaveStatusId.value,
                        activeColor: appColor.value,
                      ),
                      title: TextWidget(
                        "Pending",
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 8.0),
                      child: TextField(
                        controller: controller1.commentController,
                        minLines: 5,
                        maxLines: 10,
                        decoration: const InputDecoration(
                            hintText: "If rejected please give us reason.",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            )),
                        CustomButton(
                            onPressed: () {
                              if (controller.selectLeaveStatusId.value != -1) {
                                if (controller.selectLeaveStatusId.value == 2) {
                                  if (controller.commentController.text
                                      .trim()
                                      .isEmpty) {
                                    VxToast.show(context,
                                        msg: "Please give us reason.",
                                        bgColor: Colors.black,
                                        textColor: Colors.white);
                                  } else {
                                    controller1.updateStatus(data);
                                  }
                                } else {
                                  controller1.updateStatus(data);
                                }
                              } else {
                                VxToast.show(context,
                                    msg: "Please select status",
                                    bgColor: Colors.black,
                                    textColor: Colors.white);
                              }
                            },
                            text: "Submit")
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
