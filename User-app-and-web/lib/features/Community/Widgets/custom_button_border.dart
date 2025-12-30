import 'package:flutter/material.dart';
import 'color_utils.dart';
import 'font_utils.dart';

class CustomButtonBorder extends StatelessWidget {

  final VoidCallback? onButtonPressed;
  final String? textValue;
  final Color? buttonTextColor, borderColor, buttonColor, prefixImgColor;
  final double? textSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final String? prefixImage;

  CustomButtonBorder({this.onButtonPressed, this.textValue, this.buttonTextColor, this.borderColor, this.textSize, this.buttonHeight, this.prefixImage, Key? key, this.buttonWidth, this.buttonColor, this.prefixImgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: buttonColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor ?? ColorUtils.white.withOpacity(0)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: buttonHeight ?? 35,
        width: buttonWidth,
        child: MaterialButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: onButtonPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixImage != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(prefixImage!, height: 20,
                    color: prefixImgColor ?? ColorUtils.grey3,),
                ),
              Text(
                textValue ?? '',
                style: TextStyle(
                  fontFamily: FontUtils.urbanistSemiBold,
                  fontSize: textSize ?? 16,
                  color: buttonTextColor ?? ColorUtils.grey2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
