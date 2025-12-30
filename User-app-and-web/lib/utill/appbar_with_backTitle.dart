import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexacom_user/utill/styles.dart';
import '../features/Community/Widgets/color_utils.dart';
import '../features/Community/Widgets/font_utils.dart';
import '../features/Community/Widgets/page_horizontal_margin.dart';
import '../features/Community/Widgets/text_widget.dart';
import 'images.dart';

class AppBarWithBackTitle extends StatelessWidget {
  final String? title;
  final String? suffixIcon1;
  final VoidCallback? onSuffixButtonPressed1;
  final String? suffixIcon2;
  final VoidCallback? onSuffixButtonPressed2;
  final Color? color;
  final bool showBackButton;

  const AppBarWithBackTitle({
    this.title,
    this.suffixIcon1,
    this.onSuffixButtonPressed1,
    this.suffixIcon2,
    this.onSuffixButtonPressed2,
    this.showBackButton = true,
    Key? key, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageHorizontalMargin(
      horizontal: 15,
      widget: Row(
        children: [
          showBackButton ?
          GestureDetector(
            child: SvgPicture.asset(
              Images.backArrow,
              width: 24,
              height: 24,
              color: color ?? ColorUtils.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ) : SizedBox(width: 24,),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: TextWidget(
              textValue: title,
              textColor: color ?? ColorUtils.black,
              textAlign: TextAlign.center,
              fontFamily: rubikSemiBold.fontFamily,
              fontSize: 18,
              fontWeight: rubikSemiBold.fontWeight,
            ),
          ),
          if (suffixIcon1 != null)
            GestureDetector(
              onTap: onSuffixButtonPressed1,
              child: SvgPicture.asset(
                suffixIcon1 ?? "",
                width: 24,
                height: 24,
              ),
            ),
          if (suffixIcon1 != null && suffixIcon2 != null)
            SizedBox(
              width: 2.w, // Add spacing between the icons
            ),
          if (suffixIcon2 != null)
            GestureDetector(
              onTap: onSuffixButtonPressed2,
              child: SvgPicture.asset(
                suffixIcon2 ?? "",
                width: 24,
                height: 24,
              ),
            ),
          if (suffixIcon1 == null && suffixIcon2 == null)
            SizedBox(
              width: 3.2.h,
            ),
        ],
      ),
    );
  }
}
