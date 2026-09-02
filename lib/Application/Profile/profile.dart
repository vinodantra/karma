import 'package:flutter_html/flutter_html.dart';
import 'package:karma/Application/Profile/EditProfile.dart';

import '../../Constants/Library.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Personal Details",
      ),
      body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(
            () => Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Get.to(() => const EditProfile());
                        },
                        icon: const Icon(Icons.edit))),
                InkWell(
                  onTap: () {
                    // Get.bottomSheet(Card(
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       10.heightBox,
                    //       TextWidget("Upload Profile Picture",fontSize: 16,color: appColor.value,fontWeight: FontWeight.w600,),
                    //       10.heightBox,
                    //       CustomWidgets.divider(color: appColor),
                    //       20.heightBox,
                    //       ListTile(
                    //         leading: const Icon(Icons.image_rounded,color: appColor,),
                    //         title: TextWidget("Choose from Gallery",fontSize: 16,
                    //           color: Colors.black,fontWeight: FontWeight.w500,),),
                    //       ListTile(
                    //         leading: const Icon(Icons.camera_alt_outlined,color: appColor,),
                    //         title: TextWidget("Take New Picture",fontSize: 16,
                    //           color: Colors.black,fontWeight: FontWeight.w500,),),
                    //
                    //
                    //     ],
                    //   ).p8(),
                    // ));
                  },
                  child: Hero(
                    tag: "profile",
                    child: Stack(
                      children: [
                        CustomWidgets.profileImage(
                                url:
                                    "${WebApis.rootUrl}/crm/image/A${DataInfo.profileId.value.toString()}.jpeg",
                                radius: 70)
                            .p2()
                            .card
                            .color(appColor.value)
                            .elevation(5.0)
                            .circular
                            .make()
                            .pOnly(top: 20.0),
                        // Positioned(
                        //   bottom: 8,
                        //   right: 5,
                        //   child: Container(
                        //     decoration: const BoxDecoration(
                        //         shape: BoxShape.circle, color: appColor),
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(5.0),
                        //       child: Icon(
                        //         Icons.camera_alt_outlined,
                        //         color: Colors.white,
                        //         size: 20,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                10.heightBox,
                TextWidget(
                  DataInfo.fullName.value,
                  fontSize: 18,
                  color: appColor.value,
                  fontWeight: FontWeight.w500,
                ),
                Utilities.checkString(DataInfo.designation.value)
                    ? Column(
                        children: [
                          10.heightBox,
                          TextWidget(
                            DataInfo.designation.value,
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      )
                    : const SizedBox(),
                10.heightBox,
                TextWidget(
                  DataInfo.mobile.value,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                10.heightBox,
                TextWidget(
                  DataInfo.email.value,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                10.heightBox,
                Utilities.checkString(DataInfo.aboutMe.value)
                    ? Html(data: DataInfo.aboutMe.value).pSymmetric(h: 10.0)
                    : const SizedBox()
              ],
            ),
          )),
    );
  }
}
