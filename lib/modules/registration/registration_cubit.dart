import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/modules/registration/domain/usecases/signup_usecase.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final SignupUsecase signupUsecase;
  RegistrationCubit(this.signupUsecase) : super(RegistrationInitialState());

  UserEntity userEntity = UserEntity.empty();

  Future signUp(String password, XFile picture, XFile pinImage) async {
    emit(RegistrationLoadingState());
    try {
      final response =
          await signupUsecase(userEntity, password, picture, pinImage);
      response.fold((l) => null, (r) => emit(RegistrationSuccessState()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        var message = 'O email fornecido já está vinculado a uma conta.';
        emit(RegistrationErrorState(message));
      }
      emit(RegistrationErrorState('Erro inesperado'));
    }
  }
}

abstract class RegistrationState {}

class RegistrationInitialState extends RegistrationState {}

class RegistrationLoadingState extends RegistrationState {}

class RegistrationErrorState extends RegistrationState {
  final String message;
  RegistrationErrorState(this.message);
}

class RegistrationSuccessState extends RegistrationState {}
