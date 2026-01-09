import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexacom_user/features/Community/CommunityUser/UserDetailScreen.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:hexacom_user/utill/color_resources.dart';
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
import '../Widgets/custom_button_border.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/top_margin.dart';

class GroupFeedDetailScreen extends StatefulWidget {
  final int? groupID;
  final int? postID;

  GroupFeedDetailScreen({
    Key? key,
    required this.groupID,
    required this.postID,
  }) : super(key: key);

  @override
  _GroupFeedDetailScreenState createState() => _GroupFeedDetailScreenState();
}

class _GroupFeedDetailScreenState extends State<GroupFeedDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await model.doGroupPostIndividual(
            context,
            model.userToken ?? "",
            widget.postID ?? 0,
          );
        });
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: ColorResources.getHomeScreenBackgroundColor(
                context), // Solid color matching CommunityScreen
            resizeToAvoidBottomInset: true, // This is key for keyboard handling
            body: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const TopMargin(),
                            AppBarWithBackTitle(
                              title: 'Post Detail',
                            ),
                            SizedBox(height: 20),
                            PageHorizontalMargin(
                              horizontal: 16, // Match CommunityScreen padding
                              widget: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Match CommunityScreen card
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '${splashProvider.baseUrls!.customerImageUrl}/${model.allGroupPostIndividualData?.users?.image ?? ""}',
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.grey
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.grey
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Icon(Icons.person,
                                                      color: ColorUtils.grey),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  textValue: model
                                                          .allGroupPostIndividualData
                                                          ?.title ??
                                                      "",
                                                  textColor: ColorUtils.black,
                                                  fontFamily: FontUtils
                                                      .urbanistSemiBold,
                                                  fontSize: 16,
                                                  maxLines: 2,
                                                ),
                                                SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    TextWidget(
                                                      textValue:
                                                          "${model.allGroupPostIndividualData?.users?.firstName ?? ""} ${model.allGroupPostIndividualData?.users?.lastName ?? ""}",
                                                      textColor:
                                                          ColorUtils.grey3,
                                                      fontFamily: FontUtils
                                                          .urbanistMedium,
                                                      fontSize: 13,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Container(
                                                      width: 4,
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        color: ColorUtils.grey3,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    TextWidget(
                                                      textValue: DateConverterHelper
                                                          .convertToAgo(model
                                                                  .allGroupPostIndividualData
                                                                  ?.updatedAt ??
                                                              ""),
                                                      textColor:
                                                          ColorUtils.grey3,
                                                      fontFamily: FontUtils
                                                          .urbanistRegular,
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
                                              color: ColorUtils.grey
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (context) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            height: 4,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ColorUtils
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          if (model
                                                                  .allGroupPostIndividualData
                                                                  ?.users
                                                                  ?.id
                                                                  .toString() ==
                                                              model.userID) ...[
                                                            ListTile(
                                                              leading:
                                                                  Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 20),
                                                              ),
                                                              title: Text(
                                                                'Delete Post',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily:
                                                                      FontUtils
                                                                          .urbanistSemiBold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await model
                                                                    .doGroupPostDelete(
                                                                  context,
                                                                  model.userToken ??
                                                                      "",
                                                                  model.allGroupPostIndividualData
                                                                          ?.id ??
                                                                      0,
                                                                  model.allGroupPostIndividualData
                                                                          ?.groupId ??
                                                                      0,
                                                                );
                                                              },
                                                            ),
                                                          ] else ...[
                                                            ListTile(
                                                              leading:
                                                                  Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Icon(
                                                                    Icons
                                                                        .report_outlined,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 20),
                                                              ),
                                                              title: Text(
                                                                'Report Post',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily:
                                                                      FontUtils
                                                                          .urbanistSemiBold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await model
                                                                    .doGroupPostReport(
                                                                  context,
                                                                  model.userToken ??
                                                                      "",
                                                                  model.allGroupPostIndividualData
                                                                          ?.id ??
                                                                      0,
                                                                  model.allGroupPostIndividualData
                                                                          ?.groupId ??
                                                                      0,
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
                                      ExpandableTextWidget(
                                        textValue: model
                                                .allGroupPostIndividualData
                                                ?.description ??
                                            "",
                                        textColor: ColorUtils.black,
                                        fontFamily: FontUtils.urbanistRegular,
                                        fontSize: 15,
                                        maxLines: 3,
                                      ),
                                      SizedBox(height: 12),
                                      if (model.allGroupPostIndividualData
                                              ?.content?.isNotEmpty ==
                                          true)
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: model
                                                      .allGroupPostIndividualData
                                                      ?.content
                                                      ?.first ??
                                                  "",
                                              placeholder: (context, url) =>
                                                  Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.grey
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.grey
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                      Icons.image_not_supported,
                                                      color: ColorUtils.grey),
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 200,
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 16),
                                      //           Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.spaceBetween,
                                      //             children: [
                                      //               Row(
                                      //                 children: [
                                      //                   Container(
                                      //                     padding: EdgeInsets.all(4),
                                      //                     decoration: BoxDecoration(
                                      //                       color: Colors.red
                                      //                           .withOpacity(0.1),
                                      //                       borderRadius:
                                      //                           BorderRadius.circular(20),
                                      //                     ),
                                      //                     child: Icon(Icons.favorite,
                                      //                         color: Colors.red,
                                      //                         size: 14),
                                      //                   ),
                                      //                   SizedBox(width: 6),
                                      //                   TextWidget(
                                      //                     textValue:
                                      //                         '${model.allGroupPostIndividualData?.likes?.length ?? 0}',
                                      //                     textColor: ColorUtils.grey3,
                                      //                     fontFamily:
                                      //                         FontUtils.urbanistSemiBold,
                                      //                     fontSize: 13,
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //               TextWidget(
                                      //                 textValue:
                                      //                     '${model.allGroupPostIndividualData?.comments?.length ?? 0} comments',
                                      //                 textColor: ColorUtils.grey3,
                                      //                 fontFamily:
                                      //                     FontUtils.urbanistMedium,
                                      //                 fontSize: 13,
                                      //               ),
                                      //             ],
                                      //           ),
                                      //           SizedBox(height: 12),
                                      //           Container(
                                      //             padding:
                                      //                 EdgeInsets.symmetric(vertical: 8),
                                      //             decoration: BoxDecoration(
                                      //               color:
                                      //                   ColorUtils.grey.withOpacity(0.05),
                                      //               borderRadius:
                                      //                   BorderRadius.circular(12),
                                      //             ),
                                      //             child: Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment.spaceEvenly,
                                      //               children: [
                                      //                 Expanded(
                                      //                   child: InkWell(
                                      //                     onTap: () async {
                                      //                       await model
                                      //                           .doGroupPostLikeAddApi(
                                      //                         context,
                                      //                         model.userToken ?? "",
                                      //                         model.allGroupPostIndividualData
                                      //                                 ?.id ??
                                      //                             0,
                                      //                         model.allGroupPostIndividualData
                                      //                                 ?.groupId ??
                                      //                             0,
                                      //                       );
                                      //                     },
                                      //                     borderRadius:
                                      //                         BorderRadius.circular(8),
                                      //                     child: Container(
                                      //                       padding: EdgeInsets.symmetric(
                                      //                           vertical: 8),
                                      //                       child: Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .center,
                                      //                         children: [
                                      //                           Icon(
                                      //                             model.allGroupPostIndividualData
                                      //                                         ?.likes
                                      //                                         ?.any((like) =>
                                      //                                             like.userId
                                      //                                                 .toString() ==
                                      //                                             model
                                      //                                                 .userID) ??
                                      //                                     false
                                      //                                 ? Icons.favorite
                                      //                                 : Icons
                                      //                                     .favorite_outline,
                                      //                             color: model.allGroupPostIndividualData
                                      //                                         ?.likes
                                      //                                         ?.any((like) =>
                                      //                                             like.userId
                                      //                                                 .toString() ==
                                      //                                             model
                                      //                                                 .userID) ??
                                      //                                     false
                                      //                                 ? Colors.red
                                      //                                 : ColorUtils.grey3,
                                      //                             size: 18,
                                      //                           ),
                                      //                           SizedBox(width: 6),
                                      //                           TextWidget(
                                      //                             textValue: 'Like',
                                      //                             textColor: model
                                      //                                         .allGroupPostIndividualData
                                      //                                         ?.likes
                                      //                                         ?.any((like) =>
                                      //                                             like.userId
                                      //                                                 .toString() ==
                                      //                                             model
                                      //                                                 .userID) ??
                                      //                                     false
                                      //                                 ? Colors.red
                                      //                                 : ColorUtils.grey3,
                                      //                             fontFamily: FontUtils
                                      //                                 .urbanistMedium,
                                      //                             fontSize: 13,
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Container(
                                      //                   width: 1,
                                      //                   height: 20,
                                      //                   color: ColorUtils.grey
                                      //                       .withOpacity(0.2),
                                      //                 ),
                                      //                 Expanded(
                                      //                   child: InkWell(
                                      //                     onTap: () {
                                      //                       // Handle comment action
                                      //                     },
                                      //                     borderRadius:
                                      //                         BorderRadius.circular(8),
                                      //                     child: Container(
                                      //                       padding: EdgeInsets.symmetric(
                                      //                           vertical: 8),
                                      //                       child: Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .center,
                                      //                         children: [
                                      //                           Icon(
                                      //                             Icons
                                      //                                 .chat_bubble_outline,
                                      //                             color: ColorUtils.grey3,
                                      //                             size: 18,
                                      //                           ),
                                      //                           SizedBox(width: 6),
                                      //                           TextWidget(
                                      //                             textValue: 'Comment',
                                      //                             textColor:
                                      //                                 ColorUtils.grey3,
                                      //                             fontFamily: FontUtils
                                      //                                 .urbanistMedium,
                                      //                             fontSize: 13,
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 8, 8, 5),
                              child: Row(
                                children: [
                                  TextWidget(
                                    textValue: "Comments",
                                    textColor: ColorUtils.darkblue,
                                    fontFamily: FontUtils.urbanistBold,
                                    textAlign: TextAlign.start,
                                    fontSize:
                                        18, // Match CommunityScreen section headers
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: UserDetailScreen(
                                            userID: model
                                                .allGroupPostIndividualData
                                                ?.comments?[index]
                                                .users
                                                ?.id
                                                .toString())), //Fixed by Safi 9 Jan 2026
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${splashProvider.baseUrls!.customerImageUrl}/${model.allGroupPostIndividualData?.comments?[index].users?.image ?? ""}',
                                              placeholder: (context, url) =>
                                                  Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.grey
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.grey
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Icon(Icons.person,
                                                    color: ColorUtils.grey),
                                              ),
                                              fit: BoxFit.cover,
                                              width: 44,
                                              height: 44,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  textValue:
                                                      "${model.allGroupPostIndividualData?.comments?[index].users?.firstName ?? ""} ${model.allGroupPostIndividualData?.comments?[index].users?.lastName ?? ""}",
                                                  textColor: ColorUtils.black,
                                                  fontFamily:
                                                      FontUtils.urbanistBold,
                                                  fontSize: 14,
                                                ),
                                                SizedBox(height: 4),
                                                TextWidget(
                                                  textValue: model
                                                          .allGroupPostIndividualData
                                                          ?.comments?[index]
                                                          .comment ??
                                                      "",
                                                  textColor: ColorUtils.grey3,
                                                  fontFamily:
                                                      FontUtils.urbanistRegular,
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: model.allGroupPostIndividualData
                                    ?.comments?.length ??
                                0,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                            height:
                                20), // Reduced space since we're using Column now
                      ),
                    ],
                  ),
                ),
                // Bottom comment input section - now part of Column, not bottomNavigationBar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorUtils.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF87CDEA).withOpacity(0.2),
                            ),
                          ),
                          child: CustomTextField(
                            hintText: 'Type your comment here',
                            FieldHeight: 0.8.h,
                            controller: model.addCommentController,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () async {
                              await model.doGroupPostCommentAddApi(
                                context,
                                model.userToken ?? "",
                                model.addCommentController.text,
                                model.allGroupPostIndividualData?.id ?? 0,
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 24,
                              ),
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
        );
      },
    );
  }
}
