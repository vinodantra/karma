// ignore_for_file: must_be_immutable, file_names

import '../../Constants/Library.dart';

class MonthlyReport extends StatelessWidget {
  List<dynamic> data;
  MonthlyReport({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Monthly Report",
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, int index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      data[index]['DATE'],
                      fontSize: 20,
                      color: appColor.value,
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "Status",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        TextWidget(
                          data[index]['STATUS'],
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "In Time",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        TextWidget(
                          data[index]['TMIN'],
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "Out Time",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        TextWidget(
                          data[index]['TMOUT'],
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    10.heightBox,
                  ],
                ).pSymmetric(h: 10.0, v: 10.0),
              ).pSymmetric(h: 10.0, v: 4.0);
            }),
      ),
    );
  }
}
