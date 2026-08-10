import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:sprints_firstapp/cubit/auth_cubit/auth_state.dart';
import 'package:sprints_firstapp/services/auth_services.dart';
import 'package:sprints_firstapp/services/image_services.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String errorMessage = '';

  //------------create user------------------

  Future<void> createUserCubit({
    required String email,
    required String password,
    required String username,
    File? profileImage,
  }) async {
    emit(AuthLoading());

    String profileImageUrl = '';

    // Upload profile picture to ImgBB if one was selected
    if (profileImage != null) {
      profileImageUrl = await ImageServices.uploadImage(
        image: profileImage,
        apiKey: '99fecb79a682139d934ae76e00582ea5',
      );
    }

    final state = await AuthServices.createUser(
      email: email,
      password: password,
      username: username,
      profileImage: profileImageUrl,
    );

    if (state == 'success') {
      emit(AuthSuccess());
    } else {
      errorMessage = state;
      emit(AuthFailed());
    }
  }

  //------------login user------------------

  Future<void> loginUserCubit({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final state = await AuthServices.loginUser(
      email: email,
      password: password,
    );

    if (state == 'success') {
      emit(AuthSuccess());
    } else {
      errorMessage = state;
      emit(AuthFailed());
    }
  }

  //------------logout user---------------

  Future<void> logoutUserCubit() async {
    emit(AuthLoading());

    final state = await AuthServices.logOutUser();

    if (state == 'success') {
      errorMessage = '';
      emit(AuthInitial());
    } else {
      errorMessage = state;
      emit(AuthFailed());
    }
  }

  //-----------delete user--------------

  Future<void> deleteUserCubit() async {
    emit(AuthLoading());

    final state = await AuthServices.deleteUser();

    if (state == 'success') {
      emit(AuthInitial());
    } else {
      errorMessage = state;
      emit(AuthFailed());
    }
  }

  //------------reset password------------------

  Future<void> resetPasswordCubit({
    required String email,
  }) async {
    emit(AuthLoading());

    final state = await AuthServices.resetPassword(
      email: email,
    );

    if (state == 'success') {
      errorMessage = '';
      emit(PasswordResetSuccess());
    } else {
      errorMessage = state;
      emit(AuthFailed());
    }
  }
}