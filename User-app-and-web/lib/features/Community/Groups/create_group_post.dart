import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:stacked/stacked.dart';

import '../../../App/locator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/DashedBorderContainer.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/top_margin.dart';

class CreateGroupPost extends StatefulWidget {
  final int? groupID;
  CreateGroupPost({super.key, required this.groupID});

  @override
  State<CreateGroupPost> createState() => _CreateGroupPostState();
}

class _CreateGroupPostState extends State<CreateGroupPost> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {},
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor:
                ColorResources.getHomeScreenBackgroundColor(context),
            body: PageHorizontalMargin(
              horizontal: 0,
              widget: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: const Column(
                        children: [
                          TopMargin(),
                          AppBarWithBackTitle(
                            title: 'Create New Post',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    PageHorizontalMargin(
                      horizontal: 20,
                      widget: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Enter Title Here',
                            labelText: 'Title',
                            controller: model.createGroupPostTitle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: 'Enter your description...',
                            labelText: 'Description',
                            controller: model.createGroupPostDesc,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: image_picker_2(
                                  onImagePicked: (File? image) {
                                    selectedImage =
                                        image; // Store the picked image
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            textValue: 'Create Post',
                            onButtonPressed: () {
                              model.loadingWidget == true
                                  ? () {}
                                  : model.doCreateGroupPost(
                                      context,
                                      model.userToken ?? "",
                                      model.createGroupPostTitle.text,
                                      model.createGroupPostDesc.text,
                                      widget.groupID ?? 0,
                                      selectedImage);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
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
