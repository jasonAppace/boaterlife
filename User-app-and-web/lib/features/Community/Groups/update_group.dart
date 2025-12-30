import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:stacked/stacked.dart';

import '../../../App/locator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/DashedBorderContainer.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/top_margin.dart';

class UpdateGroup extends StatefulWidget {
  const UpdateGroup({Key? key}) : super(key: key);

  @override
  State<UpdateGroup> createState() => _UpdateGroupState();
}

class _UpdateGroupState extends State<UpdateGroup> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        model.createGroupTitle.text = model.allGroupDetailData?.data?.name ?? "";
        model.createGroupDesc.text = model.allGroupDetailData?.data?.description ?? "";
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: PageHorizontalMargin(
              widget: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopMargin(),
                    AppBarWithBackTitle(
                      title: 'Update Group',
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    CustomTextField(
                      hintText: 'Group Title Here',
                      labelText: 'Group Title',
                      controller: model.createGroupTitle,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      hintText: 'Enter your description...',
                      labelText: 'Description',
                      controller: model.createGroupDesc,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DashedBorderContainer(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomButton(
                      textValue: 'Create Group',
                      onButtonPressed: () {
                        // model.loadingWidget == true
                        //     ? () {}
                        //     : model.doCreateGroup(
                        //     context,
                        //     model.userToken ?? "",
                        //     model.createGroupTitle.text,
                        //     model.createGroupDesc.text,
                        //     _selectedInterestId ?? 0
                        // );
                      },
                    ),
                    SizedBox(
                      height: 4.h,
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
