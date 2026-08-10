import 'package:bloc/bloc.dart';
import 'package:sprints_firstapp/cubit/post_cubit/post_state.dart';
import 'package:sprints_firstapp/services/post_services.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  String errorMessage = '';

  //------------ Create Post ------------------

  Future createPostCubit({
    required String title,
    required String description,
    required String imageUrl,
  }) async {
    emit(PostLoading());

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