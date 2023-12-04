
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_event.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_exception.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_repository.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{

  final AuthRepository authRepository = AuthRepository();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  AuthBloc() : super(AuthState()){

    on<SignUpEvent>((event, emit) => _signUpEvent(event, emit));

    on<CheckVerifyEvent>((event, emit) => _checkVerifyEmailEvent(event, emit));

    on<SignInEvent>((event, emit) => _signInEvent(event, emit));

    on<DeleteUserEvent>((event, emit) => _deleteUserEvent(event, emit));

    on<SignInWithGoogleEvent>((event, emit) => _signInWithGoogleEvent(event, emit));

  }

  void _signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(SignUpState(isLoading: true));
    try {
      await authRepository.signUpWithEmailPassword(fullName: event.fullName, email: event.email, password: event.password);
      emit(SignUpState(signUpSucces: true));
    } catch (e) {
      emit(SignUpState(error: e));
    }
  }

  void _checkVerifyEmailEvent(CheckVerifyEvent event, Emitter<AuthState> emit){
    FirebaseAuth.instance.currentUser!.reload();
    if(firebaseAuth.currentUser!.emailVerified){
      emit(CheckVerifyState(isVerifyEmail: true));
    }
  }

  void _signInEvent(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(SignInState(isLoading: true));
      await authRepository.signInWithEmailPassword(email: event.email, password: event.password);
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
      print("delete success");
    } catch (e) {
      emit(DeleteUserState(isSuccess: false));
    }
  }

  void _signInWithGoogleEvent(SignInWithGoogleEvent event, Emitter<AuthState> emit) async {

    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser;

    try {
      googleUser = await googleSignIn.signIn().catchError((onError) => null);
    } catch (e) {
      // print(e);
    }

    try {
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().timeout(
      //   const Duration(seconds: 20),
      //   onTimeout: () => throw TimeOutException(),
      // );
      if(googleUser != null){
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication.timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeOutException(),
      );

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      
      emit(SignInWithGoogleState(isLoading: true));

      await FirebaseAuth.instance.signInWithCredential(credential).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeOutException(),
      );

      emit(SignInWithGoogleState(isSuccess: true));
      }
      

    } on PlatformException catch (err) {

      if (err.code == 'sign_in_canceled') {
      print(err.toString());
      } else {
        emit(SignInWithGoogleState(error: err));
      }

    }catch (e) {
      if(e is TimeOutException){
        emit(SignInWithGoogleState(error: TimeOutException()));
      }else {
        emit(SignInWithGoogleState(error: e));
      }
    }
  } 
}