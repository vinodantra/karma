// ignore_for_file: invalid_use_of_protected_member, file_names

import 'package:flutter/services.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/createDataPointController.dart';

class CreateDataPoint extends GetView<CreateDataPointController> {
  const CreateDataPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(title: "Create Data Point"),
        body: Obx(() {
          if (controller.isLoading.value) return const LoadingScreen();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// ----------------- LEAD SOURCE ------------------
              selectItem(
                title: controller.selectLead.value,
                label: "Lead Source",
                onPressed: () {
                  CustomWidgets.customBottomSheet(
                      controller.lead, "SOURCE", false, (data) {
                    controller.selectLead.value = data['SOURCE'];
                    controller.selectLeadId.value = data['ID'];
                    Get.back();
                  });
                },
              ),

              /// ----------------- COMPANY NAME ------------------
              textField(
                  controller: controller.companyName,
                  hintText: "Company Name",
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words),
              10.heightBox,

              const Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: '* ',
                    style: TextStyle(
                        color: Color(0xFFFF1313),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text:
                        'Please double check the provided company name. Once saved, it can’t be altered again in future.',
                    style: TextStyle(
                        color: greyColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                ]),
              ),

              /// ----------------- WEBSITE ------------------
              textField(
                controller: controller.companyWebsite,
                hintText: "Company Website",
                keyboardType: TextInputType.url,
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget("https://",
                        color: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    10.widthBox,
                    CustomWidgets.divider(height: 20.0, width: 1.0),
                    10.widthBox,
                  ],
                ).pOnly(bottom: 5),
              ),

              /// ----------------- SALUTATION ------------------
              selectItem(
                title: controller.selectSalutationData.value,
                label: "Select Salutation",
                onPressed: () {
                  CustomWidgets.customBottomSheet(
                      controller.salutationList, "name", false, (data) {
                    controller.selectSalutationData.value = data['name'];
                    Get.back();
                  });
                },
              ),

              /// ----------------- CONTACT DETAILS ------------------
              textField(
                  controller: controller.contactName,
                  hintText: "Contact Name",
                  textCapitalization: TextCapitalization.words),
              10.heightBox,

              textField(
                  controller: controller.designation,
                  hintText: "Designation",
                  textCapitalization: TextCapitalization.words),
              10.heightBox,

              textField(
                  controller: controller.mobile,
                  hintText: "Mobile Number",
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 15),
              10.heightBox,

              textField(
                  controller: controller.email,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress),
              10.heightBox,

              textField(
                  controller: controller.landlineNumber,
                  hintText: "Landline Number",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 15),

              20.heightBox,

              /// ----------------- TALLY USER ------------------
              TextWidget("Is Tally User?",
                  color: blackColor, fontSize: 14, fontWeight: FontWeight.w400),

              Row(
                children: [
                  radioOption(
                    label: "Yes",
                    value: 1,
                    groupValue: controller.selectTallyUser.value,
                    onTap: () => controller.selectTallyUser.value = 1,
                  ),
                  radioOption(
                    label: "No",
                    value: 2,
                    groupValue: controller.selectTallyUser.value,
                    onTap: () => controller.selectTallyUser.value = 2,
                  ),
                ],
              ),

              /// ----------------- Tally Extra Fields ------------------
              if (controller.selectTallyUser.value == 1) ...[
                textField(
                    controller: controller.tallySerialNumber,
                    hintText: "Tally Serial Number",
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 9),
                textField(
                    controller: controller.location,
                    hintText: "Location",
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words),
                selectItem(
                  title: controller.selectProduct.value,
                  label: "Product",
                  onPressed: () {
                    CustomWidgets.customBottomSheet(
                        controller.productList, "name", false, (data) {
                      controller.selectProduct.value = data['name'];
                      Get.back();
                    });
                  },
                ),
                selectItem(
                  title: controller.selectUrt.value,
                  label: "URT",
                  onPressed: () {
                    CustomWidgets.customBottomSheet(
                        controller.urtList, "name", false, (data) {
                      controller.selectUrt.value = data['name'];
                      Get.back();
                    });
                  },
                ),
              ],

              /// ----------------- EPICENTER ------------------
              selectItem(
                title: controller.selectEpicenter.value,
                label: "Epicenter",
                onPressed: () {
                  CustomWidgets.customBottomSheet(
                      controller.epicenter, "NAME", false, (data) {
                    controller.selectEpicenter.value = data['NAME'];
                    controller.selectEpicenterId.value = data['ID'].toString();
                    Get.back();
                  });
                },
              ),

              20.heightBox,

              CustomButton(
                text: "Save",
                width: Get.width,
                onPressed: () => controller.checkData(),
              ),

              20.heightBox,
            ],
          );
        }),
      ),
    );
  }

  /// Radio Button Widget
  Widget radioOption({
    required String label,
    required int value,
    required int groupValue,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 80,
      child: InkWell(
          onTap: onTap,
          child: RadioGroup(
            groupValue: groupValue,
            onChanged: (_) => onTap(),
            child: Row(
              children: [
                Radio(
                  value: value,
                  activeColor:
                      Provider.of<AppThemeController>(Get.context!).appColor,
                ),
                TextWidget(label),
              ],
            ),
          )),
    );
  }
}
