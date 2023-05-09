import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_lopes_family/modules/auth/domain/usecases/signin_usecase/signin_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final SigninUsecase signinUsecase;
  AuthCubit(this.signinUsecase) : super(AuthInitialState());

  Future signIn(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final response = await signinUsecase(email, password);
      response.fold((l) => null, (r) => emit(AuthSuccessState()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        var message = 'Nenhum usuário encontrado com esse email.';
        emit(AuthErrorState(message));
      } else if (e.code == 'wrong-password') {
        var message = 'Senha incorreta.';
        emit(AuthErrorState(message));
      }
    }
  }
}

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
