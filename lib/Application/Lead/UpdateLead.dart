// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

import 'package:karma/Controller/updateLeadController.dart';

class UpdateLead extends GetView<UpdateLeadController> {
  const UpdateLead({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UpdateLeadController());
    return Scaffold(
      appBar: AppBarWidget(
        title: DataInfo.desCat.value == "L1" ? "Lead Received" : "Lead Given",
        onSubmit: controller.showData.value
            ? () {
                controller.updateData();
              }
            : null,
      ),
      body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(() => Stack(
                children: [
                  controller.isLoading.value == false
                      ? ListView(
                          children: [
                            tile(
                              title: "Company Name",
                              data: controller.args['CMPNAME'],
                            ),
                            tile(
                              title: "Contact Name",
                              data: controller.args['NAME'],
                            ),
                            tile(
                              title: "Contact Number",
                              data: controller.args['MOB'],
                            ),
                            tile(
                              title: "Email-ID",
                              data: controller.args['EMAIL'],
                            ),
                            tile(
                              title: "City",
                              data: controller.leadData['CITY'].toString(),
                            ),
                            tile(
                              title: "Lead Source",
                              data: controller.leadData['LEADSRC'].toString(),
                            ),
                            tile(
                              title: "Tally Serial No",
                              data: controller.leadData['TALLYSRNO'].toString(),
                            ),
                            tile(
                              title: "User Name",
                              data: controller.leadData['UNAME'].toString(),
                            ),
                            tile(
                              title: "Comment",
                              data: controller.leadData['COMMENT'].toString(),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "status",
                                      color: titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (controller.showData.value) {
                                          CustomWidgets.customBottomSheet(
                                              controller.status, "NAME", false,
                                              (data) {
                                            controller.selectStatus.value =
                                                data['NAME'];
                                            controller.selectStatusId.value =
                                                data['ID'];

                                            Get.back();
                                          });
                                        }
                                      },
                                      child: ColoredBox(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            TextWidget(
                                              controller.selectStatus.value,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            const Icon(Icons
                                                .keyboard_arrow_down_outlined)
                                          ],
                                        ),
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
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  "Comment",
                                  color: titleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ).p8(),
                                TextField(
                                  controller: controller.comment,
                                  minLines: 5,
                                  maxLines: 20,
                                  readOnly: !controller.showData.value,
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Write Additional details/Comment here ",
                                  ),
                                ).pSymmetric(h: 8.0),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  controller.isLoading.value
                      ? const LoadingScreen()
                      : const SizedBox(),
                ],
              ))),
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
          color: Colors.grey[400],
        ),
      ],
    );
  }
}
