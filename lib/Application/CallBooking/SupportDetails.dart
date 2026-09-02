// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class SupportDetails extends GetView<SupportDetailsController> {
  const SupportDetails({super.key});

  Widget _longTextTile(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(title,
            color: titleColor, fontSize: 16, fontWeight: FontWeight.w500),
        10.heightBox,
        TextWidget(data.trim(),
            color: descriptionColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            maxLines: 100),
        5.heightBox,
        Container(width: Get.width, height: 1.0, color: Colors.grey[300]),
      ],
    ).pSymmetric(h: 16.0, v: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SupportDetailsController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Call Details",
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(
          () => Stack(
            children: [
              controller.isLoading.value == false
                  ? ListView(
                      children: [
                        tile(
                            title: "Contact Person",
                            data: controller.details['CNTPER']),
                        tile(
                            title: "Email-ID",
                            data: controller.details['CNTEMAIL']),
                        tile(
                            title: "Level Of Call",
                            data: controller.details['PRIORITY']),
                        tile(
                            title: "Call Mode",
                            data: controller.details['MODEOFCALL']),
                        tile(
                            title: "Call Status",
                            data: controller.details['SUPSTATUS']),
                        tile(
                            title: "Call Category",
                            data: controller.details['SUPCATID']),
                        tile(
                            title: "Tally Serial No",
                            data: controller.details['TALLYSRNO']),
                        tile(
                            title: "Start Time",
                            data: controller.details['STARTTIME']),
                        tile(
                            title: "End Time",
                            data: controller.details['ENDTIME']),
                        controller.details['REMARK'].toString().trim().length <
                                50
                            ? tile(
                                title: "Remark",
                                data: controller.details['REMARK'])
                            : _longTextTile(
                                "Remark", controller.details['REMARK']),
                        Check.data(controller.details['RECOMMENDATION']) &&
                                DataInfo.desCat.value == "L1"
                            ? controller.details['RECOMMENDATION']
                                        .toString()
                                        .trim()
                                        .length <
                                    50
                                ? tile(
                                    title: "Observation",
                                    data: controller.details['RECOMMENDATION'])
                                : _longTextTile("Observation",
                                    controller.details['RECOMMENDATION'])
                            : const SizedBox(),
                        Check.data(controller.details['REQUIREMENT']) &&
                                DataInfo.desCat.value == "L1"
                            ? controller.details['REQUIREMENT']
                                        .toString()
                                        .trim()
                                        .length <
                                    50
                                ? tile(
                                    title: "Requirement",
                                    data: controller.details['REQUIREMENT'])
                                : _longTextTile("Requirement",
                                    controller.details['REQUIREMENT'])
                            : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),
              controller.isLoading.value
                  ? const LoadingScreen()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
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
                      data.toString(),
                      color: descriptionColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.right,
                      maxLines: 100,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Utilities.onClickMobile(data);
                    },
                    child: TextWidget(
                      Utilities.checkString(data!) ? data : "",
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
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
