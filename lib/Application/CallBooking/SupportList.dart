// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

class SupportList extends GetView<SupportListController> {
  const SupportList({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SupportListController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Support List",
        onPressAdd: () {
          Get.to(() => const AddSupportEntry(), arguments: controller.callId)!
              .then((value) {
            Get.find<SupportListController>().refreshData();
          });
        },
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: AsyncStateView(
              isLoading: controller.isLoading.value,
              hasError: controller.hasError.value,
              isEmpty: controller.supportEntries.isEmpty,
              onRetry: controller.getData,
              emptyMessage: "Support entries are not available.",
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.supportEntries.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Get.to(() => const SupportDetails(),
                        arguments: controller.supportEntries[index]);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TextWidget(
                              "Ticket : ",
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            10.widthBox,
                            TextWidget(
                              controller.supportEntries[index]['TICKET'],
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        5.heightBox,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Category : ",
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            10.widthBox,
                            SizedBox(
                              width: Get.width * 0.65,
                              child: TextWidget(
                                controller.supportEntries[index]['CATEGORY'],
                                color: titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).p8(),
                  ).p8(),
                ),
              ),
            ),
          )),
    );
  }
}
