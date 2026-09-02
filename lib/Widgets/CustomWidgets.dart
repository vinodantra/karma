// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/NotificationListProvider.dart';
import 'package:karma/Services/db_helper.dart';

import 'package:karma/Widgets/CustomBottomSheet.dart';
import 'package:karma/Widgets/UpdateAppWidget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/NotificationListController.dart';

class CustomWidgets {
  static snackBar({required String title}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: TextWidget(
          title,
          maxLines: 5,
        )));
  }

  static showSvgImage(
      {required String path,
      Color color = Colors.white,
      String? tooltip,
      Function()? onPressed}) {
    return IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: SvgPicture.asset(path));
  }

  static showImage(
      {required String path,
      double width = 20.0,
      double height = 20.0,
      Color? color}) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      color: color,
    );
  }

  static showAssetImage(
      {required String path,
      double width = 20.0,
      double height = 20.0,
      Color? color}) {
    return Image.asset(
      path,
      width: width,
      height: height,
      color: Provider.of<AppThemeController>(Get.context!).appColor,
    );
  }

  static showAssetImage1(
      {required String path, double width = 20.0, double height = 20.0}) {
    return Image.asset(
      path,
      width: width,
      height: height,
    );
  }

  static Widget checkBox(
      {bool? value = false,
      Function()? onChanged,
      String? title,
      dynamic controller}) {
    return InkWell(
      onTap: onChanged,
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Checkbox(
                onChanged: (val) {
                  controller = val;
                },
                value: value,
              ),
            ),
            10.widthBox,
            TextWidget(
              "$title",
            ),
          ],
        ),
      ),
    );
  }

  static String? showNumber(final data) {
    String nr = "0";
    if (data.isFinite) {
      return double.parse(data.toString()).toStringAsFixed(2);
    } else {
      return nr;
    }
  }

  static showProfileDialog() {
    Utilities.speak();
    showDialog(
        context: DataInfo.navKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                            DataInfo.box.write("status", 2);
                          },
                          icon: const Icon(Icons.close))),
                  CustomWidgets.profileImage(
                      url:
                          "${WebApis.rootUrl}/crm/image/A${DataInfo.profileId.value.toString()}.jpeg",
                      radius: 50),
                  // "${WebApis.rootUrl}/crm/image/A${DataInfo.userId.value.toString()}.jpeg"
                  //     .circularNetworkImage(
                  //         bgColor: Colors.transparent, radius: 50),
                  20.heightBox,
                  TextWidget(
                    DataInfo.fullName.value,
                    textAlign: TextAlign.center,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: appColor.value,
                  ),
                  10.heightBox,
                  TextWidget(
                    DataInfo.designation.value,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  10.heightBox,
                  VxRating(
                    onRatingUpdate: (value) {},
                    isSelectable: false,
                    selectionColor: appColor.value,
                  ),
                  10.heightBox,
                ],
              ),
            ).p24(),
          );
        }).then((value) {
      DataInfo.box.write("status", 2);

      if (DataInfo.updateAvailable.value && Platform.isAndroid) {
        updateDialog();
      }
    });
    // Get.dialog(
    //   Center(
    //     child: Card(
    //       color: Colors.white,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Align(
    //               alignment: Alignment.topRight,
    //               child: IconButton(
    //                   onPressed: () {
    //                     Get.back();
    //                     DataInfo.box.write("status", 2);
    //                   },
    //                   icon: const Icon(Icons.close))),
    //           CustomWidgets.profileImage(
    //               url:
    //                   "${WebApis.rootUrl}/crm/image/A${DataInfo.profileId.value.toString()}.jpeg",
    //               radius: 50),
    //           // "${WebApis.rootUrl}/crm/image/A${DataInfo.userId.value.toString()}.jpeg"
    //           //     .circularNetworkImage(
    //           //         bgColor: Colors.transparent, radius: 50),
    //           20.heightBox,
    //           TextWidget(
    //             DataInfo.fullName.value,
    //             textAlign: TextAlign.center,
    //             fontSize: 20,
    //             fontWeight: FontWeight.w700,
    //             color: appColor.value,
    //           ),
    //           10.heightBox,
    //           TextWidget(
    //             DataInfo.designation.value,
    //             textAlign: TextAlign.center,
    //             fontSize: 14,
    //             color: Colors.grey[700],
    //           ),
    //           10.heightBox,
    //           VxRating(
    //             onRatingUpdate: (value) {},
    //             isSelectable: false,
    //             selectionColor: appColor.value,
    //           ),
    //           10.heightBox,
    //         ],
    //       ),
    //     ).p24(),
    //   ),
    // ).then((value) {
    //   DataInfo.box.write("status", 2);
    //
    //   if(DataInfo.updateAvailable.value && Platform.isAndroid){
    //     updateDialog();
    //   }
    //   // Get.back();
    // });
  }

  static pickDate(BuildContext context,
      {bool selectPreviousDate = true, DateTime? selectFromDate}) {
    return showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: DateTime.now(),
        firstDate: selectFromDate ??
            (!selectPreviousDate
                ? DateTime.now()
                : DateTime(DateTime.now().year - 50)),
        lastDate: DateTime.now().add(
          const Duration(days: 200),
        ));
  }

  // static pickDate(BuildContext context,
  //     {bool selectPreviousDate = true, DateTime? selectFromDate}) {
  //   return showDatePicker(
  //       context: context,
  //       initialDatePickerMode: DatePickerMode.day,
  //       initialDate: selectFromDate ?? DateTime.now(),
  //       firstDate: selectFromDate ??
  //           (!selectPreviousDate
  //               ? DateTime.now()
  //               : DateTime(DateTime.now().year - 50)),
  //       lastDate: DateTime.now().add(
  //         const Duration(days: 200),
  //       ));
  // }

  static pickTime(BuildContext context) {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  static pickMonth(BuildContext context, {DateTime? selectDate}) async {
    return await showMonthPicker(
      context: context,
      initialDate: selectDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 50),
    );
  }

  static customDropDown(RxList list, String type, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            showMenu(
                context: Get.context!,
                position: const RelativeRect.fromLTRB(60.0, 500.0, 100.0, 0),
                items: list.map((data) {
                  return PopupMenuItem<dynamic>(
                    onTap: () {
                      //controller.selectBrochure.value = data['NAME'];
                    },
                    child: TextWidget(
                      data['NAME'],
                      fontSize: 14,
                    ),
                  );
                }).toList());
          },
          child: Row(
            children: [
              TextWidget(
                "Select",
                fontSize: 16,
              ),
              10.widthBox,
              const Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
              )
            ],
          ),
        ),
      ],
    ).pOnly(bottom: 5.0);
  }

  static customBottomSheet(var list, String parameter, bool isShowSearch,
      ValueChanged<Map<String, dynamic>> data) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36.0), topRight: Radius.circular(36.0)),
          boxShadow: [
            BoxShadow(
              color: Color(0x3f929292),
              blurRadius: 27,
              offset: Offset(0, -4),
            ),
          ],
          color: Colors.white,
        ),
        child: CustomBottomSheet(
          list: list,
          parameter: parameter,
          showSearchWidget: isShowSearch,
          data: (value) {
            data(value);
          },
        ),
      ),
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 400),
    ).then((value) => FocusManager.instance.primaryFocus?.unfocus());
  }

  static showDialogWidget({String? title, String? content}) {
    Get.dialog(Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              title!,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ).p8(),
            Container(
              width: Get.width,
              height: 1.0,
              color: Colors.grey[400],
            ),
            10.heightBox,
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                child: SingleChildScrollView(
                  child: TextWidget(
                    content,
                    fontSize: 16,
                    maxLines: 100,
                  ),
                ),
              ),
            ),
            10.heightBox,
            CustomButton(
              text: "OK",
              onPressed: () {
                Get.back();
              },
              width: 120,
              height: 40,
            )
          ],
        ).p8(),
      ).p8(),
    ));
  }

  static showAlertDialog(
      {String? title,
      String? content,
      Function()? onCancel,
      Function()? onClick}) {
    Get.dialog(Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              title!,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ).p8(),
            Container(
              width: Get.width,
              height: 1.0,
              color: Colors.grey[400],
            ),
            10.heightBox,
            TextWidget(
              content,
              fontSize: 16,
              maxLines: 10,
            ),
            40.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                onCancel != null
                    ? TextButton(
                        onPressed: onCancel, child: TextWidget("Cancel"))
                    : const SizedBox(),
                onClick != null
                    ? CustomButton(
                        text: "OK",
                        onPressed: onClick,
                        width: 120,
                        height: 40,
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ).p8(),
      ).pSymmetric(h: 50.0, v: 8.0),
    ));
  }

  static showAlertDialog1(
      {Icon? icon,
      String? title,
      String? content,
      Function()? onCancel,
      Function()? onClick,
      Widget? widget,
      String? text1 = "Ok",
      String? text2 = "Cancel",
      Widget workShop = const SizedBox()}) {
    Get.dialog(Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            20.heightBox,
            icon ??
                Icon(
                  Icons.check,
                  color: appColor.value,
                  size: 45,
                ),
            10.heightBox,
            TextWidget(
              title!,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ).p8(),
            20.heightBox,
            TextWidget(
              content,
              fontSize: 16,
              maxLines: 10,
              textAlign: TextAlign.center,
            ),
            workShop,
            40.heightBox,
            widget ?? const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                onCancel != null
                    ? TextButton(
                        onPressed: onCancel,
                        child: TextWidget(
                          text2,
                          fontSize: 18,
                          color: Colors.black,
                        ))
                    : const SizedBox(),
                onClick != null
                    ? CustomButton(
                        text: text1,
                        onPressed: onClick,
                        width: 120,
                        height: 40,
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ).p8(),
      ).pSymmetric(h: 50.0, v: 8.0),
    ).pOnly(bottom: 100.0));
  }

  static Widget divider({double? width, double? height, Color? color}) {
    return Container(
      width: width ?? Get.width,
      height: height ?? 0.8,
      color: color ?? Colors.grey[300],
    );
  }

  static pickDateRange(
    BuildContext context,
    var selectFromDate,
  ) {
    return showDatePicker(
        context: context,
        initialDate: selectFromDate ?? DateTime.now(),
        firstDate: selectFromDate ?? DateTime.now(),
        lastDate: DateTime.now().add(
          const Duration(days: 200),
        ));
  }

  static pickDateRange1(
    BuildContext context,
    var selectFromDate,
  ) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: selectFromDate ?? DateTime.now(),
        lastDate: DateTime.now().add(
          const Duration(days: 200),
        ));
  }

  static Widget profileImage({required String url, double radius = 40.0}) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const SizedBox(
          width: 40,
          height: 40,
          child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(defaultProfile))),
      ),
      imageBuilder: (context, provider) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: provider,
      ),
    );
  }
}

