// ignore_for_file: file_names

import 'package:flutter_html/flutter_html.dart';
import 'package:karma/Application/Escalation/EscalationFromTicket.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/tickerDetailsController1.dart';

class TicketDetails extends GetView<TicketDetailsController1> {
  const TicketDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TicketDetailsController1());
    return Scaffold(
        appBar: AppBarWidget(
          title: "Ticket Details",
          addTooltip: "Raise Escalation",
          onPressAdd: () {
            Get.to(() => EscalationFromTicket(
                  ticketNo: controller.ticketNumber.value,
                ));
          },
        ),
        body: Obx(
          () => SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  controller.interactionList.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.interactionList.length,
                          itemBuilder: (context, int index) {
                            return tile(controller.interactionList[index]);
                          }).p16()
                      : const SizedBox(),
                  controller.isLoading.value
                      ? const LoadingScreen()
                      : const SizedBox(),
                  controller.isLoading.value == false &&
                          controller.interactionList.isEmpty
                      ? Center(
                          child: TextWidget(
                            "No data found.",
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                ],
              )),
        ));
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
                "Subject",
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
                      "Executive",
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
                      "Description",
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
