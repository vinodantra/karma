// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

const primaryColor = Colors.blue;
Rx<dynamic> appColor = const Color(0xffe0659b).obs;
RxList<Color> appGradientColor = const [Color(0xffe0659b), Color(0xff8b4de6)].obs;
const backgroundColor = Colors.white;
const  textColor = Colors.white;
const titleColor = Color(0xff344053);
const descriptionColor = Color(0xff667084);
const iconColor = Color(0xff7E8494);
const greyColor = Color(0xFF7D8493);
const blackColor = Color(0xFF282828);

// Named replacements for the most-used hardcoded literals in lib/Application/.
// Naming intent (most-frequent first):
const subtleTextColor = Color(0xff555b69);   // 28 sites — secondary text/labels
const darkTextColor = Color(0xff2f3237);     // 23 sites — strong text on light bg
const cardBorderColor = Color(0xffE5E7EF);   // ~29 sites — light card/divider border
const linkBlueColor = Color(0xff6891ff);     // 16 sites — link/info accent
const cardShadowColor = Color(0x3f919191);   // 16 sites — card box-shadow
const surfaceColor = Color(0xffF4F5F8);      // ~20 sites — light surface fill
const infoSoftBgColor = Color(0xffeceffe);   // 12 sites — info chip soft bg
const dividerColor = Color(0xFFDFDFDF);      // 11 sites — explicit dividers
const darkGreyColor = Color(0xff3d3d3d);     // 6 sites — strong grey text
const mediumGreyColor = Color(0xff787878);   // 5 sites — medium grey text
const successGreenColor = Color(0xFF33BE52); // status badges
const warnAmberColor = Color(0xFFDF8E16);    // status badges

var appColorList = const [Color(0xffe0659b),Color(0xff38CC9F),Color(0xff060606),
  Color(0xffFF616D),Color(0xff598AE5),Color(0xff56c2ae)];

const appTheme = [
  [Color(0xffe0659b), Color(0xff8b4de6)],
  [Color(0xff38CC9F), Color(0xff0A815D)],
  [Color(0xff060606), Color(0xff424242)],
  [Color(0xffFFBD71), Color(0xffFF616D)],
  [Color(0xff598AE5), Color(0xff36CFDC)],
[Color(0xff56c2ae), Color(0xff39b0d5)]];

const themeName = ["Default","Mild","Deap Sea","Sweet Morning","Scooter","Antra Theme"];

class AppTheme extends GetxController{
  Rx<dynamic> appColor = const Color(0xffe0659b).obs;
  RxList<Color> appGradientColor = const [Color(0xffe0659b), Color(0xff8b4de6)].obs;

  Rx<Gradient> appBarGradientColor = const LinearGradient(
    colors: [Color(0xffe0659b), Color(0xff8b4de6)]
  ).obs;

  changeTheme(List<Color> colors){

    appBarGradientColor.value = LinearGradient(
        colors: colors
    );
  }
}