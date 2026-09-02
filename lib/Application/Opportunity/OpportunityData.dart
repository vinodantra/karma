// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class OpportunityData extends GetView<OpportunityDataController> {
  const OpportunityData({super.key});

  List<dynamic> _products() {
    final p = controller.data['PRODUCT'];
    if (p is List) return p;
    return [];
  }

  @override
  Widget build(BuildContext context) {
     Get.put(OpportunityDataController());
    return Scaffold(
      appBar: AppBarWidget(
        title: controller.data['DPNAME'],
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(() => ListView(
              children: [
                Container(
                  width: Get.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: appColor.value, width: 1.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.selectType.value = "1";
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: controller.selectType.value == "1"
                                ? appColor.value
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: TextWidget(
                            "Details",
                            color: controller.selectType.value == "1"
                                ? Colors.white
                                : appColor.value,
                          ).pSymmetric(h: 10.0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.selectType.value = "2";
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: controller.selectType.value == "2"
                                ? appColor.value
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: TextWidget(
                            "Proposal",
                            color: controller.selectType.value == "2"
                                ? Colors.white
                                : appColor.value,
                          ).pSymmetric(h: 10.0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.selectType.value = "3";
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: controller.selectType.value == "3"
                                ? appColor.value
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: TextWidget(
                            "Proforma",
                            color: controller.selectType.value == "3"
                                ? Colors.white
                                : appColor.value,
                          ).pSymmetric(h: 10.0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.selectType.value = "4";
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: controller.selectType.value == "4"
                                ? appColor.value
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: TextWidget(
                            "Invoice",
                            color: controller.selectType.value == "4"
                                ? Colors.white
                                : appColor.value,
                          ).pSymmetric(h: 20.0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.selectType.value = "5";
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: controller.selectType.value == "5"
                                ? appColor.value
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: TextWidget(
                            "Activity",
                            color: controller.selectType.value == "5"
                                ? Colors.white
                                : appColor.value,
                          ).pSymmetric(h: 10.0),
                        ),
                      ),
                    ],
                  ),
                ).pSymmetric(h: 20.0, v: 10.0),
                controller.selectType.value == "1"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tileData("Create Date", controller.data['CRTDATE']),
                          tileData("Lead Source", controller.data['LEADSRC']),
                          tileData(
                              "Business Line", controller.data['BUSLINENAME']),
                          tileData(
                              "Price Level", controller.data['PRICELEVEL']),
                          tileData("Net Value", controller.data['NETVALUE']),
                          tileData(
                              "Order Amount", controller.data['ESTAMOUNT']),
                          tileData("User", controller.data['USERNAME']),
                          tileData("Opp Stage", controller.data['STGENAME']),
                          tileData(
                              "Special Term", controller.data['SPECIALTERM']),
                          tileData("Description", controller.data['OPDESC']),
                          20.heightBox,
                          TextWidget(
                            "Stock Items",
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                List.generate(_products().length, (index) {
                              final prod = _products()[index];
                              final name = prod is Map && prod['NAME'] != null
                                  ? prod['NAME'].toString()
                                  : '';
                              final qty = prod is Map && prod['QTY'] != null
                                  ? prod['QTY'].toString()
                                  : '';
                              final amt = prod is Map && prod['AMT'] != null
                                  ? prod['AMT'].toString()
                                  : '';
                              final rate = prod is Map && prod['RATE'] != null
                                  ? prod['RATE'].toString()
                                  : '';
                              final disc = prod is Map && prod['DISC'] != null
                                  ? prod['DISC'].toString()
                                  : '';
                              return SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 3,
                                      child: TextWidget(
                                        name,
                                        color: titleColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    5.heightBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TextWidget("Quantity",
                                                color: descriptionColor,
                                                fontSize: 14),
                                            10.widthBox,
                                            SizedBox(
                                              width: Get.width / 5,
                                              child: TextWidget(
                                                qty,
                                                textAlign: TextAlign.start,
                                                color: darkTextColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            TextWidget("Total",
                                                color: descriptionColor,
                                                fontSize: 14),
                                            10.widthBox,
                                            TextWidget(
                                              amt,
                                              color: darkTextColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    10.heightBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TextWidget("Rate",
                                                color: descriptionColor,
                                                fontSize: 14),
                                            10.widthBox,
                                            SizedBox(
                                              width: Get.width / 5,
                                              child: TextWidget(
                                                rate,
                                                textAlign: TextAlign.start,
                                                color: darkTextColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            TextWidget("Discount",
                                                color: descriptionColor,
                                                fontSize: 14),
                                            10.widthBox,
                                            TextWidget(
                                              disc,
                                              color: darkTextColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    10.heightBox,
                                    Row(
                                      children: [
                                        TextWidget("Net Value : ",
                                            color: descriptionColor,
                                            fontSize: 14),
                                        10.widthBox,
                                        SizedBox(
                                          width: Get.width / 5,
                                          child: TextWidget(
                                            "${controller.data['NETVALUE']}",
                                            textAlign: TextAlign.start,
                                            color: darkTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.heightBox,
                                    Container(
                                      width: Get.width,
                                      height: 1.0,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ).pSymmetric(h: 20.0),
                              );
                            }),
                          ),
                        ],
                      )
                    : controller.selectType.value == "2"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                controller.proposalList.length,
                                (index) => Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            controller.proposalList[index]
                                                    ['NAME']
                                                .toString(),
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                controller.proposalList[index]
                                                        ['CREATEDT']
                                                    .toString(),
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color: appColor.value,
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.email_outlined,
                                                        color: appColor.value,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons
                                                            .cloud_download_outlined,
                                                        color: appColor.value,
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ).p8(),
                                    )),
                          ).p8()
                        : controller.selectType.value == "3"
                            ? Card(
                                child: TextWidget(
                                  controller.proformaData.value,
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ).p8(),
                              ).p8()
                            : Column(
                                children: List.generate(
                                    controller.activityList.length,
                                    (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              controller.activityList[index]
                                                      ['HSTTYPE']
                                                  .toString(),
                                              fontSize: 16,
                                              color: appColor.value,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            10.heightBox,
                                            Container(
                                              width: Get.width,
                                              height: 1.0,
                                              color: Colors.grey[400],
                                            ),
                                            10.heightBox,
                                            TextWidget(
                                              "Follwup Date",
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            5.heightBox,
                                            TextWidget(
                                              controller.activityList[index]
                                                      ['FLWDATE']
                                                  .toString(),
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            10.heightBox,
                                            TextWidget(
                                              "Regarding",
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            5.heightBox,
                                            TextWidget(
                                              controller.activityList[index]
                                                      ['REGARDING']
                                                  .toString(),
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            10.heightBox,
                                            TextWidget(
                                              "Details",
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            5.heightBox,
                                            TextWidget(
                                              controller.activityList[index]
                                                      ['DETAILS']
                                                  .toString(),
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ],
                                        )),
                              ).p8(),
              ],
            )),
      ),
    );
  }

  Widget tileData(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title,
          color: titleColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TextWidget(value, color: descriptionColor, fontSize: 14),
      ],
    ).pSymmetric(h: 20.0, v: 10.0);
  }
}
