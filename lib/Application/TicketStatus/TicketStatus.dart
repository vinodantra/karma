// ignore_for_file: file_names

import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Application/TicketStatus/TicketStatusDetails.dart';
import 'package:karma/Constants/Library.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class TicketStatus extends GetView<TicketStatusController> {
  const TicketStatus({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TicketStatusController());
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.offAll(() => const DashboardNew());
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Ticket Status",
          onBackPress: () {
            Get.offAll(() => const DashboardNew());
          },
        ),
        body: Obx(
          () => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  controller.filterUserList.isNotEmpty &&
                          DataInfo.desCat.value == "L1"
                      ? InkWell(
                          onTap: () {
                            CustomWidgets.customBottomSheet(
                                controller.filterUserList, "NAME", true,
                                (data) {
                              controller.onSelectUser(data);
                              Get.back();
                            });
                          },
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
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
                                  const Divider(
                                    color: iconColor,
                                  )
                                ],
                              ).pSymmetric(v: 15.0),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SearchWidget(
                    onChanged: (value) {
                      controller.search.value = value!;
                      controller.searchUser();
                    },
                    controller: controller.searchController,
                    hintText: "Search",
                    onClose: () {
                      controller.searchController.clear();
                      controller.search.value = "";
                      controller.searchUser();
                    },
                  ),
                  Expanded(
                    child: controller.ticketList.isNotEmpty &&
                            controller.isLoading.value == false
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.ticketList.length,
                            itemBuilder: (context, index) {
                              return tileWidget(
                                  controller.ticketList[index], index);
                            })
                        : controller.isLoading.value
                            ? const LoadingScreen()
                            : const ValidationWidget(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  tileWidget(var data, int index) {
    if (kDebugMode) {
      print("$data");
    }

    return InkWell(
      onTap: () {
        Get.to(() => const TicketStatusDetails(), arguments: data);
      },
      child: Container(
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
                    data['NAME'],
                    color: titleColor,
                    fontSize: titleFontSize,
                    fontWeight: titleFontWeight,
                  ),
                ),
                TextWidget(data['STATUS'].toString(),
                    color: descriptionColor, fontSize: descriptionFontSize),
              ],
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(data['TICKET'],
                    color: descriptionColor, fontSize: descriptionFontSize),
                TextWidget(data['DATE'].toString(),
                    color: descriptionColor, fontSize: descriptionFontSize),
              ],
            ),
            10.heightBox,
            Utilities.checkString(data['CNTPER'].toString())
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget("Contact Person",
                          color: descriptionColor,
                          fontSize: descriptionFontSize),
                      TextWidget(data['CNTPER'].toString(),
                          color: descriptionColor,
                          fontSize: descriptionFontSize),
                    ],
                  ).pOnly(bottom: 10.0)
                : const SizedBox(),
            Utilities.checkString(data['CNTPERMOB'].toString())
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget("Contact Number",
                          color: descriptionColor,
                          fontSize: descriptionFontSize),
                      GestureDetector(
                        onTap: () {
                          if (Utilities.checkString(
                              data['CNTPERMOB'].toString())) {
                            Utilities.onClickMobile(
                                data['CNTPERMOB'].toString());
                          }
                        },
                        child: TextWidget(data['CNTPERMOB'].toString(),
                            color: Colors.blue,
                            fontSize: descriptionFontSize,
                            textDecoration: TextDecoration.underline),
                      ),
                    ],
                  ).pOnly(bottom: 10.0)
                : const SizedBox(),
            InkWell(
                onTap: () {
                  controller.selectTicket(index);
                },
                child: Obx(
                  () => Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        TextWidget(
                          controller.selectIndex.value != index
                              ? "More Details"
                              : "Less Details",
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        controller.selectIndex.value != index
                            ? const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.keyboard_arrow_up_rounded,
                                size: 18,
                                color: Colors.blue,
                              )
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 10.0,
            ),
            Obx(() => controller.selectIndex.value == index
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utilities.checkString(data['CREATEDBY'].toString())
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget("Supported By",
                                    color: descriptionColor,
                                    fontSize: descriptionFontSize),
                                TextWidget(data['CREATEDBY'].toString(),
                                    color: descriptionColor,
                                    fontSize: descriptionFontSize),
                              ],
                            ).pOnly(bottom: 10.0)
                          : const SizedBox(),
                      Utilities.checkString(data['MOBILE'].toString())
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget("Supported Person Number",
                                    color: descriptionColor,
                                    fontSize: descriptionFontSize),
                                GestureDetector(
                                  onTap: () {
                                    if (Utilities.checkString(
                                        data['MOBILE'].toString())) {
                                      Utilities.onClickMobile(
                                          data['MOBILE'].toString());
                                    }
                                  },
                                  child: TextWidget(data['MOBILE'].toString(),
                                      color: Colors.blue,
                                      fontSize: descriptionFontSize,
                                      textDecoration: TextDecoration.underline),
                                ),
                              ],
                            ).pOnly(bottom: 10.0)
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget("Last Interaction",
                              color: descriptionColor,
                              fontSize: descriptionFontSize),
                          TextWidget(data['LASTINTDT'].toString(),
                              color: descriptionColor,
                              fontSize: descriptionFontSize),
                        ],
                      ).pOnly(bottom: 10.0),
                      Utilities.checkString(data['LASTSCHD'].toString())
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget("Support Schedule",
                                    color: descriptionColor,
                                    fontSize: descriptionFontSize),
                                SizedBox(
                                  width: Get.width / 2,
                                  child: TextWidget(
                                      controller.checkDate(
                                          data['LASTSCHD'].toString()),
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                      color: descriptionColor,
                                      fontSize: descriptionFontSize),
                                ),
                              ],
                            ).pOnly(bottom: 10.0)
                          : const SizedBox(),
                      Utilities.checkString(data['CUSTSCHD'].toString())
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget("Customer Schedule",
                                    color: descriptionColor,
                                    fontSize: descriptionFontSize),
                                SizedBox(
                                  width: Get.width / 2,
                                  child: TextWidget(
                                    controller
                                        .checkDate(data['CUSTSCHD'].toString()),
                                    textAlign: TextAlign.right,
                                    color: descriptionColor,
                                    fontSize: descriptionFontSize,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ).pOnly(bottom: 10.0)
                          : const SizedBox(),
                    ],
                  )
                : const SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          CustomWidgets.showDialogWidget(
                              title: "Description", content: data['DESC']);
                        },
                        icon: SvgPicture.asset(descriptionIcon1)),
                    IconButton(
                        onPressed: () {
                          Get.bottomSheet(Obx(() => Container(
                                height: 350,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(36.0),
                                      topRight: Radius.circular(36.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f929292),
                                      blurRadius: 27,
                                      offset: Offset(0, -4),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    TextWidget(
                                      "Update Ticket Status",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ).p12(),
                                    Expanded(
                                      child: Scrollbar(
                                        thickness: 5.0,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: List.generate(
                                              controller.ticketStatus.length,
                                              (index) => ListTile(
                                                    onTap: () {
                                                      controller
                                                          .selectTicketStatus
                                                          .value = controller
                                                              .ticketStatus[
                                                          index]['NAME'];
                                                      controller
                                                          .selectTicketStatusId
                                                          .value = controller
                                                              .ticketStatus[
                                                          index]['ID'];
                                                    },
                                                    title: TextWidget(
                                                      controller.ticketStatus[
                                                          index]['NAME'],
                                                      fontSize: 16,
                                                    ),
                                                    trailing: controller
                                                                .selectTicketStatus
                                                                .value ==
                                                            controller
                                                                    .ticketStatus[
                                                                index]['NAME']
                                                        ? const Icon(
                                                            Icons.check)
                                                        : const SizedBox(),
                                                  )),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              controller.selectTicketStatus
                                                  .value = "";
                                              Get.back();
                                            },
                                            child: const Text("Cancel")),
                                        CustomButton(
                                          text: "Save",
                                          onPressed: () {
                                            controller.updateStatus(
                                                data['TICKET'],
                                                controller.selectTicketStatusId
                                                    .value);
                                            Get.back();
                                            controller.selectTicketStatusId
                                                .value = "";
                                          },
                                        ),
                                      ],
                                    ).pSymmetric(h: 20.0, v: 10.0),
                                  ],
                                ),
                              )));
                        },
                        icon: const Icon(Icons.edit)),
                    // data.containsKey("MOBILE")  == true ?  IconButton(onPressed: (){
                    //   Utilities.onClickMobile(data['MOBILE']);
                    // }, icon: const Icon(Icons.call),tooltip: data['CREATEDBY'],) : const SizedBox(),
                  ],
                ),
                Utilities.checkString(data['TCKSTATUS'])
                    ? TextWidget(
                        controller.getTicketStatus(data['TCKSTATUS'])['NAME'],
                        fontSize: 16,
                        color: controller.checkColor(controller
                            .getTicketStatus(data['TCKSTATUS'])['NAME']),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ).p8(),
      ).pLTRB(8.0, 4.0, 8.0, 8.0),
    );
  }
}
