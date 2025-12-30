import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../App/dio_service.dart';
import '../../../../utill/app_constants.dart';
import '../../CommunityModel/groupPostModel.dart';


class GroupPostIndividual {
  var _dioService = DioService.getInstance();

  Future groupPostIndividual(String token, int postID) async {
    try {
      final response = await _dioService.get(AppConstants.individualPost+postID.toString(),
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
      );
      if(response.statusCode == 200){
        // user found
        if(response.data["status"] == true){
          PostData userLoginResponse = PostData.fromJson(response.data["data"]);
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