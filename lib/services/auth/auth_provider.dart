import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/services/auth/auth_user.dart';

import '../../firebase_options.dart';

abstract class AuthProvider{
  Future<void> initialize();
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
  Future<void> sendPasswordReset({required String toEmail});
}