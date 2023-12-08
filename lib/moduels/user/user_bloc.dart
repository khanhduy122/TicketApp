import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/moduels/user/user_event.dart';
import 'package:ticket_app/moduels/user/user_repo.dart';
import 'package:ticket_app/moduels/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final User _user = FirebaseAuth.instance.currentUser!;
  final UserRepo _userRepo = UserRepo();

  UserBloc() : super(UserState()) {
    on<EditProfileUserEvent>((event, emit) => _editProfileUser(event, emit));

    on<UploadPhotoUserEvent>((event, emit) => _uploadPhotoUser(event, emit));
  }

  void _editProfileUser(EditProfileUserEvent event, Emitter emit) async {
    try {
      emit(EditProfileUserState(isLoading: true));
      if (event.name != null) {
        await _user.updateDisplayName(event.name);
      }
      if (event.photoURL != null) {
        await _user.updatePhotoURL(event.photoURL);
      }
      await _user.reload();
      emit(EditProfileUserState(user: _user));
    } catch (e) {
      emit(EditProfileUserState(error: e));
    }
  }

  void _uploadPhotoUser(UploadPhotoUserEvent event, Emitter emit) async {
    try {
      emit(UploadPhotoUserState(isLoading: true));
      String? photoUrl = await _userRepo.uploadImageToFirebase(event.photo);
      emit(UploadPhotoUserState(photoUrl: photoUrl));
    } catch (e) {
      emit(UploadPhotoUserState(error: e));
    }
  }
}
