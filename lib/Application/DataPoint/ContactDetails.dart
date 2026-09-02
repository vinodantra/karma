// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class ContactDetails extends GetView<ContactDetailsController> {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactDetailsController());
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Contact Details',
        onPressAdd: () {
          customBottomSheet(
              title: "Add Contact",
              widget: Obx(() => Container(
                  width: Get.width,
                  constraints: const BoxConstraints(minHeight: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            "Salutation",
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          InkWell(
                            onTap: () {
                              CustomWidgets.customBottomSheet(
                                  controller.salutationList, "NAME", false,
                                  (data) {
                                controller.selectSalutation.value =
                                    data['NAME'];

                                controller.getData();
                                Get.back();
                              });
                            },
                            child: Row(
                              children: [
                                TextWidget(
                                  controller.selectSalutation.value,
                                  color: greyColor,
                                  fontSize: 16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: iconColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(v: 10.0),
                      CustomWidgets.divider(height: 1.5),
                      textField(controller: controller.name, hintText: "Name")
                          .pSymmetric(v: 5.0),
                      textField(controller: controller.email, hintText: "Email")
                          .pSymmetric(v: 5.0),
                      textField(
                              controller: controller.mobile, hintText: "Mobile")
                          .pSymmetric(v: 5.0),
                      textField(
                              controller: controller.designation,
                              hintText: "Designation")
                          .pSymmetric(v: 5.0),
                      20.heightBox,
                      CustomButton(
                        text: "Add",
                        width: Get.width,
                        onPressed: () {
                          if (controller.selectSalutation.value
                              .trim()
                              .isEmpty) {
                            VxToast.show(context,
                                msg: "Please select Salutation.",
                                bgColor: Colors.black,
                                textColor: Colors.white);
                          } else if (controller.email.text.trim().isEmpty) {
                            VxToast.show(context,
                                msg: "Please enter email.",
                                bgColor: Colors.black,
                                textColor: Colors.white);
                          } else if (controller.name.text.trim().isEmpty) {
                            VxToast.show(context,
                                msg: "Please enter name.",
                                bgColor: Colors.black,
                                textColor: Colors.white);
                          } else if (controller.designation.text
                              .trim()
                              .isEmpty) {
                            VxToast.show(context,
                                msg: "Please enter designation.",
                                bgColor: Colors.black,
                                textColor: Colors.white);
                          } else {
                            controller.addContact(context);
                          }
                        },
                      )
                    ],
                  )).scrollVertical()));
        },
      ),
      body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(() => Stack(
                children: [
                  ListView(
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                          controller.contactList.length,
                          (index) =>
                              tileWidget(controller.contactList[index]))).p8(),
                  controller.isLoading.value
                      ? const LoadingScreen()
                      : const SizedBox(),
                ],
              ))),
    );
  }

  Widget tileWidget(var data) {
    return Utilities.checkString(data['CNTNAME']) ||
            Utilities.checkString(data['MOBILE'].toString().trim()) ||
            Utilities.checkString(data['Name'].toString().trim())
        ? Container(
            width: Get.width,
            decoration: shapeDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded).circle(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                    ),
                    10.widthBox,
                    TextWidget(
                      data['CNTNAME'],
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Utilities.checkString(data['MOBILE'].toString().trim())
                    ? data['MOBILE'].toString().trim().length >= 8
                        ? Row(
                            children: [
                              CustomWidgets.showSvgImage(path: callIcon1),
                              10.widthBox,
                              InkWell(
                                onTap: () {
                                  Utilities.onClickMobile(
                                      data['MOBILE'].toString().trim());
                                },
                                child: GradientTextWidget(
                                  data['MOBILE'].toString().trim(),
                                  color: Colors.lightBlueAccent,
                                  fontSize: 16,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(
                            height: 10.0,
                          )
                    : const SizedBox(
                        height: 8.0,
                      ),
                Utilities.checkString(data['Name'].toString().trim())
                    ? data['Name'].toString().trim().isEmail
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: CustomWidgets.showAssetImage(
                                    path: mailBrochure),
                              ),
                              20.widthBox,
                              InkWell(
                                onTap: () {
                                  Utilities.onClickEmail(
                                      data['Name'].toString().trim());
                                },
                                child: GradientTextWidget(
                                  data['Name'],
                                  fontSize: 16,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox()
                    : const SizedBox(),
                10.heightBox,
              ],
            ).p16(),
          ).p8()
        : const SizedBox();
  }
}
