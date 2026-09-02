// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class AppThemeController extends ChangeNotifier{
  Color appColor = const  Color(0xffe0659b);
  List<Color> appGradientColor = const [Color(0xffe0659b), Color(0xff8b4de6)];

  Gradient appBarGradientColor = const LinearGradient(
      colors: [Color(0xffe0659b), Color(0xff8b4de6)]
  );


  changeTheme(List<Color> colors){
    appColor = colors.first;
    appGradientColor = colors;
    appBarGradientColor = LinearGradient(
        colors: colors
    );
    notifyListeners();
  }
}