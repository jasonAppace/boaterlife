import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stacked/stacked.dart';
import '../../../App/locator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../../../utill/images.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/top_margin.dart';
import 'create_group.dart';

class GroupsMainScreen extends StatefulWidget {
  const GroupsMainScreen({super.key});

  @override
  State<GroupsMainScreen> createState() => _GroupsMainScreenState();
}

class _GroupsMainScreenState extends State<GroupsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await model.doMyGroups(context, model.userToken ?? "");
        });
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: Column(
              children: [
                TopMargin(),
                AppBarWithBackTitle(
                  title: 'Groups',
                  suffixIcon2: Images.addIc,
                  onSuffixButtonPressed2: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CreateGroup()));
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: model.allMyGroupsData?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     type: PageTransitionType.rightToLeft,
                          //     child: GroupHomeScreen(
                          //       groupID: model.allMyGroupsData?.data?[index].id ?? 0,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: CachedNetworkImage(
                                  imageUrl: model.allMyGroupsData?.data?[index].image ?? "",
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                                child: TextWidget(
                                  textValue: model.allMyGroupsData?.data?[index].name ?? "",
                                  textColor: ColorUtils.black,
                                  fontFamily: FontUtils.urbanistSemiBold,
                                  fontSize: 15,
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextWidget(
                                  textValue: model.allMyGroupsData?.data?[index].description ?? "",
                                  textColor: ColorUtils.black,
                                  fontFamily: FontUtils.urbanistMedium,
                                  fontSize: 11,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}