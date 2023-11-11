import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ticket_app/screen/auth/blocs/auth_exception.dart';


class AuthRepository {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signUpWithEmailPassword ({ required fullName , required String email, required String password, String? photoUrl}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeOutException(),
      );

      await signInWithEmailPassword(email: email, password: password);

      final user = firebaseAuth.currentUser!;
      user.updateDisplayName(fullName);
      user.updatePhotoURL(photoUrl);

      user.sendEmailVerification();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak_password') {
        throw WeakPasswordException();
      } else{
        if (e.code == 'email-already-in-use') {
          throw AccountAlreadyExistsException();
        }else{
          print( "FirebaseAuthException" + e.code);
          throw Exception();
        }
      } 
    } catch (e) {
      if(e is TimeOutException){
        throw TimeOutException();
      }else{
        print(e);
        throw Exception();
      }
      
    }
  }

  Future<void> signInWithEmailPassword ({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeOutException(),
      ).catchError((error){
        throw error;
      });
    }on FirebaseAuthException catch (e) {
      print("bbb " + e.runtimeType.toString() + "  " + e.code);

      if (e.code == 'user-not-found'){
        throw UserNotFoundException();
      }

      if (e.code == 'wrong-password'){
        throw WrongPasswordException();
      }else{
        throw Exception();
      }
    } catch (e){
      print("aaa" + e.toString());
      if(e is TimeOutException){
        throw TimeOutException();
      }else{
        throw Exception();
      }
    }
  }

  Future<void> deleteUser()async{
    try {
      firebaseAuth.currentUser!.delete();
    } catch (e) {
      throw Exception();
    }
  }

  
}