import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/user/user_event.dart';
import 'package:ticket_app/moduels/user/user_repo.dart';
import 'package:ticket_app/moduels/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final User _user = FirebaseAuth.instance.currentUser!;
  final UserRepo _userRepo = UserRepo();

  UserBloc() : super(UserState()) {
    on<EditProfileUserEvent>((event, emit) => _editProfileUser(event, emit));
  }

  void _editProfileUser(EditProfileUserEvent event, Emitter emit) async {
    try {
      emit(EditProfileUserState(isLoading: true));

      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(EditProfileUserState(error: NoInternetException()));
        return;
      }

      if (event.name != null) {
        await _user.updateDisplayName(event.name);
      }

      if (event.photo != null) {
        String? photoUrl = await _userRepo.uploadImageToFirebase(event.photo!);
        await _user.updatePhotoURL(photoUrl);
      }
      emit(EditProfileUserState(user: _user));
    } catch (e) {
      emit(EditProfileUserState(error: e));
    }
  }
}
