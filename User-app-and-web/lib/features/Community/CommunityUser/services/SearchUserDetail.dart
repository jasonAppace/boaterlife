import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';
import '../model/userDetailModel.dart';

class SearchUserDetailList {
  var _dioService = DioService.getInstance();

  Future searchUserDetail(String token, String userID) async {

    try {
      final response = await _dioService.get(AppConstants.userDetail+userID,
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
      );
      if(response.statusCode == 200){
        // user found
        if(response.data["status"] == true){
          UserDetailModel responseL = UserDetailModel.fromJson(response.data);
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