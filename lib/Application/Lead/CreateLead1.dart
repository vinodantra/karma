// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class CreateLead1 extends GetView<CreateLeadController1> {
  const CreateLead1({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateLeadController1());
    final formKey = GlobalKey<FormState>();
    return Obx(() => PopScope(
          canPop: !controller.isLoading.value,
          child: Scaffold(
            appBar: AppBarWidget(
              title: "New Lead",
              onSubmit: () {
                if (formKey.currentState?.validate() == true) {
                  controller.checkData();
                }
              },
            ),
            body: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        selectItem(
                            title: Utilities.checkString(
                                    controller.selectLeadSourceId.value)
                                ? controller.selectLeadSourceData.value
                                : "",
                            label: "Lead Source",
                            onPressed: () {
                              CustomWidgets.customBottomSheet(
                                  controller.leadSourceList, "SOURCE", true,
                                  (data) {
                                controller.selectLeadSourceId.value = data['ID'];
                                controller.selectLeadSourceData.value =
                                    data['SOURCE'];

                                Get.back();
                              });
                            }),
                        selectItem(
                            title: Utilities.checkString(
                                    controller.selectInterestedId.value)
                                ? controller.selectInterestedData.value
                                : "",
                            label: "Interested In",
                            onPressed: () {
                              CustomWidgets.customBottomSheet(
                                  controller.interestedDataList, "SOURCE", true,
                                  (data) {
                                controller.selectInterestedId.value = data['ID'];
                                controller.selectInterestedData.value =
                                    data['SOURCE'];

                                Get.back();
                              });
                            }),
                        selectItem(
                            title:
                                Utilities.checkString(controller.selectItemId.value)
                                    ? controller.selectItemData.value
                                    : "",
                            label: "Item",
                            onPressed: () {
                              CustomWidgets.customBottomSheet(
                                  controller.itemList, "NAME", true, (data) {
                                controller.selectItemId.value = data['ID'];
                                controller.selectItemData.value = data['NAME'];
                                Get.back();
                              });
                            }),
                        _formFieldText(
                          controller: controller.companyName,
                          hintText: "Company Name",
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              requiredField(value, "Company Name"),
                        ),
                        _formFieldText(
                          controller: controller.contactName,
                          hintText: "Contact Name",
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              requiredField(value, "Contact Name"),
                        ),
                        _formFieldText(
                          controller: controller.contactNumber,
                          hintText: "Contact Number",
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: phoneField,
                        ),
                        _formFieldText(
                          controller: controller.email,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: emailField,
                        ),
                        _formFieldText(
                          controller: controller.city,
                          hintText: "City",
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) => requiredField(value, "City"),
                        ),
                        _formFieldText(
                          controller: controller.tallySerialNumber,
                          hintText: "Tally Serial Number",
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.0, color: dividerColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: TextFormField(
                            controller: controller.comment,
                            validator: (value) =>
                                requiredField(value, "Comment"),
                            decoration: const InputDecoration(
                              hintText: "Comment",
                              hintStyle: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                            minLines: 5,
                            maxLines: 50,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                          ).pSymmetric(h: 16.0, v: 8.0),
                        ).pSymmetric(v: 16.0),
                        CustomButton(
                          text: "Add",
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              controller.checkData();
                            }
                          },
                        )
                      ],
                    ).p16(),
                  ),
                  controller.isLoading.value
                      ? const LoadingScreen()
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _formFieldText({
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          onTapOutside: (event) {},
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: greyColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            counterText: "",
          ),
          keyboardType: keyboardType ?? TextInputType.name,
          textInputAction: textInputAction ?? TextInputAction.none,
          validator: validator,
        ),
        5.heightBox,
        CustomWidgets.divider(height: 1.5),
      ],
    );
  }
}
