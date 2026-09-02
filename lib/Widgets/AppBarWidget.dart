// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/services.dart';
import 'package:karma/Application/Notification/NotificationScreen.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/NotificationListController.dart';
import 'package:karma/Controller/NotificationListProvider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Function()? onBackPress;
  Function()? onPressAdd;
  Function()? onSubmit;
  Function()? onLocation;
  List<Color>? colors;

  Function()? onStatus;
  Function()? onClick;
  Function()? onInfo;

  Function()? onSelectDate;

  bool? isShowNotification;

  String? addTooltip;


  AppBarWidget(
      {super.key,
      required this.title,
      this.colors,
      this.onBackPress,
      this.onPressAdd,
      this.addTooltip,
      this.onSubmit,
      this.onLocation,
      this.onStatus,
      this.onClick,
      this.onInfo,
      this.onSelectDate,
      this.isShowNotification = false,
      });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: Provider.of<AppThemeController>(context)
                        .appGradientColor)),
          ),
          elevation: 0,
          leadingWidth: 30.0,
          leading: onBackPress != null
              ? IconButton(
                  onPressed: onBackPress,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
              : null,
          iconTheme: const IconThemeData(color: Colors.white),
          title: TextWidget(
            title,
            color: surfaceColor,
            fontSize: 16,
          ),
          actions: [
            onSelectDate != null
                ? IconButton(
                    onPressed: onSelectDate,
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            onPressAdd != null
                ? CustomWidgets.showSvgImage(
                    path: addIcon, tooltip: addTooltip, onPressed: onPressAdd)
                : const SizedBox(),
            onSubmit != null
                ? IconButton(
                    onPressed: onSubmit,
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            onLocation != null
                ? IconButton(
                    onPressed: onLocation,
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            onStatus != null
                ? IconButton(
                    onPressed: onStatus,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            onInfo != null
                ? IconButton(
                    onPressed: onInfo,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            isShowNotification == true
                ?
                Consumer<NotificationListProvider>(builder: (ctx,controller,_){

                  return  ctx.watch<NotificationListProvider>().badgesCount > 0 ?
                  VxBadge(
                      count: ctx.watch<NotificationListProvider>().badgesCount,
                      color: Colors.red,
                      child: IconButton(
                          onPressed: () {
                            Get.off(() => const NotificationScreen())!.then((value){


                              Get.find<NotificationListController>().isReadNotification.value = true;
                              Get.find<NotificationListController>().badgesCount.value = 0;

                            });
                          },
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ))) : IconButton(
                      onPressed: () {
                        Get.to(() => const NotificationScreen());
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ));


                }) : const SizedBox(),


            onClick != null
                ? IconButton(
                    onPressed: onClick,
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ))
                : const SizedBox(),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 60);
}
