// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';
// import 'package:karma/Application/DataPoint/CreateDataPoint.dart';
// import '../../Controller/createDataPointController.dart';

class DataPoints extends StatelessWidget {
  DataPoints({super.key});

  final controller = Get.put(DataPointController()); // Always outside build()

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.back();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Data Points",
          onBackPress: () => Get.back(),
          // onPressAdd: () => Get.to(() => const CreateDataPoint(),
          //             binding: BindingsBuilder(() {
          //       Get.put(CreateDataPointController());
          //     }))!
          //         .then((value) => controller.getData())
        ),
        body: Obx(() => Column(
              children: [
                /// Search Box + Filter
                Row(
                  children: [
                    Expanded(
                      child: SearchWidget(
                        onChanged: (value) =>
                            controller.onSearchChanged(value ?? ""),
                        controller: controller.searchController,
                        hintText: "Search datapoints",
                        onClose: () {
                          controller.searchController.clear();
                          controller.onSearchChanged("");
                        },
                      ),
                    ),
                    Obx(() => PopupMenuButton<String>(
                          tooltip: "Filter",
                          initialValue: controller.qualifiedFilter.value,
                          onSelected: controller.onFilterChanged,
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: "All", child: Text("All")),
                            PopupMenuItem(
                                value: "Qualified", child: Text("Qualified")),
                            PopupMenuItem(
                                value: "Non Qualified",
                                child: Text("Non Qualified")),
                          ],
                          child: Container(
                            margin: const EdgeInsets.only(right: 8, left: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: dividerColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.filter_list,
                              color: controller.qualifiedFilter.value == "All"
                                  ? blackColor
                                  : primaryColor,
                            ),
                          ),
                        )),
                  ],
                ),
                10.heightBox,

                /// Main List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: AsyncStateView(
                      isLoading: controller.isLoading.value,
                      hasError: controller.hasError.value,
                      isEmpty: controller.dataPointList.isEmpty,
                      onRetry: controller.getData,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.dataPointList.length,
                        itemBuilder: (context, index) {
                          return tileWidget(
                            controller.dataPointList[index],
                            index,
                            context,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Tile Widget
  Widget tileWidget(data, int index, BuildContext context) {
    final qualified =
        (data['Qualified'] ?? '').toString().trim().toLowerCase() == 'yes';
    return InkWell(
      onTap: () {
        Get.to(
          () => const DataPointInfo(),
          arguments: data,
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: Container(
        width: context.screenWidth,
        decoration: ShapeDecoration(
          color: qualified
              ? const Color(0xFFE8F5E9)
              : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14919191),
              blurRadius: 12,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.screenWidth * 0.65,
              child: TextWidget(
                data['DPNAME'] ?? 'Unnamed Data Point',
                color: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                maxLines: 5,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 20,
              color: blackColor,
            ),
          ],
        ).p12(),
      ).pSymmetric(h: 8.0, v: 4.0),
    );
  }
}
