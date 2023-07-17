import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/usecases/email_verification_usecase.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/usecases/resend_email_verification_usecase.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final EmailVerificationUsecase emailVerificationUsecase;
  final ResendVerificationEmailUsecase resendVerificationEmailUsecase;
  EmailVerificationCubit(
      this.emailVerificationUsecase, this.resendVerificationEmailUsecase)
      : super(EmailVerificationInitialState());

  Future<void> reloadUser() async {
    try {
      await emailVerificationUsecase();
    } on FirebaseException catch (e) {
      emit(EmailVerificationErrorState(e.code));
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await resendVerificationEmailUsecase();
    } on FirebaseException catch (e) {
      emit(EmailVerificationErrorState(e.code));
    }
  }
}

abstract class EmailVerificationState {}

class EmailVerificationInitialState extends EmailVerificationState {}

class EmailVerificationSuccessState extends EmailVerificationState {}

class EmailVerificationErrorState extends EmailVerificationState {
  final String message;

  EmailVerificationErrorState(this.message);
}
