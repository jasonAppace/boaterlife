import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../App/dio_service.dart';
import '../../../../utill/app_constants.dart';

class GroupPostCreate {
  var _dioService = DioService.getInstance();

  Future groupPostCreate(String token, String title, String description, int groupID, File? imageFile) async {
    try {
      // Prepare the multipart form data
      FormData formData = FormData.fromMap({
        "title": title,
        "description": description,
        "group_id": groupID,
        if (imageFile != null)
          "content[]": [
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ]
      });

      final response = await _dioService.post(
        AppConstants.groupPostCreate,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        if (response.data["status"] == true) {
          return response.data;
        } else {
          return response.data['data'];
        }
      } else {
        return response.statusMessage;
      }
    } catch (e) {
      // Handle exceptions
      return e.toString();
    }
  }
}