Widget selectItem(
    {required String title,
    required String label,
    Function()? onPressed,
    Widget? icon}) {
  return ColoredBox(
    color: Colors.transparent,
    child: TextField(
      onTap: onPressed,
      readOnly: true,
      controller: TextEditingController(text: title),
      maxLines: null,
      style: const TextStyle(
        fontSize: 14,
        color: greyColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        label: TextWidget(
          label,
          color: Colors.grey[700],
          fontSize: 14,
        ),
        suffixIcon: icon ??
            const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Color(0xff4A4A4A),
            ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.grey[300]!)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.grey[300]!)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.grey[300]!)),
      ),
    ),

    // Column(
    //   children: [
    //
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         SizedBox(
    //           width: Get.width * 0.85,
    //
    //           child: TextWidget(
    //             title,
    //             color: greyColor,
    //             fontSize: 14,
    //             fontWeight: FontWeight.w400,
    //             maxLines: 5,
    //           ),
    //         ),
    //      icon ??   const Icon(
    //           Icons.keyboard_arrow_down_outlined,
    //           color: Color(0xff4A4A4A),
    //         )
    //
    //       ],
    //     ),
    //     15.heightBox,
    //     CustomWidgets.divider(
    //         height: 1.5
    //     ),
    //   ],
    // ),
  ).pSymmetric(v: 8.0);
}

