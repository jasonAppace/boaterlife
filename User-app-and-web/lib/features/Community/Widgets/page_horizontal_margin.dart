import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';

class PageHorizontalMargin extends StatelessWidget {

  final Widget? widget;
  final double? horizontal;

  PageHorizontalMargin({this.widget, Key? key, this.horizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal ?? 5),
      child: widget,
    );
  }
}
