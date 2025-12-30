
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/size_config.dart';

extension MakeUiResponse on BuildContext{
  double screenHeight() {
    return MediaQuery.of(this).size.height.toDouble();
  }
  double screenWidth() {
    return MediaQuery.of(this).size.width.toDouble();
  }
  EdgeInsets getPadding(){
    return MediaQuery.of(this).padding;
  }
  void unFocus(){
    FocusScope.of(this).requestFocus(FocusNode());
  }

}

extension MakeUiResponse1 on num {
  double get h {
    return SizeConfig.heightMultiplier* this;
  }
  double get w {
    return SizeConfig.widthMultiplier* this;
  }
  double get t {
    return SizeConfig.textMultiplier* this;
  }
  double get i {
    return SizeConfig.imageSizeMultiplier* this;
  }
}