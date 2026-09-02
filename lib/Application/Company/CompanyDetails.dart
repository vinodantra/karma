// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class CompanyDetails extends StatelessWidget {
  const CompanyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "ABC Company Ltd",),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: ListView(
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xffeaecf0), width: 1, ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(profile)
                          )
                        ),

                      ),
                      10.widthBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget("Olivia Rhye",fontSize: 14,),
                          5.heightBox,
                          TextWidget("Products Manager, Integrations",
                            color: descriptionColor,
                            fontSize: 14,),
                          15.heightBox,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              iconWidget(callIcon1, "Call"),
                              iconWidget(emailIcon, "Email"),
                              iconWidget(websiteIcon, "Website"),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ).p12(),
            ),
            15.heightBox,
            Column(
              children: [
                tileWidget("Address"),
                tileWidget("Mail Brochure"),
                tileWidget("Call Booking"),
                tileWidget("Contact Details"),
                tileWidget("Opportunity"),
                tileWidget("Products & Services"),
                tileWidget("Delivery Request"),
                tileWidget("Recent Activity"),
                tileWidget("Tally Serial Number"),
                tileWidget("Tickets"),
                tileWidget("Visit History"),
              ],
            )
          ],
        ).pSymmetric(h: 8.0,v: 15.0),
      ),
    );
  }
  Widget iconWidget(String iconName,String title){
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xffd0d5dd), width: 1, ),
      ),
      child: Row(
        children: [
          CustomWidgets.showImage(path: iconName,
              width: 14,
              height: 14
          ),
          5.widthBox,
          TextWidget(title,color: const Color(0xff191d23),
            fontSize: 12,)
        ],
      ).pSymmetric(h: 15.0,v: 5.0),
    ).pOnly(right: 8.0);
  }

  Widget tileWidget(String title){
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3fb0b0b0),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(child: TextWidget(title,
              color: darkTextColor,
              fontSize: 16,)),
          ),
          CustomWidgets.showImage(path: arrowRightIcon,
              width: 24,
              height: 24)
        ],
      ).pSymmetric(h: 10.0,v: 10.0),
    ).pOnly(bottom: 8.0);
  }
}
