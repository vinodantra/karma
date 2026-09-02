// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
class TallySerialNumber extends StatelessWidget {
  const TallySerialNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Details"),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Column(
              children: [
                ListTile(

                  title: TextWidget("Is Tally",
                    fontSize: 16,),
                  trailing: TextWidget("Yes"),

                ),
                Container(
                  width: Get.width,
                  height: 1.0,
                  color: Colors.grey[200],
                )
              ],
            ),
            Column(
              children: [
                ListTile(

                  title: TextWidget("URT",
                    fontSize: 16,),
                  trailing: TextWidget("No"),

                ),
                Container(
                  width: Get.width,
                  height: 1.0,
                  color: Colors.grey[200],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
