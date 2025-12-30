import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';
import '../../CommunityModel/myGroupsModel.dart';

class SuggestedGroups {
  var _dioService = DioService.getInstance();

  Future suggestedGroups(String token) async {
    try {
      final response = await _dioService.get(AppConstants.groupSuggested,
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              HttpHeaders.contentTypeHeader: "application/json",
            }),
      );
      if(response.statusCode == 200){
        // user found
          MyGroupsModel userLoginResponse = MyGroupsModel.fromJson(response.data);
          return userLoginResponse;
      }
      else{
        return response.data;
      }
    }
    catch (e) {
      dynamic exception= e;
      return exception.message;
    }
  }
}