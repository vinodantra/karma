// ignore_for_file: file_names

import 'package:karma/Controller/PiwFormController.dart';

import '../../Constants/Library.dart';

class PiwForm extends StatelessWidget {
  const PiwForm({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PiwFormController>()) {
      Get.put(PiwFormController());
    }
    return GetBuilder<PiwFormController>(
      builder: (controller) => Scaffold(
        appBar: AppBarWidget(
          title: "PIW Form",
          onSubmit: controller.selectPiwId.value.isNotEmpty &&
                  controller.isLoading.value == false
              ? () => Get.find<PiwFormController>().updatePiwData()
              : null,
        ),
        body: controller.isLoading.value == false
            ? SizedBox(
                width: context.screenWidth,
                height: context.screenHeight,
                child: ListView(
                  children: [
                    selectItem(
                      title:
                          Utilities.checkString(controller.selectPiwName.value)
                              ? controller.selectPiwName.value
                              : "",
                      label: "Select PIW",
                      onPressed: () {
                        CustomWidgets.customBottomSheet(
                          controller.piwList,
                          "PIW_Name",
                          false,
                          (data) {
                            controller.selectPiwData(data);
                            Get.back();
                          },
                        );
                      },
                    ).pSymmetric(h: 16.0),
                    Column(
                      children: List.generate(
                        controller.questionList.length,
                        (int i) {
                          return Utilities.checkString(controller
                                  .questionList[i]['Question']
                                  .toString())
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextWidget(
                                          "${i + 1}. ",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        5.widthBox,
                                        Flexible(
                                          child: TextWidget(
                                            controller.questionList[i]
                                                    ['Question']
                                                .toString(),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    commentField(
                                      controller:
                                          controller.answerControllerList[i],
                                      onChanged: (value) =>
                                          controller.updateAnswer(i, value),
                                      hintText: "Answer",
                                      maxLength: 1000,
                                      minLines: 1,
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        },
                      ),
                    ).pSymmetric(h: 16.0),
                    controller.questionList.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffe0659b)
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: appColor.value),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.heightBox,
                                TextWidget(
                                  "PIW Answer",
                                  color: appColor.value,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ).pOnly(left: 16.0),
                                Column(
                                  children: List.generate(
                                    controller.answeredPiwList.length,
                                    (int index) => Column(
                                      children: [
                                        ListTile(
                                          onTap: () => controller.selectPiwData(
                                              controller
                                                  .answeredPiwList[index]),
                                          title: TextWidget(
                                            controller.answeredPiwList[index]
                                                    ['PIW_Name']
                                                .toString(),
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: appColor.value,
                                            size: 15,
                                          ),
                                        ),
                                        controller.answeredPiwList.length - 1 !=
                                                index
                                            ? Container(
                                                width: context.screenWidth,
                                                height: 1.0,
                                                color: appColor.value,
                                              ).pSymmetric(h: 16.0)
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).pSymmetric(h: 16.0, v: 20.0)
                        : const SizedBox(),
                  ],
                ),
              )
            : const LoadingScreen(),
      ),
    );
  }
}
