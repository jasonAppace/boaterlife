import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';
import '../../CommunityModel/groupPostModel.dart';

class GroupPosts {
  var _dioService = DioService.getInstance();

  Future groupPosts(String token, int groupID) async {
    try {
      final response = await _dioService.get(AppConstants.groupPosts+groupID.toString(),
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
      );
      if(response.statusCode == 200){
        // user found
        if(response.data["status"] == true){
          GroupPostModel userLoginResponse = GroupPostModel.fromJson(response.data);
          return userLoginResponse;
        }
        else {
          return response.data['data'];
        }
      }
      else{
        return response.statusMessage;
      }
    }
    catch (e) {
      dynamic exception= e;
      return exception.message;
    }
  }
}