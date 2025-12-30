import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../App/dio_service.dart';
import '../../../../utill/app_constants.dart';

class GroupPostReport {
  var _dioService = DioService.getInstance();

  Future groupPostReport(String token, int postID, String reportReason) async {
    var json = {
      "post_id" : postID,
      "reason" : reportReason,
    };
    try {
      final response = await _dioService.post(AppConstants.groupPostReport,
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
