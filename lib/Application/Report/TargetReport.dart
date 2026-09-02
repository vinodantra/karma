// ignore_for_file: file_names

import '../../Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

class TargetReport extends GetView<TargetReportController> {
  const TargetReport({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TargetReportController());
    return Scaffold(
      appBar: AppBarWidget(title: controller.args['title'].toString()),
      body: Obx(() => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    controller.args['status'] == "weekly"
                        ? "Select Week"
                        : "Select Monthly",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  InkWell(
                    onTap: () {
                      CustomWidgets.customBottomSheet(
                          controller.filterList, "NAME", false, (data) {
                        controller.selectData.value = data['NAME'];
                        controller.selectId.value = data['ID'].toString();
                        controller.getData();
                        Get.back();
                      });
                    },
                    child: Row(
                      children: [
                        TextWidget(
                          controller.selectData.value,
                          color: greyColor,
                          fontSize: 16,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: iconColor,
                        )
                      ],
                    ),
                  ),
                ],
              ).pSymmetric(h: 15.0, v: 10.0),
              if (controller.args['type'] == "individual")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      "Select User",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        CustomWidgets.customBottomSheet(
                            controller.filterUserList, "NAME", true, (data) {
                          controller.selectUser.value = data['NAME'];
                          controller.selectUserId.value =
                              data['ID'].toString();
                          controller.getData();
                          Get.back();
                        });
                      },
                      child: Row(
                        children: [
                          TextWidget(
                            controller.selectUser.value,
                            color: greyColor,
                            fontSize: 16,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: iconColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ).pSymmetric(h: 15.0, v: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: Get.width / 4,
                      child: TextWidget(
                        "Milestone",
                        fontSize: 18,
                        color: appColor.value,
                      )),
                  TextWidget(
                    "Target",
                    fontSize: 18,
                    color: appColor.value,
                  ),
                  TextWidget(
                    "Done",
                    fontSize: 18,
                    color: appColor.value,
                  ),
                ],
              ).paddingSymmetric(horizontal: 15.0, vertical: 10.0),
              CustomWidgets.divider(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.listData.isEmpty,
                    onRetry: controller.getData,
                    emptyMessage: 'No target data found.',
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.listData.length,
                      itemBuilder: (context, index) =>
                          tile(controller.listData[index]),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  tile(data) {
    return controller.args['action'] != "SLSREPORT"
        ? Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Get.width / 4,
                        child: TextWidget(
                          data['HEADER'].toString(),
                          fontSize: 15,
                          color: Colors.black,
                          maxLines: 2,
                        )),
                    TextWidget(
                      data['TARGET'].toString(),
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    TextWidget(
                      data['VALUE'].toString(),
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Get.width * 0.75,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey[300]),
                    ),
                    TextWidget(
                      data['PERC'].toString(),
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ).p8(),
          ).pSymmetric(h: 15.0, v: 4.0)
        : Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Get.width / 4,
                        child: TextWidget(
                          data['NAME'].toString(),
                          fontSize: 15,
                          color: Colors.black,
                          maxLines: 2,
                        )),
                    TextWidget(
                      data['UINPUT'].toString(),
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    TextWidget(
                      data['ACHIVEED'].toString(),
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Get.width * 0.75,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey[300]),
                    ),
                    TextWidget(
                      data['PERC'].toString(),
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ).p8(),
          ).pSymmetric(h: 15.0, v: 4.0);
  }
}
