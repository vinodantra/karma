// ignore_for_file: file_names

import 'package:karma/Controller/myCustomerCallController.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

import '../../Constants/Library.dart';

class MyCustomerCall extends GetView<MyCustomerCallController> {
  const MyCustomerCall({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyCustomerCallController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "My Customer Call",
      ),
      body: Obx(() => Column(
            children: [
              if (Get.find<DashboardController>().filterUserList.isNotEmpty)
                InkWell(
                  onTap: () {
                    CustomWidgets.customBottomSheet(
                        Get.find<DashboardController>().filterUserList,
                        "NAME",
                        true, (data) {
                      controller.selectUser.value = data['NAME'];
                      controller.getData(data['ID'].toString());
                      Get.back();
                    });
                  },
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CustomWidgets.showImage(path: userIcon),
                                  10.widthBox,
                                  TextWidget(
                                    controller.selectUser.value,
                                    color: greyColor,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: iconColor,
                            )
                          ],
                        ),
                        const Divider(color: iconColor),
                      ],
                    ).pSymmetric(v: 15.0),
                  ),
                ).pSymmetric(h: 16.0, v: 8.0),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.customerList.isEmpty,
                    onRetry: controller.onRefresh,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.customerList.length,
                      itemBuilder: (_, int index) =>
                          tileWidget(controller.customerList[index]),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  tileWidget(var data) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffeaecf0),
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 247,
                child: TextWidget(
                  data['COMPANYNAME'],
                  color: titleColor,
                  fontSize: titleFontSize,
                  fontWeight: titleFontWeight,
                ),
              ),
              data['TEAMID'].toString() != "2" &&
                      controller.showIcon(date: data['NEWECALLDATE'].toString())
                  ? IconButton(
                      onPressed: () {
                        CustomWidgets.showAlertDialog1(
                            icon: const Icon(
                              Icons.info_outline,
                              size: 40,
                            ),
                            title: "Are you sure",
                            content: "You want to cancel the call?",
                            widget: GetBuilder<MyCustomerCallController>(
                              builder: (controller1) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    height: 70,
                                    child: TextField(
                                      controller: controller1.remark,
                                      decoration: const InputDecoration(
                                          hintText: "Remarks"),
                                    ),
                                  ).pOnly(bottom: 5.0),
                                ],
                              ),
                            ),
                            text1: "Yes",
                            onCancel: () {
                              Get.back();
                            },
                            text2: "No",
                            onClick: () {
                              controller.deleteCall(data);
                            });
                      },
                      icon: const Icon(Icons.close))
                  : const SizedBox(),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TextWidget(data['TICKET'],
              //     color: descriptionColor,
              //     fontSize: descriptionFontSize),
              TextWidget(data['CALLDATE'].toString(),
                  color: descriptionColor, fontSize: descriptionFontSize),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Status:",
                color: titleColor,
                fontSize: titleFontSize,
                fontWeight: titleFontWeight,
              ),
              TextWidget(data['STATUS'].toString(),
                  color: controller.checkColor(data['STATUS'].toString()),
                  fontSize: descriptionFontSize),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Engineer Name",
                color: titleColor,
                fontSize: titleFontSize,
                fontWeight: titleFontWeight,
              ),
              TextWidget(data['UNAME'].toString(),
                  color: descriptionColor, fontSize: descriptionFontSize),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Mobile:",
                color: titleColor,
                fontSize: titleFontSize,
                fontWeight: titleFontWeight,
              ),
              Row(
                children: [
                  TextWidget(data['MOB'].toString(),
                      color: descriptionColor, fontSize: descriptionFontSize),
                  Utilities.checkString(data['MOB'].toString())
                      ? IconButton(
                          onPressed: () {
                            Utilities.onClickMobile(data['MOB']);
                          },
                          icon: const Icon(Icons.call),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "Remark:",
                color: titleColor,
                fontSize: titleFontSize,
                fontWeight: titleFontWeight,
              ),
              SizedBox(
                width: Get.width * 0.7,
                child: TextWidget(data['REMARK'].toString().trim(),
                    maxLines: 20,
                    textAlign: TextAlign.start,
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
              ),
            ],
          ),
        ],
      ).p8(),
    ).pLTRB(8.0, 1.0, 8.0, 12.0);
  }
}
