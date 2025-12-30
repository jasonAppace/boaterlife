import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexacom_user/utill/appbar_with_backTitle.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../App/locator.dart';
import '../../../utill/CustomSeperator.dart';
import '../../../utill/images.dart';
import '../../splash/providers/splash_provider.dart';
import '../Groups/GroupFeedDetail.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_button_border.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/top_margin.dart';

class UserDetailScreen extends StatefulWidget {
  final String? userID;
  UserDetailScreen({super.key, required this.userID});
  @override
  _UserDetailScreenScreenState createState() => _UserDetailScreenScreenState();
}

class _UserDetailScreenScreenState extends State<UserDetailScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await model.doSearchUserDetail(context, model.userToken ?? "", widget.userID.toString());
        });
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: PageHorizontalMargin(
              horizontal: 15,
              widget: SingleChildScrollView(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TopMargin(),
                    AppBarWithBackTitle(title: "User Profile",),
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: CachedNetworkImage(
                        imageUrl: model.allSearchUserDetailData?.data?.imageFullPath ?? "",
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextWidget(
                      textValue: (model.allSearchUserDetailData?.data?.firstName ?? "") + " " + (model.allSearchUserDetailData?.data?.lastName ?? ""),
                      textColor: ColorUtils.black,
                      fontFamily: rubikSemiBold.fontFamily,
                      fontWeight: rubikSemiBold.fontWeight,
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      textValue: model.allSearchUserDetailData?.data?.email ?? "",
                      textColor: ColorUtils.black,
                      fontFamily: FontUtils.urbanistMedium,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomSeparator(),
                    SizedBox(
                      height: 10,
                    ),
                    if (model.allSearchUserDetailData?.data?.blocked == true)
                      CustomButton(
                        //Width: 200,
                        textValue:  'Unblock',
                        onButtonPressed: () {
                          //model.doCreateGroup(context, model.userToken ?? "", model.createGroupTitle.text, model.createGroupDesc.text ?? "", selectedImage);
                        },
                      ),
                    if (model.allSearchUserDetailData?.data?.blocked != true)
                      Column(
                        children: [
                          if (model.allSearchUserDetailData?.data?.areFriends == true)
                            CustomButton(
                              //Width: 200,
                              textValue:  'UnFriend',
                              isLoading: _isLoading,
                              onButtonPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                model.doRemoveFriendApi(context,model.userToken ?? "", widget.userID.toString() ?? "", model.allSearchUserDetailData?.data?.friendshipID.toString() ?? "");
                                setState(() {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              },
                            ),
                          if (model.allSearchUserDetailData?.data?.requestReceived == true)
                            CustomButton(
                              //Width: 200,
                              textValue:  'Accept Request',
                              isLoading: _isLoading,
                              onButtonPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                model.doRespondToFriendReqApi(context,model.userToken ?? "", widget.userID.toString() ?? "", model.allSearchUserDetailData?.data?.friendshipID.toString() ?? "", "accepted");
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                          if (model.allSearchUserDetailData?.data?.requestSent == true)
                            CustomButton(
                              //Width: 200,
                              textValue:  'Cancel Request',
                              isLoading: _isLoading,
                              onButtonPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await model.doCancelFriendshipRequestApi(context,model.userToken ?? "",  widget.userID.toString() ?? "", model.allSearchUserDetailData?.data?.friendshipID.toString() ?? "");
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                          if ((model.allSearchUserDetailData?.data?.requestSent == false) && (model.allSearchUserDetailData?.data?.requestReceived == false && (model.allSearchUserDetailData?.data?.areFriends == false)))
                            CustomButton(
                              //Width: 200,
                              isLoading: _isLoading,
                              textValue:  'Add Friend',
                              onButtonPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                model.doAddFriendApi(context,model.userToken ?? "", widget.userID ?? "");
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                        ],
                      ),
                    SizedBox(height: 18,),
                    (model.allSearchUserDetailData?.data?.areFriends == true) ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: GroupFeedDetailScreen(
                                    groupID: model.allSearchUserDetailData?.data?.posts?[index].groupId ?? 0,
                                    postID: model.allSearchUserDetailData?.data?.posts?[index].id ?? 0,
                                  ),
                                ),
                              );
                            },
                            child: (model.allSearchUserDetailData?.data?.posts?[index].groupId == null) ? PageHorizontalMargin(
                              horizontal: 15,
                              widget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   PageTransition(
                                          //     type: PageTransitionType.rightToLeft,
                                          //     child: UserDetailScreen(
                                          //       userID: model.allSearchUserDetailData?.data?[index].userId.toString() ?? "0",
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: CachedNetworkImage(
                                            imageUrl: '${splashProvider.baseUrls!.customerImageUrl}/' '${model.allSearchUserDetailData?.data?.image ?? ""}',
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            fit: BoxFit.fill,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              textValue: model.allSearchUserDetailData?.data?.posts?[index].title ?? "",
                                              textColor: ColorUtils.black,
                                              fontFamily: FontUtils.urbanistSemiBold,
                                              fontSize: 16,
                                            ),
                                            TextWidget(
                                              textValue: (model.allSearchUserDetailData?.data?.firstName ?? "") + " " + (model.allSearchUserDetailData?.data?.lastName ?? ""),
                                              textColor: ColorUtils.grey3,
                                              fontFamily: FontUtils.urbanistRegular,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      (model.allSearchUserDetailData!.data!.id.toString() == model.userID)
                                          ? GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                            builder: (context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(Icons.delete, color: Colors.red),
                                                      title: const Text(
                                                        'Delete Post',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                      onTap: () async {
                                                        await model.doGroupPostDelete(context, model.userToken ?? "", model.allSearchUserDetailData?.data?.posts?[index].id ?? 0,
                                                            model.allSearchUserDetailData?.data?.posts?[index].groupId ?? 0);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: SvgPicture.asset(Images.kebebMenuIc),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                            builder: (context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(Icons.report_gmailerrorred, color: Colors.red),
                                                      title: const Text(
                                                        'Report Post',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                      onTap: () async {
                                                        await model.doGroupPostReport(context, model.userToken ?? "", model.allSearchUserDetailData?.data?.posts?[index].id ?? 0,
                                                            model.allSearchUserDetailData?.data?.posts?[index].groupId ?? 0);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: SvgPicture.asset(Images.kebebMenuIc),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ExpandableTextWidget(
                                    textValue: model.allSearchUserDetailData?.data?.posts?[index].description ?? "",
                                    textColor: ColorUtils.black,
                                    fontFamily: FontUtils.urbanistRegular,
                                    fontSize: 14,
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (model.allSearchUserDetailData?.data?.posts?[index].content?.isEmpty == false)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: (model.allSearchUserDetailData?.data?.posts?[index].content != null && model.allSearchUserDetailData!.data!.posts![index].content!.isNotEmpty)
                                            ? model.allSearchUserDetailData!.data!.posts![index].content![0]
                                            : "https://via.placeholder.com/150",
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: 264,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        textValue: '${model.allSearchUserDetailData?.data?.posts?[index].likes?.length.toString() ?? "0"} Likes',
                                        textColor: ColorUtils.grey3,
                                        fontFamily: FontUtils.urbanistSemiBold,
                                        fontSize: 14,
                                      ),
                                      TextWidget(
                                        textValue: '${model.allSearchUserDetailData?.data?.posts?[index].comments?.length.toString() ?? "0"} Comments  ',
                                        textColor: ColorUtils.grey3,
                                        fontFamily: FontUtils.urbanistSemiBold,
                                        fontSize: 14,
                                      ),
                                      // TextWidget(
                                      //   textValue: '${model.allSearchUserDetailData?.data?[index].likes?.length.toString() ?? "0"} Shares',
                                      //   textColor: ColorUtils.black,
                                      //   fontFamily: FontUtils.urbanistSemiBold,
                                      //   fontSize: 14,
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButtonBorder(
                                        buttonHeight: 35,
                                        textValue: 'Like',
                                        prefixImgColor: model.allSearchUserDetailData!.data!.posts![index].likes!.any((like) => like.userId.toString() == model.userID) ? ColorUtils.white : null,
                                        buttonTextColor: model.allSearchUserDetailData!.data!.posts![index].likes!.any((like) => like.userId.toString() == model.userID) ? ColorUtils.white : null,
                                        buttonColor: model.allSearchUserDetailData!.data!.posts![index].likes!.any((like) => like.userId.toString() == model.userID)
                                            ? Theme.of(context).primaryColor
                                            : null,
                                        prefixImage: Images.like,
                                        onButtonPressed: () async {
                                          await model.doGroupPostLikeAddApi(
                                            context,
                                            model.userToken ?? "",
                                            model.allSearchUserDetailData!.data!.posts![index].id ?? 0,
                                            model.allSearchUserDetailData!.data!.posts![index].groupId ?? 0,
                                          );
                                        },
                                      ),
                                      CustomButtonBorder(
                                        buttonHeight: 35,
                                        buttonWidth: 130,
                                        textValue: 'Comments  ',
                                        prefixImage: Images.comment,
                                      ),
                                      // CustomButtonBorder(
                                      //   buttonHeight: 35,
                                      //   buttonWidth: 100,
                                      //   textValue: 'Share ',
                                      //   prefixImage: Images.share,
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ) : PageHorizontalMargin(
                              horizontal: 15,
                              widget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Posted in Group Section
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          // color: ColorUtils.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: ColorUtils.grey.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: CachedNetworkImage(
                                                imageUrl: model.allSearchUserDetailData?.data?.posts?[index].groups?.image ?? "",
                                                placeholder: (context, url) => Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(25),
                                                  ),
                                                  child: Icon(Icons.group, color: ColorUtils.grey),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(25),
                                                  ),
                                                  child: Icon(Icons.group, color: ColorUtils.grey),
                                                ),
                                                fit: BoxFit.cover,
                                                width: 35,
                                                height: 35,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    textValue: "Posted in Group",
                                                    textColor: ColorUtils.grey3,
                                                    fontFamily: FontUtils.urbanistRegular,
                                                    fontSize: 12,
                                                  ),
                                                  TextWidget(
                                                    textValue: model.allSearchUserDetailData?.data?.posts?[index].groups?.name ?? "",
                                                    textColor: ColorUtils.black,
                                                    fontFamily: FontUtils.urbanistSemiBold,
                                                    fontSize: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              // Navigator.push(
                                              //   context,
                                              //   PageTransition(
                                              //     type: PageTransitionType.rightToLeft,
                                              //     child: UserDetailScreen(
                                              //       userID: model.allSearchUserDetailData?.data?[index].userId.toString() ?? "0",
                                              //     ),
                                              //   ),
                                              // );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: CachedNetworkImage(
                                                imageUrl: '${splashProvider.baseUrls!.customerImageUrl}/' '${model.allSearchUserDetailData?.data?.image ?? ""}',
                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                fit: BoxFit.fill,
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  textValue: model.allSearchUserDetailData?.data?.posts?[index].title ?? "",
                                                  textColor: ColorUtils.black,
                                                  fontFamily: FontUtils.urbanistSemiBold,
                                                  fontSize: 16,
                                                ),
                                                TextWidget(
                                                  textValue: (model.allSearchUserDetailData?.data?.firstName ?? "") + " " + (model.allSearchUserDetailData?.data?.lastName ?? ""),
                                                  textColor: ColorUtils.grey3,
                                                  fontFamily: FontUtils.urbanistRegular,
                                                  fontSize: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                          (model.allSearchUserDetailData!.data!.id.toString() == model.userID)
                                              ? GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                ),
                                                builder: (context) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          leading: const Icon(Icons.delete, color: Colors.red),
                                                          title: const Text(
                                                            'Delete Post',
                                                            style: TextStyle(color: Colors.red),
                                                          ),
                                                          onTap: () async {
                                                            await model.doGroupPostDelete(context, model.userToken ?? "", model.allSearchUserDetailData?.data?.posts?[index].id ?? 0,
                                                                model.allSearchUserDetailData?.data?.posts?[index].groupId ?? 0);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: SvgPicture.asset(Images.kebebMenuIc),
                                          )
                                              : GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                ),
                                                builder: (context) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          leading: const Icon(Icons.report_gmailerrorred, color: Colors.red),
                                                          title: const Text(
                                                            'Report Post',
                                                            style: TextStyle(color: Colors.red),
                                                          ),
                                                          onTap: () async {
                                                            await model.doGroupPostReport(context, model.userToken ?? "", model.allSearchUserDetailData?.data?.posts?[index].id ?? 0,
                                                                model.allSearchUserDetailData?.data?.posts?[index].groupId ?? 0);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: SvgPicture.asset(Images.kebebMenuIc),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      // Post Description
                                      ExpandableTextWidget(
                                        textValue: model.allSearchUserDetailData?.data?.posts?[index].description ?? "",
                                        textColor: ColorUtils.black,
                                        fontFamily: FontUtils.urbanistRegular,
                                        fontSize: 14,
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 10),

                                      // Post Image
                                      if (model.allSearchUserDetailData?.data?.posts?[index].content?.isEmpty == false)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: (model.allSearchUserDetailData?.data?.posts?[index].content != null && model.allSearchUserDetailData!.data!.posts![index].content!.isNotEmpty)
                                                ? model.allSearchUserDetailData!.data!.posts![index].content![0]
                                                : "https://via.placeholder.com/150",
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            height: 264,
                                          ),
                                        ),
                                      SizedBox(height: 10),

                                      // Likes and Comments Count
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            textValue: '${model.allSearchUserDetailData?.data?.posts?[index].likes?.length.toString() ?? "0"} Likes',
                                            textColor: ColorUtils.grey3,
                                            fontFamily: FontUtils.urbanistSemiBold,
                                            fontSize: 14,
                                          ),
                                          TextWidget(
                                            textValue: '${model.allSearchUserDetailData?.data?.posts?[index].comments?.length.toString() ?? "0"} Comments  ',
                                            textColor: ColorUtils.grey3,
                                            fontFamily: FontUtils.urbanistSemiBold,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),

                                      // Action Buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomButtonBorder(
                                            buttonHeight: 35,
                                            textValue: 'Like',
                                            prefixImgColor: model.allSearchUserDetailData!.data!.posts![index].likes!.any((like) => like.userId.toString() == model.userID) ? ColorUtils.white : null,
                                            buttonTextColor: model.allSearchUserDetailData!.data!.posts![index].likes!.any((like) => like.userId.toString() == model.userID) ? ColorUtils.white : null,
                                            buttonColor: model.allSearchUserDetailData!.data!.posts![index].likes!.any((like) => like.userId.toString() == model.userID)
                                                ? Theme.of(context).primaryColor
                                                : null,
                                            prefixImage: Images.like,
                                            onButtonPressed: () async {
                                              await model.doGroupPostLikeAddApi(
                                                context,
                                                model.userToken ?? "",
                                                model.allSearchUserDetailData!.data!.posts?[index].id ?? 0,
                                                model.allSearchUserDetailData!.data!.posts?[index].groupId ?? 0,
                                              );
                                            },
                                          ),
                                          CustomButtonBorder(
                                            buttonHeight: 35,
                                            buttonWidth: 130,
                                            textValue: 'Comments  ',
                                            prefixImage: Images.comment,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            )
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: model.allSearchUserDetailData?.data?.posts?.length ?? 0,
                    ) :
                    PageHorizontalMargin(
                      horizontal: 35,
                      widget: Column(
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Icon(Icons.lock, size: 60,),
                          SizedBox(
                            height: 15,
                          ),
                          TextWidget(
                            textValue: "Content of this account will be visible when you become their friend",
                            textColor: ColorUtils.black,
                            fontFamily: FontUtils.urbanistMedium,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )
            ),
          ),
        );
      },
    );
  }
}
