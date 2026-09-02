import 'package:karma/Application/Dashboard/DashboardNew.dart';

import '../../Constants/Library.dart';

class SyncProgress extends StatelessWidget {
  const SyncProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Sync Progress ",
        onBackPress: (){


          Get.offAll(()=>const DashboardNew());
        },


      ),
      body: SizedBox(width: context.screenWidth,
      height: context.screenHeight,
      child: Column(children: [
        Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xffeaecf0),
                width: 1,
              ),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        "Name: ",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        "",
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  5.heightBox,
                  Row(
                    children: [
                      TextWidget(
                        "Row Count: ",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        "",
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  5.heightBox,
                  Row(
                    children: [
                      TextWidget(
                        "Progress Count: ",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        "2",
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  5.heightBox,
                  Row(
                    children: [
                      TextWidget(
                        "Pending",
                        color: descriptionColor,
                        fontSize: 14,
                      ),
                      5.widthBox,
                      TextWidget(
                        "",
                        color: descriptionColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  5.heightBox,



                ]).pSymmetric(h: 10, v: 10))
      ],).p8(),),
    );
  }
}
