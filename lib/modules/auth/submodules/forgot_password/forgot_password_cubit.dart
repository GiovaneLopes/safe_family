import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/domain/usecases/recover_password_usecase.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final RecoverPasswordUsecase recoverPasswordUsecase;
  ForgotPasswordCubit(this.recoverPasswordUsecase)
      : super(ForgotPasswordInitialState());

  Future recoverPassword(String email) async {
    emit(ForgotPasswordLoadingState());
    try {
      final response = await recoverPasswordUsecase(email);
      response.fold((l) => emit(ForgotPasswordErrorState('Erro inesperado')),
          (r) => emit(ForgotPasswordSuccessState()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        var message = 'Email inválido.';
        emit(ForgotPasswordErrorState(message));
      } else if (e.code == 'user-not-found') {
        var message = 'Nenhum usuário encontrado com esse email.';
        emit(ForgotPasswordErrorState(message));
      }
      emit(ForgotPasswordErrorState(e.message ?? 'Erro inesperado'));
    }
  }
}

abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String message;
  ForgotPasswordErrorState(this.message);
}
