// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:hexacom_user/features/Community/Widgets/color_utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../common/widgets/custom_app_bar_widget.dart';
// import '../../../utill/app_constants.dart';
// import '../CommunityModel/community_post_model.dart';
// import '../Widgets/CustomSingleChildScrollView.dart';
// import '../Widgets/DashedBorderContainer.dart';
// import '../Widgets/custom_button.dart';
// import '../Widgets/custom_text_field.dart';
// import '../Widgets/font_utils.dart';
// import '../Widgets/page_horizontal_margin.dart';
// import '../Widgets/text_widget.dart';
//
// class CreateCommunityPost extends StatefulWidget {
//   CreateCommunityPost({super.key});
//
//   @override
//   State<CreateCommunityPost> createState() => _CreateCommunityPostState();
// }
//
// class _CreateCommunityPostState extends State<CreateCommunityPost> {
//   File? selectedImage;
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();
//   final Dio _dio = Dio();
//   SharedPreferences? sharedPreferences;
//   CommunityPostModel? _posts;
//   bool _isLoading = false; // Loading state variable
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeSharedPreferences();
//   }
//
//   // Initialize SharedPreferences
//   Future<void> _initializeSharedPreferences() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//   }
//
//   Future<void> _createPost() async {
//     if (_isLoading) return;
//
//     if (_titleController.text.isEmpty || _descController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Title and Description are required')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true; // Start loading
//     });
//
//     try {
//       FormData formData = FormData.fromMap({
//         'title': _titleController.text,
//         'content': _descController.text,
//         if (selectedImage != null)
//           'image': await MultipartFile.fromFile(
//             selectedImage!.path,
//             filename: selectedImage!.path.split('/').last,
//           ),
//       });
//
//       String? token = sharedPreferences!.getString(AppConstants.token);
//
//       Response response = await _dio.post(
//         AppConstants.baseUrl + AppConstants.communityListAdd,
//         data: formData,
//         options: Options(
//           headers: {
//             'Content-Type': 'multipart/form-data',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Post Created Successfully')),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create post')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating post: $e')),
//       );
//     } finally {
//       // Ensure loading is set to false when done, whether success or error
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: Scaffold(
//         backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//         body: CustomSingleChildScrollView(
//           widget: Column(
//             children: [
//               CustomAppBarWidget(title: 'Add Post'),
//               SizedBox(height: 50),
//               PageHorizontalMargin(
//                 horizontal: 15,
//                 widget: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomTextField(
//                       hintText: 'Enter Title Here',
//                       labelText: 'Title',
//                       controller: _titleController,
//                       TextColor: ColorUtils.black,
//                     ),
//                     SizedBox(height: 16),
//                     CustomTextField(
//                       hintText: 'Enter your description...',
//                       labelText: 'Description',
//                       controller: _descController,
//                       TextColor: ColorUtils.black,
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: image_picker_2(
//                             onImagePicked: (File? image) {
//                               setState(() {
//                                 selectedImage = image;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                     CustomButton(
//                       textValue: _isLoading ? 'Creating...' : 'Create Post',
//                       onButtonPressed: _isLoading ? null : _createPost,
//                       TextColor: ColorUtils.black,
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }