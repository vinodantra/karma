// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

import 'package:intl/intl.dart';
class ConveyReport extends GetView<ConveyReportController> {
  const ConveyReport({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConveyReportController());
    return Scaffold(


      appBar: AppBarWidget(title: "Conveyance Report"),
      body: Obx(() => Column(
            children: [
              if (controller.listData.isNotEmpty)
                Column(
                  children: [
                    TextWidget(
                      "Total Amount",
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                    10.heightBox,
                    TextWidget(
                      controller.listData
                          .map((e) => e['AMOUNT'])
                          .toList()
                          .reduce((a, b) => a + b)
                          .toString(),
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    )
                  ],
                ).pSymmetric(v: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "Select Month",
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: () async {
                      var de = await CustomWidgets.pickMonth(context);

                      if (de != null) {
                        controller.selectDate.value =
                            DateFormat('MMM yyyy').format(de);

                        controller.getData();
                      }
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          TextWidget(
                            "1 ${controller.selectDate.value}",
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          10.widthBox,
                          const Icon(Icons.calendar_today_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
              ).pSymmetric(h: 20.0),
              20.heightBox,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.listData.isEmpty,
                    onRetry: controller.getData,
                    emptyMessage: 'No data found.',
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(data['COMPANY'],fontSize: 20,color: appColor.value,),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget("Date",fontSize: 18,color: Colors.grey[700],),
                  5.heightBox,
                  TextWidget(data['DATE'],fontSize: 18,color: Colors.black,),
                ],
              ),
              SizedBox(
                width: Get.width/3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget("Amount",fontSize: 18,color: Colors.grey[700],),
                    5.heightBox,
                    TextWidget(data['AMOUNT'].toString(),fontSize: 18,color: Colors.red,),
                  ],
                ),
              ),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget("From",fontSize: 18,color: Colors.grey[700],),
                  5.heightBox,
                  TextWidget(data['FROMLOC'],fontSize: 18,color: Colors.black,),
                ],
              ),
              SizedBox(
                width: Get.width/3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget("To",fontSize: 18,color: Colors.grey[700],),
                    5.heightBox,
                    TextWidget(data['TOLOC'].toString(),fontSize: 18,color: Colors.black,),
                  ],
                ),
              ),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget("By",fontSize: 18,color: Colors.grey[700],),
                  5.heightBox,
                  TextWidget(data['TRANSPORTMODE'],fontSize: 18,color: Colors.black,),
                ],




              ),
              SizedBox(
                width: Get.width/3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget("Remark",fontSize: 18,color: Colors.grey[700],),
                    5.heightBox,
                    TextWidget(data['REMARK'].toString(),fontSize: 18,color: Colors.black,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ).p12(),
    ).pSymmetric(h: 15.0);
  }
}
