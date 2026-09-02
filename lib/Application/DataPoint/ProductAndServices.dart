// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class ProductAndServices extends GetView<ServicesController> {
  const ProductAndServices({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServicesController());
    return Scaffold(
        appBar: AppBarWidget(title: "Live Products"),
        body: Obx(
          () => SizedBox(
            height: Get.height,
            width: Get.width,
            child: controller.isLoading.value == false
                ? controller.boosterList.isNotEmpty ||
                        controller.addonsList.isNotEmpty
                    ? ListView(
                        children: [
                          controller.boosterList.isNotEmpty
                              ? TextWidget(
                                  "Boosters",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ).p8()
                              : const SizedBox.shrink(),
                          Column(
                            children: List.generate(
                                controller.boosterList.length,
                                (index) => contentWidget(
                                    text:
                                        "${controller.boosterList[index]['MODULENO'].toString().trim()} ${controller.boosterList[index]['MODULENAME'].toString().trim()}")),
                          ),
                          controller.addonsList.isNotEmpty
                              ? TextWidget(
                                  "Addons",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ).p8()
                              : const SizedBox.shrink(),
                          Column(
                            children: List.generate(
                                controller.addonsList.length,
                                (index) => contentWidget(
                                    text:
                                        "${controller.addonsList[index]['MODULENO']?.toString() ?? 'N/A'} ${controller.addonsList[index]['MODULENAME']?.toString() ?? 'Unknown'}")),
                          ),
                        ],
                      )
                    : Center(
                        child: TextWidget(
                          "No Products Available",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                : const LoadingScreen(),
          ),
        ));
  }

  Widget contentWidget({required String text, Function()? onPressed}) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed,
          title: TextWidget(
            text,
            fontSize: 16,
            maxLines: 5,
          ),
          // trailing: const Icon(Icons.arrow_forward_ios_outlined,
          //   size: 20,),
        ),
        Container(
          width: Get.width,
          height: 1.0,
          color: Colors.grey[200],
        )
      ],
    );
  }
}
