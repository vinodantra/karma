
// ignore_for_file: file_names, invalid_use_of_protected_member

import 'package:karma/Constants/Library.dart';
class EpicenterDetails extends GetView<EpicentersController> {
  const EpicenterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EpicentersController());
    return Scaffold(
      appBar: AppBarWidget(title: "Epicenter",),



      body: Obx(()=>Stack(
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              children: [
                SearchWidget(controller: controller.search,
                onChanged: (value){
                  controller.mstdtlsList.value = controller.list.where((element) => element['NAME'].toString().toLowerCase().contains(value!.trim().toLowerCase())).toList();
                },
                hintText: "Search",
                  onClose: (){
                  controller.search.clear();
                  controller.mstdtlsList.value = controller.list;
                  },

                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                      itemCount: controller.mstdtlsList.length,
                      itemBuilder: (context, index) {
                        return tileWidget(controller.mstdtlsList[index]);
                      }),
                )
              ],
            ),

          ),
          controller.isLoading.value ? const LoadingScreen() : const SizedBox()
        ],
      )),
    );
  }

  tileWidget(var data){
    return InkWell(
      onTap: (){
        Get.to(()=>  const EpicentersPage2(),arguments: {"id":data['EPIID'].toString(),"data":controller.epcdtlsList.value});
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffeaecf0), width: 1, ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 247,
              child: TextWidget(
                data['NAME'],

                color: titleColor,
                fontSize:titleFontSize,

                fontWeight: titleFontWeight,

              ),
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("Datapoint count",
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
                TextWidget(data['DPCNT'].toString(),
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
              ],
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("Own",
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
                TextWidget(data['OWN'].toString(),
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
              ],
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("Unit",
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
                TextWidget(data['UNIT'].toString(),
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
              ],
            ),
            10.heightBox,
          ],
        ).p8(),
      ).pLTRB(8.0, 4.0, 8.0, 8.0),
    );
  }
}
