import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/set_circle_usecase.dart';
import 'package:safe_lopes_family/src/utils/random_string_generate.dart';

class NewCircleCubit extends Cubit<NewCircleState> {
  final SetCircleUsecase setCircleUsecase;
  NewCircleCubit(this.setCircleUsecase) : super(NewCircleInitialState());

  Future<void> saveNewCircle() async {
    emit(NewCircleLoadingState());
    try {
      final newCode = RandomStringGenerate.generateRandomString(6);
      final response = await setCircleUsecase(newCode);
      response.fold((l) => null, (r) => emit(NewCircleSuccessState(newCode)));
    } on FirebaseException {
      emit(NewCircleErrorState());
    }
  }
}

abstract class NewCircleState {}

class NewCircleLoadingState extends NewCircleState {}

class NewCircleSuccessState extends NewCircleState {
  final String code;

  NewCircleSuccessState(this.code);
}

class NewCircleErrorState extends NewCircleState {}

class NewCircleInitialState extends NewCircleState {}
