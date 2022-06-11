import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({ Key? key }) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email')
      ),
      body: Column(
          children: [
            const Text('An email has been sent to your email address, please follow the instructions to verify your account'),
            const Text('If you have not recieved an Email yet press the button below'),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              }, child: const Text('Send email verificationn'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut(); // Need to sign user out!
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }, 
              child: const Text('Return'),
            )
          ],
        ),
    );
  }
}