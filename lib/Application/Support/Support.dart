// ignore_for_file: file_names

import 'package:karma/Controller/supportController.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

import '../../Constants/Library.dart';
class Support extends GetView<SupportController> {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SupportController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Support Availability",
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: AsyncStateView(
              isLoading: controller.isLoading.value,
              hasError: controller.hasError.value,
              isEmpty:
                  controller.list.isEmpty && controller.list1.isEmpty,
              onRetry: controller.getData,
              emptyMessage: 'No data found.',
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (controller.list.isNotEmpty)
                    Column(
                      children: [
                        TextWidget(
                          "Antra Cloud Support",
                          color: Provider.of<AppThemeController>(context)
                              .appColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ).p8(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              "Name",
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextWidget(
                              "Status",
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ).pSymmetric(h: 10.0),
                          ],
                        ).pSymmetric(h: 20.0, v: 10.0),
                        Divider(
                          height: 1.0,
                          color: Colors.grey[500],
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.list.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: TextWidget(
                                controller.list[index]['name'],
                                color: titleColor,
                                fontSize: titleFontSize,
                              ),
                              trailing: SizedBox(
                                width: 180,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    TextWidget(
                                      controller.list[index]
                                          ['available_status'],
                                      color: setColor(controller
                                          .list[index]['available_status']),
                                      fontSize: titleFontSize,
                                    ),
                                    Utilities.checkString(controller
                                                    .list[index]['MOBILE']
                                                .toString()
                                                .trim()) &&
                                            showIcon(controller.list[index]
                                                ['available_status'])
                                        ? SizedBox(
                                            height: 35,
                                            child: IconButton(
                                              onPressed: () {
                                                Utilities.onClickMobile(
                                                    controller.list[index]
                                                            ['MOBILE']
                                                        .toString()
                                                        .trim());
                                              },
                                              icon: CustomWidgets.showImage(
                                                path: callIcon1,
                                                color: Provider.of<
                                                            AppThemeController>(
                                                        Get.context!)
                                                    .appColor,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 50,
                                          )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 1.0,
                              color: Colors.grey[500],
                            );
                          },
                        ),
                      ],
                    ),
                  if (controller.list1.isNotEmpty)
                    Column(
                      children: [
                        TextWidget(
                          "Tally Support",
                          color: Provider.of<AppThemeController>(context)
                              .appColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ).p8(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              "Name",
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextWidget(
                              "Status",
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ).pSymmetric(h: 10.0),
                          ],
                        ).pSymmetric(h: 20.0, v: 10.0),
                        Divider(
                          height: 1.0,
                          color: Colors.grey[500],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.list1.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {},
                                  title: TextWidget(
                                    controller.list1[index]['name'],
                                    color: titleColor,
                                    fontSize: titleFontSize,
                                  ),
                                  trailing: SizedBox(
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        TextWidget(
                                          controller.list1[index]
                                              ['available_status'],
                                          color: setColor(
                                              controller.list1[index]
                                                  ['available_status']),
                                          fontSize: titleFontSize,
                                        ),
                                        Utilities.checkString(controller
                                                        .list1[index]['MOBILE']
                                                    .toString()
                                                    .trim()) &&
                                                showIcon(controller
                                                        .list1[index]
                                                    ['available_status'])
                                            ? SizedBox(
                                                height: 35,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Utilities.onClickMobile(
                                                        controller.list1[
                                                                index]
                                                                ['MOBILE']
                                                            .trim());
                                                  },
                                                  icon: CustomWidgets
                                                      .showImage(
                                                    path: callIcon1,
                                                    color: Provider.of<
                                                                AppThemeController>(
                                                            Get.context!)
                                                        .appColor,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 50,
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: Colors.grey[500],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )),
    );
  }
 Color setColor(String value){
    if(value == "On Leave" || value == "Not in Shift"){
      return Colors.red;
    }else if(value == "Available" || value == "Available Incharge"){
      return Colors.green;
    }else{
      return Colors.yellow;
    }
  }

  bool showIcon(String value){
    if(value == "Available" || value == "Available Incharge"){
      return true;
    }
    else{
      return false;
    }
  }

}
/*
On Leave
Not in Shift
Available
Available Incharge
Lunch Break*/
