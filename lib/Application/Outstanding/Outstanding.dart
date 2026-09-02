// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
import 'package:intl/intl.dart';

class Outstanding extends GetView<OutstandingController> {
  const Outstanding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OutstandingController());
    return Scaffold(
      appBar: AppBarWidget(title: "Outstandings"),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(() => RefreshIndicator(
              onRefresh: controller.onRefresh,
              child: AsyncStateView(
                isLoading: controller.isLoading.value,
                hasError: controller.hasError.value,
                isEmpty: controller.list.isEmpty,
                onRetry: controller.getData,
                emptyMessage: 'No outstandings found.',
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.list.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return TextWidget(
                        "Last Updated : ${DateFormat('dd-MM-yyyy hh:mm').format(DateTime.parse(controller.date.value))}",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ).pSymmetric(h: 12.0, v: 8.0);
                    }
                    return tile(controller.list[index - 1]);
                  },
                ),
              ),
            )),
      ),
    );
  }

  tile(var data){
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextWidget(data['QRT'],fontSize: 20,),
              Column(
                children: [
                  TextWidget(data['ORDPND'].toString(),fontSize: 15,),
                  5.heightBox,
                  TextWidget("O/L Pending"),
                ],
              ),
              Column(
                children: [
                  TextWidget(data['BILLPND'].toString(),fontSize: 15,),
                  5.heightBox,
                  TextWidget("O/L Bill"),
                ],
              ),
              Column(
                children: [
                  TextWidget(data['TODT'].toString(),fontSize: 15,),
                  5.heightBox,
                  TextWidget("Total"),
                ],
              ),
            ],
          ).pSymmetric(h: 16.0,v: 8.0),
          TextWidget("Cancelled ${data['CANCELPER'].toString()}",fontSize: 15,).pSymmetric(h: 16.0,v: 8.0),
        ],
      ),
    ).pSymmetric(h: 8.0,v:4.0);
  }
}
