import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../App/dio_service.dart';
import '../../../../utill/app_constants.dart';

class GroupPostDelete {
  var _dioService = DioService.getInstance();

  Future groupPostDelete(String token, int postID) async {
    try {
      final response = await _dioService.get(AppConstants.groupPostDelete+postID.toString(),
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
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