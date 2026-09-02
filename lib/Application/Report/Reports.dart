// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:karma/Constants/Library.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Operations"),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.heightBox,
            Container(
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
                  TextWidget(
                    "Reports",
                    color: appColor.value,
                    fontSize: 18,
                  ).pSymmetric(h: 16.0, v: 8.0),
                  CustomWidgets.divider(),
                  Row(
                    children: [
                      tile(
                          title: "Leave",
                          icon: "leavv.png",
                          onTap: () {
                            Get.to(() => const LeaveReport());
                          }).pSymmetric(h: 16.0, v: 8.0),
                      40.widthBox,
                      CustomWidgets.divider(width: 1.0, height: 40.0),
                      tile(
                          title: "Conveyance",
                          icon: "Conveyance.png",
                          onTap: () {
                            Get.to(() => const ConveyReport());
                          }).pSymmetric(h: 16.0, v: 8.0),
                    ],
                  ),
                ],
              ),
            ).pSymmetric(h: 16.0, v: 4.0),
            DataInfo.desCat.value == "L1"
                ? Container(
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
                        TextWidget(
                          "Individual Target",
                          color: appColor.value,
                          fontSize: 18,
                        ).pSymmetric(h: 16.0, v: 8.0),
                        5.heightBox,
                        CustomWidgets.divider(),
                        Row(
                          children: [
                            tile(
                                title: "Weekly",
                                icon: "target.png",
                                onTap: () {
                                  Get.to(() => const TargetReport(),
                                      arguments: {
                                        "title": "Weekly Report",
                                        "action": "SLSREPORT",
                                        "teamLead": "0",
                                        "type": "individual",
                                        "status": "weekly"
                                      });
                                }).pSymmetric(h: 16.0, v: 8.0),
                            40.widthBox,
                            CustomWidgets.divider(width: 1.0, height: 40.0),
                            tile(
                                title: "Monthly",
                                icon: "target.png",
                                onTap: () {
                                  Get.to(() => const TargetReport(),
                                      arguments: {
                                        "title": "Monthly Report",
                                        "action": "SLSMONTHREPORT",
                                        "type": "individual",
                                        "status": "monthly"
                                      });
                                }).pSymmetric(h: 16.0, v: 8.0),
                          ],
                        ),
                      ],
                    ),
                  ).pSymmetric(h: 16.0, v: 4.0)
                : const SizedBox(),
            DataInfo.desCat.value == "L1"
                ? Container(
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
                        TextWidget(
                          "Team Target",
                          color: appColor.value,
                          fontSize: 18,
                        ).pSymmetric(h: 16.0, v: 8.0),
                        5.heightBox,
                        CustomWidgets.divider(),
                        Row(
                          children: [
                            tile(
                                title: "Weekly",
                                icon: "target.png",
                                onTap: () {
                                  Get.to(() => const TargetReport(),
                                      arguments: {
                                        "title": "Weekly Team Report",
                                        "action": "SLSREPORT",
                                        "teamlead": "1",
                                        "type": "team",
                                        "status": "weekly"
                                      });
                                }).pSymmetric(h: 16.0, v: 8.0),
                            40.widthBox,
                            CustomWidgets.divider(width: 1.0, height: 40.0),
                            tile(
                                title: "Monthly",
                                icon: "target.png",
                                onTap: () {
                                  Get.to(() => const TargetReport(),
                                      arguments: {
                                        "title": "Monthly Team Report",
                                        "action": "TEAMMONTHREPORT",
                                        "type": "team",
                                        "status": "monthly"
                                      });
                                }).pSymmetric(h: 16.0, v: 8.0),
                          ],
                        ),
                      ],
                    )).pSymmetric(h: 16.0, v: 4.0)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget tile(
      {required String title, required String icon, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: "${WebApis.rootUrl}/CRM/Karma/www/img/$icon",
              width: 25,
              height: 25,
              color: Colors.black,
              memCacheWidth: 50,
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image),
              placeholder: (context, url) => const SizedBox.shrink(),
            ),
            10.widthBox,
            TextWidget(
              title,
              fontSize: 18,
            )
          ],
        ),
      ),
    );
  }
}
