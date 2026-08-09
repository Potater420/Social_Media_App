import 'dart:io';
import 'package:dio/dio.dart';

class ImageServices {
  static final Dio _dio = Dio();

  static Future<String> uploadImage({
    required File image,
    required String apiKey,
  }) async {
    try {
      final formData = FormData.fromMap({
        'key': '99fecb79a682139d934ae76e00582ea5',
        'image': await MultipartFile.fromFile(
          image.path,
        ),
      });

      final response = await _dio.post(
        'https://api.imgbb.com/1/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data']['url'];
      } else {
        return 'Upload failed';
      }
    } catch (e) {
      return 'Unexpected error';
    }
  }
}