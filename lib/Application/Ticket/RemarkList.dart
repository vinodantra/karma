// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/remark_list_controller.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
import 'package:readmore/readmore.dart';

class RemarkList extends GetView<RemarkListController> {
  const RemarkList({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RemarkListController());
    return Scaffold(
      appBar: AppBarWidget(title: "Allocator's Remarks"),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: AsyncStateView(
              isLoading: controller.isLoading.value,
              hasError: controller.hasError.value,
              isEmpty: controller.remarkList.isEmpty,
              onRetry: controller.getList,
              emptyMessage: 'No remarks found.',
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: controller.remarkList.length,
                itemBuilder: (context, index) {
                  return tileWidget(controller.remarkList[index], index);
                },
              ),
            ),
          )),
    );
  }

  tileWidget(var data,int index) {
    return Container(
        width: Get.width,
        decoration: shapeDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  "Remark ${controller.remarkList.length - index}",
                  color: appColor.value,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                TextWidget(
                  data['remarkDate'],
                  color: greyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),

            Check.data(
              data['Remarks'],
            )
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "Remark:",
                  color: blackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                ReadMoreText(
                  data['Remarks'],
                  style: const TextStyle(
                    color: greyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                )
              ],
            ).paddingOnly(bottom: 10)
                : const SizedBox(),

          ],
        ).p16(),).p8();
  }
}
