// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

/// Screen for creating a new lead.
class CreateLead extends GetView<CreateLeadController> {
  /// Constructor for CreateLead.
  const CreateLead({super.key});

  // Static constants for repeated strings
  static const String newLeadTitle = "New Lead";
  static const String interestedIn = "Interested In";
  static const String leadSource = "Lead Source";
  static const String item = "Item";
  static const String companyName = "Company Name";
  static const String contactName = "Contact Name";
  static const String contactNumber = "Contact Number";
  static const String email = "Email";
  static const String city = "City";
  static const String tallySerialNumber = "Tally Serial Number";
  static const String comment = "Comment";
  static const String commentHint = "Write Additional detail/Comment here";

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CreateLeadController>()) {
      Get.put(CreateLeadController());
    }
    final formKey = GlobalKey<FormState>();
    return Obx(() => PopScope(
          canPop: !controller.isLoading.value,
          child: Scaffold(
            appBar: AppBarWidget(
              title: newLeadTitle,
              onSubmit: () {
                if (formKey.currentState?.validate() == true) {
                  controller.checkData();
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
                    tile(
                      title: interestedIn,
                      list: controller.list,
                      type: "3",
                      selectData: controller.selectData.value,
                      pa: "SOURCE",
                      updateData: (data) {
                        controller.selectId.value = data['ID'];
                        controller.selectData.value = data['SOURCE'];
                      },
                    ),
                    tile(title: leadSource, data: "Cust. Reference"),
                    tile(
                      title: item,
                      list: controller.itemList,
                      type: "3",
                      selectData: controller.selectItem.value,
                      pa: "NAME",
                      updateData: (data) {
                        controller.selectItemId.value = data['ID'];
                        controller.selectItem.value = data['NAME'];
                      },
                    ),
                    tile(
                        title: companyName,
                        data: controller.data['CMP']?.toString()),
                    _formFieldSection(
                      label: contactName,
                      controller: controller.contactName,
                      validator: (value) =>
                          requiredField(value, contactName),
                    ),
                    _formFieldSection(
                      label: contactNumber,
                      controller: controller.contactNumber,
                      keyboardType: TextInputType.number,
                      validator: phoneField,
                    ),
                    _formFieldSection(
                      label: email,
                      controller: controller.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailField,
                    ),
                    _formFieldSection(
                      label: city,
                      controller: controller.city,
                      validator: (value) => requiredField(value, city),
                    ),
                    tile(
                        title: tallySerialNumber,
                        data: controller.data['TALLYSRLNO']?.toString()),
                    TextWidget(
                      comment,
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ).pSymmetric(h: 15.0, v: 10.0),
                    TextFormField(
                      controller: controller.remark,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(hintText: commentHint),
                      minLines: 10,
                      maxLines: 10,
                      validator: (value) => requiredField(value, comment),
                    ).pSymmetric(h: 15.0, v: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  /// Widget for a single form field section.
  static Widget _formFieldSection({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              label,
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              width: Get.width / 2,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType ?? TextInputType.name,
                textAlign: TextAlign.right,
                validator: validator,
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
    );
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
