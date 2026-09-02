// ignore_for_file: depend_on_referenced_packages

import 'package:karma/Application/ANS/create_ans_screen.dart';
import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
import '../../Constants/Library.dart';
import '../../Controller/ans_controller.dart';
import 'package:intl/intl.dart';

// Reusable date formatters to avoid repeated allocations and parsing work in build
final _parseFmt = DateFormat("dd MMM yyyy HH:mm:ss:SSS");
final _displayDateFmt = DateFormat("dd-MMM-yyyy");
final _timeFmt = DateFormat("hh:mm a");

class AnsScreen extends GetView<AnsController> {
  const AnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AnsController>()) {
      Get.put(AnsController());
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const DashboardNew());
        }
      },
      child: Scaffold(
          appBar: AppBarWidget(
            title: "ANS Report ",
            onBackPress: () {
              Get.offAll(() => const DashboardNew());
            },
            onPressAdd: DataInfo.rollId.value == "1" ||
                    DataInfo.tcId.value == "7" ||
                    DataInfo.titleId.value == "24" ||
                    DataInfo.titleId.value == "25" ||
                    DataInfo.titleId.value == "26" ||
                    DataInfo.userId.value == "176" ||
                    DataInfo.userId.value == "177" ||
                    DataInfo.userId.value == "365"
                ? () {
                    Get.to(() => const CreateAnsScreen())!.then((value) {
                      Get.find<AnsController>().getAnsData();
                    });
                  }
                : null,
          ),
          body: GetBuilder<AnsController>(builder: (controller) {
            return Column(
                      children: [
                        DataInfo.rollId.value == "1"
                            ? InkWell(
                                onTap: () {
                                  CustomWidgets.customBottomSheet(
                                      controller.usersList, "NAME", true,
                                      (data) {
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
                                                CustomWidgets.showImage(
                                                    path: userIcon),
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8),
                                  itemCount: controller.ansData.length,
                                  itemBuilder: (context, index) {
                                    // safe map access
                                    final item = controller.ansData[index];
                                    final fromRaw =
                                        (item['fromDate'] ?? '').toString();
                                    final toRaw =
                                        (item['toDate'] ?? '').toString();
                                    final createdRaw =
                                        (item['ANScreatedDate'] ?? '')
                                            .toString();

                                    DateTime dFrom = DateTime.now();
                                    DateTime dTo = DateTime.now();
                                    DateTime dCreated = DateTime.now();
                                    try {
                                      if (fromRaw.isNotEmpty) {
                                        dFrom = _parseFmt.parse(fromRaw);
                                      }
                                      if (toRaw.isNotEmpty) {
                                        dTo = _parseFmt.parse(toRaw);
                                      }
                                      if (createdRaw.isNotEmpty) {
                                        dCreated = _parseFmt.parse(createdRaw);
                                      }
                                    } catch (e) {
                                      // keep fallback dates as now
                                    }

                                    final formattedDate =
                                        _displayDateFmt.format(dFrom);
                                    final formattedDate2 =
                                        _displayDateFmt.format(dCreated);
                                    final t1 = _timeFmt.format(dFrom);
                                    final t2 = _timeFmt.format(dTo);

                                    final descr =
                                        (item['descr'] ?? '').toString();
                                    final type =
                                        (item['type'] ?? '').toString();
                                    final personName =
                                        (item['PersonName'] ?? '').toString();

                                    return Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                        "ANS Creation Date : ",
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                      ),
                                                      5.widthBox,
                                                      TextWidget(
                                                        formattedDate2,
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                  5.heightBox,
                                                  Row(
                                                    children: [
                                                      TextWidget(
                                                        "ANS Date : ",
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                      ),
                                                      5.widthBox,
                                                      TextWidget(
                                                        formattedDate,
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                  5.heightBox,
                                                  Row(
                                                    children: [
                                                      TextWidget(
                                                        "ANS Time : ",
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                      ),
                                                      5.widthBox,
                                                      TextWidget(
                                                        "$t1 - $t2",
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                  5.heightBox,
                                                  Row(
                                                    children: [
                                                      TextWidget(
                                                        "ANS Type : ",
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                      ),
                                                      5.widthBox,
                                                      TextWidget(
                                                        type,
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                  5.heightBox,
                                                  Row(
                                                    children: [
                                                      TextWidget(
                                                        "Username : ",
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                      ),
                                                      5.widthBox,
                                                      TextWidget(
                                                        personName,
                                                        color: const Color(
                                                            0xff667084),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                  5.heightBox,
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          CustomWidgets
                                                              .showDialogWidget(
                                                            title:
                                                                "Description",
                                                            content: descr,
                                                          );
                                                        },
                                                        tooltip: "Description",
                                                        icon: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffebeffd),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          child: TextWidget(
                                                            "DE",
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ).p8(),
                                                        ),
                                                      ),
                                                      Check.data(item[
                                                              'Recommendation'])
                                                          ? IconButton(
                                                              onPressed: () {
                                                                CustomWidgets
                                                                    .showDialogWidget(
                                                                  title:
                                                                      "Observation",
                                                                  content: (item[
                                                                              'Recommendation'] ??
                                                                          '')
                                                                      .toString(),
                                                                );
                                                              },
                                                              tooltip:
                                                                  "Observation",
                                                              icon: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6),
                                                                    color: const Color(
                                                                        0xffebeffd),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black)),
                                                                child:
                                                                    TextWidget(
                                                                  "OB",
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ).p8(),
                                                              ))
                                                          : const SizedBox(),
                                                      Check.data(item[
                                                              'Requirement'])
                                                          ? IconButton(
                                                              onPressed: () {
                                                                CustomWidgets
                                                                    .showDialogWidget(
                                                                  title:
                                                                      "Requirement",
                                                                  content: (item[
                                                                              'Requirement'] ??
                                                                          '')
                                                                      .toString(),
                                                                );
                                                              },
                                                              tooltip:
                                                                  "Requirement",
                                                              icon: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6),
                                                                    color: const Color(
                                                                        0xffebeffd),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black)),
                                                                child:
                                                                    TextWidget(
                                                                  "RE",
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
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
