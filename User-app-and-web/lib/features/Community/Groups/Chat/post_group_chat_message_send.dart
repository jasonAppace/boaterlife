import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';

import '../../../../App/dio_service.dart';

class GroupChatMessageSend {
  var _dioService = DioService.getInstance();

  Future groupChatMessageSend(String token, {String? groupID, String? toID, required String message}) async {
    // Dynamically build the JSON object
    var json = {
      "body": message,
    };

    if (groupID != null) {
      json["group_id"] = groupID;
    }

    if (toID != null) {
      json["to_id"] = toID;
    }

    try {
      final response = await _dioService.post(
        AppConstants.sendGroupMessages,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: jsonEncode(json),
      );

      if (response.statusCode == 200) {
        // User found
        if (response.data["status"] == true) {
          return response.data["status"];
        } else {
          return response.data['data'];
        }
      } else {
        return response.statusMessage;
      }
    } catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }
}
