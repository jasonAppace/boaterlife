import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexacom_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hexacom_user/features/Community/Widgets/custom_text_field.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:hexacom_user/features/Community/Widgets/page_horizontal_margin.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:hexacom_user/helper/date_converter_helper.dart';
import '../../../App/locator.dart';
import '../../../common/widgets/not_logged_in_screen.dart';
import '../../../utill/CustomSeperator.dart';
import '../../../utill/app_constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../../splash/providers/splash_provider.dart';
import '../CommunityModel/community_post_model.dart';
import '../CommunityUser/SearchUserScreen.dart';
import '../Groups/ChatMainScreen.dart';
import '../Groups/GroupFeedDetail.dart';
import '../Groups/GroupHomeScreen.dart';
import '../Groups/create_group.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/custom_button_border.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/text_widget.dart';

class CommunityScreen extends StatefulWidget {
  CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData(MainViewModel model) async {
    await model.doNewsFeedPosts(context, model.userToken ?? "");
    await model.doJoinedGroups(context, model.userToken ?? "");
    await model.doSuggestedGroups(context, model.userToken ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        model.initializeViewModel(context);
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: isLoggedIn
              ? Scaffold(
            backgroundColor: Color(0xFF87CDEA).withOpacity(0.05),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    loadData(model);
                  },
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      // Enhanced App Bar
                      SliverAppBar(
                        expandedHeight: 120,
                        floating: false,
                        pinned: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF87CDEA).withOpacity(0.1),
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        textValue: 'Community',
                                        textColor: ColorUtils.black,
                                        fontFamily: FontUtils.urbanistBold,
                                        fontSize: 24,
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.all(8),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.white,
                                      //     borderRadius: BorderRadius.circular(12),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         color: Colors.black.withOpacity(0.05),
                                      //         blurRadius: 10,
                                      //         offset: Offset(0, 2),
                                      //       ),
                                      //     ],
                                      //   ),
                                      //   child: Icon(
                                      //     Icons.notifications_outlined,
                                      //     color: Theme.of(context).primaryColor,
                                      //     size: 22,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  TextWidget(
                                    textValue: 'Connect, Share, and Discover',
                                    textColor: ColorUtils.grey3,
                                    fontFamily: FontUtils.urbanistRegular,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Enhanced Search Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
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
                                    child: SearchUserScreen(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 56,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Theme.of(context).primaryColor,
                                      size: 22,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: TextWidget(
                                        textValue: "Search users...",
                                        textColor: ColorUtils.grey3,
                                        fontFamily: FontUtils.urbanistMedium,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF87CDEA).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.tune,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Enhanced Groups Section
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    textValue: "My Groups",
                                    textColor: ColorUtils.black,
                                    fontFamily: FontUtils.urbanistBold,
                                    fontSize: 18,
                                  ),
                                  // TextWidget(
                                  //   textValue: "View all",
                                  //   textColor: Theme.of(context).primaryColor,
                                  //   fontFamily: FontUtils.urbanistSemiBold,
                                  //   fontSize: 14,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              height: 160,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (model.allJoinedGroupsData?.data?.length ?? 0) + 1,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (index == 0) {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: CreateGroup(),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: GroupHomeScreen(
                                              groupID: model.allJoinedGroupsData?.data?[index - 1].id ?? 0,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 110,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          // Main image with enhanced styling
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: index == 0
                                                ? Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Theme.of(context).primaryColor.withOpacity(0.8),
                                                    Theme.of(context).primaryColor,
                                                  ],
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            )
                                                : CachedNetworkImage(
                                              imageUrl: model.allJoinedGroupsData?.data?[index - 1].image ?? "",
                                              placeholder: (context, url) => Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorUtils.grey.withOpacity(0.3),
                                                      ColorUtils.grey.withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorUtils.grey.withOpacity(0.3),
                                                      ColorUtils.grey.withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: Icon(Icons.error, color: ColorUtils.grey),
                                              ),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                          // Enhanced Gradient Overlay
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            height: 70,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(16),
                                                  bottomRight: Radius.circular(16),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black.withOpacity(0.7),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Enhanced Text Overlay
                                          Positioned(
                                            bottom: 8,
                                            left: 8,
                                            right: 8,
                                            child: TextWidget(
                                              textValue: index == 0 ? "Create Group" : model.allJoinedGroupsData?.data?[index - 1].name ?? "",
                                              textColor: Colors.white,
                                              fontFamily: FontUtils.urbanistSemiBold,
                                              textAlign: TextAlign.center,
                                              fontSize: 13,
                                              maxLines: 2,
                                            ),
                                          ),

