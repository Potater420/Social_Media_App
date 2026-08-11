import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/services/chat_services.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  String errorMessage = '';

  Future<String?> sendMessage(String message) async {
    errorMessage = '';

    emit(ChatLoading());

    try {
      final response = await ChatServices.sendMessage(message);

      emit(ChatSuccess());

      return response;
    } catch (e) {
      errorMessage = e.toString().replaceFirst(
        'Exception: ',
        '',
      );

      emit(ChatError());

      return null;
    }
  }
}