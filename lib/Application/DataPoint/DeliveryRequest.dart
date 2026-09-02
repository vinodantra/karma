// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class DeliveryRequest extends GetView<DeliveryRequestController> {
  const DeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DeliveryRequestController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Delivery Request",
      ),
      body: Obx(()=>Stack(
        children: [
          SizedBox(
              width: Get.width,
              height: Get.height,
              child: controller.list.isNotEmpty ?
              ListView.builder(
                  itemCount: controller.list.length,
                  itemBuilder: (context,index ){return tile(controller.list[index],index);}) : controller.isLoading.value == false ?
              Center(child: TextWidget("No data found",fontSize: 20,fontWeight: FontWeight.w500,)) : const SizedBox()
          ),
          controller.isLoading.value ? const LoadingScreen() : const SizedBox(),
        ],
      )),
    );
  }

  Widget tile(var data,int i,){
    return GetBuilder<DeliveryRequestController>(builder: (dashboardController){
      return InkWell(
        onTap:(){
         // Get.to(()=> const OpportunityData(),arguments: data);
        },
        child: Container(
          width:Get.width,


          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffeaecf0), width: 1, ),
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
                      data['REQTYPE'],

                      color: appColor.value,
                      fontSize: 18,

                      fontWeight: FontWeight.w500,

                    ),
                  ),
                  TextWidget(data['DELTYPE'],color: Colors.black,
                    fontSize: 18,

                    fontWeight: FontWeight.w500,)

                ],
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "Tally Release :${data['TALLYREALISE']}",

                    color:  titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                  TextWidget(
                    "(Refer.ID-${data['REQID']})",

                    color: titleColor,
                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                  ),
                ],
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(data['DELDATE'],
                      color: descriptionColor,
                      fontSize: 14),
                  Row(
                    children: [
                      TextWidget("Dev-${data['FRDDEV']}",
                          color: descriptionColor,
                          fontSize: 14),
                      TextWidget("Acc-${data['ACCOUNTS']}",
                          color: descriptionColor,
                          fontSize: 14),
                      IconButton(onPressed: (){
                        controller.showProduct(i);
                      }, icon:  Icon(
                        controller.selectPrdId.value.isNotEmpty && controller.selectPrdId.value == data['REQID'] ?
                        Icons.keyboard_arrow_up_outlined :
                        Icons.keyboard_arrow_down_outlined,size: 20,)),
                    ],
                  ),
                ],
              ),






              
              controller.selectPrdId.value.isNotEmpty && controller.selectPrdId.value == data['REQID'] && data.containsKey('MODULLIST') ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width / 4,
                        child: TextWidget(
                          "Pr.No",
                          color: const Color(
                              0xff2f3237),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextWidget(
                        "NAME",
                        color: const Color(
                            0xff2f3237),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),

                    ],
                  ).pSymmetric(h: 5.0),
                  10.heightBox,
                ],
              ): const SizedBox(),
              controller.selectPrdId.value.isNotEmpty && controller.selectPrdId.value == data['REQID'] &&  data.containsKey('MODULLIST')?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(data['MODULLIST'].length, (index) => SizedBox(
                  width: Get.width,


                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width / 3,
                        child: TextWidget(
                          "${data['MODULLIST'][index]['MODULENO']}",
                          color: const Color(
                              0xff2f3237),
                          fontSize: 16,
                        ),
                      ),

                      TextWidget(
                        "${data['MODULLIST'][index]['MODULENAME']}",
                        color: const Color(
                            0xff2f3237),
                        fontSize: 16,
                      ),

                    ],
                  ).pSymmetric(h: 5.0),
                )),
              ) : const SizedBox(),
            ],
          ).p16(),
        ).p8(),
      );
    });
  }
}
