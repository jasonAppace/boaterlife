import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';

import '../../../../App/dio_service.dart';

class GroupPostLikeAdd {
  var _dioService = DioService.getInstance();

  Future groupPostLikeAdd(String token, int post_id) async {
    var json = {
      "post_id" : post_id,
    };
    try {
      final response = await _dioService.post(AppConstants.postLikeAdd,
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