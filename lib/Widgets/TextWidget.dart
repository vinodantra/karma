// ignore_for_file: file_names, must_be_immutable, avoid_init_to_null

import 'package:karma/Constants/Library.dart';


class TextWidget extends StatelessWidget {
  String? text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  int maxLines;
  TextDecoration textDecoration;
  TextWidget(this.text,
      {super.key,
      this.color,
      this.fontSize = 12,
      this.fontWeight = FontWeight.normal,
      this.textAlign = null,
      this.maxLines = 1,
      this.textDecoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!.trim().toString(),
      textAlign: textAlign,
      maxLines: maxLines,
      textScaler: TextScaler.noScaling,

      style: GoogleFonts.inter(
          color: color, fontSize: fontSize, fontWeight: fontWeight,
      decoration: textDecoration),
    );
  }
}


class GradientTextWidget extends StatelessWidget {
  String? text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  int maxLines;
  TextDecoration textDecoration;
  Gradient? gradient;
  GradientTextWidget(this.text,
      {super.key,
        this.color,
        this.fontSize = 12,
        this.fontWeight = FontWeight.normal,
        this.textAlign = null,
        this.maxLines = 1,
        this.textDecoration = TextDecoration.none,this.gradient,});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppThemeController>(context);
    // gradient = Gradient(
    //   colors: Provider.of<AppThemeController>(context).appGradientColor
    // );
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(colors: controller.appGradientColor).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text!.trim().toString(),
        textAlign: textAlign,
        maxLines: maxLines,
        style: GoogleFonts.inter(
             fontSize: fontSize, fontWeight: fontWeight,
            decoration: textDecoration),
      ),
    );
  }
}