Widget textField(
    {final controller,
    String? hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization? textCapitalization,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefix}) {
  return Column(
    children: [
      TextField(
        controller: controller,
        onTapOutside: (event) {},
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: greyColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            prefixIcon: prefix,
            counterText: ""),
        maxLength: maxLength,
        keyboardType: keyboardType ?? TextInputType.name,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        textInputAction: textInputAction ?? TextInputAction.none,
        inputFormatters: inputFormatters,
      ),
      5.heightBox,
      CustomWidgets.divider(height: 1.5),
    ],
  );
}

commentField({
  final controller,
  Function(String value)? onChanged,
  String? hintText,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  int? maxLength,
  FocusNode? focusNode,
  int minLines = 5,
  int maxLines = 50,
  Function()? onTap,
}) {
  return Container(
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1.0, color: dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: TextField(
      onChanged: onChanged,
      controller: controller,
      onTap: onTap,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: greyColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
      ),
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType ?? TextInputType.name,
      textInputAction: textInputAction ?? TextInputAction.done,
      focusNode: focusNode,
    ).pSymmetric(h: 16.0, v: 8.0),
  ).pSymmetric(v: 16.0);
}

BoxDecoration decoration(BuildContext context, {final borderRadius}) {
  return BoxDecoration(
      gradient: LinearGradient(
        begin: const Alignment(1.00, 0.00),
        end: const Alignment(-1, 0),
        colors: [
          Provider.of<AppThemeController>(context)
              .appGradientColor
              .first
              .withOpacity(0.1),
          Provider.of<AppThemeController>(context)
              .appGradientColor[1]
              .withOpacity(0.1)
        ],
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14919191),
          blurRadius: 12,
          offset: Offset(0, 2),
          spreadRadius: 0,
        )
      ],
      border: GradientBoxBorder(
        gradient: LinearGradient(
          begin: const Alignment(1.00, 0.00),
          end: const Alignment(-1, 0),
          colors: [
            Provider.of<AppThemeController>(context)
                .appGradientColor
                .first
                .withOpacity(0.4),
            Provider.of<AppThemeController>(context)
                .appGradientColor[1]
                .withOpacity(0.2),
          ],
        ),
        width: 1.0,
      ));
}

