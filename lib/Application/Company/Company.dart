// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class Company extends StatelessWidget {
  const Company({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Company",),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {

              return ListTile(
                title: TextWidget("ABC Company Ltd",
                  color: darkTextColor,
                  fontSize: 16,),
                trailing: CustomWidgets.showSvgImage(path: callIcon),

              );
        })),

    );
  }
}
