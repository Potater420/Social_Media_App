import 'package:dio/dio.dart';

class ChatServices {
  static final Dio _dio = Dio();

  static const String _webhookUrl =
      'https://peter-gamal4420.app.n8n.cloud/webhook/chat';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        _webhookUrl,
        data: {
          'message': message,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }

        return 'The AI returned an invalid response.';
      }

      return 'Failed to get a response from the AI.';
    } on DioException catch (e) {
      print('CHAT DIO ERROR: ${e.message}');
      print('CHAT RESPONSE: ${e.response?.data}');

      throw Exception('Failed to connect to the AI.');
    } catch (e) {
      print('CHAT ERROR: $e');

      throw Exception('Something went wrong.');
    }
  }
}