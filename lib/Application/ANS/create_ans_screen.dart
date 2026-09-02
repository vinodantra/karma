// ignore_for_file: depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/create_ans_controller.dart';
import 'package:intl/intl.dart';

/// Screen for creating an ANS entry.
class CreateAnsScreen extends GetView<CreateAnsController> {
  const CreateAnsScreen({super.key});

  // Constants for repeated strings
  static const String nameKey = "NAME";
  static const String userNameLabel = "User Name";
  static const String ansTypeLabel = "ANS Type";
  static const String ansDateLabel = "ANS Date";
  static const String startTimeLabel = "Start Time";
  static const String endTimeLabel = "End Time";
  static const String descriptionLabel = "Description";
  static const String observationLabel = "Observation";
  static const String requirementLabel = "Requirement";

  /// Builds the Create ANS Entry screen.
  @override
  Widget build(BuildContext context) {
    Get.put(CreateAnsController());
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBarWidget(
          onBackPress: () {
            Get.back();
          },
          title: "Create ANS Entry",
          onSubmit: () {
            controller.createAns();
          },
        ),
        body: SingleChildScrollView(
          child: GetBuilder<CreateAnsController>(builder: (controller) {
            return Obx(
              () => controller.isLoading.value == false
                  ? SizedBox(
                      width: context.screenWidth,
                      height: context.screenHeight,
                      child: ListView(
                        children: [
                          selectItem(
                              title: controller.userName.value,
                              label: userNameLabel,
                              onPressed: () {
                                CustomWidgets.customBottomSheet(
                                    controller.usersList, nameKey, true,
                                    (data) {
                                  controller.userName.value = data[nameKey];
                                  controller.id.value = data['ID'].toString();
                                  Get.back();
                                });
                              }),
                          selectItem(
                              title: controller.type.value,
                              label: ansTypeLabel,
                              onPressed: () {
                                CustomWidgets.customBottomSheet(const [
                                  {nameKey: "Online"},
                                  {nameKey: "InPerson"}
                                ], nameKey, false, (data) {
                                  controller.type.value =
                                      data[nameKey].toString();
                                  Get.back();
                                });
                              }),
                          selectItem(
                            title: Utilities.checkString(
                                    controller.currentDate.value)
                                ? controller.currentDate.value
                                : "",
                            label: ansDateLabel,
                            icon: CustomWidgets.showAssetImage1(path: calendar),
                            onPressed: () async {
                              var de = await CustomWidgets.pickDate(context,
                                  selectPreviousDate: true);
                              if (de != null) {
                                controller.selectDate.value = de.toString();
                                controller.currentDate.value =
                                    DateFormat('dd MMM yyyy').format(de);
                              }
                            },
                          ),
                          selectItem(
                              title: controller.currentTime.value,
                              label: startTimeLabel,
                              icon:
                                  CustomWidgets.showAssetImage1(path: calendar),
                              onPressed: () async {
                                TimeOfDay? selectTime =
                                    await CustomWidgets.pickTime(context);
                                if (!context.mounted) return;
                                if (selectTime != null) {
                                  controller.selectTime.value =
                                      selectTime.format(context).toString();
                                  controller.currentTime.value =
                                      selectTime.format(context).toString();
                                }
                              }),
                          selectItem(
                              title: controller.currentTime1.value,
                              label: endTimeLabel,
                              icon:
                                  CustomWidgets.showAssetImage1(path: calendar),
                              onPressed: () async {
                                TimeOfDay? selectTime =
                                    await CustomWidgets.pickTime(context);
                                if (!context.mounted) return;
                                if (selectTime != null) {
                                  controller.selectTime.value =
                                      selectTime.format(context).toString();
                                  controller.currentTime1.value =
                                      selectTime.format(context).toString();
                                }
                              }),
                          commentField(
                            onChanged: controller.updateData,
                            controller: controller.desc,
                            hintText: descriptionLabel,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),

                          controller.desc.text.isNotEmpty &&
                                  controller.desc.text.trim().length >= 15
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
                                        width: 168,
                                        height: 35,
                                      ),
                                    ],
                                  ),
                                ).pSymmetric(h: 12.0)
                              : const SizedBox(),

                          ListTile(
                            onTap: () {
                              controller.changeStatue1(
                                  controller.isShowObservation.value);
                            },
                            title: TextWidget(observationLabel),
                            trailing: controller.isShowObservation.value
                                ? const Icon(Icons.keyboard_arrow_up_rounded)
                                : const Icon(
                                    Icons.keyboard_arrow_down_outlined),
                          ),

                          controller.isShowObservation.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commentField(
                                      onChanged: controller.updateData1,
                                      controller: controller.observation,
                                      hintText: observationLabel,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                    ),
                                    controller.observation.text.isNotEmpty &&
                                            controller.observation.text
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
                                                controller.observationMessage1
                                                        .value.isNotEmpty
                                                    ? CustomButton(
                                                        text: "Previous Remark",
                                                        onPressed: () {
                                                          controller
                                                              .selectData1();
                                                        },
                                                        width: 175,
                                                        height: 35,
                                                      )
                                                    : const SizedBox(),
                                                CustomButton(
                                                  text: "Enhance Text",
                                                  onPressed: () {
                                                    controller.chatGptApi1();
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
                                )
                              : const SizedBox(),
                          ListTile(
                            onTap: () {
                              controller.changeStatue2(
                                  controller.isShowRequirement.value);
                            },
                            title: TextWidget(requirementLabel),
                            trailing: controller.isShowRequirement.value
                                ? const Icon(Icons.keyboard_arrow_up_rounded)
                                : const Icon(
                                    Icons.keyboard_arrow_down_outlined),
                          ),
                          controller.isShowRequirement.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commentField(
                                      onChanged: controller.updateData2,
                                      controller: controller.requirement,
                                      hintText: requirementLabel,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                    ),
                                    controller.requirement.text.isNotEmpty &&
                                            controller.requirement.text
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
                                                controller.requirementMessage1
                                                        .value.isNotEmpty
                                                    ? CustomButton(
                                                        text: "Previous Remark",
                                                        onPressed: () {
                                                          controller
                                                              .selectData2();
                                                        },
                                                        width: 175,
                                                        height: 35,
                                                      )
                                                    : const SizedBox(),
                                                CustomButton(
                                                  text: "Enhance Text",
                                                  onPressed: () {
                                                    controller.chatGptApi2();
                                                  },
                                                  width: 168,
                                                  height: 35,
                                                ),
                                              ],
                                            ),
                                          ).pSymmetric(h: 12.0)
                                        : const SizedBox(),
                                  ],
                                )
                              : const SizedBox(),
                          20.heightBox,
                          // CustomButton(
                          //   text: "Create ANS Entry",
                          //   width: context.screenWidth,
                          //   onPressed: () {
                          //     controller.createAns();
                          //   },
                          // ),
                        ],
                      ).p12(),
                    )
                  : const SizedBox(),
            );
          }),
        ),
      ),
    );
  }
}
