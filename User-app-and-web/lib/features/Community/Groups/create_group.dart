import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:stacked/stacked.dart';
import '../../../App/locator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/DashedBorderContainer.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/top_margin.dart';
import '../Widgets/text_widget.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        model.loadingWidget = false;
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Color(0xFFF9FCFE), // Solid color matching CommunityScreen
            body: PageHorizontalMargin(
              horizontal: 16, // Match CommunityScreen padding
              widget: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopMargin(),
                    AppBarWithBackTitle(
                      title: 'Create New Group',
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            textValue: 'Group Title',
                            textColor: ColorUtils.black,
                            fontFamily: FontUtils.urbanistSemiBold,
                            fontSize: 16,
                          ),
                          SizedBox(height: 8),
                          StyledTextField(
                            hintText: 'Group Title Here',
                            controller: model.createGroupTitle,
                          ),
                          SizedBox(height: 16),
                          TextWidget(
                            textValue: 'Description',
                            textColor: ColorUtils.black,
                            fontFamily: FontUtils.urbanistSemiBold,
                            fontSize: 16,
                          ),
                          SizedBox(height: 8),
                          StyledTextField(
                            hintText: 'Enter your description...',
                            controller: model.createGroupDesc,
                            maxLines: 4,
                          ),
                          SizedBox(height: 16),
                          TextWidget(
                            textValue: 'Group Image',
                            textColor: ColorUtils.black,
                            fontFamily: FontUtils.urbanistSemiBold,
                            fontSize: 16,
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorUtils.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF87CDEA).withOpacity(0.2),
                              ),
                            ),
                            child: image_picker_2(
                              onImagePicked: (File? image) {
                                setState(() {
                                  selectedImage = image;
                                });
                                print("Image Path check thisss: ${selectedImage?.path}");
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          TextWidget(
                            textValue: '*Note: You agree to the Terms & Conditions and Privacy Policy.',
                            textColor: ColorUtils.grey3,
                            fontFamily: FontUtils.urbanistRegular,
                            fontSize: 13,
                          ),
                          SizedBox(height: 20),
                          StyledButton(
                            textValue: model.loadingWidget ? 'Creating...' : 'Create Group',
                            onPressed: model.loadingWidget
                                ? null
                                : () {
                              model.doCreateGroup(
                                context,
                                model.userToken ?? "",
                                model.createGroupTitle.text,
                                model.createGroupDesc.text ?? "",
                                selectedImage,
                              );
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom TextField widget to match CommunityScreen
class StyledTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxLines;

  const StyledTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF87CDEA).withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: ColorUtils.black,
          fontFamily: FontUtils.urbanistRegular,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ColorUtils.grey3,
            fontFamily: FontUtils.urbanistRegular,
            fontSize: 15,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

// Custom Button widget to match CommunityScreen
class StyledButton extends StatelessWidget {
  final String textValue;
  final VoidCallback? onPressed;

  const StyledButton({
    Key? key,
    required this.textValue,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: TextWidget(
              textValue: textValue,
              textColor: Colors.white,
              fontFamily: FontUtils.urbanistSemiBold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}