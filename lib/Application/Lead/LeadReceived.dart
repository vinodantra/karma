// ignore_for_file: file_names

import 'package:karma/Application/Lead/UpdateLead.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/leadReceivedController.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

class LeadReceived extends GetView<LeadReceivedController> {
  const LeadReceived({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeadReceivedController());
    return Scaffold(
        appBar: AppBarWidget(
          title: DataInfo.desCat.value == "L1" ? "Lead Received" : "Lead Given",
        ),
        body: Obx(() => RefreshIndicator(
              onRefresh: controller.getData,
              child: AsyncStateView(
                isLoading: controller.isLoading.value,
                hasError: controller.hasError.value,
                isEmpty: controller.list.isEmpty,
                onRetry: controller.getData,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.list.length,
                  itemBuilder: (context, int index) =>
                      _tile(controller.list[index]),
                ),
              ),
            )));
  }

  Widget _tile(var data) {
    return InkWell(
      onTap: () {
        Get.to(() => const UpdateLead(), arguments: {
          "leadData": data,
          "showData": controller.lead.value != "Given" &&
              (controller.leadType.value == "InProcess" ||
                  controller.leadType.value == "UNTOUCHED")
        })!
            .then((value) {
          controller.getData();
        });
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: cardShadowColor,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: Get.width * 0.7,
                    child: TextWidget(
                      "${data['CMPNAME']}",
                      maxLines: 2,
                      fontSize: 18,
                      color: appColor.value,
                      fontWeight: FontWeight.w500,
                    )),
                controller.lead.value != "Given" &&
                        (controller.leadType.value == "InProcess" ||
                            controller.leadType.value == "UNTOUCHED")
                    ? IconButton(
                        onPressed: () {
                          Get.dialog(Obx(() => Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextWidget(
                                        "Create Ticket",
                                        fontSize: 16,
                                        color: appColor.value,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      20.heightBox,
                                      CustomWidgets.divider(
                                          width: Get.width,
                                          height: 1,
                                          color: appColor.value),
                                      20.heightBox,
                                      TextField(
                                        controller: controller.description,
                                        minLines: 1,
                                        maxLines: 10,
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Have Description? Write Here.....",
                                            border: OutlineInputBorder()),
                                      ).pSymmetric(h: 25.0),
                                      15.heightBox,
                                      InkWell(
                                        onTap: () {
                                          CustomWidgets.customBottomSheet(
                                              controller.ticketTypeList,
                                              "TYPE",
                                              false, (data) {
                                            controller.selectTicket.value =
                                                data['TYPE'];
                                            controller.selectTicketId.value =
                                                data['ID'].toString();
                                            Get.back();
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  color:
                                                      darkGreyColor,
                                                  width: 1.0),
                                              color: Colors.white),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                controller.selectTicket.value,
                                                fontSize: 16,
                                                color: darkGreyColor,
                                              ),
                                              const Icon(Icons
                                                  .keyboard_arrow_down_outlined)
                                            ],
                                          ).pSymmetric(h: 10.0),
                                        ).pSymmetric(h: 25.0),
                                      ),
                                      15.heightBox,
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
                                                color: darkGreyColor,
                                              )),
                                          CustomButton(
                                            text: "Save",
                                            onPressed: () async {
                                              Get.back();
                                              await controller
                                                  .createTicket(data['ID']);
                                            },
                                          )
                                        ],
                                      ).pSymmetric(h: 25.0),
                                    ],
                                  ).p16(),
                                ).p16(),
                              )));
                        },
                        icon: const Icon(Icons.more_vert))
                    : const SizedBox()
              ],
            ),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  "Received",
                  fontSize: 14,
                  color: darkGreyColor,
                  fontWeight: FontWeight.w500,
                ),
                TextWidget(
                  "${data['NAME']}",
                  fontSize: 16,
                  color: mediumGreyColor,
                  fontWeight: FontWeight.w500,
                  maxLines: 5,
                )
              ],
            ),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  "Create Date",
                  fontSize: 14,
                  color: darkGreyColor,
                  fontWeight: FontWeight.w500,
                ),
                TextWidget(
                  "${data['CREATEDATE']}",
                  fontSize: 16,
                  color: mediumGreyColor,
                  fontWeight: FontWeight.w500,
                  maxLines: 5,
                )
              ],
            ),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  "Attend Date",
                  fontSize: 14,
                  color: darkGreyColor,
                  fontWeight: FontWeight.w500,
                ),
                TextWidget(
                  "${data['ATNDATE']}",
                  fontSize: 16,
                  color: mediumGreyColor,
                  fontWeight: FontWeight.w500,
                  maxLines: 5,
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Utilities.onClickMobile(data['MOB']);
                    },
                    icon: const Icon(
                      Icons.call,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      Utilities.onClickMessage(data['MOB']);
                    },
                    icon: const Icon(
                      Icons.message,
                      size: 20,
                    )),
              ],
            ),
          ],
        ).p8(),
      ).pSymmetric(v: 4.0),
    );
  }
}
