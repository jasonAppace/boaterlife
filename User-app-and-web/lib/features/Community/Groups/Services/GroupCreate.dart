import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import '../../../../App/dio_service.dart';

class GroupCreate {
  var _dioService = DioService.getInstance();

  Future groupCreate(String token, String groupName, String groupDescription, File? imageFile) async {
    try {
      // Create a FormData object to handle multipart data
      FormData formData = FormData.fromMap({
        "name": groupName,
        "description": groupDescription,
        if (imageFile != null)
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _dioService.post(
        AppConstants.createGroup,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: "multipart/form-data",
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        // Check response status
        if (response.data["status"] == true) {
          return response.data;
        } else {
          return response.data['data'];
        }
      } else {
        return response.statusMessage;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
