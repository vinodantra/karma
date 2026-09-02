// ignore_for_file: must_be_immutable, file_names, invalid_use_of_protected_member
import '../../Constants/Library.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  String? text;
  double? width;
  double? height;

   CustomButton({super.key,@required this.text,this.onPressed,this.width = 150,this.height = 50});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient:   LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: appGradientColor.value, ),
        ),

       alignment: Alignment.center,
       child: TextWidget(
         text,
         color: Colors.white,
         fontSize: 16,
         fontWeight: FontWeight.w600,
       ),
      ),
    );
  }
}
