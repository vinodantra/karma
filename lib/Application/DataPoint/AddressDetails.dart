// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
class AddressDetails extends StatelessWidget {
  const AddressDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.back();
      },
      child: Scaffold(
        appBar: AppBarWidget(title: "${data['NAME']}",

        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded,color: Colors.lightBlueAccent,size: 18,),
                  10.widthBox,
                  TextWidget(data['NAME'],fontSize: 16,),
                ],
              ).pSymmetric(h: 10,v: 5.0),
              Row(
                children: [
                  const Icon(Icons.call_outlined,color: Colors.lightBlueAccent,size: 18,),
                  10.widthBox,
                  TextWidget("${data['STD'].toString().trim()} ${data['PHONE']}",fontSize: 16,),
                ],
              ).pSymmetric(h: 10,v: 5.0),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,color: Colors.lightBlueAccent,size: 18,),
                  10.widthBox,
                  TextWidget("${data['PIN'].toString().trim()} ${data['CITY'].toString().trim()} ${data['DISTRICT'].toString().trim()}",fontSize: 16,),
                ],
              ).pSymmetric(h: 10,v: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
