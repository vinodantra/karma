// ignore_for_file: file_names, must_be_immutable

import '../../Constants/Library.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  String? label;
  bool obscureText;
  Widget? suffixIcon;
  TextInputType? keyboardType;
  String? errorText;
  int maxLines;
  TextInputAction textInputAction;
  Function(String value)? onSubmitted;

  CustomTextField(
      {super.key,
      this.controller,
      this.label,
      this.obscureText = false,
      this.suffixIcon = const SizedBox(),
      this.keyboardType = TextInputType.text,
      this.errorText = "",
      this.maxLines = 1,
      this.textInputAction =  TextInputAction.none,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: TextWidget(
          label!,
          color: greyColor,
          fontSize: 12,
        ),
        suffixIcon: suffixIcon,
        errorText: errorText!.isNotEmpty ? errorText : null
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
    );
  }
}
