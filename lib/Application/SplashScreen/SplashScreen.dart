// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors:Provider.of<AppThemeController>(context).appGradientColor
            )
                
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(s1),
              Image.asset(logo),
              Image.asset(s1),
            ],
          ),
        ),
      ),
    );
  }
}
