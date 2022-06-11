import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/services/auth/auth_user.dart';

import '../../firebase_options.dart';

abstract class AuthProvider{
  @override
  Future<void> initialize() async{
    Firebase.initializeApp( // Initialize firebase here so we can use later
                  options: DefaultFirebaseOptions.currentPlatform,);
  }
  AuthUser? get currentUser;
  Future<AuthUser> logIn(
    {
      required String email,
      required String password,
    }
  );
  Future<AuthUser> createUser(
    {
      required String email,
      required String password,
    }
  );
  Future<void> logOut();
  Future<void> sendEmailVerification();
}