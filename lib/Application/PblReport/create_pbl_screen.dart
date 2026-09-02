// ignore_for_file: depend_on_referenced_packages

import 'package:karma/Application/PblReport/PblReport.dart';
import 'package:karma/Constants/Library.dart';
import 'package:intl/intl.dart';
import '../../Controller/create_pbl_controller.dart';

class CreatePblScreen extends GetView<CreatePblController> {
  const CreatePblScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreatePblController());
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.offAll(() => const PblReport());
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Create PBL Entry",
          onSubmit: () {
            controller.createAns();
          },
        ),
        body: SingleChildScrollView(
          child: GetBuilder<CreatePblController>(builder: (controller) {
            return Obx(
              () => controller.isLoading.value == false
                  ? SizedBox(
                      width: context.screenWidth,
                      height: context.screenHeight,
                      child: ListView(
                        children: [
                          selectItem(
                              title: controller.userName.value,
                              label: "User Name",
                              onPressed: () {
                                CustomWidgets.customBottomSheet(
                                    controller.usersList, "NAME", true, (data) {
                                  controller.userName.value = data['NAME'];
                                  controller.id.value = data['ID'].toString();

                                  Get.back();
                                });
                              }),
                          selectItem(
                              title: controller.type.value,
                              label: "PBL Type",
                              onPressed: () {
                                CustomWidgets.customBottomSheet([
                                  {"NAME": "Online"},
                                  {"NAME": "InPerson"}
                                ], "NAME", false, (data) {
                                  controller.type.value =
                                      data['NAME'].toString();

                                  Get.back();
                                });
                              }),
                          selectItem(
                            title: Utilities.checkString(
                                    controller.currentDate.value)
                                ? controller.currentDate.value
                                : "",
                            label: "PBL Date",
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
                              label: "Start Time",
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
                              label: "End Time",
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Topic",
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                              commentField(
                                  onChanged: controller.updateData1,
                                  controller: controller.observation,
                                  hintText: "Please enter topic for PBL",
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  minLines: 1),
                              controller.observation.text.isNotEmpty &&
                                      controller.observation.text
                                              .trim()
                                              .length >=
                                          15
                                  ? SizedBox(
                                      width: context.screenWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          controller.observationMessage1.value
                                                  .isNotEmpty
                                              ? CustomButton(
                                                  text: "Previous Remark",
                                                  onPressed: () {
                                                    controller.selectData1();
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
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Description",
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                              commentField(
                                onChanged: controller.updateData,
                                controller: controller.desc,
                                hintText: "Please enter description for PBL",
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              ),
                            ],
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
                              controller.changeStatue2(
                                  controller.isShowRequirement.value);
                            },
                            title: TextWidget(
                              "Learning",
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
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
                                      hintText: "Learning",
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
                          150.heightBox,
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