BoxDecoration decoration1(BuildContext context) {
  return BoxDecoration(
      gradient: LinearGradient(
        begin: const Alignment(1.00, 0.00),
        end: const Alignment(-1, 0),
        colors: [
          Provider.of<AppThemeController>(context)
              .appGradientColor
              .first
              .withOpacity(0.1),
          Provider.of<AppThemeController>(context)
              .appGradientColor[1]
              .withOpacity(0.1)
        ],
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14919191),
          blurRadius: 12,
          offset: Offset(0, 2),
          spreadRadius: 0,
        )
      ],
      border: GradientBoxBorder(
        gradient: LinearGradient(
          begin: const Alignment(1.00, 0.00),
          end: const Alignment(-1, 0),
          colors: Provider.of<AppThemeController>(context).appGradientColor,
        ),
        width: 1.0,
      ));
}

var bGradient = LinearGradient(colors: [
  Provider.of<AppThemeController>(Get.context!)
      .appGradientColor
      .first
      .withOpacity(0.1),
  Provider.of<AppThemeController>(Get.context!)
      .appGradientColor[1]
      .withOpacity(0.1)
]);

BoxDecoration decoration2(BuildContext context) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14919191),
          blurRadius: 12,
          offset: Offset(0, 2),
          spreadRadius: 0,
        )
      ],
      border: GradientBoxBorder(
        gradient: LinearGradient(
          begin: const Alignment(1.00, 0.00),
          end: const Alignment(-1, 0),
          colors: Provider.of<AppThemeController>(context).appGradientColor,
        ),
        width: 1.0,
      ));
}

customBottomSheet({String? title, required Widget widget}) {
  Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36.0), topRight: Radius.circular(36.0)),
          boxShadow: [
            BoxShadow(
              color: Color(0x3f929292),
              blurRadius: 27,
              offset: Offset(0, -4),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 134,
              height: 5,
              decoration: ShapeDecoration(
                color: dividerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ).p16(),
            Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                title ?? "Select",
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            10.heightBox,
            widget,
          ],
        ).pSymmetric(h: 20.0, v: 10.0),
      ),
      isScrollControlled: true);
}

shapeDecoration({final borderRadius}) {
  return ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: const BorderSide(width: 0.50, color: dividerColor),
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    ),
    shadows: const [
      BoxShadow(
        color: Color(0x14919191),
        blurRadius: 12,
        offset: Offset(0, 2),
        spreadRadius: 0,
      )
    ],
  );
}

updateDialog() {
  return Get.bottomSheet(const UpdateAppWidget(),
      isDismissible: DataInfo.updateAvailable.value
          ? false
          : true, //DataInfo.isDownloadApp.value ? false : true,
      enableDrag: DataInfo.updateAvailable.value
          ? false
          : true, // DataInfo.isDownloadApp.value ? false : true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      clipBehavior: Clip.hardEdge);
}

String timeAgoSinceDate(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}

storeNotification(RemoteMessage? event) async {
  try {
    await PrefsService().init();
    if (event != null) {
      List<dynamic> list = [];
      String? data = await SharedPrefHelper.getString(DataInfo.notificationKey);

      int count = PrefsService().getNotificationCount();
      List<dynamic> list1 = await DBHelper().getAllNotifications();
      if (data != null) {
        list = json.decode(data);
      }

      int index = list1.length;
      if (event.notification != null) {
        Map<String, dynamic> data = {
          "id": index + 1,
          "title": "${event.notification!.title}",
          "content": "${event.notification!.body}",
          "date": "${DateTime.now()}",
          "isRead": 0,
        };
        list.add(data);

        if (list.isNotEmpty) {
          if (data['title'] != 'Title') {
            DBHelper().insertNotification(data);
            await SharedPrefHelper.saveString(
                DataInfo.notificationKey, json.encode(list));
            count = count + 1;
          }
        }
      }
      await PrefsService().setNotificationData(list);

      Get.put(NotificationListController()).list.value = list;

      DataInfo.navKey.currentContext!
          .read<NotificationListProvider>()
          .updateNotificationData(list: list, count: count);

      await SharedPrefHelper.saveBool("isReadNotification", false);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

class SharedPrefHelper {
  // Save a string
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Save a boolean
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Save an integer
  static Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Save a double
  static Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Save a list of strings
  static Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  // Get a string
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Get a boolean
  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Get an integer
  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Get a double
  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Get a list of strings
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Remove a key
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clear all keys
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
