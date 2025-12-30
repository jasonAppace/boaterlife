import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';

class GroupStatusChange {
  final _dioService = DioService.getInstance();

  Future groupStatusChange(String token, int groupID) async {
    var json = {
      "group_id" : groupID,
    };
    try {
      final response = await _dioService.post(AppConstants.activateDeactivateGroup,
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