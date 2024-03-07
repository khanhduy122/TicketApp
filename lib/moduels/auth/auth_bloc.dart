import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/moduels/auth/auth_event.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/auth/auth_repository.dart';
import 'package:ticket_app/moduels/auth/auth_state.dart';
import 'package:ticket_app/moduels/ticket/ticket_repo.dart';
import 'package:ticket_app/moduels/user/user_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository = AuthRepository();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TicketRepo ticketRepo = TicketRepo();
  final UserRepo _userRepo = UserRepo();

  AuthBloc() : super(AuthState()) {
    on<SignUpEvent>((event, emit) => _signUpEvent(event, emit));

    on<CheckVerifyEvent>((event, emit) => _checkVerifyEmailEvent(event, emit));

    on<SignInEvent>((event, emit) => _signInEvent(event, emit));

    on<DeleteUserEvent>((event, emit) => _deleteUserEvent(event, emit));

    on<SignInWithGoogleEvent>(
        (event, emit) => _signInWithGoogleEvent(event, emit));

    on<SendLinkResetPasswordEvent>(
        (event, emit) => _sendLinkResetPassword(event, emit));
  }

  void _signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(SignUpState(isLoading: true));
    try {
      await authRepository.signUpWithEmailPassword(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          image: event.image);
      emit(SignUpState(signUpSucces: true));
    } catch (e) {
      emit(SignUpState(error: e));
    }
  }

  void _checkVerifyEmailEvent(CheckVerifyEvent event, Emitter<AuthState> emit) {
    FirebaseAuth.instance.currentUser!.reload();
    if (firebaseAuth.currentUser!.emailVerified) {
      emit(CheckVerifyState(isVerifyEmail: true));
    }
  }

  void _signInEvent(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(SignInState(isLoading: true));
      await authRepository.signInWithEmailPassword(
          email: event.email, password: event.password);
      await ticketRepo.convertTicketToExpired();
      final voucher = await _userRepo.getListVoucher();
      event.context.read<DataAppProvider>().setListVoucher(vouchers: voucher);
      emit(SignInState(signInSuccess: true));
    } catch (e) {
      emit(SignInState(error: e));
    }
  }

  void _deleteUserEvent(DeleteUserEvent event, Emitter<AuthState> emit) async {
    try {
      emit(DeleteUserState(isLoading: true));
      await authRepository.deleteUser();
      emit(DeleteUserState(isSuccess: true));
    } catch (e) {
      emit(DeleteUserState(isSuccess: false));
    }
  }

  void _signInWithGoogleEvent(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser;

    googleUser = await googleSignIn.signIn().catchError((onError) => null);

    try {
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication.timeout(
          const Duration(seconds: 20),
          onTimeout: () => throw TimeOutException(),
        );

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        emit(SignInWithGoogleState(isLoading: true));

        await FirebaseAuth.instance.signInWithCredential(credential).timeout(
              const Duration(seconds: 20),
              onTimeout: () => throw TimeOutException(),
            );
        await ticketRepo.convertTicketToExpired();
        final voucher = await _userRepo.getListVoucher();
        event.context.read<DataAppProvider>().setListVoucher(vouchers: voucher);

        emit(SignInWithGoogleState(isSuccess: true));
      }
    } on PlatformException catch (err) {
      if (err.code == 'sign_in_canceled') {
      } else {
        emit(SignInWithGoogleState(error: err));
      }
    } catch (e) {
      if (e is TimeOutException) {
        emit(SignInWithGoogleState(error: TimeOutException()));
      } else {
        emit(SignInWithGoogleState(error: e));
      }
    }
  }

  void _sendLinkResetPassword(
      SendLinkResetPasswordEvent event, Emitter<AuthState> emit) async {
    authRepository.sendLinkResetPassword(email: event.email);
  }
}
