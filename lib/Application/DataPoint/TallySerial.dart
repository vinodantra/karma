// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class TallySerial extends GetView<TallySerialController> {
  const TallySerial({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TallySerialController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Tally Serial",
      ),
      body: Obx(() => Stack(
            children: [
              SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: controller.tallySerialList.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.tallySerialList.length,
                          itemBuilder: (context, index) {
                            return tile(
                                controller.tallySerialList[index], index);
                          })
                      : controller.isLoading.value == false
                          ? Center(
                              child: TextWidget(
                              "No data found",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ))
                          : const SizedBox()),
              controller.isLoading.value
                  ? const LoadingScreen()
                  : const SizedBox(),
            ],
          )),
    );
  }

  Widget tile(
    var data,
    int i,
  ) {
    return InkWell(
      onTap: () {},
      child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xffeaecf0),
              width: 1,
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Provider.of<AppThemeController>(Get.context!)
                          .appGradientColor
                          .first
                          .withValues(alpha: 0.1),
                      Provider.of<AppThemeController>(Get.context!)
                          .appGradientColor[1]
                          .withValues(alpha: 0.1)
                    ]),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 247,
                      child: TextWidget(
                        data['MULTIUSER']?.toString() ?? 'Unknown',
                        color: appColor.value,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ).pOnly(left: 16.0),
              ),
              Container(
                width: Get.width,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: dividerColor),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      'Serial Number',
                      color: greyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    10.heightBox,
                    SelectableText(
                      data['NAME']?.toString() ?? 'N/A',
                    ),
                    15.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              'Location',
                              color: greyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            10.heightBox,
                            TextWidget(
                              data['LOCATION']?.toString() ?? 'N/A',
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              'TNS Date',
                              color: greyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            10.heightBox,
                            TextWidget(
                              data['TNSDT']?.toString() ?? 'N/A',
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              'ASC Date',
                              color: greyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            10.heightBox,
                            TextWidget(
                              data['ASCDT'],
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ).p16(),
              ),
            ],
          )).p8(),
    );
  }
}
