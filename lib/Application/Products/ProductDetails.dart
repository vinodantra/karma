// ignore_for_file: must_be_immutable, file_names

import 'package:flutter_html/flutter_html.dart';

import '../../Constants/Library.dart';
class ProductDetails extends StatelessWidget {
  final Map<String,dynamic> data;
  const ProductDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: data['MODULENAME'],),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Html(
          data: data['DESCR'],
        )
      ),
    );
  }
}
