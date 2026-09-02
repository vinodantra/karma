// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/createTicketController.dart';

class CreateTicket extends GetView<CreateTicketController> {
  const CreateTicket({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateTicketController());
    final formKey = GlobalKey<FormState>();
    return Obx(() => PopScope(
          canPop: !controller.isLoading.value,
          child: Scaffold(
              appBar: AppBarWidget(
                title: "Create Ticket",
              ),
              body: GetBuilder<CreateTicketController>(
                builder: (controller) => controller.isLoading.value == false
                    ? Form(
                        key: formKey,
                        child: ListView(
                          children: [
                            selectItem(
                                title: Utilities.checkString(
                                        controller.selectCategory.value)
                                    ? controller.selectCategory.value
                                    : "",
                                label: "Select To Department",
                                onPressed: () {
                                  CustomWidgets.customBottomSheet(
                                      controller.categoryList, "Name", false,
                                      (data) {
                                    controller.selectCategoryData(data);

                                    Get.back();
                                  });
                                }),
                            selectItem(
                                title: Utilities.checkString(
                                        controller.selectSubjectData.value)
                                    ? controller.selectSubjectData.value
                                    : "",
                                label: "Select Subject",
                                onPressed: () {
                                  CustomWidgets.customBottomSheet(
                                      controller.subjectList, "Category", false,
                                      (data) {
                                    controller.selectSubject(data);

                                    Get.back();
                                  });
                                }),
                            selectItem(
                                title: Utilities.checkString(
                                        controller.selectPriority.value)
                                    ? controller.selectPriority.value
                                    : "",
                                label: "Select Priority",
                                onPressed: () {
                                  CustomWidgets.customBottomSheet(
                                      controller.priorityList, "Name", false,
                                      (data) {
                                    controller.selectPriorityData(data);

                                    Get.back();
                                  });
                                }),
                            Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1.0, color: dividerColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: TextFormField(
                                onChanged: controller.updateData,
                                controller: controller.description,
                                validator: (value) =>
                                    requiredField(value, "Description"),
                                decoration: const InputDecoration(
                                  hintText: "Description",
                                  hintStyle: TextStyle(
                                    color: greyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                ),
                                minLines: 5,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              ).pSymmetric(h: 16.0, v: 8.0),
                            ).pSymmetric(v: 16.0),
                            controller.description.text.isNotEmpty &&
                                    controller.description.text.trim().length >= 15
                                ? SizedBox(
                                    width: context.screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        controller.message1.value.isNotEmpty
                                            ? CustomButton(
                                                text: "Previous Description",
                                                onPressed: () {
                                                  controller.selectData();
                                                },
                                                width: 175,
                                                height: 35,
                                              )
                                            : const SizedBox(),
                                        CustomButton(
                                          text: "Enhance Text ",
                                          onPressed: () {
                                            controller.getChatGptData();
                                          },
                                          width: 175,
                                          height: 35,
                                        ),
                                      ],
                                    ))
                                : const SizedBox(),
                            20.heightBox,
                            CustomButton(
                              text: "Create Ticket",
                              width: context.screenWidth,
                              onPressed: () {
                                if (formKey.currentState?.validate() == true) {
                                  controller.createTicket();
                                }
                              },
                            ),
                          ],
                        ).p16(),
                      )
                    : const LoadingScreen(),
              )),
        ));
  }
}
