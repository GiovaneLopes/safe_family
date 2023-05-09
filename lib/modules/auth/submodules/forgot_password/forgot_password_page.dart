import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/forgot_password_cubit.dart';
import 'package:safe_lopes_family/src/resources/images.dart';
import 'package:safe_lopes_family/src/widgets/safe_family_text_form_field/safe_family_text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordCubit forgotPasswordCubit = Modular.get();
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
                bloc: forgotPasswordCubit,
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
                        'Informe o email cadastrado para recuperar a senha',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Form(
                        key: formKey,
                        child: SafeFamilyTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'E-mail',
                          prefixIcon: const Icon(
                            Icons.email,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo vazio';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  forgotPasswordCubit.recoverPassword(emailController.text);
                                }
                              },
                              child: state.runtimeType ==
                                      ForgotPasswordLoadingState
                                  ? const Center(
                                      child: CircularProgressIndicator(color: Colors.white,),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.email_outlined),
                                        SizedBox(width: 12),
                                        Text('Recuperar senha'),
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
