// ignore_for_file: file_names

import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

import '../../Constants/Library.dart';
import '../../Controller/NotificationListController.dart';

class NotificationScreen extends GetView<NotificationListController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Get.find<NotificationListController>().getData();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {


        controller.updateNotificationBadgesCount();
        Get.offAll(()=>const DashboardNew());
      },

      child: Scaffold(
        appBar: AppBarWidget(
          onBackPress: (){

            controller.updateNotificationBadgesCount();
            Get.offAll(()=>const DashboardNew());
          },
          title: "Notification",
        ),
        body: Obx(() => Column(
              children: [
                if (controller.list.isNotEmpty && !controller.isLoading.value)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          controller.clearNotification();
                        },
                        child: TextWidget(
                          "Clear All",
                          color: Provider.of<AppThemeController>(Get.context!)
                              .appColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: AsyncStateView(
                      isLoading: controller.isLoading.value,
                      hasError: controller.hasError.value,
                      isEmpty: controller.list.isEmpty,
                      onRetry: controller.getData,
                      emptyMessage: 'No notifications.',
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.list.length,
                          itemBuilder: (context, index) {
                            return title(
                                context: context,
                                data: controller.list[index],
                                index: index);
                          }),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  title({required BuildContext context,required Map<String,dynamic> data, required int index}){
    int i  = index;
    return Dismissible(
      key: ValueKey(data),
      direction: DismissDirection.horizontal,
      child: Container(
        width: context.screenWidth,

        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(data['title'],fontSize: 14,color:Provider.of<AppThemeController>(context).appColor,
                fontWeight: FontWeight.w700,),

              TextWidget(timeAgoSinceDate(data['date'].toString())),

            ],).pOnly(bottom: 5.0),
          TextWidget(data['content'].toString(),
            fontSize: 12,color: Colors.grey[700],maxLines: 10,)
        ],).p16(),
      ).pOnly(bottom: 5.0),
      onDismissed: (direction) {
        controller.removeItemData(index: i);
      },
    );
  }
}