                                          // Member count badge for joined groups
                                          if (index != 0)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.9),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.people, size: 10, color: Theme.of(context).primaryColor),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      "",
                                                      // "${model.allJoinedGroupsData?.data?[index - 1].memberCount ?? 0}",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Enhanced Suggested Groups Section
                      if ((model.allSuggestedGroupsData?.data?.length ?? 0) > 0)
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF87CDEA).withOpacity(0.1),
                                      Colors.white,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Color(0xFF87CDEA).withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.star_outline,
                                            color: Theme.of(context).primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                textValue: "Suggested for You",
                                                textColor: ColorUtils.black,
                                                fontFamily: FontUtils.urbanistBold,
                                                fontSize: 16,
                                              ),
                                              TextWidget(
                                                textValue: "Groups you might like",
                                                textColor: ColorUtils.grey3,
                                                fontFamily: FontUtils.urbanistRegular,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: model.allSuggestedGroupsData?.data?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 140,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.08),
                                                  blurRadius: 15,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                                        child: CachedNetworkImage(
                                                          imageUrl: model.allSuggestedGroupsData?.data?[index].image ?? "",
                                                          placeholder: (context, url) => Container(
                                                            color: ColorUtils.grey.withOpacity(0.1),
                                                            child: Center(
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context, url, error) => Container(
                                                            color: ColorUtils.grey.withOpacity(0.1),
                                                            child: Icon(Icons.group, color: ColorUtils.grey),
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              model.allSuggestedGroupsData?.data?[index].name ?? "",
                                                              style: TextStyle(
                                                                color: ColorUtils.black,
                                                                fontFamily: FontUtils.urbanistSemiBold,
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: 8),
                                                            SizedBox(
                                                              width: double.infinity,
                                                              height: 28,
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  model.loadingWidget == true
                                                                      ? () {}
                                                                      : model.doGroupJoin(
                                                                    context,
                                                                    model.userToken ?? "",
                                                                    model.allSuggestedGroupsData?.data?[index].id ?? 0,
                                                                  );
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Theme.of(context).primaryColor,
                                                                  foregroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(14),
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                child: Text(
                                                                  "Join",
                                                                  style: TextStyle(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),

                      // Enhanced Feed Section
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Theme.of(context).primaryColor,
                                size: 22,
                              ),
                              SizedBox(width: 12),
                              TextWidget(
                                textValue: "Community Feed",
                                textColor: ColorUtils.black,
                                fontFamily: FontUtils.urbanistBold,
                                fontSize: 18,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverPadding(
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
                                          groupID: model.allNewsFeedPostsData?.data?[index].groupId ?? 0,
                                          postID: model.allNewsFeedPostsData?.data?[index].id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: _buildPostWidget(context, model, index, splashProvider),
                                  ),
                                ),
                              );
                            },
                            childCount: model.allNewsFeedPostsData?.data?.length ?? 0,
                          ),
                        ),
                      ),

                      // Bottom padding for floating action button
                      SliverToBoxAdapter(
                        child: SizedBox(height: 80),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                      child: ChatMainScreen(),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.message_outlined, color: Colors.white, size: 26),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          )
              : const NotLoggedInScreen(),
        );
      },
    );
  }

  Widget _buildPostWidget(BuildContext context, MainViewModel model, int index, SplashProvider splashProvider) {
    final post = model.allNewsFeedPostsData?.data?[index];
    final bool isGroupPost = post?.groupId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group indicator for group posts
        if (isGroupPost) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF87CDEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF87CDEA).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: post?.groups?.image ?? "",
                    placeholder: (context, url) => Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ColorUtils.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.group, color: ColorUtils.grey, size: 16),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ColorUtils.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.group, color: ColorUtils.grey, size: 16),
                    ),
                    fit: BoxFit.cover,
                    width: 32,
                    height: 32,
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
                        fontSize: 11,
                      ),
                      TextWidget(
                        textValue: post?.groups?.name ?? "",
                        textColor: ColorUtils.black,
                        fontFamily: FontUtils.urbanistSemiBold,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],

        // User info section
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
                  imageUrl: '${splashProvider.baseUrls!.customerImageUrl}/${post?.users?.image ?? ""}',
                  placeholder: (context, url) => Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorUtils.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(Icons.person, color: ColorUtils.grey),
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
                    textValue: post?.title ?? "",
                    textColor: ColorUtils.black,
                    fontFamily: FontUtils.urbanistSemiBold,
                    fontSize: 16,
                    maxLines: 2,
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextWidget(
                        textValue: "${post?.users?.firstName ?? ""} ${post?.users?.lastName ?? ""}",
                        textColor: ColorUtils.grey3,
                        fontFamily: FontUtils.urbanistMedium,
                        fontSize: 13,
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
                        textValue: DateConverterHelper.convertToAgo(post?.updatedAt ?? ""),
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
                            if (post?.users?.id.toString() == model.userID) ...[
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
                                    post?.id ?? 0,
                                    post?.groupId ?? 0,
                                  );
                                },
                              ),
                            ] else ...[
                              ListTile(
                                leading: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.block, color: Colors.orange, size: 20),
                                ),
                                title: Text(
                                  'Block User',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontFamily: FontUtils.urbanistSemiBold,
                                  ),
                                ),
                                onTap: () async {
                                  await model.doBlockChat(
                                    context,
                                    model.userToken ?? "",
                                    post?.users?.id.toString() ?? "0",
                                  );
                                },
                              ),
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
                                    post?.id ?? 0,
                                    post?.groupId ?? 0,
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
        SizedBox(height: 12),

        // Post description
        ExpandableTextWidget(
          textValue: post?.description ?? "",
          textColor: ColorUtils.black,
          fontFamily: FontUtils.urbanistRegular,
          fontSize: 15,
          maxLines: 3,
        ),
        SizedBox(height: 12),

        // Post image
        if (post?.content?.isNotEmpty == true)
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
                imageUrl: post?.content?.first ?? "",
                placeholder: (context, url) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: ColorUtils.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
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

        // Engagement stats
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
                  textValue: '${post?.likes?.length ?? 0}',
                  textColor: ColorUtils.grey3,
                  fontFamily: FontUtils.urbanistSemiBold,
                  fontSize: 13,
                ),
              ],
            ),
            Row(
              children: [
                TextWidget(
                  textValue: '${post?.comments?.length ?? 0} comments',
                  textColor: ColorUtils.grey3,
                  fontFamily: FontUtils.urbanistMedium,
                  fontSize: 13,
                ),
                SizedBox(width: 12),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),

        // Action buttons
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: ColorUtils.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Like',
                  isActive: post?.likes?.any((like) => like.userId.toString() == model.userID) ?? false,
                  onTap: () async {
                    await model.doGroupPostLikeAddApi(
                      context,
                      model.userToken ?? "",
                      post?.id ?? 0,
                      post?.groupId ?? 0,
                    );
                  },
                ),
              ),
              Container(
                width: 1,
                height: 20,
                color: ColorUtils.grey.withOpacity(0.2),
              ),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: 'Comment',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: GroupFeedDetailScreen(
                          groupID: model.allNewsFeedPostsData?.data?[index].groupId ?? 0,
                          postID: model.allNewsFeedPostsData?.data?[index].id ?? 0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        IconData? activeIcon,
        required String label,
        bool isActive = false,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? (activeIcon ?? icon) : icon,
              color: isActive ? Colors.red : ColorUtils.grey3,
              size: 18,
            ),
            SizedBox(width: 6),
            TextWidget(
              textValue: label,
              textColor: isActive ? Colors.red : ColorUtils.grey3,
              fontFamily: FontUtils.urbanistMedium,
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}