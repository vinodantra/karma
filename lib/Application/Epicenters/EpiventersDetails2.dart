// ignore_for_file: file_names, must_be_immutable

import 'package:karma/Constants/Library.dart';

class EpicentersDetails2 extends StatelessWidget {
  final Map<String, dynamic> data;
  const EpicentersDetails2({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: (data['DPNAME'] ?? '').toString()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(
                label: "Account Owner",
                content: (data['ACCOWNER'] ?? '').toString()),
            _infoRow(
                label: "Company", content: (data['DPNAME'] ?? '').toString()),
            _infoRow(
                label: "Contact Name",
                content: (data['CONTNAME1'] ?? '').toString()),
            _infoRow(
                label: "Contact Number",
                content:
                    (data['CONTNO1'] ?? data['CONTNAME1'] ?? '').toString()),
            _infoRow(
                label: "Transferable",
                content: (data['ALOCATE'] ?? '').toString()),
            _infoRow(label: "AMC", content: (data['AMC'] ?? '').toString()),
            _infoRow(
                label: "ISTALLY", content: (data['ISTALLY'] ?? '').toString()),
            _infoRow(label: "SB", content: (data['SB'] ?? '').toString()),
            _infoRow(label: "TNS", content: (data['TNS'] ?? '').toString()),
            RichText(
              text: TextSpan(
                  text: "Address : ",
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16,
                    fontWeight: titleFontWeight,
                  ),
                  children: [
                    TextSpan(
                      text: (data['ADD1'] ?? '').toString().trim(),
                      style: TextStyle(
                        color: descriptionColor,
                        fontSize: 16,
                        fontWeight: titleFontWeight,
                      ),
                    )
                  ]),
            ).pSymmetric(h: 10.0, v: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required String label, String? content}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              label,
              color: titleColor,
              fontSize: 16,
              fontWeight: titleFontWeight,
            ),
            SizedBox(
              width: Get.width / 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextWidget(
                  (content ?? ''),
                  color: descriptionColor,
                  fontSize: 16,
                  maxLines: 5,
                  fontWeight: titleFontWeight,
                ),
              ),
            ),
          ],
        ),
        10.heightBox,
        CustomWidgets.divider(),
      ],
    ).paddingSymmetric(horizontal: 10.0, vertical: 10.0);
  }
}
