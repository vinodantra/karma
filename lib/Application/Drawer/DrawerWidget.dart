// ignore_for_file: file_names, invalid_use_of_protected_member, unused_import

import 'dart:io';
import 'package:karma/Application/AGH/AGHDashboard.dart';
import 'package:karma/Application/ANS/ans_screen.dart';
import 'package:karma/Application/Escalation/EscalationChooseType.dart';
import 'package:karma/Application/Customer/MyCustomerCall.dart';
import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Application/PblReport/PblReport.dart';
import 'package:karma/Application/Profile/profile.dart';
import 'package:karma/Application/Ticket/Ticket.dart';
import 'package:karma/Services/SecureCredentials.dart';
import '../../Constants/Library.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: appGradientColor.value)),
      child: Drawer(
        child: Container(
          height: context.screenHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: appGradientColor.value)),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: context.screenHeight * 0.25,
                    width: Get.width,
                    child: Column(
                      children: [
                        Image.asset(
                          drawerImage,
                          fit: BoxFit.cover,
                          width: Get.width,
                          height: context.screenHeight * 0.2,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 10,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const Profile());
                      },
                      child: Hero(
                        tag: "profile",
                        child: Row(
                          children: [
                            CustomWidgets.profileImage(
                                url:
                                    "${WebApis.rootUrl}/crm/image/A${DataInfo.profileId.value.toString()}.jpeg"),
                            // "${WebApis.rootUrl}/crm/image/A${DataInfo.userId.value.toString()}.jpeg".circularNetworkImage(
                            //     bgColor: Colors.transparent, radius: 40),
                            10.widthBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextWidget(
                                    "${DataInfo.profileName}",
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    maxLines: 2,
                                  ),
                                ),
                                25.heightBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "+91 ${DataInfo.mobile.trim()}",
                                      color: surfaceColor,
                                      fontSize: 12,
                                    ),
                                    5.heightBox,
                                    TextWidget(
                                      DataInfo.email.trim(),
                                      color: surfaceColor,
                                      maxLines: 2,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const DashboardNew());
                        },
                        title: "Home",
                        iconName: homeIcon),
                    DataInfo.desCat.value == "L1"
                        ? tileWidget(
                            onTap: () {
                              Get.back();
                              Get.to(() => const AGHDashboard());
                            },
                            title: "Antra Golden Hour",
                            iconName: starIcon1)
                        : const SizedBox(),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const EscalationChooseType());
                        },
                        title: "Raise Escalation",
                        iconName: notesIcon),
                    // tileWidget(
                    //     onTap: () {}, title: "About Us", iconName: aboutUsIcon),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const EpicenterDetails());
                        },
                        title: "Epicenter",
                        iconName: notesIcon),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const Reports());
                        },
                        title: "Operations",
                        iconName: walletIcon),
                    // tileWidget(
                    //     onTap: () {},
                    //     title: "Social Events",
                    //     iconName: socialEvent),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const Products());
                        },
                        title: "Products",
                        iconName: cartIcon),

                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const Ticket());
                        },
                        title: "Antra Ticket System",
                        iconName: antraTicket),
                    // DataInfo.rollId.value == "1" &&
                    DataInfo.desCat.value == "L1"
                        ? tileWidget(
                            onTap: () {
                              Get.back();
                              Get.to(() => const AnsScreen());
                            },
                            title: "ANS Report",
                            iconName: ansReport)
                        : const SizedBox(),
                    DataInfo.desCat.value == "L1"
                        ? tileWidget(
                            onTap: () {
                              Get.back();
                              Get.to(() => const PblReport());
                            },
                            title: "PBL Report",
                            iconName: pblReport)
                        : const SizedBox(),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const TicketStatus());
                        },
                        title: "Ticket Status",
                        iconName: tagsIcon),
                    // tileWidget(
                    //     onTap: () {
                    //       Get.back();
                    //       Get.to(() => const NotificationScreen());
                    //     },
                    //     title: "Notification",
                    //     iconName: tagsIcon),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Get.to(() => const Contacts());
                        },
                        title: "Contact List",
                        iconName: contactList),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Utilities.onClickLink(
                              "https://gateway.tallyhelp.com/cloudsupport");
                          //Get.to(() => const Support());
                        },
                        title: "Support Availability",
                        iconName: support),
                    // tileWidget(
                    //     onTap: () {
                    //       Get.back();
                    //       Get.to(() => const SyncProgress());
                    //     },
                    //     title: "Sync Progress",
                    //     iconName: tagsIcon),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Utilities.onClickLink(
                              "https://gateway.tallyhelp.com/pas/policy.html");
                        },
                        title: "CertiKit ISO27001",
                        iconName: infoIcon),

                    tileWidget(
                        onTap: () {
                          Get.back();
                          Utilities.onClickLink(
                              "https://docs.google.com/forms/d/e/1FAIpQLSe9M4DnN5Ttp-o4zxJ-25S5jO-d-dxr6NFVyw-U9X0rRP9fxA/viewform?c=0&w=1");
                        },
                        title: "Product Requirement",
                        iconName: notesIcon),
                    tileWidget(
                        onTap: () {
                          Get.back();
                          Utilities.onClickLink(
                              "https://forms.gle/JKk9u1y8WDXCvvZGA");
                        },
                        title: "Karma Enhancement",
                        iconName: enhancement),
                    DataInfo.desCat.value == "L1"
                        ? tileWidget(
                            onTap: () {
                              Get.back();
                              Get.to(() => const MyCustomerCall());
                            },
                            title: "My Customer Call",
                            iconName: supportIcon)
                        : const SizedBox(),

                    Platform.isAndroid
                        ? tileWidget(
                            onTap: () {
                              Get.back();
                              updateDialog();
                            },
                            title: "Update App",
                            iconName: updateIcon)
                        : const SizedBox(),

                    Platform.isAndroid
                        ? tileWidget(
                            onTap: () {
                              Get.back();
                              Utilities.onClickLink(DataInfo.url.value,
                                  mode: LaunchMode.inAppWebView);
                            },
                            title: "What's New",
                            iconName: infoIcon)
                        : const SizedBox(),
                    // tileWidget(
                    //     onTap: () {
                    //
                    //
                    //       //Get.toNamed("/products");
                    //     }, title: "Support", iconName: supportIcon),
                    // tileWidget(
                    //     onTap: () {},
                    //     title: "Settings",
                    //     iconName: settingsIcon),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "App Version - V${DataInfo.appVersion.value}",
                    color: surfaceColor,
                    fontSize: 12,
                  ),
                  InkWell(
                    onTap: () async {
                      bool isRemember = false;

                      if (DataInfo.box.hasData('isRemember')) {
                        isRemember = DataInfo.box.read('isRemember');
                      }

                      final rememberedPwd =
                          isRemember ? DataInfo.password.value : null;
                      final rememberedUser =
                          isRemember ? DataInfo.username1.value : null;

                      await DataInfo.box.erase();
                      // Always wipe secure storage on logout; we re-save
                      // below only if Remember Me was on.
                      await SecureCredentials.clear();

                      DataInfo.isSelectUser.value = true;
                      DataInfo.selectTheme.value = 1;
                      if (isRemember && rememberedUser != null) {
                        DataInfo.box.write("username", rememberedUser);
                        DataInfo.box.write("isRemember", isRemember);
                        if (rememberedPwd != null && rememberedPwd.isNotEmpty) {
                          await SecureCredentials.savePassword(rememberedPwd);
                        }
                        final lc = Get.find<LoginController>();
                        lc.userNameController.text = rememberedUser;
                        lc.passwordController.text = rememberedPwd ?? '';
                      }

                      Get.offAll(() => const LoginPage());
                    },
                    child: TextWidget(
                      "Logout",
                      color: surfaceColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ).pSymmetric(h: 25.0, v: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget tileWidget({String? title, String? iconName, Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: iconName!.contains('svg')
          ? CustomWidgets.showImage(path: iconName, color: Colors.white)
          : CustomWidgets.showAssetImage1(path: iconName),
      minLeadingWidth: 1.0,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 1.0,
      title: TextWidget(
        title,
        color: surfaceColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ).pOnly(left: 20.0).h(40);
  }
}
