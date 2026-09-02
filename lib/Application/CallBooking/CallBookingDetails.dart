// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:karma/Constants/Library.dart';

import 'package:intl/intl.dart';

/// Screen displaying the details of a call booking.
class CallBookingDetails extends GetView<CallBookingDetailsController> {
  /// Constructor for CallBookingDetails.
  const CallBookingDetails({super.key});

  // Static constants for repeated strings
  static const String checkIn = "Check In";
  static const String checkOut = "Check Out";
  static const String cancel = "Cancel";
  static const String accessDenied = "Access Denied";
  static const String onlyToday =
      "You can only do check in/out for today's call.";
  static const String opps = "Opps!!";
  static const String checkInEntryMsg =
      "CheckIn Entry is must to be add Support Entry!";
  static const String checkOutEntryMsg =
      "CheckOut Entry is must to be add Support Entry!";

  @override
  Widget build(BuildContext context) {
    // Register controller if not already registered
    if (!Get.isRegistered<CallBookingDetailsController>()) {
      Get.put(CallBookingDetailsController());
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: "Call Details",
        onLocation: () async {
          final String? callDate = controller.data['NRMLCALLDATE']?.toString();
          if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == callDate) {
            if (!Utilities.checkString(controller.data['CHKIN']) ||
                controller.data['CHKIN'] == "00") {
              if (controller.data['CHKIN'] == "00" &&
                  DataInfo.desCat.value == "L1") {
                await controller.checkStatus(
                  controller.data['COMPANYID'].toString(),
                  controller.data['ID'].toString(),
                );
              }
              CustomWidgets.showAlertDialog1(
                icon: const Icon(
                  Icons.info,
                  color: Colors.orangeAccent,
                  size: 45,
                ),
                title: checkIn,
                content: "You want to check in?",
                text1: checkIn,
                workShop: DataInfo.desCat.value == "L1"
                    ? Obx(
                        () => Column(
                          children: [
                            10.heightBox,
                            Container(
                              width: Get.width,
                              height: 1.0,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: controller.workShopStatus.value,
                                  onChanged: controller.isWorkShop.value
                                      ? controller.changeWorkShopStatus
                                      : null,
                                ),
                                TextWidget(
                                  "is PIW",
                                  color: controller.isWorkShop.value
                                      ? Colors.black
                                      : Colors.grey[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Utilities.checkString(controller.workShopDate.value)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        "Last Workshop Date : ",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      5.widthBox,
                                      TextWidget(
                                        controller.workShopDate.value,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ).pOnly(bottom: 10)
                                : const SizedBox(),
                            Container(
                              width: Get.width,
                              height: 1.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                onClick: () async {
                  Get.back();
                  Loader();
                  final locationData = await Utilities.getLocation();
                  if (locationData == null) {
                    Loader().hide();
                    CustomWidgets.snackBar(
                        title:
                            "Location permission required to check in. Please enable it in Settings.");
                    return;
                  }
                  final String address = await Utilities.getAddressFromLatLng(
                    locationData.latitude!,
                    locationData.longitude!,
                  );
                  controller.updateStatus(
                    controller.data,
                    locationData.latitude.toString(),
                    locationData.longitude.toString(),
                    address,
                  );
                },
                text2: cancel,
                onCancel: () {
                  Get.back();
                },
              );
              controller.isLoading.value = false;
            } else {
              controller.isLoading.value = true;
              CustomWidgets.showAlertDialog1(
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.orangeAccent,
                  size: 50,
                ),
                title: checkOut,
                content: "You want to check out?",
                text1: checkOut,
                onClick: () async {
                  Get.back();
                  Loader();
                  final locationData = await Utilities.getLocation();
                  if (locationData == null) {
                    Loader().hide();
                    CustomWidgets.snackBar(
                        title:
                            "Location permission required to check out. Please enable it in Settings.");
                    return;
                  }
                  final String address = await Utilities.getAddressFromLatLng(
                    locationData.latitude!,
                    locationData.longitude!,
                  );
                  controller.updateStatus(
                    controller.data,
                    locationData.latitude.toString(),
                    locationData.longitude.toString(),
                    address,
                  );
                },
                text2: cancel,
                onCancel: () {
                  Get.back();
                },
              );
              controller.isLoading.value = false;
            }
          } else {
            CustomWidgets.showDialogWidget(
              title: accessDenied,
              content: onlyToday,
            );
          }
        },
        onStatus: () {
          CustomWidgets.customBottomSheet(
            controller.optionList1,
            "NAME",
            false,
            (value) {
              if (value['ID'] ==
                  CallBookingDetailsController.optionIdCreateLead) {
                Get.back();
                Get.to(() => const CreateLead(), arguments: controller.data);
              }
              if (value['ID'] ==
                  CallBookingDetailsController.optionIdTicketHistory) {
                Get.back();
                Get.to(() => const Tickets(), arguments: controller.data);
              }
              if (value['ID'] ==
                  CallBookingDetailsController.optionIdSupportVisitHistory) {
                if (DataInfo.desCat.value == "L1") {
                  if (controller.data['CHKIN'] != "00" &&
                      controller.data['CHKOUT'] != "00") {
                    Get.back();
                    Get.to(() => const SupportList(),
                        arguments: controller.data);
                  } else {
                    if (controller.data['CHKIN'] == "00") {
                      CustomWidgets.showDialogWidget(
                          title: opps, content: checkInEntryMsg);
                    } else {
                      CustomWidgets.showDialogWidget(
                          title: opps, content: checkOutEntryMsg);
                    }
                  }
                } else {
                  if (controller.data['CHKIN'] != "00") {
                    Get.back();
                    Get.to(() => const SupportList(),
                        arguments: controller.data);
                  } else {
                    CustomWidgets.showDialogWidget(
                        title: opps, content: checkInEntryMsg);
                  }
                }
              }
              if (value['ID'] ==
                  CallBookingDetailsController.optionIdConveyanceEntry) {
                Get.back();
                Get.to(() => const ConveyanceEntry(),
                    arguments: controller.data);
              }
              if (value['ID'] ==
                  CallBookingDetailsController.optionIdProductServices) {
                Get.back();
                Get.to(() => const ProductAndServices(),
                    arguments: {"DPID": DataInfo.dpId.value});
              }
            },
          );
        },
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(
          () => Stack(
            children: [
              ListView(
                children: [
                  tile(
                      title: "Company Name",
                      data: controller.data['CMP']?.toString()),
                  tile(
                      title: "Contact Person",
                      data: controller.data['CNTPERSON']?.toString()),
                  tile(
                      title: "Gateway Installation",
                      data: controller.data['GATEWAY']?.toString()),
                  tile(
                      title: "Admin Email",
                      data: controller.data['ADMINEMAIL']?.toString()),
                  tile(
                      title: "Account Owner",
                      data: controller.data['ACCOWNER']?.toString()),
                  tile(
                      title: "Acc Owner No",
                      data: controller.data['ACCMOBILE']?.toString(),
                      type: "2"),
                  tile(
                      title: "Customer Mobile",
                      data: controller.data['MOB']?.toString(),
                      type: "2"),
                  tile(
                      title: "Landline",
                      data: controller.data['PHONE']?.toString(),
                      type: "2"),
                  tile(
                      title: "Address",
                      data: controller.data['ADDRESS']?.toString()),
                  tile(
                      title: "Support Type",
                      data: controller.data['CALLTYPID']?.toString()),
                  tile(
                      title: "Call Date",
                      data: controller.data['CALLDATE']?.toString()),
                  tile(
                      title: "Tally Serial No",
                      data: controller.data['TALLYSRLNO']?.toString()),
                  tile(
                      title: "Call Schedule",
                      data: controller.data['SHEDULE']?.toString()),
                  tile(
                      title: "Remark",
                      data: controller.data['REMARK']?.toString()),
                  tile(
                      title: "Note",
                      data: controller.data['SPNOTE']?.toString()),
                ],
              ),
              controller.isLoading.value
                  ? const LoadingScreen()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget for displaying a single detail row.
  Widget tile({String? title, String? data, String type = "1"}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title ?? '',
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            type == "1"
                ? SizedBox(
                    width: Get.width / 2,
                    child: TextWidget(
                      data ?? '',
                      color: descriptionColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.right,
                      maxLines: 10,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (data != null) {
                        Utilities.onClickMobile(data);
                      }
                    },
                    child: TextWidget(
                      data ?? '',
                      color: Provider.of<AppThemeController>(Get.context!)
                          .appColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
          ],
        ).pSymmetric(h: 15.0, v: 10.0),
        5.heightBox,
        Container(
          width: Get.width,
          height: 1.0,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}
