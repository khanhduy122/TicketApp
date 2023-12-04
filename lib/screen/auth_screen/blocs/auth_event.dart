
abstract class AuthEvent{}

class SignInEvent extends AuthEvent{
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent{
  final String fullName;
  final String email;
  final String password;

  SignUpEvent({required this.fullName, required this.email, required this.password});

}

class SignInWithGoogleEvent extends AuthEvent {}

class CheckVerifyEvent extends AuthEvent{}

class DeleteUserEvent extends AuthEvent{}