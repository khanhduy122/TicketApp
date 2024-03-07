import 'dart:io';

import 'package:flutter/material.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  SignInEvent(
      {required this.context, required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final File? image;

  SignUpEvent(
      {required this.fullName,
      required this.email,
      required this.password,
      required this.image});
}

class SignInWithGoogleEvent extends AuthEvent {
  final BuildContext context;

  SignInWithGoogleEvent({required this.context});
}

class CheckVerifyEvent extends AuthEvent {}

class DeleteUserEvent extends AuthEvent {}

class SendLinkResetPasswordEvent extends AuthEvent {
  String email;

  SendLinkResetPasswordEvent({required this.email});
}
