// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';

import 'package:intl/intl.dart';

class AddSupportEntry extends GetView<AddSupportEntryController> {
  const AddSupportEntry({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddSupportEntryController());
    final formKey = GlobalKey<FormState>();
    return Obx(
      () => PopScope(
        canPop: !controller.isLoading.value,
        child: Scaffold(
          appBar: AppBarWidget(
            title: "Add Support Entry",
            onSubmit: () {
              if (formKey.currentState?.validate() == true) {
                controller.updateStatus();
              }
            },
          ),
          body: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  tile(title: "Company Name", data: controller.data['CMP']),
                  tile(title: "CheckIn Time", data: controller.data['CHKIN']),
                  tile(title: "CheckOut Time", data: controller.data['CHKOUT']),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            "Tally Serial",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                              width: Get.width / 2,
                              height: 50,
                              child: TextFormField(
                                controller: controller.tallySerialController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                validator: (value) =>
                                    requiredField(value, "Tally Serial"),
                              )),
                        ],
                      ).pSymmetric(
                        h: 15.0,
                      ),
                      5.heightBox,
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[300],
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
                            "Ticket Number",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                              width: Get.width / 2,
                              height: 50,
                              child: TextField(
                                controller: controller.tallyNumberController,
                                onTap: () {
                                  controller.tallyNoController.clear();

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
                                                  CustomWidgets
                                                      .customBottomSheet(
                                                          controller
                                                              .ticketTypeList,
                                                          "NAME",
                                                          false, (data) {
                                                    controller.selectTicketType
                                                        .value = data['NAME'];
                                                    controller
                                                        .selectTicketTypeId
                                                        .value = data['ID'];
                                                    Get.back();
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                      controller
                                                          .selectTicketType
                                                          .value,
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
                                                    controller.selectDate
                                                        .value = de.toString();

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
                                                      controller.selectTallyDate
                                                          .value,
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
                                                      controller
                                                              .tallyNoController
                                                              .text !=
                                                          "") {
                                                    controller
                                                            .tallyNumberController
                                                            .text =
                                                        "${controller.selectTicketType.value}-${controller.tallyDate.value.toUpperCase()}-${controller.tallyNoController.text}";

                                                    Get.back();
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
                                readOnly: true,
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                              )),
                        ],
                      ).pSymmetric(
                        h: 15.0,
                      ),
                      5.heightBox,
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Type of Call",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          InkWell(
                            onTap: () {
                              CustomWidgets.customBottomSheet(
                                  controller.data['TEAMID'] != "1"
                                      ? controller.typeOfCallList
                                      : controller.typeOfCallList1,
                                  "NAME",
                                  false, (data) {
                                controller.selectTypeOfCall.value =
                                    data['NAME'];
                                controller.selectTypeOfCallId.value =
                                    data['ID'];
                                Get.back();
                              });
                            },
                            child: Row(
                              children: [
                                TextWidget(
                                  controller.selectTypeOfCall.value,
                                  fontSize: 14,
                                  color: darkTextColor,
                                ),
                                5.widthBox,
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 15.0, v: 10.0),
                      5.heightBox,
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  controller.data['TEAMID'] == "1"
                      ? Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "Level of Call",
                                      color: titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CustomWidgets.customBottomSheet(
                                            controller.levelList, "NAME", false,
                                            (data) {
                                          controller.selectLevel.value =
                                              data['NAME'];
                                          controller.selectLevelId.value =
                                              data['ID'];
                                          Get.back();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            controller.selectLevel.value,
                                            fontSize: 14,
                                            color: darkTextColor,
                                          ),
                                          5.widthBox,
                                          const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: iconColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ).pSymmetric(h: 15.0, v: 10.0),
                                5.heightBox,
                                Container(
                                  width: Get.width,
                                  height: 1.0,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "Category",
                                      color: titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        
                                        CustomWidgets.customBottomSheet(
                                            controller.categoryList,
                                            "NAME",
                                            true, (data) {
                                          controller.selectCategory.value =
                                              data['NAME'];
                                          controller.selectCategoryId.value =
                                              data['ID'];
                                          Get.back();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            controller.selectCategory.value,
                                            fontSize: 14,
                                            color: darkTextColor,
                                          ),
                                          5.widthBox,
                                          const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: iconColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ).pSymmetric(h: 15.0, v: 10.0),
                                5.heightBox,
                                Container(
                                  width: Get.width,
                                  height: 1.0,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "Status",
                                      color: titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CustomWidgets.customBottomSheet(
                                            controller.statusList,
                                            "NAME",
                                            false, (data) {
                                          controller.selectStatus.value =
                                              data['NAME'];
                                          controller.selectStatusId.value =
                                              data['ID'];
                                          Get.back();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            controller.selectStatus.value,
                                            fontSize: 14,
                                            color: darkTextColor,
                                          ),
                                          5.widthBox,
                                          const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: iconColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ).pSymmetric(h: 15.0, v: 10.0),
                                5.heightBox,
                                Container(
                                  width: Get.width,
                                  height: 1.0,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                            controller.selectStatusId.value == "2"
                                ? CheckboxListTile(
                                    value: controller.experienceTicket.value,
                                    onChanged: (value) {
                                      controller.experienceTicket.value =
                                          value!;
                                    },
                                    contentPadding: const EdgeInsets.all(2),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: TextWidget(
                                      "Experience Ticket",
                                      fontSize: 16,
                                    ),
                                  )
                                : const SizedBox(),
                            Container(
                              width: Get.width,
                              height: 1.0,
                              color: Colors.grey[300],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  tile(
                      title: "Contact Person",
                      data: controller.data['CNTPERSON'].toString()),
                  tile(
                      title: "Contact Email",
                      data: controller.data['ALTEREMAILID'].toString()),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            "Attend Person",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                              width: Get.width / 2,
                              height: 50,
                              child: TextFormField(
                                controller: controller.name,
                                keyboardType: TextInputType.name,
                                textAlign: TextAlign.right,
                                validator: (value) =>
                                    requiredField(value, "Attend Person"),
                              )),
                        ],
                      ).pSymmetric(
                        h: 15.0,
                      ),
                      5.heightBox,
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[300],
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
                            "Attend Person Email",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                              width: Get.width / 2,
                              height: 50,
                              child: TextFormField(
                                controller: controller.email,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.right,
                                validator: emailField,
                              )),
                        ],
                      ).pSymmetric(
                        h: 15.0,
                      ),
                      5.heightBox,
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                      GetBuilder<AddSupportEntryController>(
                        builder: (controller) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onChanged: controller.updateData,
                              controller: controller.remark,
                              validator: (value) =>
                                  requiredField(value, "Remark"),
                              decoration: const InputDecoration(
                                  hintText: "Visit/Support remark",
                                  hintStyle: TextStyle(
                                    color: titleColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLines: 10,
                              maxLength: 4000,
                            ).pSymmetric(h: 15.0, v: 8.0),
                            controller.remark.text.isNotEmpty &&
                                    controller.remark.text.trim().length >= 15
                                ? SizedBox(
                                    width: context.screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        controller.message1.value.isNotEmpty
                                            ? CustomButton(
                                                text: "Previous Remark",
                                                onPressed: () {
                                                  controller.selectData();
                                                },
                                                width: 175,
                                                height: 35,
                                              )
                                            : const SizedBox(),
                                        CustomButton(
                                          text: "Enhance Text",
                                          onPressed: () {
                                            controller.chatGptApi();
                                          },
                                          width: 175,
                                          height: 35,
                                        ),
                                      ],
                                    ),
                                  ).pSymmetric(h: 12.0)
                                : const SizedBox(),
                            DataInfo.desCat.value == "L1"
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          controller.changeStatus1(controller
                                              .isShowObservation.value);
                                        },
                                        title: TextWidget(
                                          "Observation",
                                          color: titleColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        trailing: controller
                                                .isShowObservation.value
                                            ? const Icon(
                                                Icons.keyboard_arrow_up_rounded)
                                            : const Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                      ),
                                      controller.isShowObservation.value
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                commentField(
                                                    onChanged:
                                                        controller.updateData1,
                                                    controller:
                                                        controller.observation,
                                                    hintText: "Observation",
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.newline,
                                                    maxLength: 1000),
                                                controller.observation.text
                                                            .isNotEmpty &&
                                                        controller.observation
                                                                .text
                                                                .trim()
                                                                .length >=
                                                            15
                                                    ? SizedBox(
                                                        width:
                                                            context.screenWidth,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            controller
                                                                    .observationMessage1
                                                                    .value
                                                                    .isNotEmpty
                                                                ? CustomButton(
                                                                    text:
                                                                        "Previous Remark",
                                                                    onPressed:
                                                                        () {
                                                                      controller
                                                                          .selectData1();
                                                                    },
                                                                    width: 175,
                                                                    height: 35,
                                                                  )
                                                                : const SizedBox(),
                                                            CustomButton(
                                                              text:
                                                                  "Enhance Text",
                                                              onPressed: () {
                                                                controller
                                                                    .chatGptApi1();
                                                              },
                                                              width: 168,
                                                              height: 35,
                                                            ),
                                                          ],
                                                        ),
                                                      ).pSymmetric(h: 12.0)
                                                    : const SizedBox(),
                                                5.heightBox,
                                              ],
                                            ).pSymmetric(h: 15.0)
                                          : const SizedBox(),
                                      ListTile(
                                        onTap: () {
                                          controller.changeStatus2(controller
                                              .isShowRequirement.value);
                                        },
                                        title: TextWidget(
                                          "Requirement",
                                          color: titleColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        trailing: controller
                                                .isShowRequirement.value
                                            ? const Icon(
                                                Icons.keyboard_arrow_up_rounded)
                                            : const Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                      ),
                                      controller.isShowRequirement.value
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                commentField(
                                                    onChanged:
                                                        controller.updateData2,
                                                    controller:
                                                        controller.requirement,
                                                    hintText: "Requirement",
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.newline,
                                                    maxLength: 1000),
                                                controller.requirement.text
                                                            .isNotEmpty &&
                                                        controller.requirement
                                                                .text
                                                                .trim()
                                                                .length >=
                                                            15
                                                    ? SizedBox(
                                                        width:
                                                            context.screenWidth,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            controller
                                                                    .requirementMessage1
                                                                    .value
                                                                    .isNotEmpty
                                                                ? CustomButton(
                                                                    text:
                                                                        "Previous Remark",
                                                                    onPressed:
                                                                        () {
                                                                      controller
                                                                          .selectData2();
                                                                    },
                                                                    width: 175,
                                                                    height: 35,
                                                                  )
                                                                : const SizedBox(),
                                                            CustomButton(
                                                              text:
                                                                  "Enhance Text",
                                                              onPressed: () {
                                                                controller
                                                                    .chatGptApi2();
                                                              },
                                                              width: 168,
                                                              height: 35,
                                                            ),
                                                          ],
                                                        ),
                                                      ).pSymmetric(h: 12.0)
                                                    : const SizedBox(),
                                              ],
                                            ).pSymmetric(h: 15.0)
                                          : const SizedBox(),
                                    ],
                                  )
                                : const SizedBox(),
                            20.heightBox,
                          ],
                        ),
                      ),
                      5.heightBox,
                      Container(
                        width: Get.width,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      var status = !controller.isCCEmail.value;
                      controller.checkEmailStatus(status);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          TextWidget(
                            "Send Email",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ).pOnly(left: 15.0),
                          Checkbox(
                              value: controller.isCCEmail.value,
                              onChanged: (value) {
                                controller.checkEmailStatus(value!);
                              }),
                        ],
                      ),
                    ),
                  ),
                  controller.isCCEmail.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            5.heightBox,
                            TextWidget(
                              "Your remark will be emailed to the customer and CC, with attached file.",
                              color: Colors.red,
                              fontSize: 14,
                              maxLines: 2,
                            ).pOnly(left: 15.0),
                            5.heightBox,
                            controller.ccEmailList.isNotEmpty
                                ? Container(
                                    width: context.screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[400]!, width: 0.5),
                                    ),
                                    child: Wrap(
                                      children: List.generate(
                                          controller.ccEmailList.length,
                                          (int index) {
                                        return Chip(
                                          elevation: 2,
                                          padding: const EdgeInsets.all(8),
                                          backgroundColor: Colors.grey[100],
                                          // shadowColor: Colors.black,
                                          //CircleAvatar
                                          label: Text(
                                            controller.ccEmailList[index]
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          onDeleted: () {
                                            controller.removeCCEmail(index);
                                          }, //Text
                                        ).pOnly(right: 5.0);
                                      }),
                                    ).p2(),
                                  ).pSymmetric(h: 15.0)
                                : const SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Get.width * 0.65,
                                    child: TextField(
                                      controller: controller.ccEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      enableSuggestions: false,
                                      decoration: const InputDecoration(
                                          hintText: "Add 1 email at a time"),
                                    )),
                                OutlinedButton(
                                    onPressed: () {
                                      controller.addCCEmail();
                                    },
                                    style: const ButtonStyle(),
                                    child: const Text("Add CC")),
                                // TextButton(onPressed: (){
                                //   controller.addCCEmail();
                                // }, child: TextWidget("Add CC")),
                                // IconButton(
                                //   onPressed: () {
                                //     controller.addCCEmail();
                                //   },
                                //   icon: const Icon(Icons.arrow_right_alt_outlined),
                                // ),
                              ],
                            ).pSymmetric(
                              h: 15.0,
                            ),
                            5.heightBox,
                            Container(
                              width: Get.width,
                              height: 1.0,
                              color: Colors.grey[300],
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () {
                                    controller.pickMultipleFiles();
                                  },
                                  label: TextWidget(
                                    "Attachment",
                                    color:
                                        Provider.of<AppThemeController>(context)
                                            .appColor,
                                    fontSize: 16,
                                  ),
                                  icon: Icon(
                                    Icons.attach_file_rounded,
                                    color:
                                        Provider.of<AppThemeController>(context)
                                            .appColor,
                                  ),
                                )),
                            SizedBox(
                              width: context.screenWidth,
                              child: Wrap(
                                children: List.generate(
                                    controller.selectFile.length, (int index) {
                                  return Chip(
                                    elevation: 2,
                                    padding: const EdgeInsets.all(8),
                                    backgroundColor: Colors.grey[100],
                                    // shadowColor: Colors.black,
                                    //CircleAvatar

                                    label: Row(
                                      children: [
                                        SvgPicture.asset(
                                          controller.getFileIcon(controller
                                              .selectFile[index].extension
                                              .toString()),
                                          width: 30,
                                          height: 30,
                                        ),
                                        10.widthBox,
                                        SizedBox(
                                          width: context.screenWidth * 0.6,
                                          child: Text(
                                            controller.selectFile[index].name,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onDeleted: () {
                                      controller.removeFile(index);
                                    }, //Text
                                  ).pOnly(bottom: 5.0);
                                }),
                              ).p2(),
                            ).pSymmetric(h: 15.0)
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tile({String? title, String? data, String type = "1"}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title,
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            type == "1"
                ? SizedBox(
                    width: Get.width / 2,
                    child: TextWidget(
                      data,
                      color: descriptionColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.right,
                      maxLines: 10,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Utilities.onClickMobile(data!);
                    },
                    child: TextWidget(
                      data,
                      color: Colors.lightBlueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
          ],
        ).pSymmetric(h: 15.0, v: 10.0),
        5.heightBox,
        Container(
          width: Get.width,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
