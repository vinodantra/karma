// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Application/PblReport/create_pbl_screen.dart';
import 'package:karma/Controller/pbl_controller.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
import '../../Constants/Library.dart';
import 'package:intl/intl.dart';

class PblReport extends GetView<PblController> {
  const PblReport({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PblController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const DashboardNew());
        }
      },
      child: Scaffold(
          appBar: AppBarWidget(
            title: "PBL Report",
            onBackPress: (){


              Get.offAll(()=>const DashboardNew());
            },

            onPressAdd:  DataInfo.rollId.value == "1" || DataInfo.tcId.value == "7" || DataInfo.titleId.value == "24" || DataInfo.titleId.value == "25" || DataInfo.titleId.value == "26" ||
                DataInfo.userId.value == "176" || DataInfo.userId.value == "177"  || DataInfo.userId.value == "365" ? () {
              Get.to(() => const CreatePblScreen());
            }:null,
          ),
          body: GetBuilder<PblController>(builder: (controller) {
            return Column(
              children: [
                DataInfo.rollId.value == "1"
                    ? InkWell(
                        onTap: () {
                          CustomWidgets.customBottomSheet(
                              controller.usersList, "NAME", true, (data) {
                            //controller.id.value = data['ID'].toString();
                            controller.userName.value = data['NAME'];
                            controller.changeData();
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
                                          controller.userName.value,
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
                              const Divider(
                                color: iconColor,
                              )
                            ],
                          ).pSymmetric(h: 15.0, v: 10.0),
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: AsyncStateView(
                      isLoading: controller.isLoading.value,
                      hasError: controller.hasError.value,
                      isEmpty: controller.ansData.isEmpty,
                      onRetry: controller.getAnsData,
                      emptyMessage: "No data found",
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: controller.ansData.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime =
                              DateFormat("dd MMM yyyy HH:mm:ss:SSS").parse(
                                  controller.ansData[index]['fromDate']);

                          // Converting into desired format
                          String formattedDate =
                              DateFormat("dd-MMM-yyyy").format(dateTime);

                          DateTime dateTime2 =
                              DateFormat("dd MMM yyyy HH:mm:ss:SSS").parse(
                                  controller.ansData[index]['ANScreatedDate']);

                          // Converting into desired format
                          String formattedDate2 =
                              DateFormat("dd-MMM-yyyy").format(dateTime2);

                          DateTime d1 = DateFormat("dd MMM yyyy HH:mm:ss:SSS")
                              .parse(controller.ansData[index]['fromDate']);

                          DateTime d2 = DateFormat("dd MMM yyyy HH:mm:ss:SSS")
                              .parse(controller.ansData[index]['toDate']);

                          String t1 = DateFormat("hh:mm a").format(d1);

                          String t2 = DateFormat("hh:mm a").format(d2);

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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            TextWidget(
                                              "PBL Creation Date : ",
                                              color: descriptionColor,
                                              fontSize: 14,
                                            ),
                                            5.widthBox,
                                            TextWidget(
                                              formattedDate2,
                                              color: descriptionColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                        5.heightBox,
                                        Row(
                                          children: [
                                            TextWidget(
                                              "PBL Date : ",
                                              color: descriptionColor,
                                              fontSize: 14,
                                            ),
                                            5.widthBox,
                                            TextWidget(
                                              formattedDate,
                                              color: descriptionColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                        5.heightBox,
                                        Row(
                                          children: [
                                            TextWidget(
                                              "PBL Time : ",
                                              color: descriptionColor,
                                              fontSize: 14,
                                            ),
                                            5.widthBox,
                                            TextWidget(
                                              "$t1 - $t2",
                                              color: descriptionColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                        5.heightBox,
                                        Row(
                                          children: [
                                            TextWidget(
                                              "PBL Type : ",
                                              color: descriptionColor,
                                              fontSize: 14,
                                            ),
                                            5.widthBox,
                                            TextWidget(
                                              controller.ansData[index]['type'],
                                              color: descriptionColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                        5.heightBox,
                                        Row(
                                          children: [
                                            TextWidget(
                                              "Username : ",
                                              color: descriptionColor,
                                              fontSize: 14,
                                            ),
                                            5.widthBox,
                                            TextWidget(
                                              controller.ansData[index]
                                                  ['PersonName'],
                                              color: descriptionColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                        5.heightBox,
                                        Row(
                                          children: [
                                            Check.data(controller.ansData[index]
                                                    ['Recommendation'])
                                                ? IconButton(
                                                    onPressed: () {
                                                      CustomWidgets
                                                          .showDialogWidget(
                                                        title: "Topic",
                                                        content: controller
                                                                .ansData[index]
                                                            ['Recommendation'],
                                                      );
                                                    },
                                                    tooltip: "Topic",
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: const Color(
                                                              0xffebeffd),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      child: TextWidget(
                                                        "TP",
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ).p8(),
                                                    ))
                                                : const SizedBox(),
                                            IconButton(
                                              onPressed: () {
                                                CustomWidgets.showDialogWidget(
                                                  title: "Description",
                                                  content: controller
                                                      .ansData[index]['descr'],
                                                );
                                              },
                                              tooltip: "Description",
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: const Color(
                                                        0xffebeffd),
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: TextWidget(
                                                  "DE",
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ).p8(),
                                              ),
                                            ),
                                            Check.data(controller.ansData[index]
                                                    ['Requirement'])
                                                ? IconButton(
                                                    onPressed: () {
                                                      CustomWidgets
                                                          .showDialogWidget(
                                                        title: "Learning",
                                                        content: controller
                                                                .ansData[index]
                                                            ['Requirement'],
                                                      );
                                                    },
                                                    tooltip: "Learning",
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: const Color(
                                                              0xffebeffd),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      child: TextWidget(
                                                        "LR",
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ).p8(),
                                                    ))
                                                : const SizedBox(),
                                          ],
                                        )
                                      ]).pSymmetric(h: 10, v: 10))
                              .pSymmetric(h: 16, v: 10);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
