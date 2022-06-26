import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart'; // Only show user class

@immutable  // Internals of this class will never be changed once initialized subclasses cannot have fields that change
class AuthUser{
  final String id;
  final bool isEmailVerified;
  final String email;
  const AuthUser({required this.id, required this.isEmailVerified, required this.email}); // Curly braces and required so we can check if isEmailVerified is true in testing

  factory AuthUser.fromFirebase(User user) => AuthUser(
    id: user.uid, 
    email: user.email!, 
    isEmailVerified: user.emailVerified,
    ); // takes emailverified from firebase user and places in Authuser
}

