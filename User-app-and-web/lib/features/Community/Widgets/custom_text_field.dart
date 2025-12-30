import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'color_utils.dart';
import 'font_utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final IconData? prefixIconData;
  final bool? prefixRequired;
  final bool? suffixRequired;
  final String? svgPrefixImage;
  final String? svgSuffixImage;
  final double? suffixImageWidth;
  final double? suffixImageHeight;
  final double? prefixImageWidth;
  final double? prefixImageHeight;
  final double? borderRadius;
  final double? fontSize;
  final bool isEditable;
  final String? labelText;
  final Color? feildTheme;
  final Color? labelColor;
  final Color? TextColor;
  final double? FieldHeight;
  final double? Field_Width;
  final Color? hintColor;

  const CustomTextField(
      {this.controller,
      this.textInputType,
      this.hintText,
      this.prefixIconData,
      this.prefixRequired,
      this.suffixRequired,
      this.svgSuffixImage,
      this.svgPrefixImage,
      this.suffixImageWidth,
      this.suffixImageHeight,
      this.prefixImageWidth,
      this.prefixImageHeight,
        this.borderRadius,
      this.labelText,
      this.fontSize,
      this.feildTheme,
      this.isEditable = true,
      Key? key,
      this.TextColor,
      this.FieldHeight,
      this.Field_Width,
      this.hintColor,
      this.labelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: prefixRequired == true
          ? TextField(
              controller: controller,
              style: TextStyle(
                color: TextColor ?? ColorUtils.black,
                fontFamily: FontUtils.urbanistMedium,
                fontSize: fontSize ?? 16,
              ),
              keyboardType: textInputType,
              readOnly: !isEditable,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: labelText,
                labelStyle: TextStyle(
                  color: labelColor ?? ColorUtils.grey2,
                ),
                prefixIconConstraints: BoxConstraints(
                  minHeight: prefixImageHeight!,
                  minWidth: prefixImageWidth!,
                ),
                contentPadding: EdgeInsets.only(
                    left: 20,
                    top: FieldHeight ?? 15,
                    right: 10,
                    bottom: 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: feildTheme ?? ColorUtils.grey2,
                      width: Field_Width ?? 1),
                  borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
                  borderSide: BorderSide(
                      color: feildTheme ?? Theme.of(context).primaryColor,
                      width: Field_Width ?? 1.5),
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: hintColor ?? ColorUtils.hintGrey),
                prefixIcon: svgPrefixImage != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 4.w, right: 4.w),
                        child: SvgPicture.asset(
                          svgPrefixImage!,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.calendar_month,
                          color: ColorUtils.black,
                        ),
                      ),
              ),
            )
          : suffixRequired == true
              ? TextField(
                  controller: controller,
                  style: TextStyle(
                    color: TextColor ?? ColorUtils.black,
                    fontFamily: FontUtils.urbanistMedium,
                    fontSize: fontSize ?? 16,
                  ),
                  keyboardType: textInputType,
                  readOnly: !isEditable,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: labelText,
                    labelStyle: TextStyle(
                      color: labelColor ?? ColorUtils.grey2,
                    ),
                    //isDense: true,
                    suffixIconConstraints: BoxConstraints(
                      minHeight: suffixImageHeight!,
                      minWidth: suffixImageWidth!,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 20,
                        top: FieldHeight ?? 15,
                        right: 10,
                        bottom: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              feildTheme ?? ColorUtils.grey2,
                          width: Field_Width ?? 1),
                      borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
                      borderSide: BorderSide(
                          color: feildTheme ?? Theme.of(context).primaryColor,
                          width: Field_Width ?? 1.5),
                    ),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: hintColor ?? ColorUtils.hintGrey,
                    ),
                    suffixIcon: svgSuffixImage != null
                        ? Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: SvgPicture.asset(svgSuffixImage!),
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: Icon(
                              Icons.calendar_month,
                              color: ColorUtils.black,
                            ),
                          ),
                  ),
                )
              : TextField(
                  controller: controller,
                   maxLines: null,
                  style: TextStyle(
                    color: TextColor ?? ColorUtils.black,
                    fontFamily: FontUtils.urbanistMedium,
                    fontSize: fontSize ?? 16,
                  ),
                  keyboardType: textInputType,
                  readOnly: !isEditable,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: labelText,
                    labelStyle: TextStyle(
                      color: labelColor ?? ColorUtils.grey2,
                    ),
                    //isDense: true,
                    contentPadding: EdgeInsets.only(
                        left: 20,
                        top: FieldHeight ?? 15,
                        right: 10,
                        bottom: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              feildTheme ?? ColorUtils.grey2,
                          width: Field_Width ?? 1),
                      borderRadius: BorderRadius.circular(borderRadius ?? 40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 40.0),
                      borderSide: BorderSide(
                          color: feildTheme ?? Theme.of(context).primaryColor,
                          width: Field_Width ?? 1.5),
                    ),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: hintColor ?? ColorUtils.hintGrey,
                    ),
                  ),
                ),
    );
  }
}
