import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log; //Only show log options from dart:developer by typing devtools.XXX
//import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ensure firebase gets initialized
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>( // create homepage in a bloc provider
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        // Named paths to different views with strings as keys
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if (state.isLoading){
          LoadingScreen().show(context: context, text: state.loadingText ?? 'Please wait');
        } else{
          LoadingScreen().hide();
        }
      },
      builder: ((context, state) {
      if (state is AuthStateLoggedIn){
        return const NotesView();
      }
      else if (state is AuthStateNeedsVerification){
        return const VerifyEmailView();
      }
      else if (state is AuthStateLoggedOut){
        return const LoginView();
      } 
      else if (state is AuthStateForgotPassword){
        return const ForgotPasswordView();
      }
      else if(state is AuthStateRegistering){
        return const RegisterView();
      }
      else{
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    }));
  }
}
