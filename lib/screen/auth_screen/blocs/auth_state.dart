class AuthState {}

class SignUpState extends AuthState {
  Object? error;
  bool? isLoading;
  bool? signUpSucces;

  SignUpState({this.error, this.isLoading, this.signUpSucces});
}

class SignInState extends AuthState{
  Object? error;
  bool? isLoading;
  bool? signInSuccess;

  SignInState({this.error, this.isLoading, this.signInSuccess});
}

class SignInWithGoogleState extends AuthState {
  bool? isLoading;
  Object? error;
  bool? isSuccess;

  SignInWithGoogleState({this.error, this.isLoading, this.isSuccess});
}

class CheckVerifyState extends AuthState {
  final bool isVerifyEmail;

  CheckVerifyState({required this.isVerifyEmail});
}

class DeleteUserState extends AuthState{
  bool? isLoading;
  bool? isSuccess;

  DeleteUserState({this.isLoading, this.isSuccess});
}