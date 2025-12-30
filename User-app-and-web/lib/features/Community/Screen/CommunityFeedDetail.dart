// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:hexacom_user/utill/app_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../common/widgets/custom_app_bar_widget.dart';
// import '../../../utill/images.dart';
// import '../CommunityModel/community_post_model.dart';
// import '../Widgets/color_utils.dart';
// import '../Widgets/custom_button_border.dart';
// import '../Widgets/custom_text_field.dart';
// import '../Widgets/expandable_text_widget.dart';
// import '../Widgets/font_utils.dart';
// import '../Widgets/page_horizontal_margin.dart';
// import '../Widgets/text_widget.dart';
//
// class CommunityDetailScreen extends StatefulWidget {
//   final int? postID;
//
//   CommunityDetailScreen({Key? key, required this.postID}) : super(key: key);
//
//   @override
//   _CommunityDetailScreenState createState() => _CommunityDetailScreenState();
// }
//
// class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
//   TextEditingController _commentController = TextEditingController();
//   SharedPreferences? sharedPreferences;
//   String? token = "";
//   String userID = "";
//   PostData? postData;
//   Dio dio = Dio();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeSharedPreferences();
//   }
//
//   Future<void> _initializeSharedPreferences() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     token = sharedPreferences!.getString(AppConstants.token);
//     userID = sharedPreferences!.getString(AppConstants.userId)!;
//     fetchPostDetails();
//     print("User ID testing ${userID}");
//   }
//
//   Future<void> fetchPostDetails() async {
//     try {
//       final response = await dio.get(
//         '${AppConstants.baseUrl}${AppConstants.communityPostDetail}?post_id=${widget.postID}',
//         options: Options(headers: {"Authorization": 'Bearer $token'}),
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           postData = PostData.fromJson(response.data["post"]);
//         });
//       }
//     } catch (e) {
//       print("Failed to fetch post details: $e");
//     }
//   }
//
//   Future<void> likePost() async {
//     try {
//       await dio.post(
//         '${AppConstants.baseUrl}${AppConstants.communityLikeAdd}',
//         data: {"post_id": widget.postID},
//         options: Options(headers: {"Authorization": 'Bearer $token'}),
//       );
//       fetchPostDetails();
//     } catch (e) {
//       print("Failed to like post: $e");
//     }
//   }
//
//   Future<void> postComment() async {
//     if (_commentController.text.isEmpty) return;
//     try {
//       await dio.post(
//         '${AppConstants.baseUrl}${AppConstants.communityCommentAdd}',
//         data: {"post_id": widget.postID, "comment": _commentController.text},
//         options: Options(headers: {"Authorization": 'Bearer $token'}),
//       );
//       _commentController.clear();
//       fetchPostDetails();
//     } catch (e) {
//       print("Failed to post comment: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: Scaffold(
//         body: Column(
//           children: [
//             CustomAppBarWidget(title: 'Post Details'),
//             PageHorizontalMargin(
//               horizontal: 15,
//               widget: Container(
//                 child: postData == null
//                     ? Center(child: CircularProgressIndicator())
//                     : PageHorizontalMargin(
//                         widget: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(60),
//                                   child: CachedNetworkImage(
//                                     imageUrl: postData?.user?.imageFullpath ?? "",
//                                     placeholder: (context, url) => CircularProgressIndicator(),
//                                     errorWidget: (context, url, error) => Icon(Icons.error),
//                                     width: 40,
//                                     height: 40,
//                                   ),
//                                 ),
//                                 SizedBox(width: 15),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       TextWidget(
//                                         textValue: postData!.title ?? "",
//                                         textColor: ColorUtils.black,
//                                         fontFamily: FontUtils.urbanistSemiBold,
//                                         fontSize: 16,
//                                       ),
//                                       TextWidget(
//                                         textValue: "${postData?.user?.fName ?? ""} ${postData?.user?.lName ?? ""}",
//                                         textColor: ColorUtils.grey3,
//                                         fontFamily: FontUtils.urbanistRegular,
//                                         fontSize: 12,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 15),
//                             ExpandableTextWidget(
//                               textValue: postData?.content ?? "",
//                               textColor: ColorUtils.black,
//                               fontFamily: FontUtils.urbanistRegular,
//                               fontSize: 14,
//                               maxLines: 2,
//                             ),
//                             SizedBox(height: 8),
//                             postData?.image != "https://boaterslife.com/dashboard/assets/admin/img/160x160/img1.jpg"
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: CachedNetworkImage(
//                                       imageUrl: (postData?.image ?? ""),
//                                       placeholder: (context, url) => CircularProgressIndicator(),
//                                       errorWidget: (context, url, error) => Icon(Icons.error),
//                                       fit: BoxFit.fitWidth,
//                                       width: double.infinity,
//                                       height: 167,
//                                     ),
//                                   )
//                                 : SizedBox(),
//                             SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 CustomButtonBorder(
//                                   buttonHeight: 35,
//                                   buttonWidth: 110,
//                                   textValue: '(${postData?.likes?.length ?? 0}) Like',
//                                   prefixImage: Images.like,
//                                   prefixImgColor: postData!.likes!.any((like) => like.userId.toString() == userID) ? ColorUtils.white : null,
//                                   buttonTextColor: postData!.likes!.any((like) => like.userId.toString() == userID) ? ColorUtils.white : null,
//                                   buttonColor: postData!.likes!.any((like) => like.userId.toString() == userID) ? Theme.of(context).primaryColor : null,
//                                   onButtonPressed: likePost,
//                                 ),
//                                 CustomButtonBorder(
//                                   buttonHeight: 35,
//                                   buttonWidth: 150,
//                                   textValue: '(${postData!.comments?.length ?? 0}) Comments',
//                                   prefixImage: Images.comment,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             TextWidget(
//                               textValue: "Comments",
//                               textColor: ColorUtils.black,
//                               fontFamily: FontUtils.urbanistBold,
//                               fontSize: 16,
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Expanded(
//               child: ListView.separated(
//                 padding: EdgeInsets.zero,
//                 itemBuilder: (context, index) {
//                   return PageHorizontalMargin(
//                     horizontal: 20,
//                     widget: Column(
//                       children: [
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: CachedNetworkImage(
//                                 imageUrl: postData?.comments?[index].user?.imageFullpath ?? "",
//                                 placeholder: (context, url) => const CircularProgressIndicator(),
//                                 errorWidget: (context, url, error) => Icon(Icons.error),
//                                 fit: BoxFit.cover,
//                                 width: 35,
//                                 height: 35,
//                               ),
//                             ),
//                             SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextWidget(
//                                     textValue: (postData?.comments?[index].user?.fName ?? "") + " " + (postData?.comments?[index].user?.lName ?? ""),
//                                     textColor: ColorUtils.black,
//                                     fontFamily: FontUtils.urbanistSemiBold,
//                                     fontSize: 14,
//                                   ),
//                                   TextWidget(
//                                     textValue: postData?.comments?[index].comment ?? "",
//                                     textColor: ColorUtils.hintGrey,
//                                     fontFamily: FontUtils.urbanistRegular,
//                                     fontSize: 14,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 separatorBuilder: (context, index) => Divider(),
//                 itemCount: postData?.comments?.length ?? 0,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomTextField(
//                       hintText: 'Type your comment here',
//                       FieldHeight: 12,
//                       controller: _commentController,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   InkWell(
//                     onTap: postComment,
//                     child: Icon(Icons.send, color: Theme.of(context).primaryColor, size: 32),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
