import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';

import '../../../../App/dio_service.dart';
import '../../ChatModels/individualChatMessagesModel.dart';

class IndividualChatMessages {
  var _dioService = DioService.getInstance();

  Future individualChatMessages(String token, String userID) async {
    var json = {
      "user_id": userID,
    };
    try {
      final response = await _dioService.post(AppConstants.individualChatMessages,
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
          IndividualChatMessagesModel responseApi = IndividualChatMessagesModel.fromJson(response.data);
          return responseApi;
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