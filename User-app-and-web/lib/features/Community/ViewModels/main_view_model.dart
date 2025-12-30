import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/ViewModels/prefrences_view_model.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:hexacom_user/App/navigation_service.dart' as my_nav_service;

import '../../../App/locator.dart';
import '../../../utill/app_constants.dart';
import '../ChatModels/groupChatListModel.dart';
import '../ChatModels/groupChatMessagesModel.dart';
import '../ChatModels/individualChatListModel.dart';
import '../ChatModels/individualChatMessagesModel.dart';
import '../CommunityModel/groupInfoModel.dart';
import '../CommunityModel/groupMemberModel.dart';
import '../CommunityModel/groupPostModel.dart';
import '../CommunityModel/myGroupsModel.dart';
import '../CommunityUser/model/searchUserModel.dart';
import '../CommunityUser/model/userDetailModel.dart';
import '../CommunityUser/services/SearchUser.dart';
import '../CommunityUser/services/SearchUserDetail.dart';
import '../CommunityUser/services/post-addFriend.dart';
import '../CommunityUser/services/post-cancelFriendRequest.dart';
import '../CommunityUser/services/post-removeFriend.dart';
import '../CommunityUser/services/post-respondToFriendReq.dart';
import '../Groups/Chat/post-block-chat.dart';
import '../Groups/Chat/post_group_chat_message_send.dart';
import '../Groups/Chat/post_group_chat_messages.dart';
import '../Groups/Chat/post_individual_chat_messages.dart';
import '../Groups/Services/GroupCreate.dart';
import '../Groups/Services/GroupDetail.dart';
import '../Groups/Services/GroupJoin.dart';
import '../Groups/Services/GroupLeave.dart';
import '../Groups/Services/GroupMemberBlock.dart';
import '../Groups/Services/GroupMembers.dart';
import '../Groups/Services/GroupPostCommentAdd.dart';
import '../Groups/Services/GroupPostCreate.dart';
import '../Groups/Services/GroupPostDelete.dart';
import '../Groups/Services/GroupPostIndividual.dart';
import '../Groups/Services/GroupPostLikeAdd.dart';
import '../Groups/Services/GroupPostReport.dart';
import '../Groups/Services/GroupPosts.dart';
import '../Groups/Services/GroupStatusChange.dart';
import '../Groups/Services/JoinedGroups.dart';
import '../Groups/Services/MyGroups.dart';
import '../Groups/Services/NewsFeedPosts.dart';
import '../Groups/Services/SuggestedGroups.dart';
import '../Groups/Services/get_group_chat_list.dart';
import '../Groups/Services/get_individual_chat_list.dart';
import '../Widgets/font_utils.dart';


class MainViewModel extends BaseViewModel {
  var prefService = locator<PreferencesViewModel>();
  var navigationService = my_nav_service.NavigationService();
  SharedPreferences? sharedPreferences;

  bool loadingWidget = false;
  String? userID;
  String? userName;
  String? userToken;
  String? fcmToken;
  String? userEmail;
  String? userCompany;
  String? userPhone;
  String? userExtension;

  TextEditingController userNameProfile = TextEditingController();
  TextEditingController userCompanyNameProfile = TextEditingController();
  TextEditingController userPhoneProfile = TextEditingController();
  TextEditingController userPhoneAltProfile = TextEditingController();
  TextEditingController userEmailProfile = TextEditingController();

  void initializeViewModel(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    userToken = sharedPreferences!.getString(AppConstants.token);
    userID = sharedPreferences!.getString(AppConstants.userId);

    await doNewsFeedPosts(context, userToken ?? "");
    await doJoinedGroups(context, userToken ?? "");
    await doSuggestedGroups(context, userToken ?? "");
  }

