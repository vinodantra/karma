// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:karma/Application/Lead/LeadReceived.dart';
import 'package:karma/Constants/Library.dart';

class Lead extends GetView<LeadController> {
  const Lead({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LeadController>()) {
      Get.put(LeadController());
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: "Lead",
        onPressAdd: () {
          Get.to(() => const CreateLead1());
        },
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(() => Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.selectFilterData.value = "Given";
                            controller.getData();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: controller.selectFilterData.value ==
                                    "Given"
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: Provider.of<AppThemeController>(
                                                context)
                                            .appGradientColor),
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: GradientBoxBorder(
                                      gradient: LinearGradient(
                                          colors:
                                              Provider.of<AppThemeController>(
                                                      context)
                                                  .appGradientColor),
                                      width: 1.5,
                                    ),
                                  ),
                            alignment: Alignment.center,
                            child: controller.selectFilterData.value == "Given"
                                ? TextWidget(
                                    "Given",
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 12,
                                    //fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                  )
                                : GradientText(
                                    "Given",
                                    gradient: LinearGradient(
                                        colors: Provider.of<AppThemeController>(
                                                context)
                                            .appGradientColor),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                        20.widthBox,
                        InkWell(
                          onTap: () {
                            controller.selectFilterData.value = "Received";
                            controller.getData();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: controller.selectFilterData.value ==
                                    "Received"
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: Provider.of<AppThemeController>(
                                                context)
                                            .appGradientColor),
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: GradientBoxBorder(
                                      gradient: LinearGradient(
                                          colors:
                                              Provider.of<AppThemeController>(
                                                      context)
                                                  .appGradientColor),
                                      width: 1.5,
                                    ),
                                  ),
                            alignment: Alignment.center,
                            child: controller.selectFilterData.value ==
                                    "Received"
                                ? TextWidget(
                                    "Received",
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 12,
                                    //fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                  )
                                : GradientText(
                                    "Received",
                                    gradient: LinearGradient(
                                        colors: Provider.of<AppThemeController>(
                                                context)
                                            .appGradientColor),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    10.heightBox,
                    Check.data(controller.leadData)
                        ? Wrap(
                            runAlignment: WrapAlignment.spaceBetween,
                            spacing: 5.0,
                            runSpacing: 10.0,
                            children: [
                              tile(
                                  "Accepted",
                                  controller.leadData['ACCEPTED'].toString(),
                                  acceptLead,
                                  const Color(0xFFEEFFF5),
                                  "Accepted"),
                              tile(
                                  "Rejected",
                                  controller.leadData['REJECT'].toString(),
                                  rejectLead,
                                  const Color(0xFFFFEEEE),
                                  "Rejected"),
                              tile(
                                  "In progress",
                                  controller.leadData['INPROCESS'].toString(),
                                  inProgressLead,
                                  const Color(0xFFFEFBEF),
                                  "InProcess"),
                              tile(
                                  "Untouched",
                                  controller.leadData['UNTOUCHED'].toString(),
                                  untouchedLead,
                                  const Color(0xFFECF8FC),
                                  "UNTOUCHED"),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ).p16(),
                controller.isLoading.value
                    ? const LoadingScreen()
                    : const SizedBox(),
              ],
            )),
      ),
    );
  }

  Widget tile1(String title, String value, String url, String type) {
    return InkWell(
      onTap: () {
        Get.to(() => const LeadReceived(), arguments: {
          "lead": controller.selectFilterData.value,
          "leadtype": title
        })!
            .then((value) => Get.find<LeadController>().onInit());
      },
      child: Container(
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
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  imageUrl: "${WebApis.rootUrl}/CRM/Karma/www/img/$url",
                  fit: BoxFit.cover,
                  memCacheWidth: 160,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported,
                        size: 24, color: Colors.grey),
                  ),
                  placeholder: (context, url) => const SizedBox.shrink(),
                ),
              ),
            ),
            10.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
                10.heightBox,
                TextWidget(
                  value,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ],
            )
          ],
        ).p8(),
      ).pSymmetric(v: 4.0),
    );
  }

  Widget tile(
      String title, String value, String path, Color color, String data) {
    return InkWell(
      onTap: () {
        Get.to(() => const LeadReceived(), arguments: {
          "lead": controller.selectFilterData.value,
          "leadtype": data
        })!
            .then((_) => controller.getData());
      },
      child: Container(
        width: Get.width * 0.40,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: const Border(
            left: BorderSide(color: dividerColor),
            top: BorderSide(color: dividerColor),
            right: BorderSide(color: dividerColor),
            bottom: BorderSide(width: 1, color: dividerColor),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1E919191),
              blurRadius: 16,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              value,
              color: blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidgets.showAssetImage(path: path),
                5.widthBox,
                TextWidget(
                  title,
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
