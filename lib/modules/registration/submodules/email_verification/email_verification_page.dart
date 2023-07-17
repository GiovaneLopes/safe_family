import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/forgot_password_cubit.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/email_verification_cubit.dart';
import 'package:safe_lopes_family/src/resources/images.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final EmailVerificationCubit emailVerificationCubit = Modular.get();
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verificar email',
              style: TextStyle(fontSize: 22, fontFamily: 'Nunito'),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 22, top: 22, right: 22),
            child: BlocConsumer(
                bloc: emailVerificationCubit,
                listener: (context, state) {
                  if (state.runtimeType == ForgotPasswordErrorState) {
                    var errorState = state as ForgotPasswordErrorState;
                    var snackBar = SnackBar(content: Text(errorState.message));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (state.runtimeType == ForgotPasswordSuccessState) {
                    var snackBar = const SnackBar(
                        content: Text('Email enviado com sucesso'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Modular.to.navigate('/auth/');
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.logo,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Safe Family',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Text(
                        'Acesse seu email informado e abra o link para verificar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await emailVerificationCubit.reloadUser();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Email verificado'),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await emailVerificationCubit
                                    .resendVerificationEmail();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FeatherIcons.mail),
                                  SizedBox(width: 12),
                                  Text('Reenviar email'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
