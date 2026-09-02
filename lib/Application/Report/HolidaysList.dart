// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
import 'package:intl/intl.dart';
class HolidaysList extends GetView<LeaveReportController> {
  const HolidaysList({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveReportController());
    return Scaffold(
      appBar: AppBarWidget(title: "Holidays List-${DateTime.now().year}"),
      body: Obx(() => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: Get.width / 3.5,
                      child: TextWidget(
                        "Date",
                        fontSize: 20,
                        color: appColor.value,
                      )),
                  SizedBox(
                      width: Get.width / 3.5,
                      child: TextWidget(
                        "Type",
                        fontSize: 20,
                        color: appColor.value,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                      width: Get.width / 3.5,
                      child: TextWidget(
                        "Holidays",
                        fontSize: 20,
                        color: appColor.value,
                        textAlign: TextAlign.center,
                      )),
                ],
              ).pSymmetric(h: 15.0, v: 10.0),
              CustomWidgets.divider(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.getHolidaysList,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.holidaysList.isEmpty,
                    onRetry: controller.getHolidaysList,
                    emptyMessage: 'No holidays found.',
                    child: Scrollbar(
                      thickness: 5.0,
                      trackVisibility: true,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        itemCount: controller.holidaysList.length,
                        itemBuilder: (context, index) {
                          final item = controller.holidaysList[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: Get.width / 3.0,
                                      child: TextWidget(
                                        DateFormat('E dd MMM, yyyy')
                                            .format(DateFormat('dd MMM yyyy')
                                                .parse(item['DATE']))
                                            .toString(),
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                      width: Get.width / 3.5,
                                      child: TextWidget(
                                        item['TYPE'],
                                        fontSize: 14,
                                        color: Colors.black,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      )),
                                  SizedBox(
                                      width: Get.width / 3.5,
                                      child: TextWidget(
                                        item['HOLIDAY'],
                                        fontSize: 14,
                                        color: Colors.black,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ).pSymmetric(v: 10.0),
                              5.heightBox,
                              CustomWidgets.divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
