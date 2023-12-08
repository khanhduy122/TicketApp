import 'package:firebase_auth/firebase_auth.dart';

class UserState {}

class EditProfileUserState extends UserState {
  Object? error;
  bool? isLoading;
  User? user;

  EditProfileUserState({this.error, this.isLoading, this.user});
}

class UploadPhotoUserState extends UserState {
  Object? error;
  bool? isLoading;
  String? photoUrl;

  UploadPhotoUserState({this.error, this.isLoading, this.photoUrl});
}