  // Show Error Message
  void showErrorMessage(BuildContext context, String error) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: FontUtils.urbanistBold,
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      elevation: 10,
      duration: Duration(seconds: 2),
    ));
  }

  // Show Success Message
  void showSuccessMessage(BuildContext context, String error) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: FontUtils.urbanistBold,
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.green,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      elevation: 10,
      duration: Duration(seconds: 2),
    ));
  }

  //######################################################################## Login Screen ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Starts    ///////////////////////////////////////////////////////////////////////////////////

  // TextEditingController loginEmailController = TextEditingController();
  // TextEditingController loginPasswordController = TextEditingController();
  //
  // var userLogin = UserLogin();
  //
  // Future doUserLogin(
  //     BuildContext context, String userId, String password) async {
  //   if (loginEmailController.text.isEmpty) {
  //     showErrorMessage(context, "Please Enter Email");
  //   } else if (loginPasswordController.text.isEmpty) {
  //     showErrorMessage(context, "Please Enter Password");
  //   } else {
  //     loadingWidget = true;
  //     notifyListeners();
  //     var response = await userLogin.loginUser(userId, password);
  //     if (response != null && response is UserLoginModel) {
  //       userToken = response.token!;
  //       prefService.saveUserToken(userToken!);
  //       userID = response.data?.id;
  //       prefService.saveUserID(userID ?? 0);
  //       userName = response.data?.name ?? "";
  //       prefService.saveUserName(userName ?? "");
  //       loadingWidget = false;
  //
  //
  //       navigationService.navigateToUntil(to: MyBottomNavBar());
  //     } else {
  //       showErrorMessage(context, "Invalid Credentials");
  //     }
  //   }
  //   loadingWidget = false;
  //   notifyListeners();
  // }

