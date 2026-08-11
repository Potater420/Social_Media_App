import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:social_media_app/cubit/post_cubit/post_state.dart';
import 'package:social_media_app/services/post_services.dart';
import 'package:social_media_app/services/image_services.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  String errorMessage = '';

  //------------ Create Post ------------------

  Future createPostCubit({
    required String title,
    required String description,
    required File? image,
  }) async {
    emit(PostLoading());

    String imageUrl = '';

    // Upload image if one was selected
    if (image != null) {
      imageUrl = await ImageServices.uploadImage(
        image: image,
        apiKey: '99fecb79a682139d934ae76e00582ea5',
      );

      if (imageUrl == 'Upload failed' ||
          imageUrl == 'Unexpected error') {
        errorMessage = imageUrl;
        emit(PostFailed());
        return;
      }
    }

    // Create post in Firestore
    final state = await PostServices.createPost(
      title: title,
      description: description,
      imageUrl: imageUrl,
    );

    if (state == 'success') {
      errorMessage = '';
      emit(PostSuccess());
    } else {
      errorMessage = state;
      emit(PostFailed());
    }
  }
}