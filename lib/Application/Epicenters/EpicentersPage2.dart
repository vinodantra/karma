
// ignore_for_file: file_names




import '../../Constants/Library.dart';
import '../../Widgets/AsyncStateView.dart';

class EpicentersPage2 extends GetView<EpicentersPage2Controller> {


  const EpicentersPage2({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EpicentersPage2Controller());
    return Scaffold(
      appBar: AppBarWidget(title: "Epicenters"),
      body: Obx(() => Column(
            children: [
              SearchWidget(
                controller: controller.search,
                onChanged: (value) {
                  controller.list.value = controller.listData
                      .where((element) => element['DPNAME']
                          .toString()
                          .toLowerCase()
                          .contains(value!.trim().toLowerCase()))
                      .toList();
                },
                hintText: "Search",
                onClose: () {
                  controller.search.clear();
                  controller.list.value = controller.listData;
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.list.isEmpty,
                    onRetry: controller.getData,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.list.length,
                      itemBuilder: (context, index) {
                        return tileWidget(controller.list[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  tileWidget(var data){
    List<String> status = [];
    if(data['TNS'] == "Yes")
      {
        status.add("TNS");
      }
    if(data['ISTALLY'] == "Yes")
    {
      status.add("ISTALLY");
    }
    if(data['SB'] == "Yes")
      {
        status.add("SB");
      }
    if(data['AMC'] == "Yes")
    {
      status.add("AMC");
    }


   // var status = "${data['TNS'] == "Yes" ? "TNS":""}${data['ISTALLY'] == "Yes" ? "ISTALLY/":""}${data['SB'] == "Yes" ? "SB/":""}${data['AMC'] == "Yes" ? "AMC":""}";
    return InkWell(
      onTap: (){

        Get.to(()=> EpicentersDetails2(data: data,));
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
                data['DPNAME'],

                color: titleColor,
                fontSize:titleFontSize,

                fontWeight: titleFontWeight,

              ),
            ),

            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("Owner",
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
                TextWidget(data['ACCOWNER'].toString(),
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
              ],
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("Status",
                    color: descriptionColor,
                    fontSize: descriptionFontSize),
                TextWidget(
                    status.join("/").toString(),
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

