import 'package:flutter/cupertino.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';

class CustomSingleChildScrollView extends StatelessWidget {
  final Widget? widget;

  CustomSingleChildScrollView({this.widget, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: () {
        context.unFocus();
      },
      child: SingleChildScrollView(
        child: widget,
      ),
    );
  }
}
