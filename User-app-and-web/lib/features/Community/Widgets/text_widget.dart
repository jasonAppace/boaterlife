
import 'package:flutter/material.dart';
import 'color_utils.dart';
import 'font_utils.dart';


class TextWidget extends StatelessWidget {
  final String? textValue;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final int? maxLines;

  TextWidget({
    this.textValue,
    this.fontFamily,
    this.fontSize,
    this.textColor,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue!,
      textAlign: textAlign,
      maxLines: maxLines, // Will be null by default if not passed
      style: TextStyle(
        fontFamily: fontFamily ?? FontUtils.urbanistSemiBold,
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: textColor ?? ColorUtils.black,
      ),
    );
  }
}
