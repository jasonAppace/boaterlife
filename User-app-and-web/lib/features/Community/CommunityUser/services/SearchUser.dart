import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';
import '../model/searchUserModel.dart';

class SearchUserList {
  var _dioService = DioService.getInstance();

  Future searchUser(String token, String usernameKeyword) async {

    var json = {
      "search" : usernameKeyword,
    };

    try {
      final response = await _dioService.post(AppConstants.searchUser,
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
        data: jsonEncode(json),
      );
      if(response.statusCode == 200){
        // user found
        if(response.data["status"] == true){
          SearchUserModel responseL = SearchUserModel.fromJson(response.data);
          return responseL;
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