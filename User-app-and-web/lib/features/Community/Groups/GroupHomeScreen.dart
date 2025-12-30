import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:hexacom_user/helper/date_converter_helper.dart';
import '../../../App/locator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../../../utill/images.dart';
import '../../splash/providers/splash_provider.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/top_margin.dart';
import 'GroupDetailScreen.dart';
import 'GroupFeedDetail.dart';
import 'create_group_post.dart';

class GroupHomeScreen extends StatefulWidget {
  final int? groupID;
  GroupHomeScreen({super.key, required this.groupID});

  @override
  _GroupHomeScreenState createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends State<GroupHomeScreen> {
  Future<void> loadData(MainViewModel model) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await model.doGroupPosts(context, model.userToken ?? "", widget.groupID ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        loadData(model);
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Color(0xFFF9FCFE),
            body: RefreshIndicator(
              onRefresh: () async {
                loadData(model);
              },
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const TopMargin(),
                        AppBarWithBackTitle(
                          title: 'Group',
                          suffixIcon2: Images.kebebMenuIc,
                          onSuffixButtonPressed2: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: GroupDetailScreen(groupID: widget.groupID),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  (model.allGroupPostsData?.data?.isEmpty ?? true)
                      ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.ph_noPost, // Replace with your empty state image
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(height: 3.h),
                            TextWidget(
                              textValue: "No Posts Available",
                              textColor: ColorUtils.black,
                              fontFamily: FontUtils.urbanistBold,
                              fontSize: 20,
                            ),
                            SizedBox(height: 8),
                            TextWidget(
                              textValue: "Be the first one to create a post!",
                              textColor: ColorUtils.grey3,
                              fontFamily: FontUtils.urbanistMedium,
                              fontSize: 15,
                            ),
                            SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: CreateGroupPost(
                                        groupID: widget.groupID,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.symmetric(horizontal: 52, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Create Post",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontUtils.urbanistSemiBold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: GroupFeedDetailScreen(
                                      groupID: widget.groupID,
                                      postID: model.allGroupPostsData?.data?[index].id ?? 0,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: CachedNetworkImage(
                                              imageUrl: '${splashProvider.baseUrls!.customerImageUrl}/${model.allGroupPostsData?.data?[index].users?.image ?? ""}',
                                              placeholder: (context, url) => Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.grey.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.grey.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: Icon(Icons.person, color: ColorUtils.grey),
                                              ),
                                              fit: BoxFit.cover,
                                              width: 44,
                                              height: 44,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                textValue: model.allGroupPostsData?.data?[index].title ?? "",
                                                textColor: ColorUtils.black,
                                                fontFamily: FontUtils.urbanistSemiBold,
                                                fontSize: 16,
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  TextWidget(
                                                    textValue:
                                                    "${model.allGroupPostsData?.data?[index].users?.firstName ?? ""} ${model.allGroupPostsData?.data?[index].users?.lastName ?? ""}",
                                                    textColor: ColorUtils.grey3,
                                                    fontFamily: FontUtils.urbanistMedium,
                                                    fontSize: 13, // Match CommunityScreen
                                                  ),
                                                  SizedBox(width: 8),
                                                  Container(
                                                    width: 4,
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      color: ColorUtils.grey3,
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  TextWidget(
                                                    textValue: DateConverterHelper.convertToAgo(model.allGroupPostsData?.data?[index].updatedAt ?? ""),
                                                    textColor: ColorUtils.grey3,
                                                    fontFamily: FontUtils.urbanistRegular,
                                                    fontSize: 12,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: ColorUtils.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor: Colors.transparent,
                                                builder: (context) {
                                                  return Container(
                                                    margin: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 4,
                                                          margin: EdgeInsets.only(top: 12),
                                                          decoration: BoxDecoration(
                                                            color: ColorUtils.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(2),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        if (model.allGroupPostsData!.data![index].users?.id.toString() == model.userID) ...[
                                                          ListTile(
                                                            leading: Container(
                                                              padding: EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.red.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                                            ),
                                                            title: Text(
                                                              'Delete Post',
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                                fontFamily: FontUtils.urbanistSemiBold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await model.doGroupPostDelete(
                                                                context,
                                                                model.userToken ?? "",
                                                                model.allGroupPostsData?.data?[index].id ?? 0,
                                                                widget.groupID ?? 0,
                                                              );
                                                            },
                                                          ),
                                                        ] else ...[
                                                          ListTile(
                                                            leading: Container(
                                                              padding: EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.red.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: Icon(Icons.report_outlined, color: Colors.red, size: 20),
                                                            ),
                                                            title: Text(
                                                              'Report Post',
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                                fontFamily: FontUtils.urbanistSemiBold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await model.doGroupPostReport(
                                                                context,
                                                                model.userToken ?? "",
                                                                model.allGroupPostsData?.data?[index].id ?? 0,
                                                                model.allGroupPostsData?.data?[index].groupId ?? 0,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                        SizedBox(height: 20),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
                                              Icons.more_horiz,
                                              color: ColorUtils.grey3,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12), // Match CommunityScreen
                                    ExpandableTextWidget(
                                      textValue: model.allGroupPostsData?.data?[index].description ?? "",
                                      textColor: ColorUtils.black,
                                      fontFamily: FontUtils.urbanistRegular,
                                      fontSize: 15, // Match CommunityScreen
                                      maxLines: 3, // Match CommunityScreen
                                    ),
                                    SizedBox(height: 12),
                                    if (model.allGroupPostsData?.data?[index].content?.isNotEmpty == true)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: model.allGroupPostsData?.data?[index].content?.first ?? "",
                                            placeholder: (context, url) => Container(
                                              height: 200, // Match CommunityScreen
                                              decoration: BoxDecoration(
                                                color: ColorUtils.grey.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: ColorUtils.grey.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Icon(Icons.image_not_supported, color: ColorUtils.grey),
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Icon(Icons.favorite, color: Colors.red, size: 14),
                                            ),
                                            SizedBox(width: 6),
                                            TextWidget(
                                              textValue: '${model.allGroupPostsData?.data?[index].likes?.length ?? 0}',
                                              textColor: ColorUtils.grey3,
                                              fontFamily: FontUtils.urbanistSemiBold,
                                              fontSize: 13, // Match CommunityScreen
                                            ),
                                          ],
                                        ),
                                        TextWidget(
                                          textValue: '${model.allGroupPostsData?.data?[index].comments?.length ?? 0} comments',
                                          textColor: ColorUtils.grey3,
                                          fontFamily: FontUtils.urbanistMedium,
                                          fontSize: 13, // Match CommunityScreen
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: ColorUtils.grey.withOpacity(0.05), // Match CommunityScreen
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                await model.doGroupPostLikeAddApi(
                                                  context,
                                                  model.userToken ?? "",
                                                  model.allGroupPostsData!.data![index].id ?? 0,
                                                  model.allGroupPostsData!.data![index].groupId ?? 0,
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      model.allGroupPostsData!.data![index].likes!.any((like) => like.userId.toString() == model.userID)
                                                          ? Icons.favorite
                                                          : Icons.favorite_outline,
                                                      color:
                                                      model.allGroupPostsData!.data![index].likes!.any((like) => like.userId.toString() == model.userID) ? Colors.red : ColorUtils.grey3,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 6),
                                                    TextWidget(
                                                      textValue: 'Like',
                                                      textColor:
                                                      model.allGroupPostsData!.data![index].likes!.any((like) => like.userId.toString() == model.userID) ? Colors.red : ColorUtils.grey3,
                                                      fontFamily: FontUtils.urbanistMedium,
                                                      fontSize: 13,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: ColorUtils.grey.withOpacity(0.2),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType.rightToLeft,
                                                    child: GroupFeedDetailScreen(
                                                      groupID: model.allGroupPostsData?.data?[index].groupId ?? 0,
                                                      postID: model.allGroupPostsData?.data?[index].id ?? 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.chat_bubble_outline,
                                                      color: ColorUtils.grey3,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 6),
                                                    TextWidget(
                                                      textValue: 'Comment',
                                                      textColor: ColorUtils.grey3,
                                                      fontFamily: FontUtils.urbanistMedium,
                                                      fontSize: 13,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: model.allGroupPostsData?.data?.length ?? 0,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 80), // Match CommunityScreen bottom padding
                  ),
                ],
              ),
            ),
            floatingActionButton: (model.allGroupDetailData?.data?.active == 0)
                ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Match CommunityScreen FAB
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: CreateGroupPost(
                        groupID: widget.groupID,
                      ),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Match CommunityScreen
                ),
                child: Icon(Icons.add, color: Colors.white, size: 26),
              ),
            )
                : SizedBox(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        );
      },
    );
  }
}