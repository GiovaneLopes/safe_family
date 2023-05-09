import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/get_circle_usecase.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/set_circle_usecase.dart';

class CirclesCubit extends Cubit<CirclesState> {
  final GetCircleUsecase getCircleUsecase;
  final SetCircleUsecase setCircleUsecase;
  CirclesCubit(this.getCircleUsecase, this.setCircleUsecase)
      : super(CirclesLoadingState());

  Future getUserCircles() async {
    emit(CirclesLoadingState());
    try {
      final response = await getCircleUsecase();
      response.fold((l) => null, (r) => emit(CirclesSuccessState(r)));
    } on FirebaseException catch (e) {
      emit(CirclesErrorState(e.message ?? 'Algo deu errado'));
    }
  }

  Future setInvitationCode(String code) async {
    try {
      final response = await setCircleUsecase(code);
      response.fold((l) => null, (r) => emit(CirclesSuccessState(r)));
    } on FirebaseException catch (e) {
      emit(CirclesErrorState(e.message ?? 'Algo deu errado'));
    }
  }
}

abstract class CirclesState {}

class CirclesLoadingState extends CirclesState {}

class CirclesSuccessState extends CirclesState {
  final CircleEntity circle;

  CirclesSuccessState(this.circle);
}

class CirclesErrorState extends CirclesState {
  final String message;

  CirclesErrorState(this.message);
}
