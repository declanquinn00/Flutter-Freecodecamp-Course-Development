import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart'; // Only show user class

@immutable  // Internals of this class will never be changed once initialized subclasses cannot have fields that change
class AuthUser{
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified}); // Curly braces and required so we can check if isEmailVerified is true in testing

  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified); // takes emailverified from firebase user and places in Authuser
}

