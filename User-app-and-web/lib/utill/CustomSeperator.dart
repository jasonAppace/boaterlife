import 'package:flutter/material.dart';

class CustomSeparator extends StatelessWidget {
  final Color color;
  final double thickness;
  final double marginTop;
  final double marginBottom;

  const CustomSeparator({
    Key? key,
    this.color = Colors.grey,
    this.thickness = 0.5,
    this.marginTop = 10.0,
    this.marginBottom = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      child: Container(
        width: double.infinity,
        height: thickness,
        color: color,
      ),
    );
  }
}
