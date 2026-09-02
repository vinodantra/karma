// ignore_for_file: must_be_immutable, file_names

import 'package:karma/Constants/Library.dart';
class SearchWidget extends StatelessWidget {
  TextEditingController? controller;
  String? hintText;
  Function(String? value)?onChanged;
  Function()? onClose;
   SearchWidget({super.key,this.controller,this.hintText,this.onChanged,this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      //   color: Colors.grey[200],
      //
      // ),
        decoration: ShapeDecoration(
          color: const Color(0x1E767680),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),

        child: TextField(
        key: key,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText ?? "",
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search,color: iconColor,),
          suffixIcon: controller!.text.trim().isNotEmpty ?
          IconButton(onPressed: onClose,
          icon:  Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor,
            ),
            child: Icon(Icons.close,color: Colors.grey[200],size: 10,).p4(),
          )
          ) : null,
          constraints: const BoxConstraints(
            minHeight: 45,
            maxHeight: 45
          )
        ),


      )
    ).p8();
  }
}