//######################################################################## Login Screen ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End   ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Create Group ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  TextEditingController createGroupTitle = TextEditingController();
  TextEditingController createGroupDesc = TextEditingController();
  TextEditingController createGroupInterest = TextEditingController();

  var createGroupApi = GroupCreate();
  Future doCreateGroup(BuildContext context, String token, String groupName,
      String groupDescription, File? imageFile) async {
    loadingWidget = true;
    notifyListeners();
    var response = await createGroupApi.groupCreate(
        token, groupName, groupDescription, imageFile);
    if (response["status"] == true) {
      loadingWidget = false;
      createGroupTitle.text = "";
      createGroupDesc.text = "";
      doJoinedGroups(context, token);
      doNewsFeedPosts(context, userToken ?? "");
      doMyGroups(context, userToken ?? "");
      doSuggestedGroups(context, userToken ?? "");
      notifyListeners();
      Navigator.pop(context);
      showSuccessMessage(context, "Group Created Successfully");
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Create Group ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get My Groups ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var myGroupsApi = MyGroups();
  MyGroupsModel? allMyGroupsData;

  Future doMyGroups(BuildContext context, String token) async {
    loadingWidget = true;
    notifyListeners();
    var response = await myGroupsApi.myGroups(token);
    if (response != null && response is MyGroupsModel) {
      loadingWidget = false;
      allMyGroupsData = response;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get My Groups  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get Joined Groups ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var joinedGroupsApi = JoinedGroups();
  MyGroupsModel? allJoinedGroupsData;

  Future doJoinedGroups(BuildContext context, String token) async {
    loadingWidget = true;
    notifyListeners();
    var response = await joinedGroupsApi.joinedGroups(token);
    if (response != null && response is MyGroupsModel) {
      loadingWidget = false;
      allJoinedGroupsData = response;
      notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Joined Groups  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get Suggested Groups ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var suggestedGroupsApi = SuggestedGroups();
  MyGroupsModel? allSuggestedGroupsData;

  Future doSuggestedGroups(BuildContext context, String token) async {
    loadingWidget = true;
    notifyListeners();
    var response = await suggestedGroupsApi.suggestedGroups(token);
    if (response != null && response is MyGroupsModel) {
      loadingWidget = false;
      allSuggestedGroupsData = response;
      notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Suggested Groups  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get Group Detail ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupDetailApi = GroupDetail();
  GroupInfoModel? allGroupDetailData;

  Future doGroupDetail(BuildContext context, String token, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupDetailApi.groupDetail(token, groupID);
    if (response != null && response is GroupInfoModel) {
      loadingWidget = false;
      allGroupDetailData = response;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Group Detail  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get Groups Members ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupMembersApi = GroupMembers();
  GroupMemberModel? allGroupMemberData;

  Future doGroupMember(BuildContext context, String token, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupMembersApi.groupMembers(token, groupID);
    if (response != null && response is GroupMemberModel) {
      loadingWidget = false;
      allGroupMemberData = response;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Groups Members ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Group Status Change ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupStatusChangeApi = GroupStatusChange();

  Future doGroupStatusChange(
      BuildContext context, String token, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupStatusChangeApi.groupStatusChange(token, groupID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Group Status Changed Successfully");
      doGroupDetail(context, token, groupID);
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Status Change ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Group Leave ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupLeaveApi = GroupLeave();

  Future doGroupLeave(BuildContext context, String token, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupLeaveApi.groupLeave(token, groupID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Group Status Changed Successfully");
      //navigationService.navigateToUntil(to: MyBottomNavBar());
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Leave ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Group Join ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupJoinApi = GroupJoin();

  Future doGroupJoin(BuildContext context, String token, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupJoinApi.groupJoin(token, groupID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Group Joined Successfully");
      doSuggestedGroups(context, token);
      doJoinedGroups(context, token);
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Join ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Group Member Block Unblock ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupMemberBlockUnblockApi = GroupMemberBlock();

  Future doGroupMemberBlockUnblock(
      BuildContext context, String token, int groupID, int userID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupMemberBlockUnblockApi.groupMemberBlock(
        token, groupID, userID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Group Member Status Changed Successfully");
      doGroupMember(context, token, groupID);
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Member Block Unblock ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////


  //########################################################################  Block Chat Individual ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var blockChatApi = BlockChat();

  Future doBlockChat(BuildContext context, String token, String userID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await blockChatApi.blockChat(token, userID);
    if (response["status"] == true) {
      loadingWidget = false;
      String message = response["message"];
      showSuccessMessage(context, message);
      //doIndividualChatList(context, token);
      doNewsFeedPosts(context, token);
      //navigationService.back();
      Navigator.pop(context);
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Block Chat Individual ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get Groups Posts ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupPostsApi = GroupPosts();
  GroupPostModel? allGroupPostsData;

  Future doGroupPosts(BuildContext context, String token, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupPostsApi.groupPosts(token, groupID);
    if (response != null && response is GroupPostModel) {
      loadingWidget = false;
      allGroupPostsData = response;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Groups Members ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Get Newsfeed Posts ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var newsFeedPostsApi = NewsFeedPosts();
  GroupPostModel? allNewsFeedPostsData;

  Future doNewsFeedPosts(BuildContext context, String token) async {
    loadingWidget = true;
    //notifyListeners();
    var response = await newsFeedPostsApi.newsFeedPosts(token);
    if (response != null && response is GroupPostModel) {
      loadingWidget = false;
      allNewsFeedPostsData = response;
      //notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Newsfeed Members ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Post Add Comment  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  TextEditingController addCommentController = TextEditingController();
  var groupPostCommentAddApi = GroupPostCommentAdd();

  Future doGroupPostCommentAddApi(
      BuildContext context, String token, String comment, int postID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupPostCommentAddApi.groupPostCommentAdd(
        token, comment, postID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Comment Added Successfully");
      addCommentController.text = "";
      doGroupPostIndividual(
        context,
        userToken ?? "",
        postID,
      );
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//########################################################################  Post Add Comment  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Post Add Like  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupPostLikeAddApi = GroupPostLikeAdd();

  Future doGroupPostLikeAddApi(
      BuildContext context, String token, int postID, groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupPostLikeAddApi.groupPostLikeAdd(token, postID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Like Posted Successfully");
      doGroupPostIndividual(
        context,
        userToken ?? "",
        postID,
      );
      if (groupID != null && groupID != 0) {
        doGroupPosts(context, token, groupID);
        doNewsFeedPosts(context, token);
      }
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//########################################################################  Post Add Like  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Create Group ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  TextEditingController createGroupPostTitle = TextEditingController();
  TextEditingController createGroupPostDesc = TextEditingController();

  var createGroupPostApi = GroupPostCreate();
  Future doCreateGroupPost(BuildContext context, String token, String title,
      String description, int groupID, File? imageFile) async {
    loadingWidget = true;
    notifyListeners();
    var response = await createGroupPostApi.groupPostCreate(
        token, title, description, groupID, imageFile);
    if (response["status"] == true) {
      loadingWidget = false;
      createGroupPostTitle.text = "";
      createGroupPostDesc.text = "";
      Navigator.pop(context);
      //navigationService.back();
      doGroupPosts(context, token, groupID);
      showSuccessMessage(context, "Post Created Successfully");
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Create Group ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Group Post Delete ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupPostDeleteApi = GroupPostDelete();

  Future doGroupPostDelete(
      BuildContext context, String token, int postID, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupPostDeleteApi.groupPostDelete(token, postID);
    if (response["status"] = true) {
      loadingWidget = false;
      doGroupPosts(context, token, groupID);
      doNewsFeedPosts(context, token);
      showSuccessMessage(context, "Post Deleted Successfully");
      //navigationService.back();
      Navigator.pop(context);
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Post Delete  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////


  //######################################################################## Group Post Report ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupPostReportApi = GroupPostReport();

  Future doGroupPostReport(
      BuildContext context, String token, int postID, int groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupPostReportApi.groupPostReport(token, postID, "Null");
    if (response["status"] = true) {
      loadingWidget = false;
      //navigationService.back();
      Navigator.pop(context);
      showSuccessMessage(context, "Post Reported Successfully");
      doGroupPosts(context, token, groupID);
      doNewsFeedPosts(context, token);
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Post Report  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////


  //######################################################################## Get Group Post Individual ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupPostIndividualApi = GroupPostIndividual();
  PostData? allGroupPostIndividualData;

  Future doGroupPostIndividual(
      BuildContext context, String token, int postID) async {
    loadingWidget = true;
    notifyListeners();
    var response =
    await groupPostIndividualApi.groupPostIndividual(token, postID);
    if (response != null && response is PostData) {
      loadingWidget = false;
      allGroupPostIndividualData = response;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get Group Post Individual ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////


//######################################################################## Get GroupChatList ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupChatListApi = GroupChatList();
  GroupChatListModel? allGroupChatListData;

  Future doGroupChatList(BuildContext context, String token) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupChatListApi.groupChatList(token);
    if (response != null && response is GroupChatListModel) {
      if (response.data!.isNotEmpty) {
        loadingWidget = false;
        allGroupChatListData = response;
      }
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }
    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get GroupChatList ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Group Messages ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var groupChatMessagesApi = GroupChatMessages();
  GroupChatMessagesModel? allGroupChatMessagesData;

  Future doGroupChatMessages(
      BuildContext context, String token, String groupID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupChatMessagesApi.groupChatMessages(token, groupID);
    if (response != null && response is GroupChatMessagesModel) {
      loadingWidget = false;
      allGroupChatMessagesData = response;
      notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }
    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Group Messages ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Send Message Group Chat ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  TextEditingController groupChatMessageController = TextEditingController();

  var groupChatMessageSendApi = GroupChatMessageSend();
  Future dogroupChatMessageSend(BuildContext context, String token,
      String groupID, String message) async {
    loadingWidget = true;
    notifyListeners();
    var response = await groupChatMessageSendApi.groupChatMessageSend(token,
        groupID: groupID, message: message);
    if (response != null && response == true) {
      loadingWidget = false;
      groupChatMessageController.text = "";
      return true;
      // doGroupChatMessages(context,token,groupID);
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Send Message Group Chat ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Send Message Individual Chat ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var individualChatMessageSendApi = GroupChatMessageSend();
  Future doindividualChatMessageSend(
      BuildContext context, String token, String toID, String message) async {
    loadingWidget = true;
    notifyListeners();
    var response = await individualChatMessageSendApi
        .groupChatMessageSend(token, toID: toID, message: message);
    if (response != null && response == true) {
      loadingWidget = false;
      groupChatMessageController.text = "";
      return true;
      // doGroupChatMessages(context,token,groupID);
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Send Message Individual Chat ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

//######################################################################## Get IndividualChatList ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var individualChatListApi = IndividualChatList();
  IndividualChatListModel? allIndividualChatListData;

  Future doIndividualChatList(BuildContext context, String token) async {
    loadingWidget = true;
    notifyListeners();
    var response = await individualChatListApi.individualChatList(token);
    if (response != null && response is IndividualChatListModel) {
      loadingWidget = false;
      allIndividualChatListData = response;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }
    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Get IndividualChatList ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## Individual Messages ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var individualChatMessagesApi = IndividualChatMessages();
  IndividualChatMessagesModel? allIndividualChatMessagesData;

  Future doIndividualChatMessages(
      BuildContext context, String token, String userID) async {
    loadingWidget = true;
    notifyListeners();
    var response =
    await individualChatMessagesApi.individualChatMessages(token, userID);
    if (response != null && response is IndividualChatMessagesModel) {
      loadingWidget = false;
      allIndividualChatMessagesData = response;
      notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }
    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## Individual Messages ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////


//######################################################################## User Search ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  TextEditingController userSearchTF = TextEditingController();

  var searchUserApi = SearchUserList();
  SearchUserModel? allSearchUserData;

  Future doSearchUser(
      BuildContext context, String token, String usernameKeyword) async {
    loadingWidget = true;
    notifyListeners();
    var response = await searchUserApi.searchUser(token, usernameKeyword);
    if (response != null && response is SearchUserModel) {
      loadingWidget = false;
      allSearchUserData = response;
      notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }
    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## User Search ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //######################################################################## User Search Detail ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var searchUserDetailApi = SearchUserDetailList();
  UserDetailModel? allSearchUserDetailData;

  Future doSearchUserDetail(
      BuildContext context, String token, String userID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await searchUserDetailApi.searchUserDetail(token, userID);
    if (response != null && response is UserDetailModel) {
      loadingWidget = false;
      allSearchUserDetailData = response;
      notifyListeners();
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }
    loadingWidget = false;
    notifyListeners();
  }

//######################################################################## User Search Detail ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Unfriend  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var removeFriendApi = RemoveFriend();

  Future doRemoveFriendApi(
      BuildContext context, String token, String userID, String friendshipID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await removeFriendApi.removeFriend(token, friendshipID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Friend Removed Successfully");
      doSearchUserDetail(
        context,
        userToken ?? "",
          userID,
      );
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//########################################################################  Unfriend ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////



  //########################################################################  Add Friend  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var addFriendApi = AddFriend();

  Future doAddFriendApi(
      BuildContext context, String token, String userID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await addFriendApi.addFriend(token, userID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Friend Added Successfully");
      doSearchUserDetail(
        context,
        userToken ?? "",
        userID,
      );
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//########################################################################  Add Friend ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

  //########################################################################  Add Friend  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var cancelRequestFriendApi = CancelRequestFriend();

  Future doCancelFriendshipRequestApi(
      BuildContext context, String token, String userID, String friendShipID) async {
    loadingWidget = true;
    notifyListeners();
    var response = await cancelRequestFriendApi.cancelRequestFriend(token, friendShipID);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Friend Request Cancelled Successfully");
      doSearchUserDetail(
        context,
        userToken ?? "",
        userID,
      );
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//########################################################################  Add Friend ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////


  //########################################################################  Respond To Friend Req  ###############################################################################//
/////////////////////////////////////////////////////////////////////////     Start   ///////////////////////////////////////////////////////////////////////////////////

  var respondToFriendReqApi = RespondToFriendReq();

  Future doRespondToFriendReqApi(
      BuildContext context, String token, String userID, String friendShipID, String status) async {
    loadingWidget = true;
    notifyListeners();
    var response = await respondToFriendReqApi.respond(token, friendShipID,status);
    if (response["status"] == true) {
      loadingWidget = false;
      showSuccessMessage(context, "Friend Request Cancelled Successfully");
      doSearchUserDetail(
        context,
        userToken ?? "",
        userID,
      );
      return true;
    } else {
      showErrorMessage(context, "Something Went Wrong");
    }

    loadingWidget = false;
    notifyListeners();
  }

//########################################################################  Respond To Friend Req ###############################################################################//
/////////////////////////////////////////////////////////////////////////     End    ///////////////////////////////////////////////////////////////////////////////////

}


