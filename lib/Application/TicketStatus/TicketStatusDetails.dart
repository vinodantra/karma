// ignore_for_file: file_names

import 'package:flutter_html/flutter_html.dart';

import '../../Constants/Library.dart';
import '../../Controller/ticketDetailsController.dart';
import '../Escalation/EscalationTicketForm.dart';

class TicketStatusDetails extends GetView<TicketDetailsController> {
  const TicketStatusDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TicketDetailsController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Details",
        addTooltip: "Raise Escalation",
        onPressAdd: () {
          Get.to(() => EscalationTicketForm(
                presetDpId: (controller.args['DPID'] ?? '').toString(),
                presetCustomerName: (controller.args['NAME'] ?? '').toString(),
                presetTicketNo: (controller.args['TICKET'] ?? '').toString(),
                presetTicketDate: (controller.args['DATE'] ?? '').toString(),
              ));
        },
      ),
      body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(
            () => controller.isLoading.value == false
                ? ListView(
                    children: [
                      TextWidget(
                        controller.ticketData['number'],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      10.heightBox,
                      Column(
                          children: List.generate(
                              controller.interactionList.length,
                              (index) =>
                                  tile(controller.interactionList[index]))),
                    ],
                  ).p16()
                : const LoadingScreen(),
          )),
    );
  }

  Widget tile(var data) {
    return Container(
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
        color: Utilities.checkString(data['excecutive'])
            ? Colors.white
            : const Color(0xffE8F9FF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                data['int_no'].toString().toLowerCase() != "customer"
                    ? "Interaction ${data['int_no']}"
                    : "${data['int_no']}",
                fontSize: 18,
                color: appColor.value,
                fontWeight: FontWeight.w500,
              ),
              TextWidget(
                "${data['date']}",
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          5.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "Subject : ",
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              10.widthBox,
              SizedBox(
                  width: Get.width * 0.6,
                  child: TextWidget(
                    "${data['subject'].trim()}",
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    maxLines: 5,
                  )),
            ],
          ),
          5.heightBox,
          Utilities.checkString(data['excecutive'])
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Executive : ",
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    5.widthBox,
                    SizedBox(
                        width: Get.width * 0.5,
                        child: TextWidget(
                          "${data['excecutive'].trim()}",
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                          maxLines: 50,
                        )),
                    5.heightBox,
                  ],
                )
              : TextWidget(
                  "Reply from Customer",
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          5.heightBox,
          Utilities.checkString(data['desc'])
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Description : ",
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    5.heightBox,
                    SizedBox(
                        width: Get.width * 0.85,
                        child: !controller.isHtml(data['desc'].trim())
                            ? TextWidget(
                                "${data['desc'].trim()}",
                                fontSize: 14,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                                maxLines: 50,
                              )
                            : Html(
                                data: "${data['desc'].trim()}",
                              )),
                    5.heightBox,
                  ],
                )
              : const SizedBox(),
        ],
      ).p8(),
    ).pSymmetric(v: 4.0);
  }
}
