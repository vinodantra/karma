// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:karma/Controller/statusController.dart';

import '../../Constants/Library.dart';
import 'package:intl/intl.dart';

class Status extends GetView<StatusController> {
  const Status({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StatusController());
    return Scaffold(
        appBar: AppBarWidget(
          title: "Change Status",
          onSubmit: () {
            controller.checkData();
          },
        ),
        body: Obx(
          () => SizedBox(
            width: context.screenWidth,
            height: context.screenHeight,
            child: ListView(
              children: [
                selectItem(
                    title: Utilities.checkString(controller.selectStatus.value)
                        ? controller.selectStatus.value
                        : "",
                    label: "Status",
                    onPressed: () {
                      CustomWidgets.customBottomSheet(
                          controller.statusList, "NAME", false, (data) {
                        controller.selectStatus.value = data['NAME'];
                        controller.selectStatusId.value = data['ID'];
                        Get.back();
                      });
                    }),
                controller.selectStatusId.value == "3"
                    ? selectItem(
                        title: Utilities.checkString(
                                controller.selectPostponedDate.value)
                            ? controller.selectPostponedDate.value
                            : "",
                        label: "Postponed Date",
                        icon: CustomWidgets.showAssetImage1(path: calendar),
                        onPressed: () async {
                          var de = await CustomWidgets.pickDate(context,
                              selectFromDate:
                                  DateTime.now().add(const Duration(days: 1)));
                          if (de != null) {
                            // controller.selectDate.value = de.toString();

                            controller.selectPostponedDate.value =
                                DateFormat('dd MMM yyyy').format(de);
                          }
                        },
                      )
                    : const SizedBox(),
                selectItem(
                    title: Utilities.checkString(controller.selectReason.value)
                        ? controller.selectReason.value
                        : "",
                    label: "Close Reason",
                    onPressed: () {
                      CustomWidgets.customBottomSheet(
                          controller.reasonList, "NAME", false, (data) {
                        controller.selectReason.value = data['NAME'];
                        controller.selectReasonId.value = data['ID'].toString();
                        Get.back();
                      });
                    }),
                commentField(
                    controller: controller.remarkController,
                    hintText: "Close Remark",
                    maxLength: 300),
              ],
            ).p16(),
          ),
        ));
  }
}
