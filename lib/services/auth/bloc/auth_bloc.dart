import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

import '../auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()){    // Bloc needs an initial state (loading)
    // initialize
    on<AuthEventInitialize>((event, emit) async{
      await provider.initialize();
      final user = provider.currentUser;
      if(user==null){
        emit(const AuthStateLoggedOut());
      } else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification());
      } else{
        emit(AuthStateLoggedIn(user));
      }
    });

    // login
    on<AuthEventLogIn>((event, emit) async{
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(email: email, password: password,);
        emit(AuthStateLoggedIn(user));  // State is LoggedIm and send out a user
      } on Exception catch (e){
        emit(AuthStateLoginFailure(e));
      }
    });

    // Log out
    on<AuthEventLogOut>((event, emit) async{
      emit(const AuthStateLoading());
      try{
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e){
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}