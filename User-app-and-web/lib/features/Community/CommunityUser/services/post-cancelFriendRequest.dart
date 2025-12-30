import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';

class CancelRequestFriend {
  var _dioService = DioService.getInstance();

  Future cancelRequestFriend(String token, String userID) async {
    try {
      final response = await _dioService.get(AppConstants.cancelFriendRequest+userID.toString(),
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
        //data: jsonEncode(json),
      );
      if(response.statusCode == 200){
        // user found
        if(response.data["status"] == true){
          return response.data;
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