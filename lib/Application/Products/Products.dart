// ignore_for_file: file_names

import 'package:karma/Application/Products/ProductDetails.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

class Products extends GetView<ProductController> {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());
    return Scaffold(
      appBar: AppBarWidget(title: "Products",),
      body: Obx(() => Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: appColor.value)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.searchController.clear();
                        controller.selectTab.value = "1";
                        controller.modelList.value = controller.list1;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectTab.value == "1"
                              ? appColor.value
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextWidget("Addons",
                                fontSize: 15,
                                color: controller.selectTab.value == "1"
                                    ? Colors.white
                                    : appColor.value)
                            .pSymmetric(h: 10.0, v: 8.0),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.searchController.clear();
                        controller.selectTab.value = "2";
                        controller.boostersList.value = controller.list2;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectTab.value == "2"
                              ? appColor.value
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextWidget("Boosters",
                                fontSize: 15,
                                color: controller.selectTab.value == "2"
                                    ? Colors.white
                                    : appColor.value)
                            .pSymmetric(h: 10.0, v: 8.0),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.searchController.clear();
                        controller.selectTab.value = "3";
                        controller.appList.value = controller.list3;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectTab.value == "3"
                              ? appColor.value
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextWidget("Mobile App",
                                fontSize: 15,
                                color: controller.selectTab.value == "3"
                                    ? Colors.white
                                    : appColor.value)
                            .pSymmetric(h: 10.0, v: 8.0),
                      ),
                    ),
                  ],
                ),
              ).p8(),
              SearchWidget(
                onChanged: (value) {
                  controller.searchData(value!);
                },
                controller: controller.searchController,
                hintText: "Search",
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: controller.selectTab.value == "1"
                      ? AsyncStateView(
                          isLoading: controller.isLoading.value,
                          hasError: controller.hasError.value,
                          isEmpty: controller.modelList.isEmpty,
                          onRetry: controller.fetchData,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.modelList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Get.to(() => ProductDetails(
                                      data: controller.modelList[index]));
                                },
                                title: TextWidget(
                                  controller.modelList[index]['MODULENAME'],
                                  color: titleColor,
                                  fontSize: titleFontSize,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 1.0,
                                color: Colors.grey[500],
                              );
                            },
                          ),
                        )
                      : controller.selectTab.value == "2"
                          ? Column(
                              children: [
                                SizedBox(
                                  width: Get.width,
                                  height: 60,
                                  child: ListView.builder(
                                      itemCount:
                                          controller.categoryList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            controller.selectCategoryId.value =
                                                controller.categoryList[index]
                                                        ['ID']
                                                    .toString();
                                            controller.getBoosterData(controller
                                                .categoryList[index]['ID']
                                                .toString());
                                          },
                                          child: Card(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: TextWidget(
                                                controller.categoryList[index]
                                                    ['CATEGORY'],
                                                color: controller
                                                            .selectCategoryId
                                                            .value ==
                                                        controller.categoryList[
                                                                    index]
                                                                ['ID']
                                                            .toString()
                                                    ? appColor.value
                                                    : titleColor,
                                                fontSize: titleFontSize,
                                                fontWeight: titleFontWeight,
                                              ).pSymmetric(h: 10.0),
                                            ),
                                          ).pSymmetric(h: 5.0, v: 5.0),
                                        );
                                      }),
                                ),
                                Expanded(
                                  child: AsyncStateView(
                                    isLoading: controller.isLoading.value,
                                    hasError: controller.hasError.value,
                                    isEmpty: controller.boostersList.isEmpty,
                                    onRetry: controller.fetchData,
                                    child: ListView.separated(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.boostersList.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            Get.to(() => ProductDetails(
                                                data: controller
                                                    .boostersList[index]));
                                          },
                                          title: TextWidget(
                                            controller.boostersList[index]
                                                ['MODULENAME'],
                                            color: titleColor,
                                            fontSize: titleFontSize,
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          height: 1.0,
                                          color: Colors.grey[500],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : AsyncStateView(
                              isLoading: controller.isLoading.value,
                              hasError: controller.hasError.value,
                              isEmpty: controller.appList.isEmpty,
                              onRetry: controller.fetchData,
                              child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.appList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      Get.to(() => ProductDetails(
                                          data: controller.appList[index]));
                                    },
                                    title: TextWidget(
                                      controller.appList[index]['MODULENAME'],
                                      color: titleColor,
                                      fontSize: titleFontSize,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 1.0,
                                    color: Colors.grey[500],
                                  );
                                },
                              ),
                            ),
                ),
              ),
            ],
          )),
    );
  }
}
