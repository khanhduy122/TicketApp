import 'dart:io';

abstract class UserEvent {}

class EditProfileUserEvent extends UserEvent {
  File? photo;
  String? name;

  EditProfileUserEvent({this.name, this.photo});
}

class UploadPhotoUserEvent extends UserEvent {
  File photo;

  UploadPhotoUserEvent({required this.photo});
}
