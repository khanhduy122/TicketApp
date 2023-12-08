import 'dart:io';

abstract class UserEvent {}

class EditProfileUserEvent extends UserEvent {
  String? photoURL;
  String? name;

  EditProfileUserEvent({this.name, this.photoURL});
}

class UploadPhotoUserEvent extends UserEvent {
  File photo;

  UploadPhotoUserEvent({required this.photo});
}
