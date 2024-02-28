import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/user/user_repo.dart';


class AuthRepository {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepo _userRepo = UserRepo();


  Future<void> signUpWithEmailPassword ({ required fullName , required String email, required String password, required File? image}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeOutException(),
      );

      await signInWithEmailPassword(email: email, password: password);

      final user = _firebaseAuth.currentUser!;
      user.updateDisplayName(fullName);
      if(image != null){
        final photoUrl = await _userRepo.uploadImageToFirebase(image);
        user.updatePhotoURL(photoUrl);
      }
      user.sendEmailVerification();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak_password') {
        throw WeakPasswordException();
      } else{
        if (e.code == 'email-already-in-use') {
          throw AccountAlreadyExistsException();
        }else{
          throw Exception();
        }
      } 
    } catch (e) {
      if(e is TimeOutException){
        throw TimeOutException();
      }else{
        throw Exception();
      }
      
    }
  }

  Future<void> signInWithEmailPassword ({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeOutException(),
      ).catchError((error){
        throw error;
      });
    }on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found'){
        throw UserNotFoundException();
      }

      if (e.code == 'wrong-password'){
        throw WrongPasswordException();
      }else{
        throw Exception();
      }
    } catch (e){
      if(e is TimeOutException){
        throw TimeOutException();
      }else{
        throw Exception();
      }
    }
  }

  Future<void> deleteUser()async{
    try {
      _firebaseAuth.currentUser!.delete();
    } catch (e) {
      throw Exception();
    }
  }

  void sendLinkResetPassword({required String email}){
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}