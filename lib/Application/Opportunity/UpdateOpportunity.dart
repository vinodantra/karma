// ignore_for_file: file_names

import 'package:karma/Controller/updateOpportunityController.dart';

import '../../Constants/Library.dart';

class UpdateOpportunity extends GetView<UpdateOpportunityController> {
  const UpdateOpportunity({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UpdateOpportunityController());
    return Scaffold(
        appBar: AppBarWidget(
          title: "Update Opportunity",
        ),
        body: Obx(
          () => SizedBox(
            width: context.screenWidth,
            height: context.screenHeight,
            child: Stack(
              children: [
                ListView(
                  children: [
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectLeadSource.value)
                            ? controller.selectLeadSource.value
                            : "",
                        label: "Lead Source",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.leadSourceList, "SOURCE", false,
                              (data) {
                            controller.selectLeadSource.value = data['SOURCE'];
                            controller.selectLeasSourceId.value = data['ID'];
                            Get.back();
                          });
                        }),
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectBusinessLine.value)
                            ? controller.selectBusinessLine.value
                            : "",
                        label: "Business Line",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.businessLineList, "SOURCE", false,
                              (data) {
                            controller.selectBusinessLine.value =
                                data['SOURCE'];
                            controller.selectBusinessLineId.value = data['ID'];
                            Get.back();
                          });
                        }),
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectPriceLevel.value)
                            ? controller.selectPriceLevel.value
                            : "",
                        label: "Price Level",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.priceLevelList, "NAME", false, (data) {
                            controller.selectPriceLevel.value = data['NAME'];
                            //controller.selectLeasSourceId.value = data['ID'];
                            Get.back();
                          });
                        }),
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectTallyLedger.value)
                            ? controller.selectTallyLedger.value
                            : "",
                        label: "Tally Ledger",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.tallyLedgerList, "NAME", false,
                              (data) {
                            controller.selectTallyLedger.value = data['NAME'];
                            //controller.selectLeasSourceId.value = data['ID'];
                            Get.back();
                          });
                        }),
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectLocation.value)
                            ? controller.selectLocation.value
                            : "",
                        label: "Location",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.locationList, "NAME", false, (data) {
                            controller.selectLocation.value = data['NAME'];
                            controller.selectAddress.value = data['ADD'];
                            //controller.selectLeasSourceId.value = data['ID'];
                            Get.back();
                          });
                        }),
                    controller.selectAddress.value.isNotEmpty
                        ? TextWidget(
                            controller.selectAddress.value,
                            maxLines: 20,
                          ).pSymmetric(v: 10.0)
                        : const SizedBox(),
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectContactPerson.value)
                            ? controller.selectContactPerson.value
                            : "",
                        label: "Contact Person",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.contactPersonList, "CNTNAME", false,
                              (data) {
                            controller.selectContactPerson.value =
                                data['CNTNAME'];
                            controller.selectContactPersonId.value =
                                data['CNTID'];
                            Get.back();
                          });
                        }),
                    selectItem(
                        title: Utilities.checkString(
                                controller.selectTallySerial.value)
                            ? controller.selectTallySerial.value
                            : "",
                        label: "Tally Serial Number",
                        onPressed: () {
                          CustomWidgets.customBottomSheet(
                              controller.tallySerialList, "NAME", false,
                              (data) {
                            controller.selectTallySerial.value = data['NAME'];
                            // controller.selectTallySerialId.value = data['ID'];
                            Get.back();
                          });
                        }),
                    commentField(
                        controller: controller.remarkController,
                        hintText: "Opportunity Remark"),
                    commentField(
                        controller: controller.termController,
                        hintText: "Special Term (Printed in proposal)")
                  ],
                ).p16(),
                controller.isLoading.value
                    ? const LoadingScreen()
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }
}
